# [PyTorch 从入门到精通：一篇文章打通张量、自动微分、模型训练与工程化](https://mp.weixin.qq.com/s/1b1pVpm2fF_ss-RVzlxQAg)

> 这是一个关于"拾光实验室"的故事——一个靠模型吃饭的三人算法团队，和它从"模型能跑但谁也说不清为什么"到"训练结果可复现、可扩展、可部署"的完整旅程。你会跟着沈砚一起，把 Tensor、Autograd、nn.Module、训练循环、DDP 和模型导出一条主线串起来。读完之后你会发现：PyTorch 真正的门槛不是 API 数量，而是能否把数据、计算图、训练状态和工程边界放进同一套思维框架。

---

## 故事的起点：能跑，但谁也不敢动

"拾光实验室"是三个算法工程师的小团队：沈砚、师姐林夏、实习生小周。他们在做一个 FashionMNIST 之上的图像分类模型，代码是三个月前小周照着教程拼出来的：单文件七百行，训练循环和业务逻辑搅在一起，随机种子散落在五个角落。

模型能跑。但出问题时，没人敢动它。

那天早上，沈砚只是想改一下 batch size，跑出来的准确率却从 92% 掉到了 87%。查了一上午，发现是改动的位置恰好在一个没固定种子的数据增强旁边。下午，小周在另一台机器上重跑实验，结果又对不上了。

很多人学 PyTorch，卡在三个阶段：**会写 Tensor，却写不完整训练循环；模型能跑，却不知道为什么有效；单卡能训练，却不会提速、扩展和部署。**

沈砚团队三样全占。

PyTorch 的 API 很多，但真正高频、决定你能否独立完成项目的知识并不分散。你只需要先建立这样一条主线：

```
数据 → Tensor → 模型 → 损失函数 → 自动求导 → 优化器 → 评估 → 保存与部署
```

在这条主线上，初学者关注"代码能不能运行"，进阶者关注"结果是否可靠"，熟练工程师则继续追问：

- 数据加载是不是瓶颈？
- 显存为什么不够？
- 训练结果为什么不能复现？
- 多张 GPU 如何正确扩展？
- 模型如何导出并进入生产环境？

林夏在白板上写了一句话：**所谓"精通"，不是背下所有 API，而是建立四层心智模型。**

这个故事，就是沈砚团队沿着这条主线，把"能跑"变成"可靠"的路线图。

---

## 第一站：先建立 PyTorch 的四层心智模型

把 PyTorch 看成四层，会比死记函数名容易得多。

### 第一层：Tensor——所有计算的载体

`torch.Tensor` 可以理解为"支持加速设备和自动求导的多维数组"。它和 NumPy 数组很像，但多了两个关键能力：

- 可以放在 CPU、CUDA GPU、Apple Silicon 的 MPS 等设备上计算；
- 可以记录运算过程，并自动计算梯度。

### 第二层：Autograd——自动微分引擎

只要参数设置了 `requires_grad=True`，PyTorch 就能追踪相关运算，并在调用 `backward()` 时按链式法则计算梯度。这就是神经网络能够"学习"的基础。

### 第三层：nn.Module——模型的组织方式

卷积层、线性层、归一化层、激活函数，以及你自己定义的网络，都可以组织成 `nn.Module`。它负责：

- 注册可训练参数；
- 管理子模块；
- 切换训练和评估状态；
- 在不同设备之间迁移；
- 保存与加载参数。

### 第四层：训练与工程系统

这一层包括：Dataset 与 DataLoader、损失函数与优化器、混合精度训练、编译加速、分布式训练、检查点、日志、复现和模型导出。

一句话总结：**Tensor 负责算，Autograd 负责求导，Module 负责组织模型，训练系统负责把实验变成可靠工程。**

---

## 第二站：安装环境——先把"版本地狱"挡在门外

### 1. 创建独立虚拟环境

推荐使用 Python 自带的 venv：

```bash
python -m venv .venv
```

激活环境：

```bash
# macOS / Linux
source .venv/bin/activate
```

```powershell
# Windows PowerShell
.venv\Scripts\Activate.ps1
```

升级安装工具：

```bash
python -m pip install --upgrade pip
```

### 2. 安装 PyTorch

没有 NVIDIA GPU，或只是学习基础，可以先安装通用版本：

```bash
pip install torch torchvision
```

使用 NVIDIA CUDA、AMD ROCm 或 Intel XPU 时，**不要随手复制网上几年前的命令**。打开 PyTorch 官方安装页，按操作系统、包管理器和计算平台生成命令。

### 3. 验证安装

```python
import torch

print("PyTorch:", torch.__version__)
print("CUDA available:", torch.cuda.is_available())
print(torch.rand(2, 3))
```

### 4. 写一个通用设备选择函数

```python
import torch


def get_device() -> torch.device:
    if torch.cuda.is_available():
        return torch.device("cuda")
    if hasattr(torch.backends, "mps") and torch.backends.mps.is_available():
        return torch.device("mps")
    return torch.device("cpu")


device = get_device()
print("Using device:", device)
```

请记住一个贯穿全文的原则：

**参与同一次运算的 Tensor 和模型参数，通常必须位于同一设备。**

---

## 第三站：Tensor——先掌握 20% 的操作，解决 80% 的问题

### 1. 创建 Tensor

```python
import torch

# 从 Python 列表创建
x = torch.tensor([[1, 2], [3, 4]], dtype=torch.float32)

# 常用初始化
zeros = torch.zeros(2, 3)
ones = torch.ones(2, 3)
random_normal = torch.randn(2, 3)
random_uniform = torch.rand(2, 3)

# 整数序列
indices = torch.arange(0, 10, 2)

print(x)
print(x.shape)
print(x.dtype)
print(x.device)
```

一个 Tensor 最重要的三个属性是：

- **shape**：形状
- **dtype**：数据类型
- **device**：所在设备

绝大多数 PyTorch 报错，都能从这三个方向排查。

### 2. 形状变换

```python
x = torch.arange(24).reshape(2, 3, 4)
print(x.shape)              # torch.Size([2, 3, 4])
print(x.reshape(6, 4).shape)
print(x.flatten().shape)
print(x.unsqueeze(0).shape) # 增加一个维度
print(x.squeeze(0).shape)   # 仅移除大小为 1 的维度
```

交换维度：

```python
images_nhwc = torch.randn(8, 224, 224, 3)
images_nchw = images_nhwc.permute(0, 3, 1, 2)
print(images_nchw.shape)  # [8, 3, 224, 224]
```

图像模型通常使用 NCHW：

- N：batch size
- C：通道数
- H：高度
- W：宽度

### 3. view 和 reshape 有什么区别？

`view()` 通常要求底层内存连续，`reshape()` 在必要时可以创建副本，因此更稳妥。

```python
x = torch.randn(2, 3, 4)
y = x.permute(0, 2, 1)
# y.view(2, -1) 可能因内存不连续而报错
z = y.reshape(2, -1)
```

不确定时，优先使用 `reshape()`；确实需要连续内存时，可先调用：

```python
z = y.contiguous().view(2, -1)
```

### 4. 索引、切片与布尔掩码

```python
x = torch.tensor([1, 2, 3, 4, 5])
print(x[0])
print(x[1:4])
print(x[x > 3])
```

### 5. 广播机制

```python
x = torch.randn(32, 128)
bias = torch.randn(128)
y = x + bias
```

`bias` 会沿 batch 维自动广播。

**广播很方便，也很危险。**两个形状"碰巧能广播"时，代码可能不报错，却算出了错误结果。训练前养成打印形状的习惯：

```python
print("logits:", logits.shape)
print("targets:", targets.shape)
```

### 6. 矩阵乘法

```python
x = torch.randn(64, 128)
w = torch.randn(128, 10)
logits = x @ w
print(logits.shape)  # [64, 10]
```

对于分类问题，`logits[i, j]` 可以理解为第 i 个样本属于第 j 类的未归一化得分。

### 7. NumPy 与 Tensor 互转

```python
import numpy as np
import torch

array = np.array([1, 2, 3], dtype=np.float32)
tensor = torch.from_numpy(array)
back_to_numpy = tensor.numpy()
```

CPU Tensor 与 NumPy 数组可能共享内存；修改一方时，另一方也可能变化。GPU Tensor 不能直接 `.numpy()`，需要先移到 CPU：

```python
array = tensor_on_gpu.detach().cpu().numpy()
```

---

## 第四站：Autograd——理解这一节，你才真正理解"训练"

先看一个最小例子。假设模型为 `y = wx + b`，我们希望通过数据学习 w 和 b。

```python
import torch

x = torch.tensor([1.0, 2.0, 3.0])
y_true = torch.tensor([3.0, 5.0, 7.0])

w = torch.tensor(0.0, requires_grad=True)
b = torch.tensor(0.0, requires_grad=True)

for step in range(100):
    y_pred = w * x + b
    loss = ((y_pred - y_true) ** 2).mean()

    # 反向传播前清空旧梯度
    if w.grad is not None:
        w.grad.zero_()
    if b.grad is not None:
        b.grad.zero_()

    loss.backward()

    # 手动执行梯度下降，更新参数时不需要记录计算图
    with torch.no_grad():
        w -= 0.1 * w.grad
        b -= 0.1 * b.grad

print("w =", w.item())
print("b =", b.item())
```

这段代码完成了神经网络训练最核心的四步：

```
前向计算 → 计算损失 → 反向传播 → 更新参数
```

### 1. loss.backward() 到底做了什么？

前向计算时，PyTorch 构建动态计算图；调用 `backward()` 后，它从损失开始反向遍历图，根据链式法则计算每个叶子参数的梯度，并写入参数的 `.grad`。

### 2. 为什么每轮都要清空梯度？

PyTorch 默认**累加**梯度，而不是覆盖梯度：

```python
loss.backward()
loss.backward()
# 连续调用两次，参数梯度通常会累加两次
```

使用优化器时，推荐：

```python
optimizer.zero_grad(set_to_none=True)
```

相比把梯度填成全零，设为 `None` 往往更节省内存，也能帮助你识别某个参数是否真的获得了梯度。

### 3. detach()、no_grad() 和 inference_mode()

`detach()`：切断某个 Tensor 的梯度关系：

```python
y = model(x)
y_detached = y.detach()
```

`torch.no_grad()`：临时关闭梯度记录：

```python
with torch.no_grad():
    predictions = model(x)
```

`torch.inference_mode()`：推理专用模式：

```python
with torch.inference_mode():
    predictions = model(x)
```

纯推理时通常优先使用 `inference_mode()`。它不仅关闭梯度，还能跳过部分与 Autograd 相关的开销。

### 4. 原地操作为什么容易出问题？

带下划线的方法通常是原地操作：

```python
x.add_(1)
x.relu_()
```

原地操作可能覆盖反向传播需要的中间值，导致版本检查错误。刚入门时，不要为了"少占一点内存"过度使用原地操作；**先保证计算图正确。**

---

## 第五站：nn.Module——把数学公式变成可训练模型

一个最小多层感知机：

```python
import torch
from torch import nn


class MLP(nn.Module):
    def __init__(self, input_dim: int, hidden_dim: int, num_classes: int):
        super().__init__()
        self.network = nn.Sequential(
            nn.Linear(input_dim, hidden_dim),
            nn.ReLU(),
            nn.Dropout(p=0.2),
            nn.Linear(hidden_dim, num_classes),
        )

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        return self.network(x)


model = MLP(input_dim=784, hidden_dim=256, num_classes=10)
x = torch.randn(32, 784)
logits = model(x)
print(logits.shape)  # [32, 10]
```

### 1. 为什么要继承 nn.Module？

因为它会自动注册：`nn.Parameter`、子模块、训练和评估状态、`state_dict` 中需要保存的内容。

查看参数：

```python
for name, parameter in model.named_parameters():
    print(name, parameter.shape)
```

### 2. 为什么调用 model(x)，而不是 model.forward(x)？

`model(x)` 会经过 `nn.Module.__call__()`，从而正确处理钩子、混合精度、编译等机制。**除非你非常清楚内部行为，否则不要直接调用 `forward()`。**

### 3. train() 和 eval() 不只是形式

```python
model.train()
model.eval()
```

它们会影响 Dropout、BatchNorm 等层：

- 训练前：`model.train()`；
- 验证和推理前：`model.eval()`。

注意：`model.eval()` 不会自动关闭梯度，所以验证时通常还要配合 `torch.inference_mode()`。

### 4. 分类模型最后要不要手动加 Softmax？

如果使用 `nn.CrossEntropyLoss()`，模型应输出原始 logits，**不要在模型最后手动加 Softmax**。

正确：

```python
logits = model(images)
loss = criterion(logits, targets)
```

推理时需要概率，再单独计算：

```python
probabilities = logits.softmax(dim=1)
```

---

## 第六站：Dataset 与 DataLoader——把数据管道和模型解耦

PyTorch 将数据职责拆成两部分：

- **Dataset**：定义"如何取得一条样本"；
- **DataLoader**：负责批处理、打乱、多进程加载和迭代。

### 1. 自定义 Dataset

```python
import torch
from torch.utils.data import Dataset


class ArrayDataset(Dataset):
    def __init__(self, features: torch.Tensor, labels: torch.Tensor):
        if len(features) != len(labels):
            raise ValueError("features 与 labels 长度必须一致")
        self.features = features
        self.labels = labels

    def __len__(self) -> int:
        return len(self.features)

    def __getitem__(self, index: int):
        return self.features[index], self.labels[index]
```

### 2. 使用 DataLoader

```python
from torch.utils.data import DataLoader

loader = DataLoader(
    dataset,
    batch_size=64,
    shuffle=True,
    num_workers=4,
    pin_memory=torch.cuda.is_available(),
)

for features, labels in loader:
    print(features.shape, labels.shape)
    break
```

### 3. num_workers 不是越大越好

`num_workers > 0` 可以让数据加载与模型计算重叠，但最优值取决于：

- CPU 核心数；
- 磁盘速度；
- 数据预处理复杂度；
- batch 大小；
- 操作系统和容器限制。

工程上应该通过实验调优，而不是默认写成 CPU 核心数。

### 4. pin_memory 与 non_blocking

使用 CUDA GPU 时，常见组合是：

```python
loader = DataLoader(dataset, pin_memory=True)

for images, targets in loader:
    images = images.to("cuda", non_blocking=True)
    targets = targets.to("cuda", non_blocking=True)
```

它有机会加快 CPU 到 GPU 的数据传输，但收益依赖数据管道和硬件，仍应实测。

---

## 第七站：完整实战——训练一个 FashionMNIST 图像分类器

沈砚决定不再修那七百行的旧脚本，而是照着一份标准结构重写。这份脚本覆盖了一个可靠训练项目应有的核心结构：

- 配置集中管理；
- 随机种子；
- CPU、CUDA、MPS 自动选择；
- Dataset 和 DataLoader；
- CNN 模型；
- 训练与评估函数；
- CUDA 自动混合精度；
- 梯度裁剪；
- 学习率调度；
- 保存最佳检查点；
- 可选 torch.compile。

将代码保存为 `train_fashion_mnist.py`：

```python
from __future__ import annotations

import os
import random
from dataclasses import asdict, dataclass
from pathlib import Path

import numpy as np
import torch
from torch import nn
from torch.utils.data import DataLoader
from torchvision import datasets, transforms


@dataclass
class Config:
    data_dir: str = "./data"
    output_dir: str = "./outputs"
    batch_size: int = 128
    epochs: int = 5
    learning_rate: float = 3e-4
    weight_decay: float = 1e-2
    num_workers: int = min(4, os.cpu_count() or 1)
    seed: int = 42
    use_amp: bool = True
    use_compile: bool = False
    grad_clip_norm: float = 1.0


def seed_worker(worker_id: int) -> None:
    """为 DataLoader 的每个 worker 设置可复现种子。"""
    del worker_id
    worker_seed = torch.initial_seed() % (2**32)
    np.random.seed(worker_seed)
    random.seed(worker_seed)


def seed_everything(seed: int) -> None:
    random.seed(seed)
    np.random.seed(seed)
    torch.manual_seed(seed)
    if torch.cuda.is_available():
        torch.cuda.manual_seed_all(seed)


def get_device() -> torch.device:
    if torch.cuda.is_available():
        return torch.device("cuda")
    if hasattr(torch.backends, "mps") and torch.backends.mps.is_available():
        return torch.device("mps")
    return torch.device("cpu")


class FashionCNN(nn.Module):
    def __init__(self, num_classes: int = 10) -> None:
        super().__init__()
        self.features = nn.Sequential(
            nn.Conv2d(1, 32, kernel_size=3, padding=1),
            nn.BatchNorm2d(32),
            nn.ReLU(),
            nn.MaxPool2d(2),
            nn.Conv2d(32, 64, kernel_size=3, padding=1),
            nn.BatchNorm2d(64),
            nn.ReLU(),
            nn.MaxPool2d(2),
        )
        self.classifier = nn.Sequential(
            nn.Flatten(),
            nn.Linear(64 * 7 * 7, 128),
            nn.ReLU(),
            nn.Dropout(0.2),
            nn.Linear(128, num_classes),
        )

    def forward(self, x: torch.Tensor) -> torch.Tensor:
        x = self.features(x)
        return self.classifier(x)
```

模型和数据管道就绪之后，是训练主循环（含 AMP 与梯度裁剪）：

```python
def train_one_epoch(
    model: nn.Module,
    loader: DataLoader,
    criterion: nn.Module,
    optimizer: torch.optim.Optimizer,
    device: torch.device,
    scaler: torch.amp.GradScaler,
    grad_clip_norm: float,
) -> float:
    model.train()
    total_loss = 0.0
    for images, targets in loader:
        images = images.to(device, non_blocking=True)
        targets = targets.to(device, non_blocking=True)

        optimizer.zero_grad(set_to_none=True)
        with torch.amp.autocast(
            device_type=device.type,
            dtype=torch.float16,
            enabled=scaler.is_enabled(),
        ):
            logits = model(images)
            loss = criterion(logits, targets)

        scaler.scale(loss).backward()
        scaler.unscale_(optimizer)
        torch.nn.utils.clip_grad_norm_(model.parameters(), grad_clip_norm)
        scaler.step(optimizer)
        scaler.update()

        total_loss += loss.item() * images.size(0)
    return total_loss / len(loader.dataset)


@torch.inference_mode()
def evaluate(
    model: nn.Module,
    loader: DataLoader,
    device: torch.device,
) -> float:
    model.eval()
    correct = 0
    total = 0
    for images, targets in loader:
        images = images.to(device, non_blocking=True)
        targets = targets.to(device, non_blocking=True)
        logits = model(images)
        correct += (logits.argmax(dim=1) == targets).sum().item()
        total += targets.size(0)
    return correct / total


def main() -> None:
    config = Config()
    seed_everything(config.seed)
    device = get_device()
    output_dir = Path(config.output_dir)
    output_dir.mkdir(parents=True, exist_ok=True)

    transform_train = transforms.Compose([
        transforms.RandomHorizontalFlip(),
        transforms.ToTensor(),
        transforms.Normalize((0.2860,), (0.3530,)),
    ])
    transform_eval = transforms.Compose([
        transforms.ToTensor(),
        transforms.Normalize((0.2860,), (0.3530,)),
    ])

    train_set = datasets.FashionMNIST(
        config.data_dir, train=True, download=True, transform=transform_train,
    )
    val_set = datasets.FashionMNIST(
        config.data_dir, train=False, download=True, transform=transform_eval,
    )

    generator = torch.Generator().manual_seed(config.seed)
    train_loader = DataLoader(
        train_set,
        batch_size=config.batch_size,
        shuffle=True,
        num_workers=config.num_workers,
        pin_memory=device.type == "cuda",
        worker_init_fn=seed_worker,
        generator=generator,
    )
    val_loader = DataLoader(
        val_set,
        batch_size=config.batch_size,
        shuffle=False,
        num_workers=config.num_workers,
        pin_memory=device.type == "cuda",
    )

    model = FashionCNN().to(device)
    if config.use_compile and hasattr(torch, "compile"):
        model = torch.compile(model)

    criterion = nn.CrossEntropyLoss()
    optimizer = torch.optim.AdamW(
        model.parameters(),
        lr=config.learning_rate,
        weight_decay=config.weight_decay,
    )
    scheduler = torch.optim.lr_scheduler.CosineAnnealingLR(
        optimizer, T_max=config.epochs,
    )
    scaler = torch.amp.GradScaler(
        device.type, enabled=config.use_amp and device.type == "cuda",
    )

    best_acc = 0.0
    for epoch in range(1, config.epochs + 1):
        loss = train_one_epoch(
            model, train_loader, criterion, optimizer,
            device, scaler, config.grad_clip_norm,
        )
        accuracy = evaluate(model, val_loader, device)
        scheduler.step()
        print(
            f"epoch={epoch} loss={loss:.4f} "
            f"val_acc={accuracy:.4f} lr={scheduler.get_last_lr()[0]:.2e}"
        )
        if accuracy > best_acc:
            best_acc = accuracy
            torch.save(model.state_dict(), output_dir / "best.pt")

    print(f"best val acc: {best_acc:.4f}")


if __name__ == "__main__":
    main()
```

---

## 第八站：逐行拆解训练循环——每一步都不能含糊

标准训练循环的骨架：

```python
model.train()

for images, targets in loader:
    images = images.to(device, non_blocking=True)
    targets = targets.to(device, non_blocking=True)

    # 1. 清空上一步的梯度
    optimizer.zero_grad(set_to_none=True)

    # 2. 前向计算
    logits = model(images)
    loss = criterion(logits, targets)

    # 3. 反向传播
    loss.backward()

    # 4. 更新参数
    optimizer.step()
```

沈砚把每一步的"为什么"写在注释旁边：

- **zero_grad 必须在 backward 之前**——梯度默认累加，漏掉这一步，上一批的梯度会混进这一批；
- **loss.backward() 构建并遍历计算图**——没有它，`.grad` 永远是 None；
- **optimizer.step() 才真正改参数**——只 backward 不 step，模型永远不会变；
- **数据搬运 .to(device) 要和模型同设备**——否则报错第一句就是 device mismatch。

---

## 第九站：验证与推理——最容易被忽略，却最影响结果可信度

标准验证流程：

```python
model.eval()
with torch.inference_mode():
    for inputs, targets in val_loader:
        inputs = inputs.to(device)
        targets = targets.to(device)
        logits = model(inputs)
```

### 三个常见错误

**错误 1：忘记 model.eval()**——Dropout 仍会随机丢弃神经元，BatchNorm 仍可能更新统计量，导致推理结果不稳定。

**错误 2：验证时仍记录梯度**——不会改变结果，但会浪费内存和算力。

**错误 3：训练集指标很好，就认为模型很好**——训练集指标只能说明模型拟合了训练数据。真正要关注的是验证集和测试集表现，以及它们与训练集之间的差距。

---

## 第十站：保存与恢复——不要只保存一个"最终模型"

### 1. 推荐保存 state_dict

只保存权重：

```python
torch.save(model.state_dict(), "model_weights.pt")
```

加载：

```python
model = FashionCNN()
state_dict = torch.load(
    "model_weights.pt",
    map_location="cpu",
    weights_only=True,
)
model.load_state_dict(state_dict)
model.eval()
```

官方推荐以 `state_dict` 作为常规保存方式。加载纯权重或只含安全基础类型的检查点时，使用 `weights_only=True` 可以限制反序列化范围。

### 2. 继续训练需要保存完整检查点

```python
checkpoint = {
    "model": model.state_dict(),
    "optimizer": optimizer.state_dict(),
    "scheduler": scheduler.state_dict(),
    "scaler": scaler.state_dict(),
    "epoch": epoch,
    "best_metric": best_metric,
}
torch.save(checkpoint, "checkpoint.pt")
```

恢复：

```python
checkpoint = torch.load(
    "checkpoint.pt",
    map_location=device,
    weights_only=True,
)
model.load_state_dict(checkpoint["model"])
optimizer.load_state_dict(checkpoint["optimizer"])
scheduler.load_state_dict(checkpoint["scheduler"])
scaler.load_state_dict(checkpoint["scaler"])

start_epoch = checkpoint["epoch"] + 1
best_metric = checkpoint["best_metric"]
```

### 3. 最佳模型不是"最后一轮模型"

训练后期可能过拟合。应该根据验证集指标保存最佳检查点，而不是默认保留最后一轮。

还有一个隐蔽问题：

```python
best_state = model.state_dict()
```

这里得到的内容可能仍引用模型当前状态。若只想保留内存中的最佳参数，应使用深拷贝，或者在指标提升时立即 `torch.save()`。

---

## 第十一站：调试 PyTorch——先查形状，再查类型，再查设备

### 1. 建立"形状契约"

例如图像分类：

```
输入 images：  [N, C, H, W]
卷积输出：      [N, C2, H2, W2]
分类 logits：   [N, num_classes]
标签 targets：  [N]
```

在关键位置加断言：

```python
assert images.ndim == 4
assert logits.ndim == 2
assert logits.size(0) == targets.size(0)
assert targets.dtype == torch.long
```

### 2. 检查是否出现 NaN 或 Inf

```python
if not torch.isfinite(loss):
    raise FloatingPointError(f"Loss is not finite: {loss.item()}")
```

常见原因：学习率过大；输入没有合理归一化；除以零；对非正数取对数；混合精度下数值溢出；梯度爆炸。

### 3. 临时开启异常检测

```python
with torch.autograd.detect_anomaly():
    loss.backward()
```

它能帮助定位反向传播中产生 NaN 或非法梯度的操作，但会显著变慢，只建议调试时使用。

### 4. 检查梯度

```python
for name, parameter in model.named_parameters():
    if parameter.grad is None:
        print(name, "has no gradient")
    else:
        print(name, parameter.grad.norm().item())
```

梯度为 None 可能意味着：参数没有参与当前前向计算；中途调用了 `detach()`；使用了不可微操作；参数被冻结；某条分支没有被执行。

### 5. 常见报错速查

| 现象 | 高概率原因 | 排查方向 |
| --- | --- | --- |
| Expected all tensors to be on the same device | 模型和数据不在同一设备 | 打印所有关键 Tensor 的 `.device` |
| 矩阵乘法维度不匹配 | 展平后的特征数写错 | 打印每层输出形状 |
| CrossEntropyLoss 类型报错 | 标签不是整数类别索引 | 使用 `targets.long()` 并检查形状 |
| Loss 不下降 | 学习率、标签、预处理或梯度流程错误 | 先尝试在很小数据集上过拟合 |
| CUDA OOM | batch 太大、中间激活太多、引用未释放 | 降 batch、AMP、梯度累积、检查点技术 |
| 验证结果波动异常 | 忘记 `eval()` 或数据仍有随机增强 | 固定验证预处理并切换评估模式 |
| DataLoader 卡住 | 多进程、平台或数据读取问题 | 先把 `num_workers` 改为 0 |
| torch.compile 第一次更慢 | 首次需要捕获和编译 | 预热后比较稳定阶段吞吐量 |

### 6. 一个非常有效的调试方法：先过拟合极小数据集

取 16 或 32 条样本，反复训练。如果模型连这点数据都无法接近完全拟合，优先怀疑代码、标签、损失或数据预处理，而不是"模型容量不够"。

---

## 第十二站：性能优化——先测量，再动手

不要看到"优化技巧"就全部打开。正确顺序是：

```
建立基线 → 找瓶颈 → 修改一个变量 → 重新测量 → 保留有效改动
```

### 1. 先判断瓶颈在数据还是计算

如果 GPU 利用率长期很低，可能是：数据读取慢；CPU 预处理慢；batch 太小；每一步 Python 调度开销过大；频繁在 CPU 和 GPU 之间同步。

如果 GPU 利用率高但吞吐量仍低，可能需要：AMP、更高效算子、`torch.compile`、更合适的 batch、减少不必要的内存访问。

### 2. 自动混合精度 AMP

现代写法使用 `torch.amp`：

```python
amp_enabled = device.type == "cuda"
scaler = torch.amp.GradScaler("cuda", enabled=amp_enabled)

optimizer.zero_grad(set_to_none=True)
with torch.amp.autocast(
    device_type="cuda",
    dtype=torch.float16,
    enabled=amp_enabled,
):
    logits = model(inputs)
    loss = criterion(logits, targets)

scaler.scale(loss).backward()
scaler.unscale_(optimizer)
torch.nn.utils.clip_grad_norm_(model.parameters(), 1.0)
scaler.step(optimizer)
scaler.update()
```

AMP 的价值通常是：降低部分计算和激活的内存占用；利用现代 GPU 的低精度计算单元；在许多模型上提升吞吐量。

但它不是无条件加速。小模型、CPU 瓶颈任务或不适合低精度的算子，收益可能有限。

### 3. torch.compile

PyTorch 2.x 提供 `torch.compile`，用于捕获并优化模型或函数。

```python
model = MyModel().to(device)
model.compile()
# 或者
model = torch.compile(model)
```

注意四点：

1. 首次运行有编译成本；
2. 应预热后再测吞吐量；
3. 动态控制流、频繁变化的形状和不支持的操作可能造成 graph break 或重新编译；
4. 并非所有模型和硬件都一定变快，必须基准测试。

### 4. 减少显存占用

常用手段按优先级考虑：

- 减小 batch size；
- 开启 AMP；
- 使用 `zero_grad(set_to_none=True)`；
- 梯度累积；
- 激活检查点；
- 缩短序列长度或输入分辨率；
- 减少不必要的中间 Tensor 引用；
- 大模型使用 FSDP2、张量并行等分片方案。

**梯度累积示例：**

```python
accumulation_steps = 4

optimizer.zero_grad(set_to_none=True)
for step, (inputs, targets) in enumerate(loader, start=1):
    logits = model(inputs)
    loss = criterion(logits, targets) / accumulation_steps
    loss.backward()

    if step % accumulation_steps == 0:
        optimizer.step()
        optimizer.zero_grad(set_to_none=True)
```

它能用较小显存模拟更大的有效 batch，但训练时间不会凭空减少。

### 5. 不要每一步都调用 torch.cuda.empty_cache()

`empty_cache()` 释放的是缓存分配器中未被 Tensor 占用的缓存，不会让仍被引用的 Tensor 消失。每一步调用往往破坏缓存复用，反而使训练变慢。

发生 OOM 时，真正要找的是：

- 哪些 Tensor 仍被 Python 容器、日志列表或闭包引用；
- 是否保存了带计算图的 loss 或输出，而不是 `.item()` / `.detach()`；
- batch、序列长度和模型激活是否过大。

### 6. 使用 Profiler，而不是凭感觉优化

最小示例：

```python
import torch
from torch.profiler import ProfilerActivity, profile

activities = [ProfilerActivity.CPU]
if torch.cuda.is_available():
    activities.append(ProfilerActivity.CUDA)

with profile(
    activities=activities,
    record_shapes=True,
    profile_memory=True,
) as prof:
    logits = model(inputs)
    loss = criterion(logits, targets)
    loss.backward()

print(prof.key_averages().table(sort_by="self_cpu_time_total", row_limit=10))
```

Profiler 能告诉你时间和内存花在哪里，但分析结果时要考虑预热、异步执行和采样开销。

---

## 第十三站：可复现性——固定随机种子不等于完全复现

基础设置：

```python
import random

import numpy as np
import torch

seed = 42
random.seed(seed)
np.random.seed(seed)
torch.manual_seed(seed)
if torch.cuda.is_available():
    torch.cuda.manual_seed_all(seed)
```

需要更严格确定性时，可以研究：

```python
torch.use_deterministic_algorithms(True)
```

但确定性算法可能更慢，某些操作也可能没有确定性实现。

更重要的是，官方明确提醒：**跨 PyTorch 版本、平台、设备，甚至 CPU 与 GPU 之间，不保证完全逐位一致。**

一个可复现实验至少应记录：

- Python、PyTorch、CUDA/ROCm 版本；
- GPU 型号和数量；
- 随机种子；
- 数据版本与划分方式；
- 全部超参数；
- 代码提交哈希；
- 是否开启 AMP、TF32、编译和确定性选项。

**"我固定了 42"只是开始，不是结束。**

---

## 第十四站：从单卡到多卡——DDP、FSDP2、TP 和 PP 怎么选

先记住官方给出的实用决策逻辑：

```
模型能放进单张 GPU，只想加快训练 → DDP
模型放不进单张 GPU               → FSDP2
FSDP2 仍达到扩展瓶颈             → 再考虑张量并行 TP / 流水线并行 PP
```

### 1. DDP：数据并行的主力方案

DDP 为每个进程维护一份模型副本，每个进程处理不同数据，反向传播时同步梯度。

最小骨架：

```python
import os

import torch
import torch.distributed as dist
from torch.nn.parallel import DistributedDataParallel as DDP
from torch.utils.data import DataLoader, DistributedSampler


def main():
    dist.init_process_group(backend="nccl")
    local_rank = int(os.environ["LOCAL_RANK"])
    torch.cuda.set_device(local_rank)
    device = torch.device("cuda", local_rank)

    dataset = MyDataset()
    sampler = DistributedSampler(dataset, shuffle=True)
    loader = DataLoader(
        dataset,
        batch_size=64,
        sampler=sampler,
        num_workers=4,
        pin_memory=True,
    )

    model = MyModel().to(device)
    model = DDP(model, device_ids=[local_rank])

    optimizer = torch.optim.AdamW(model.parameters(), lr=3e-4)

    for epoch in range(num_epochs):
        sampler.set_epoch(epoch)
        model.train()
        for inputs, targets in loader:
            inputs = inputs.to(device, non_blocking=True)
            targets = targets.to(device, non_blocking=True)

            optimizer.zero_grad(set_to_none=True)
            logits = model(inputs)
            loss = criterion(logits, targets)
            loss.backward()
            optimizer.step()

    dist.destroy_process_group()


if __name__ == "__main__":
    main()
```

单机四卡启动：

```bash
torchrun --standalone --nproc-per-node=4 train_ddp.py
```

DDP 中必须注意：

- 每个进程绑定一张 GPU；
- 使用 `DistributedSampler`，避免各进程读取完全相同的数据；
- 每个 epoch 调用 `sampler.set_epoch(epoch)`，确保正确打乱；
- 只让主进程写日志和保存检查点，避免重复写文件；
- 全局 batch size 约等于单进程 batch size × 进程数 × 梯度累积步数。

### 2. FSDP2：模型放不下一张 GPU 时

DDP 的每个进程拥有完整模型副本。FSDP2 会分片参数、梯度和优化器状态，显著降低单卡内存压力。

它适合：

- 大语言模型；
- 大型视觉或多模态模型；
- 优化器状态占用巨大；
- 单卡无法容纳完整训练状态。

但 FSDP2 也引入更多通信、检查点与包装策略复杂度。模型能放进一张 GPU 时，通常先把 DDP 跑稳，再升级到 FSDP2。

### 3. 为什么不建议把 DataParallel 当作长期方案？

`nn.DataParallel` 使用单进程集中调度，多卡扩展和性能通常不如多进程 DDP。教学演示可以见到它，但严肃训练项目应优先学习 DDP。

---

## 第十五站：模型导出与部署——训练完成只是项目的一半

### 1. Python 环境内推理

最简单、最稳妥的方式仍然是：

```
保存 state_dict → 创建同结构模型 → 加载参数 → model.eval() → inference_mode()
```

### 2. 使用 torch.export

`torch.export` 旨在获得可进一步变换、编译或部署的完整计算图表示。

```python
import torch

model = FashionCNN()
state_dict = torch.load(
    "model_weights.pt",
    map_location="cpu",
    weights_only=True,
)
model.load_state_dict(state_dict)
model.eval()

example_inputs = (torch.randn(1, 1, 28, 28),)
exported_program = torch.export.export(model, example_inputs)
torch.export.save(exported_program, "fashion_cnn.pt2")
```

`torch.export` 比普通 eager mode 对可捕获图有更严格要求。遇到不可追踪的 Python 控制流或数据依赖行为时，它可能直接报错，这恰恰有助于暴露部署边界。

### 3. ONNX

跨框架或接入 ONNX Runtime、TensorRT 等工具链时，可以考虑 ONNX。现代 PyTorch ONNX 导出器以 `torch.export` 为基础，具体参数应按当前官方文档和目标运行时版本验证。

### 4. 不要把"成功导出"等同于"部署完成"

上线前至少要验证：

- 导出前后输出误差；
- 动态 batch 或动态尺寸；
- 前处理、后处理一致性；
- 吞吐量和尾延迟；
- 精度转换影响；
- 目标平台算子支持；
- 版本锁定和回滚方案。

另外，TorchScript 已进入弃用路线。新项目不应再把它当作默认未来方案，应根据部署目标研究 `torch.export`、AOTInductor、ONNX 或 ExecuTorch。

---

## 第十六站：从"会用"到"精通"的代码组织方式

当一个脚本超过几百行，就应开始拆分——这正是沈砚重写那七百行旧脚本时做的事：

```
project/
├── configs/
│   └── train.yaml
├── data/
├── src/
│   ├── datasets.py
│   ├── models.py
│   ├── losses.py
│   ├── engine.py
│   ├── metrics.py
│   └── utils.py
├── train.py
├── evaluate.py
├── export.py
├── tests/
├── requirements.txt
└── README.md
```

推荐的职责边界：

- `datasets.py`：读取、清洗、增强和采样；
- `models.py`：网络结构；
- `engine.py`：训练与验证循环；
- `metrics.py`：指标计算；
- `utils.py`：随机种子、日志、检查点；
- `train.py`：组装配置与启动训练；
- `evaluate.py`：独立评估；
- `export.py`：导出和一致性测试。

真正成熟的训练代码，不是"抽象越多越专业"，而是：**每个模块职责清晰，关键状态可追踪，实验能够重复，失败后可以恢复。**

---

## 第十七站：学习路线——30 天打通 PyTorch

### 第 1 周：打牢计算基础

重点：Tensor 创建、索引、广播；`reshape`、`permute`；dtype 与 device；Autograd；用 Tensor 手写线性回归和两层网络。

验收标准：不依赖高层训练框架，能解释并写出前向、损失、反向和参数更新。

### 第 2 周：完成标准项目

重点：Dataset、DataLoader；`nn.Module`；CNN、MLP；训练、验证、推理；检查点；TensorBoard 或其他实验日志。

验收标准：能把一个公开数据集项目从零跑通，并独立处理常见维度和设备报错。

### 第 3 周：提升结果可靠性

重点：数据划分；过拟合与正则化；学习率调度；指标选择；随机性与复现；小数据集过拟合测试；单元测试和断言。

验收标准：能够解释"为什么相信这个结果"。

### 第 4 周：进入工程与规模化

重点：AMP；Profiler；DataLoader 调优；`torch.compile`；DDP；FSDP2 基础；`torch.export` 与 ONNX。

验收标准：能根据瓶颈选择优化工具，而不是堆砌"加速开关"。

---

## 终点站：最后总结——记住这 12 条，PyTorch 就不会再乱

1. 任何问题先打印 `shape`、`dtype`、`device`。
2. 模型、输入和标签要放在兼容设备上。
3. `CrossEntropyLoss` 接收原始 logits，不要提前 Softmax。
4. 梯度默认累加，每轮正确清空。
5. 训练用 `model.train()`，验证与推理用 `model.eval()`。
6. 推理使用 `torch.inference_mode()`。
7. 保存权重优先使用 `state_dict`，恢复训练则保存完整检查点。
8. 先尝试过拟合极小数据集，再怀疑模型结构。
9. 性能优化必须先测量；AMP 和 `torch.compile` 都不是必然加速。
10. 模型能放进单卡、需要多卡加速时优先 DDP；放不下再看 FSDP2。
11. 固定随机种子不等于跨平台、跨版本完全复现。
12. 新部署路线优先研究 `torch.export`，不要再把 TorchScript 当作默认未来方案。

---

两个月后的那个下午，林夏在新机器上重跑了沈砚拆分后的项目：`python train.py --config configs/train.yaml`，几十秒后验证集准确率和上周的记录一字不差。小周照着 `export.py` 导出了模型，ONNX 在客户的推理服务里跑通，前后输出误差在小数点后第六位。

没人再问"结果能不能信"——每个模块职责清晰，关键状态可追踪，实验能够重复，失败后可以恢复。

PyTorch 真正的门槛，不是 API 数量，而是能否把数据、计算图、训练状态和工程边界放进同一套思维框架。当你能够回答下面四个问题，就已经越过了"会写示例"的阶段：

**模型为什么能学到？结果为什么可信？训练为什么这么快或这么慢？代码失败后能否定位、恢复和扩展？**

这，才是从入门走向精通。

正如林夏写在白板顶部的那句话：

> "Tensor 负责算，Autograd 负责求导，Module 负责组织模型——而工程师，负责让这一切变得可信。"

## 参考资料 / 官方延伸阅读

- [PyTorch 安装选择器](https://pytorch.org/get-started/locally/)
- [PyTorch Learn the Basics](https://pytorch.org/tutorials/beginner/basics/intro.html)
- [Tensor 与 DataLoader 快速入门](https://pytorch.org/tutorials/beginner/data_loading_tutorial.html)
- [自动混合精度 torch.amp](https://pytorch.org/docs/stable/amp.html)
- [torch.compile 文档](https://pytorch.org/docs/stable/torch.compiler.html)
- [模型保存与加载](https://pytorch.org/tutorials/beginner/saving_loading_models.html)
- [可复现性说明](https://pytorch.org/docs/stable/notes/randomness.html)
- [PyTorch Distributed 总览](https://pytorch.org/tutorials/beginner/dist_overview.html)
- [FSDP2 入门教程](https://pytorch.org/tutorials/intermediate/FSDP_advaeraged_tutorial.html)
- [torch.export 文档](https://pytorch.org/docs/stable/export.html)

> 版本提示：PyTorch 迭代较快（torch.amp API、torch.export、FSDP2 等均在演进中，TorchScript 已进入弃用路线）。实际使用前，请以所装版本的官方文档为准核对 API 与参数。
