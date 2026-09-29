# [CUDA 从入门到精通：一篇讲透 GPU 并行编程、性能优化与工程实践](https://mp.weixin.qq.com/s/f-9aMhW6UUhevfEqo4pk3Q)

> 你写下的并不只是"一段跑在显卡上的 C++"，而是在描述：如何把一个大任务拆成成千上万份，让 GPU 同时完成。深度学习训练、科学计算、图像处理、视频编解码、推荐系统、量化交易、计算流体力学……这些看似不同的领域，都可能遇到同一个问题：CPU 已经很努力了，但数据规模增长得更快。CUDA 的价值，就是让我们把适合并行的计算交给 NVIDIA GPU，以吞吐量换取数量级上的加速潜力。但 CUDA 也有一道明显的门槛：代码能运行，不等于写对了；结果正确，不等于跑得快；某张显卡上很快，也不等于换一代硬件仍然高效。

> **版本说明**：截至 2026 年 7 月 16 日，NVIDIA 官方列出的最新 CUDA Toolkit 为 13.3.1。本文核心代码使用成熟的 CUDA Runtime API，尽量保持版本无关；安装、驱动兼容性与新特性请始终以官方文档为准。

---

## 先回答最重要的问题：CUDA 到底是什么？

CUDA 是 NVIDIA 提供的并行计算平台与编程模型。它让开发者可以使用 C++、Python 等方式，把计算任务提交给支持 CUDA 的 NVIDIA GPU 执行。

在典型 CUDA 程序中：

- **Host** 指 CPU 及其内存；
- **Device** 指 GPU 及其显存；
- **Kernel** 指由 CPU 发起、在 GPU 上并行执行的函数；
- CPU 负责控制流程、I/O、任务调度；
- GPU 负责大规模、结构相似的数据并行计算。

可以把 CPU 和 GPU 想象成两种不同风格的组织：

| 处理器 | 更像什么 | 擅长什么 |
| --- | --- | --- |
| CPU | 少量全能专家 | 复杂控制、低延迟、分支密集、串行逻辑 |
| GPU | 大量流水线工人 | 规则重复、数据量大、可并行、吞吐优先 |

GPU 并不是"任何代码都比 CPU 快"。它更适合满足以下条件的任务：

1. 数据规模足够大；
2. 大量元素可以执行相同或相似操作；
3. 元素之间依赖较少；
4. 计算收益足以覆盖数据传输和 Kernel 启动开销。

例如，给一百万个元素分别加 1，很适合 GPU；但只计算十个元素，数据搬运和启动开销可能比计算本身更贵。

### CUDA 生态不只有 Kernel

完整 CUDA 工具链通常包含：

- `nvcc`：CUDA 编译器驱动；
- CUDA Runtime API：最常用的运行时接口；
- CUDA Driver API：更底层、更灵活的驱动接口；
- cuBLAS、cuFFT、cuSPARSE、cuSOLVER 等数学库；
- Nsight Systems、Nsight Compute 等性能分析工具；
- Compute Sanitizer：内存、竞争和同步错误检测工具；
- CUDA Samples：官方示例；
- CUB、Thrust、CUTLASS、NCCL 等算法与多 GPU 组件。

真正成熟的 CUDA 开发者，不是"所有东西都手写 Kernel"，而是知道何时用库、何时写 Kernel、何时融合算子、何时改变算法。

---

## CUDA 的核心心智模型：Grid、Block、Thread、Warp、SM

初学 CUDA 最容易卡住的地方，不是语法，而是执行模型。

### 1. Thread：最小的编程单元

一个 Kernel 会被许多线程同时执行。每个线程运行相同的函数，但通过自己的索引处理不同数据。

```cpp
__global__ void add_one(float* data, int n) {
    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if (i < n) {
        data[i] += 1.0f;
    }
}
```

这里每个线程计算一个全局索引 `i`，并处理 `data[i]`。

### 2. Block：线程的协作小组

线程被组织成 Block。一个 Block 可以是一维、二维或三维。

同一个 Block 内的线程：

- 通常运行在同一个 SM 上；
- 可以通过共享内存交换数据；
- 可以使用 `__syncthreads()` 做 Block 内同步。

不同 Block 之间不应默认存在执行顺序。它们可能并行，也可能先后执行，顺序由 GPU 调度器决定。

### 3. Grid：一次 Kernel 启动的全部 Block

一次 Kernel 启动会创建一个 Grid，Grid 中包含若干 Block。

```cpp
kernel<<<grid_size, block_size>>>(...);
```

三尖括号里的两个核心参数分别表示：

- 启动多少个 Block；
- 每个 Block 有多少个线程。

### 4. Warp：GPU 实际调度的重要单位

在传统 CUDA SIMT 模型中，线程会被组织为 Warp。一个 Warp 通常包含 32 个线程，并以"同一条指令处理不同数据"的方式推进。

这带来一个重要结论：

> **当同一个 Warp 中的线程走不同分支时，GPU 往往需要分批执行不同路径，这就是分支发散。**

例如：

```cpp
if (threadIdx.x % 2 == 0) {
    // 偶数线程执行路径 A
} else {
    // 奇数线程执行路径 B
}
```

如果同一个 Warp 中一半走 A、一半走 B，两条路径通常都要执行，吞吐效率会下降。

### 5. SM：真正执行线程的硬件单元

SM，即 Streaming Multiprocessor，是 GPU 上执行 Warp、管理寄存器和共享内存的核心计算单元。

一个 SM 可以同时驻留多个 Block 和 Warp，但能驻留多少，受以下资源共同限制：

- 每个线程使用的寄存器数量；
- 每个 Block 使用的共享内存；
- Block 的线程数；
- 硬件允许的最大驻留 Block、Warp 和线程数。

因此，**Block 并不是越大越好，Occupancy 也不是越高越好**。优化的本质，是让计算、访存和调度达到平衡。

### 一张关系图

```
一次 Kernel 启动
└── Grid
    ├── Block 0
    │   ├── Thread 0
    │   ├── Thread 1
    │   └── ...
    ├── Block 1
    └── ...

硬件执行侧
└── GPU
    ├── SM 0：调度若干 Block / Warp
    ├── SM 1：调度若干 Block / Warp
    └── ...
```

请记住这句话：

> **Thread 是你编程时分配工作的单位，Warp 是硬件调度时必须关注的单位，Block 是线程协作和资源分配的单位，Grid 是一次完整任务。**

---

## 搭建 CUDA 开发环境：先把"驱动"和"工具包"分清楚

CUDA 环境问题常常不是代码问题，而是版本、驱动、编译器和路径问题。

### 1. 需要哪些东西？

最基本的环境包括：

1. 支持 CUDA 的 NVIDIA GPU；
2. 与目标 CUDA Toolkit 兼容的 NVIDIA 驱动；
3. CUDA Toolkit；
4. 受支持的 Host C++ 编译器；
5. 可选的 CMake、IDE、Nsight 工具。

### 2. 两个常用检查命令

```bash
nvidia-smi
nvcc --version
```

这两个命令回答的是**不同**问题：

- `nvidia-smi` 主要反映驱动、GPU 状态，以及该驱动能够支持的 CUDA 兼容级别；
- `nvcc --version` 反映当前命令行找到的 CUDA Toolkit 编译器版本。

因此，`nvidia-smi` 中显示某个 "CUDA Version"，**并不等于**系统已经安装了同版本的 Toolkit。

### 3. 推荐的安装原则

不同 Linux 发行版、Windows、WSL 的安装步骤会变化，不建议硬编码所有仓库命令。更稳妥的方法是：

- 使用 NVIDIA 官方 CUDA 下载页选择操作系统、架构和安装方式；
- 根据官方 Installation Guide 安装；
- 检查驱动与 Toolkit 的兼容性；
- 用一个最小 CUDA 程序或官方 Sample 验证；
- 不要在同一台机器上无计划地混装多个来源的驱动包。

在 WSL 中，要特别区分 Windows 主机驱动与 WSL 内的 CUDA Toolkit。通常应由 Windows 侧提供 NVIDIA 驱动能力，不要把传统 Linux 显卡驱动安装流程原样搬进 WSL。

### 4. 编译第一个 .cu 文件

假设文件名为 `vector_add.cu`：

```bash
nvcc -O2 -std=c++17 vector_add.cu -o vector_add
./vector_add
```

性能分析构建可以加入行号信息：

```bash
nvcc -O3 -lineinfo -std=c++17 vector_add.cu -o vector_add
```

`-G` 会生成设备调试信息，并可能关闭大量设备端优化，适合调试，**不适合拿来做性能结论**。性能分析通常使用 `-lineinfo`。

---

## 第一个完整 CUDA 程序：向量加法

下面不是"最短示例"，而是一个更接近工程实践的版本：包含错误检查、结果校验和资源释放。

```cpp
#include <cuda_runtime.h>

#include <algorithm>
#include <cmath>
#include <cstddef>
#include <cstdlib>
#include <iostream>
#include <vector>

#define CUDA_CHECK(call)                                               \
    do {                                                               \
        const cudaError_t error = (call);                              \
        if (error != cudaSuccess) {                                    \
            std::cerr << "CUDA error at " << __FILE__ << ':' << __LINE__ \
                      << " - " << cudaGetErrorString(error) << std::endl; \
            std::exit(EXIT_FAILURE);                                   \
        }                                                              \
    } while (0)

__global__ void vector_add(const float* a,
                           const float* b,
                           float* c,
                           std::size_t n) {
    const std::size_t i =
        static_cast<std::size_t>(blockIdx.x) * blockDim.x + threadIdx.x;

    if (i < n) {
        c[i] = a[i] + b[i];
    }
}

int main() {
    constexpr std::size_t n = 1U << 20;
    const std::size_t bytes = n * sizeof(float);

    std::vector<float> h_a(n, 1.25f);
    std::vector<float> h_b(n, 2.75f);
    std::vector<float> h_c(n, 0.0f);

    float* d_a = nullptr;
    float* d_b = nullptr;
    float* d_c = nullptr;

    CUDA_CHECK(cudaMalloc(reinterpret_cast<void**>(&d_a), bytes));
    CUDA_CHECK(cudaMalloc(reinterpret_cast<void**>(&d_b), bytes));
    CUDA_CHECK(cudaMalloc(reinterpret_cast<void**>(&d_c), bytes));

    CUDA_CHECK(cudaMemcpy(d_a, h_a.data(), bytes, cudaMemcpyHostToDevice));
    CUDA_CHECK(cudaMemcpy(d_b, h_b.data(), bytes, cudaMemcpyHostToDevice));

    constexpr int threads_per_block = 256;
    const int blocks = static_cast<int>(
        (n + threads_per_block - 1) / threads_per_block);

    vector_add<<<blocks, threads_per_block>>>(d_a, d_b, d_c, n);

    // 检查 Kernel 启动参数等同步可见错误。
    CUDA_CHECK(cudaGetLastError());

    // 等待 Kernel 完成，并暴露异步执行期间发生的错误。
    CUDA_CHECK(cudaDeviceSynchronize());

    CUDA_CHECK(cudaMemcpy(h_c.data(), d_c, bytes, cudaMemcpyDeviceToHost));

    float max_error = 0.0f;
    for (std::size_t i = 0; i < n; ++i) {
        max_error = std::max(max_error, std::fabs(h_c[i] - 4.0f));
    }

    std::cout << "max error = " << max_error << std::endl;

    CUDA_CHECK(cudaFree(d_a));
    CUDA_CHECK(cudaFree(d_b));
    CUDA_CHECK(cudaFree(d_c));

    return max_error < 1e-6f ? EXIT_SUCCESS : EXIT_FAILURE;
}
```

### 这段程序做了什么？

完整流程可以概括为：

```
CPU 准备数据
→ 在 GPU 上分配显存
→ Host 数据复制到 Device
→ 启动 Kernel
→ 等待并检查错误
→ Device 结果复制回 Host
→ CPU 校验结果
→ 释放资源
```

### 为什么 Block 大小常从 256 开始？

256 是一个常见的经验起点，因为它是 Warp 大小的整数倍，也通常能在并行度和资源占用之间取得合理平衡。

但它不是定律。最优配置取决于：

- Kernel 的寄存器使用；
- 共享内存使用；
- 计算与访存比例；
- GPU 架构；
- 数据规模；
- 是否存在尾部效应。

正确做法是：**以 128、256 等合理值起步，再通过测量和分析决定。**

---

## 线程索引：从"一线程一元素"到 Grid-Stride Loop

最常见的一维索引公式是：

```cpp
int i = blockIdx.x * blockDim.x + threadIdx.x;
```

二维图像常使用：

```cpp
int x = blockIdx.x * blockDim.x + threadIdx.x;
int y = blockIdx.y * blockDim.y + threadIdx.y;
```

对应启动方式：

```cpp
dim3 block(16, 16);
dim3 grid((width + block.x - 1) / block.x,
          (height + block.y - 1) / block.y);

image_kernel<<<grid, block>>>(...);
```

### 更通用的 Grid-Stride Loop

"一线程一元素"直观，但当数据极大或想限制 Block 数量时，可以让每个线程处理多个元素：

```cpp
__global__ void vector_add_grid_stride(const float* a,
                                       const float* b,
                                       float* c,
                                       std::size_t n) {
    const std::size_t start =
        static_cast<std::size_t>(blockIdx.x) * blockDim.x + threadIdx.x;
    const std::size_t stride =
        static_cast<std::size_t>(blockDim.x) * gridDim.x;

    for (std::size_t i = start; i < n; i += stride) {
        c[i] = a[i] + b[i];
    }
}
```

它有几个优点：

- 支持任意大的数据规模；
- 可以限制 Grid 大小，复用线程；
- 便于调试，例如用 `<<<1, 1>>>` 串行验证；
- 相邻线程仍可访问相邻元素，保持良好的访存模式。

---

## CUDA 内存层次：性能优化的主战场

很多 CUDA Kernel 不是算得慢，而是**等数据等得慢**。

理解内存层次，是从"会写"走向"写快"的关键。

| 内存/存储 | 可见范围 | 典型特点 | 常见用途 |
| --- | --- | --- | --- |
| 寄存器 | 单线程 | 最快、容量有限 | 局部标量、循环变量、临时结果 |
| Local Memory | 单线程 | 逻辑私有名字叫 local，但通常落在设备内存中 | 寄存器溢出、大型局部数组 |
| Shared Memory | 同一 Block | 低延迟、显式管理、容量有限 | 数据复用、线程协作、分块算法 |
| L1/L2 Cache | 硬件管理 | 自动缓存 | 缓解部分全局内存访问成本 |
| Global Memory | 整个 Device | 容量大、延迟高 | 主数据数组、模型参数、结果 |
| Constant Memory | 整个 Device 只读 | 对 Warp 同地址读取很友好 | 小型只读常量、系数 |
| Pinned Host Memory | CPU 与 DMA 传输 | 支持高效异步传输，但资源稀缺 | Host↔Device 流水线 |
| Unified/Managed Memory | CPU 与 GPU 共享地址空间 | 编程方便，迁移与一致性需理解 | 原型、多处理器共享、复杂数据结构 |

### 1. Global Memory：大，但贵

显存容量大，通常也是大部分输入输出所在的位置。但访问延迟较高，性能强烈依赖访问模式。

**访存合并（Coalescing）**——理想模式是：同一个 Warp 中的相邻线程访问相邻地址。

好例子：

```cpp
float x = data[global_thread_id];
```

较差例子：

```cpp
float x = data[global_thread_id * large_stride];
```

前者更容易被合并成较少的内存事务；后者可能产生分散访问和带宽浪费。

> **高优先级原则：尽量让 Warp 内线程访问连续、对齐的数据。**

### 2. Shared Memory：程序员管理的高速缓存

共享内存由同一个 Block 中的线程共享，适合把会被重复使用的数据加载一次，再多次计算。

```cpp
__global__ void example(const float* input, float* output) {
    __shared__ float tile[256];

    int tid = threadIdx.x;
    int i = blockIdx.x * blockDim.x + tid;

    tile[tid] = input[i];
    __syncthreads();

    // 使用 tile 中由其他线程加载的数据。
    output[i] = tile[tid];
}
```

共享内存优化通常遵循：

```
Global Memory → Shared Memory → 多次复用 → Global Memory
```

但共享内存并非免费：

- 需要显式加载；
- 需要正确同步；
- 可能发生 Bank Conflict；
- 使用过多会降低可同时驻留的 Block 数量。

### 3. Bank Conflict：共享内存也会"堵车"

共享内存被划分为多个 Bank。理想情况下，同一 Warp 的线程访问不同 Bank，可以并行完成。

如果多个线程访问同一 Bank 的不同地址，访问可能被串行化。

矩阵转置里常见的技巧是给二维共享内存多加一列：

```cpp
__shared__ float tile[32][33];
```

这一个额外元素常用于打破列访问时的 Bank 映射冲突。

### 4. 寄存器：越多越好吗？

寄存器很快，但每个 SM 的寄存器总量有限。

如果单线程使用太多寄存器：

- 一个 SM 能同时驻留的线程可能减少；
- Occupancy 可能下降；
- 极端情况下发生寄存器溢出，变量被放入 Local Memory，代价显著增加。

所以不要只追求"全部放寄存器"，而要观察编译器报告和 Nsight 指标。

### 5. Unified Memory：方便不代表无需优化

`cudaMallocManaged` 可以创建 CPU 和 GPU 都能通过同一指针访问的内存：

```cpp
float* data = nullptr;
cudaMallocManaged(&data, n * sizeof(float));
```

它显著降低了原型开发的复杂度，但性能行为可能涉及：

- 页面迁移；
- 缺页；
- 预取；
- 不同操作系统和硬件的一致性机制；
- CPU 与 GPU 交替访问造成的抖动。

因此，Managed Memory 应当被视为一种内存管理模型，而不是"自动获得最优性能"的魔法。

---

## 同步与正确性：GPU Bug 为什么常常"时有时无"？

GPU 程序高度并行，错误往往具有非确定性：同一份代码可能运行十次都正常，第十一次才出现问题。

### 1. Kernel 启动通常是异步的

CPU 发起 Kernel 后，往往会继续执行，而不是自动等待 GPU 完成。

因此：

```cpp
kernel<<<grid, block>>>(...);
std::cout << "launched" << std::endl;
```

打印发生时，Kernel 可能仍在运行。

### 2. 两层错误检查

推荐在开发阶段至少这样检查：

```cpp
kernel<<<grid, block>>>(...);
CUDA_CHECK(cudaGetLastError());
CUDA_CHECK(cudaDeviceSynchronize());
```

- `cudaGetLastError()` 可捕获非法启动配置等错误；
- `cudaDeviceSynchronize()` 可让异步执行错误在此处暴露。

生产环境未必每次 Kernel 后都全设备同步，因为它会破坏并行流水线，但必须建立系统化的错误传播机制。

### 3. __syncthreads() 只同步一个 Block

```cpp
__syncthreads();
```

它保证同一 Block 的线程在继续之前到达同步点，并使相关共享内存操作对 Block 内线程可见。

危险写法：

```cpp
if (threadIdx.x < 16) {
    __syncthreads();
}
```

如果不是 Block 内所有应参与的线程都到达同一个屏障，可能导致死锁或未定义行为。

### 4. 不同 Block 不能随意互等

普通 Kernel 中，不同 Block 的执行顺序不可假设。若算法需要全局阶段同步，常见做法是：

- 把两个阶段拆成两个 Kernel；
- 利用 Kernel 边界作为全局同步点；
- 在适合的场景使用 Cooperative Groups 等机制；
- 重新设计为无跨 Block 依赖的算法。

### 5. Atomic 不是 Barrier

原子操作可以保证某个读改写操作不可分割，例如：

```cpp
atomicAdd(counter, 1);
```

但它不意味着所有线程都到达了某处，也不等价于全局屏障。

### 6. 浮点结果不应盲目逐位比较

并行归约会改变加法顺序，而浮点加法不满足严格结合律。因此 GPU 与 CPU 的结果可能存在微小差异。

应使用：

- 绝对误差；
- 相对误差；
- ULP；
- 与业务容差相关的阈值。

同时，不要把"允许误差"当成掩盖真正竞争条件的借口。

---

## 性能优化方法论：先测量，再优化

CUDA 优化最危险的习惯，是看到 Kernel 就开始改共享内存和展开循环。

NVIDIA 最佳实践指南提出的 **APOD 循环**很实用：

1. **Assess**：评估瓶颈和加速价值；
2. **Parallelize**：并行化最值得加速的部分；
3. **Optimize**：基于测量优化；
4. **Deploy**：部署、验证、监控，再进入下一轮。

### 第一步：先建立基线

至少记录：

- CPU 版本耗时；
- GPU 端到端耗时；
- 纯 Kernel 耗时；
- Host↔Device 传输耗时；
- 输入规模；
- GPU 型号、驱动、Toolkit 与编译参数；
- 数值误差。

否则"快了 30%"可能只是输入变小了、缓存变热了，或少做了一次校验。

### 第二步：先看全局时间线，再钻进 Kernel

推荐顺序：

1. **Nsight Systems**：看 CPU、CUDA API、内存复制、Kernel、同步和空洞；
2. **Nsight Compute**：分析某个 Kernel 的吞吐、访存、Warp 状态和资源使用；
3. 修改代码；
4. 重复测量；
5. 做结果校验和回归测试。

### 高频瓶颈清单

**1. 数据传输过多**

症状：GPU Kernel 很快，但端到端没有加速。

改进方向：

- 让数据尽量长期驻留在 GPU；
- 合并小传输；
- 使用 Pinned Memory；
- 使用异步传输与 Streams；
- 减少 CPU/GPU 来回切换。

**2. 全局内存访问不合并**

症状：内存带宽利用率低、Load/Store 效率差。

改进方向：

- 让相邻线程访问相邻数据；
- 调整数据布局；
- AoS 改 SoA；
- 使用分块与共享内存重排。

例如，把：

```cpp
struct Particle {
    float x, y, z, mass;
};
```

改成多个连续数组，有时更利于 Warp 只读取当前需要的字段。

**3. 分支发散**

症状：Warp 执行效率下降，分支路径高度不一致。

改进方向：

- 重排数据，让同类数据进入相同 Warp；
- 把不同路径拆成不同 Kernel；
- 用谓词或查表替代复杂分支；
- 只优化真正热点，不要为消灭所有 if 牺牲可读性。

**4. Occupancy 太低，或盲目追求满 Occupancy**

低 Occupancy 可能导致隐藏延迟的 Warp 不足，但高 Occupancy 也不保证高性能。

一个计算密集型 Kernel 可能在中等 Occupancy 下已经达到计算吞吐上限；强行减少寄存器，反而可能增加指令和 Local Memory 访问。

正确问题不是"Occupancy 是否 100%"，而是：

> **当前性能受延迟隐藏不足、内存带宽、计算单元、指令依赖，还是启动开销限制？**

**5. Kernel 太小、启动太频繁**

症状：大量微小 Kernel，GPU 时间线中充满启动间隙。

改进方向：

- Kernel Fusion；
- 批处理；
- CUDA Graphs；
- 减少不必要的同步；
- 把小操作交给支持批处理的库。

**6. 共享内存 Bank Conflict**

症状：共享内存吞吐不理想。

改进方向：

- 改变索引方式；
- 增加 Padding；
- 避免 Warp 内多个线程访问同一 Bank 的不同地址。

**7. 寄存器压力过大**

症状：Occupancy 下降、出现 Local Memory 访问。

改进方向：

- 缩短变量生命周期；
- 减少大型局部数组；
- 拆分过度复杂的 Kernel；
- 谨慎使用循环展开；
- 用编译器报告与 Nsight 验证，而不是靠猜。

---

## 实战优化：用共享内存加速矩阵转置

矩阵转置是理解合并访存和共享内存的经典案例。

假设输入矩阵为 `height × width`，输出为 `width × height`。

### 1. 朴素版本

```cpp
__global__ void transpose_naive(const float* input,
                                float* output,
                                int width,
                                int height) {
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;

    if (x < width && y < height) {
        output[x * height + y] = input[y * width + x];
    }
}
```

读取 `input` 时，相邻线程通常读取相邻元素，表现较好；但写入 `output` 时，相邻线程写入地址跨度很大，访存不友好。

### 2. Tiled 版本

```cpp
constexpr int TILE_DIM = 32;
constexpr int BLOCK_ROWS = 8;

__global__ void transpose_tiled(const float* input,
                                float* output,
                                int width,
                                int height) {
    __shared__ float tile[TILE_DIM][TILE_DIM + 1];

    int x = blockIdx.x * TILE_DIM + threadIdx.x;
    int y = blockIdx.y * TILE_DIM + threadIdx.y;

    // 合并读取输入矩阵。
    for (int j = 0; j < TILE_DIM; j += BLOCK_ROWS) {
        if (x < width && y + j < height) {
            tile[threadIdx.y + j][threadIdx.x] =
                input[(y + j) * width + x];
        }
    }

    __syncthreads();

    // 交换 Block 坐标后，合并写入输出矩阵。
    x = blockIdx.y * TILE_DIM + threadIdx.x;
    y = blockIdx.x * TILE_DIM + threadIdx.y;

    for (int j = 0; j < TILE_DIM; j += BLOCK_ROWS) {
        if (x < height && y + j < width) {
            output[(y + j) * height + x] =
                tile[threadIdx.x][threadIdx.y + j];
        }
    }
}
```

启动方式：

```cpp
dim3 block(TILE_DIM, BLOCK_ROWS);
dim3 grid((width + TILE_DIM - 1) / TILE_DIM,
          (height + TILE_DIM - 1) / TILE_DIM);

transpose_tiled<<<grid, block>>>(d_input, d_output, width, height);
```

### 3. 为什么更快？

这个版本做了三件事：

1. 从 Global Memory 以连续模式读入一个 Tile；
2. 在 Shared Memory 中完成转置式重排；
3. 再以连续模式写回 Global Memory。

`TILE_DIM + 1` 的 Padding 用于降低共享内存列访问时的 Bank Conflict。

这也是很多 GPU 优化的通用套路：

> **不改变数学结果，改变数据在内存中的移动方式。**

### 4. 不要直接宣称"快了多少倍"

真实性能取决于：

- GPU 架构；
- 矩阵尺寸；
- 对齐；
- 数据类型；
- ECC；
- 编译选项；
- 是否包含传输时间。

请用 CUDA Events 或 Nsight 在自己的环境测量。

---

## 异步执行与 Streams：让传输和计算重叠

默认写法通常是：

```
拷贝第 1 批数据 → 计算第 1 批 → 拷回第 1 批
→ 拷贝第 2 批数据 → 计算第 2 批 → 拷回第 2 批
```

如果硬件和数据依赖允许，可以构建流水线：

```
Stream 0：H2D(批次 0) → Kernel(批次 0) → D2H(批次 0)
Stream 1：        H2D(批次 1) → Kernel(批次 1) → D2H(批次 1)
```

### 1. 创建 Stream

```cpp
cudaStream_t stream;
CUDA_CHECK(cudaStreamCreate(&stream));

kernel<<<grid, block, 0, stream>>>(...);

CUDA_CHECK(cudaStreamSynchronize(stream));
CUDA_CHECK(cudaStreamDestroy(stream));
```

同一 Stream 中的操作按顺序执行；不同 Stream 中的操作**有机会**并发或重叠，但不保证一定重叠。

### 2. 异步内存复制需要注意什么？

```cpp
CUDA_CHECK(cudaMemcpyAsync(d_data,
                           h_data,
                           bytes,
                           cudaMemcpyHostToDevice,
                           stream));
```

要让 Host↔Device 复制真正具备良好的异步重叠条件，Host 内存通常需要是 Pinned Memory：

```cpp
float* h_data = nullptr;
CUDA_CHECK(cudaMallocHost(reinterpret_cast<void**>(&h_data), bytes));

// 使用完成后：
CUDA_CHECK(cudaFreeHost(h_data));
```

Pinned Memory 是稀缺资源，过度使用可能影响整个系统，应该池化、复用并通过测量决定规模。

### 3. 双缓冲思路

```cpp
constexpr int stream_count = 2;
cudaStream_t streams[stream_count];

for (auto& stream : streams) {
    CUDA_CHECK(cudaStreamCreate(&stream));
}

for (int chunk = 0; chunk < chunk_count; ++chunk) {
    cudaStream_t stream = streams[chunk % stream_count];

    // 等待该缓冲区上一轮任务完成后再复用。
    CUDA_CHECK(cudaStreamSynchronize(stream));

    CUDA_CHECK(cudaMemcpyAsync(d_buffers[chunk % stream_count],
                               h_input + offsets[chunk],
                               chunk_bytes[chunk],
                               cudaMemcpyHostToDevice,
                               stream));

    process<<<grid, block, 0, stream>>>(
        d_buffers[chunk % stream_count], chunk_sizes[chunk]);

    CUDA_CHECK(cudaGetLastError());

    CUDA_CHECK(cudaMemcpyAsync(h_output + offsets[chunk],
                               d_buffers[chunk % stream_count],
                               chunk_bytes[chunk],
                               cudaMemcpyDeviceToHost,
                               stream));
}

for (auto& stream : streams) {
    CUDA_CHECK(cudaStreamSynchronize(stream));
    CUDA_CHECK(cudaStreamDestroy(stream));
}
```

工程中常用 Event 代替粗粒度的 Stream 同步，以表达更精确的依赖。

### 4. 用 CUDA Event 计时

不要用普通 CPU 时钟直接包住异步 Kernel 后就宣布耗时。

```cpp
cudaEvent_t start;
cudaEvent_t stop;
CUDA_CHECK(cudaEventCreate(&start));
CUDA_CHECK(cudaEventCreate(&stop));

CUDA_CHECK(cudaEventRecord(start));
kernel<<<grid, block>>>(...);
CUDA_CHECK(cudaGetLastError());
CUDA_CHECK(cudaEventRecord(stop));
CUDA_CHECK(cudaEventSynchronize(stop));

float milliseconds = 0.0f;
CUDA_CHECK(cudaEventElapsedTime(&milliseconds, start, stop));

CUDA_CHECK(cudaEventDestroy(start));
CUDA_CHECK(cudaEventDestroy(stop));
```

正式测试还应包含：

- 预热；
- 多次重复；
- 报告中位数或分位数；
- 区分冷启动与稳态；
- 控制输入和系统负载；
- 明确是否包含数据传输。

---

## 三件性能工具：Nsight Systems、Nsight Compute、Compute Sanitizer

### 1. Nsight Systems：看全局时间线

它回答的问题包括：

- CPU 是否在等待 GPU？
- CUDA API 调用是否过于频繁？
- 内存复制和 Kernel 是否重叠？
- 是否存在大段 GPU 空闲？
- 哪个线程发起了同步？
- 多个 Stream 是否真正并发？

命令行示例：

```bash
nsys profile -o report ./vector_add
```

先用 Systems 找到"时间花在哪里"，再决定是否需要深入某个 Kernel。

### 2. Nsight Compute：看单个 Kernel

它更关注：

- 内存吞吐；
- 计算吞吐；
- Warp 状态；
- 指令与访存效率；
- Occupancy；
- Shared Memory 和 Cache 行为；
- 源码、PTX 与 SASS 的对应关系。

命令行示例：

```bash
ncu --set full -o kernel_report ./vector_add
```

`--set full` 收集内容较多，分析大型程序时应通过 Kernel 名称、NVTX 范围或启动次数进行过滤，避免采集成本过高。

### 3. Compute Sanitizer：先把正确性问题消掉

内存检查：

```bash
compute-sanitizer --tool memcheck ./vector_add
```

同步检查：

```bash
compute-sanitizer --tool synccheck ./vector_add
```

竞争检查：

```bash
compute-sanitizer --tool racecheck ./vector_add
```

建议顺序：

1. 先跑 memcheck；
2. 再检查竞争和同步；
3. 最后做性能优化。

一个越界写可能没有立即崩溃，却会让后续性能数据完全失去意义。

---

## 库优先：不要为了"练 CUDA"重写成熟算法

在生产环境中，优先检查是否有成熟库可用。

| 需求 | 常用组件 |
| --- | --- |
| 稠密线性代数 | cuBLAS、cuBLASLt |
| 快速傅里叶变换 | cuFFT |
| 稀疏矩阵 | cuSPARSE |
| 线性求解与分解 | cuSOLVER |
| 并行原语 | CUB、Thrust |
| 深度学习算子 | cuDNN |
| 多 GPU 集合通信 | NCCL |
| 高性能矩阵模板 | CUTLASS |
| 推理优化 | TensorRT |

### 为什么库通常更好？

- 针对多代 GPU 做过调优；
- 包含大量边界条件；
- 支持多种数据类型和布局；
- 能利用 Tensor Core 等硬件特性；
- 经过更系统的正确性和性能验证。

### 手写 Kernel 更适合：

- 业务特有的融合算子；
- 库无法表达的数据布局；
- 需要减少中间结果和启动开销；
- 研究新算法；
- 库调用本身成为可证实的瓶颈。

一个很实用的工程策略是：

> **先用库建立正确、稳定的基线，再手写 Kernel 挑战它。**

---

## 从进阶到精通：你还需要掌握什么？

### 1. Warp-Level Primitives

例如 Shuffle、Vote、Match 等操作，可以在 Warp 内交换数据或做投票，避免部分共享内存和 Block 级同步开销。

典型用途：

- Warp 归约；
- 前缀和；
- 数据交换；
- 活跃线程掩码处理。

但必须正确理解活跃掩码和分支后的 Warp 行为，不能沿用"所有线程永远锁步"的过时假设。

### 2. Cooperative Groups

它为线程组和同步提供更结构化的表达方式，适合：

- 明确操作对象是 Warp、Block、Cluster 还是 Grid；
- 编写可组合的并行算法；
- 使用特定硬件支持的跨 Block 协作。

### 3. CUDA Graphs

当程序反复执行相同的 Kernel 和内存操作序列时，可以把这些操作及依赖关系构造成 Graph，实例化后重复启动。

适合：

- 许多小 Kernel；
- 稳定重复的推理或仿真步骤；
- CPU 启动开销明显；
- 工作流依赖关系固定。

Graph 不是"让 Kernel 本身算得更快"，而是减少重复提交与调度开销，并让运行时看到更完整的任务图。

### 4. Stream-Ordered Memory Allocator

`cudaMalloc / cudaFree` 可能带来同步和分配开销。现代 CUDA 提供 `cudaMallocAsync`、`cudaFreeAsync` 与 Memory Pool，让分配释放与 Stream 顺序关联，并复用内存块。

```cpp
void* ptr = nullptr;
CUDA_CHECK(cudaMallocAsync(&ptr, bytes, stream));

kernel<<<grid, block, 0, stream>>>(ptr);

CUDA_CHECK(cudaFreeAsync(ptr, stream));
```

使用跨 Stream 访问时，必须明确建立分配、使用、释放之间的依赖。

### 5. 多 GPU

多 GPU 不是简单地把数据除以卡数。还要考虑：

- 任务切分与负载均衡；
- GPU 间通信；
- PCIe、NVLink、NVSwitch 拓扑；
- Peer-to-Peer；
- NCCL 集合通信；
- NUMA 与 CPU 绑定；
- 多进程或多线程模型；
- 通信与计算重叠。

很多多 GPU 程序的瓶颈不在算力，而在通信和同步。

### 6. 混合精度与 Tensor Core

在允许的误差范围内，FP16、BF16、TF32、FP8 等低精度格式可以显著提升吞吐并降低内存压力。

但必须回答：

- 哪些变量可降精度？
- 累加使用什么精度？
- 是否需要缩放？
- 是否发生上溢、下溢或精度灾难？
- 结果是否满足业务指标？

"更低精度"是算法、数值分析和硬件共同参与的设计，不只是改一个数据类型。

### 7. PTX 与 SASS

普通开发者不需要一开始就手写 PTX，但在深度优化中，需要理解：

- CUDA C++ 会被编译为设备代码；
- PTX 是虚拟指令层；
- SASS 是特定 GPU 架构的机器指令；
- 源码看起来简单，编译后的指令、寄存器与访存行为可能并不简单。

Nsight Compute 和 `cuobjdump`、`nvdisasm` 等工具，可以帮助把源码与底层执行对应起来。

### 8. CUDA Tile 与更高层抽象

CUDA 13.3 引入 CUDA Tile C++，允许开发者以 Tile 为中心表达并行计算，由编译器承担更多线程映射工作。与此同时，CUDA Python 也在走向更稳定的低层控制接口。

传统 SIMT CUDA C++ 仍然是理解 GPU 执行和性能的基础。掌握线程、Warp、内存和同步之后，再学习 Tile、DSL 或框架，才能知道抽象层替你做了什么、又隐藏了什么成本。

---

## 工程化 CUDA：从 Demo 到生产还差哪些能力？

### 1. 用 RAII 管理资源

手动 `cudaMalloc / cudaFree` 容易在异常路径泄漏。可以封装设备缓冲区：

```cpp
#include <cuda_runtime.h>

#include <cstddef>
#include <utility>

class DeviceBuffer {
public:
    explicit DeviceBuffer(std::size_t bytes) : bytes_(bytes) {
        CUDA_CHECK(cudaMalloc(&ptr_, bytes_));
    }

    ~DeviceBuffer() {
        if (ptr_ != nullptr) {
            cudaFree(ptr_);
        }
    }

    DeviceBuffer(const DeviceBuffer&) = delete;
    DeviceBuffer& operator=(const DeviceBuffer&) = delete;

    DeviceBuffer(DeviceBuffer&& other) noexcept
        : ptr_(std::exchange(other.ptr_, nullptr)),
          bytes_(std::exchange(other.bytes_, 0)) {}

    DeviceBuffer& operator=(DeviceBuffer&& other) noexcept {
        if (this != &other) {
            if (ptr_ != nullptr) {
                cudaFree(ptr_);
            }
            ptr_ = std::exchange(other.ptr_, nullptr);
            bytes_ = std::exchange(other.bytes_, 0);
        }
        return *this;
    }

    void* data() noexcept { return ptr_; }
    const void* data() const noexcept { return ptr_; }
    std::size_t size() const noexcept { return bytes_; }

private:
    void* ptr_ = nullptr;
    std::size_t bytes_ = 0;
};
```

正式项目中还应决定析构函数如何处理错误，以及同步生命周期是否由 Buffer、Stream 还是上层调度器负责。

### 2. 把正确性测试自动化

至少覆盖：

- `n = 0`；
- 小于一个 Warp；
- 非 Block 整数倍；
- 很大输入；
- 奇数尺寸矩阵；
- NaN、Inf、极值；
- 不同随机种子；
- 多种 GPU 架构；
- CPU 参考实现；
- Sanitizer 检查。

### 3. 将性能回归纳入 CI

性能测试要保存环境元数据，并设置合理波动区间。不要因为一次共享机器上的慢运行就判定回归，也不要只看平均值。

建议记录：

- GPU 型号与功耗状态；
- 驱动和 Toolkit；
- 编译参数和 Git 提交；
- 输入尺寸；
- 预热次数、重复次数；
- 中位数、P90、P99；
- 数值误差；
- 端到端与 Kernel 分项耗时。

### 4. 为架构兼容性制定策略

发布二进制时，需要考虑目标 GPU 的 Compute Capability、是否包含对应 Cubin、是否保留 PTX 供未来架构 JIT，以及部署环境的驱动兼容性。

**"在开发机能跑"不是发布策略。**

### 5. 避免隐式全局同步

常见性能杀手包括：

- 频繁 `cudaDeviceSynchronize()`；
- 在热路径反复分配和释放；
- 不必要的 Device↔Host 往返；
- 默认 Stream 与其他 Stream 的意外交互；
- 每个小操作都单独启动 Kernel；
- 日志或调试代码改变执行时序。

同步应表达真实数据依赖，而不是用来"让程序看起来稳定"。

### 6. 用 NVTX 标注业务阶段

在大型程序中，Kernel 名称通常不足以说明业务含义。可以用 NVTX 给 CPU 代码段打标签，让 Nsight Systems 时间线更易读。

```cpp
nvtxRangePushA("preprocess");
// 预处理与 CUDA 调用
nvtxRangePop();
```

一个好用的性能报告，应当能回答"哪个业务阶段慢"，而不仅是"哪个匿名 Kernel 慢"。

---

## 常见误区：很多"CUDA 经验"其实只对了一半

**误区 1：GPU 核心多，所以一定更快**

GPU 需要足够并行度、合理的数据移动和适配的算法。小任务、强串行依赖、复杂分支可能并不适合。

**误区 2：把 CPU 循环改成 Kernel 就完成优化了**

这只是迁移。真正的优化往往需要改变数据布局、减少传输、增加复用、融合阶段，甚至重写算法。

**误区 3：共享内存一定比全局内存快**

共享内存访问本身快，但加载、同步、Bank Conflict 和 Occupancy 损失都要计入。只用一次的数据搬进共享内存，可能得不偿失。

**误区 4：Occupancy 越高越快**

Occupancy 是手段，不是目标。应观察最终吞吐和瓶颈类型。

**误区 5：cudaMemcpyAsync 写上 Async 就会并发**

还需要正确的 Host 内存类型、Stream、硬件能力和无冲突的数据依赖。

**误区 6：只测 Kernel 时间就能说明业务收益**

用户感知的是端到端延迟或吞吐。Kernel 快 10 倍，但前后传输占 90%，整体仍可能几乎不变。

**误区 7：没有崩溃就是正确**

越界、竞争、未初始化读取可能暂时不崩。必须做结果校验和 Sanitizer 检查。

**误区 8：手写 Kernel 一定比库快**

成熟库拥有长期积累的架构调优和边界处理。手写版本应该通过测量证明价值，而不是靠信念。

---

## 一条可执行的学习路线

### 阶段 1：入门，目标是"写对"

掌握：

- Host / Device；
- Kernel 语法；
- Grid / Block / Thread；
- `cudaMalloc`、`cudaMemcpy`、`cudaFree`；
- 边界检查；
- 错误检查；
- CPU 参考结果校验。

练习：

- 向量加法；
- SAXPY；
- 图像灰度化；
- 简单逐元素激活函数。

### 阶段 2：进阶，目标是"解释为什么快或慢"

掌握：

- Warp 与分支发散；
- 合并访存；
- Shared Memory；
- Bank Conflict；
- 归约；
- CUDA Events；
- Nsight Systems / Compute；
- Compute Sanitizer。

练习：

- Reduction；
- 矩阵转置；
- Histogram；
- 二维卷积；
- 扫描与前缀和。

### 阶段 3：高级，目标是"设计流水线"

掌握：

- Streams 与 Events；
- Pinned Memory；
- 异步复制；
- 双缓冲；
- Kernel Fusion；
- CUB / Thrust；
- cuBLAS / cuFFT；
- CUDA Graphs；
- Memory Pool。

练习：

- 分块流式处理大数据；
- 多 Stream 图像流水线；
- 重复工作流 Graph 化；
- 手写算子与库版本对比。

### 阶段 4：精通，目标是"跨架构稳定交付"

掌握：

- Warp 原语与 Cooperative Groups；
- 多 GPU 与 NCCL；
- 混合精度和 Tensor Core；
- PTX / SASS 分析；
- 架构目标与兼容性；
- 性能模型与 Roofline；
- 自动化正确性和性能回归；
- 领域算法与数据布局共同设计。

此时真正重要的问题已经不再是"这个 API 怎么调用"，而是：

> **算法的并行结构、数据布局、硬件资源和业务目标，应该如何一起设计？**

---

## CUDA 性能优化检查表

每次优化前后，可以按下面的顺序检查：

### 正确性

- 所有 CUDA API 都有错误检查；
- Kernel 启动错误和异步执行错误都能捕获；
- 有 CPU 或高精度参考实现；
- 边界尺寸已覆盖；
- 运行过 Compute Sanitizer；
- 浮点容差有依据。

### 数据移动

- 是否把数据频繁搬回 CPU；
- 是否能让数据长期驻留 GPU；
- 小传输能否合并；
- 是否需要 Pinned Memory；
- 传输和计算能否重叠。

### Kernel

- Warp 内访问是否连续；
- 是否存在明显分支发散；
- 是否有重复全局内存读取；
- Shared Memory 是否真的带来复用；
- 是否发生 Bank Conflict；
- 寄存器是否过多或溢出；
- Block 尺寸是否经过测量；
- Occupancy 是否与瓶颈相关，而非被盲目追求。

### 系统级

- 是否存在大量小 Kernel；
- 是否有不必要的全局同步；
- 是否可以使用库；
- 是否适合 Kernel Fusion；
- 是否适合 CUDA Graphs；
- 是否需要多 GPU；
- 是否记录完整环境和性能基线。

---

## 结语：CUDA 的"精通"，不是记住更多 API

CUDA 入门，是学会写 `__global__`、计算线程索引、分配显存。

CUDA 进阶，是理解 Warp、内存层次、同步、访存合并和性能分析。

CUDA 精通，则是能够在正确性、性能、可维护性、可移植性和交付成本之间做出可解释的权衡。

最终你会发现，GPU 编程最核心的能力并不是"让更多线程跑起来"，而是三件事：

1. 把问题拆成足够独立的并行工作；
2. 让数据以更低成本到达需要它的计算单元；
3. 用测量而不是直觉，决定下一步优化。

当你开始先看时间线、再看指标；先验证正确性、再谈峰值；先考虑数据布局、再堆共享内存——你就已经跨过了 CUDA 最重要的一道门槛。
