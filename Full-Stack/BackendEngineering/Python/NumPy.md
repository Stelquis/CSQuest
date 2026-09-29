# [NumPy 从入门到精通：一篇文章掌握 Python 科学计算核心](https://mp.weixin.qq.com/s/HHH62VhVhkG26TWOW3MyTQ)

> 这是一个关于"数变多之后"的故事——当数据规模从几十条增长到几十万、几百万条，普通 Python 列表和 for 循环往往会变得笨重。NumPy 提供了高效的多维数组、向量化计算、广播机制、随机数生成和线性代数工具，是数据分析、机器学习、图像处理与科学计算的共同基础。本文从零开始，逐步讲清 NumPy 最重要的概念，并通过可直接运行的代码、常见误区和综合实战，帮助你完成从"会用"到"用好"的跨越。

---

## 为什么一定要学 NumPy？

Python 原生列表非常灵活，可以同时存放整数、字符串、对象等不同类型的数据。但这种灵活性也带来了额外开销：当我们需要对大量数值执行同一种运算时，逐个元素解释执行的效率并不理想。

NumPy 的核心对象是 `ndarray`，也就是 N 维数组。它通常保存同一种数据类型，并将大量常用运算交给底层优化代码执行。

先看一个最直观的例子：

```python
import numpy as np

python_list = [1, 2, 3, 4]
numpy_array = np.array([1, 2, 3, 4])

# Python 列表乘以 2：重复列表
print(python_list * 2)
# [1, 2, 3, 4, 1, 2, 3, 4]

# NumPy 数组乘以 2：每个元素分别乘以 2
print(numpy_array * 2)
# [2 4 6 8]
```

NumPy 的价值主要体现在四个方面：

1. **速度快**：批量数值运算减少了 Python 层循环的开销。
2. **表达简洁**：一行向量化代码可以替代多层循环。
3. **功能完整**：数组变形、统计、随机数、线性代数等功能开箱即用。
4. **生态基础**：Pandas、SciPy、Matplotlib、scikit-learn 等库都与 NumPy 深度兼容。

---

## 安装与导入

```bash
pip install numpy
```

在代码中通常使用约定俗成的别名 `np`：

```python
import numpy as np

print(np.__version__)
```

建议在虚拟环境中管理项目依赖，避免不同项目之间的版本冲突。

---

## 认识 NumPy 的核心：ndarray

### 1. 创建第一个数组

```python
import numpy as np

arr = np.array([
    [1, 2, 3],
    [4, 5, 6]
], dtype=np.float64)

print(arr)
# [[1. 2. 3.]
#  [4. 5. 6.]]
```

### 2. 五个必须掌握的属性

```python
print(arr.ndim)      # 维度数量：2
print(arr.shape)     # 每个维度的长度：(2, 3)
print(arr.size)      # 元素总数：6
print(arr.dtype)     # 元素类型：float64
print(arr.itemsize)  # 单个元素占用的字节数：通常为 8
```

可以把 `shape` 理解为数组的"外形"：

- `(6,)`：长度为 6 的一维数组；
- `(2, 3)`：2 行 3 列的二维数组；
- `(4, 3, 224, 224)`：可理解为 4 组、3 通道、224×224 的数据（典型的一批 RGB 图片）。

需要特别注意：**`(6,)` 和 `(6, 1)` 不是同一种形状**。前者是一维数组，后者是二维列向量。

```python
x = np.array([1, 2, 3])
y = np.array([[1], [2], [3]])

print(x.shape)  # (3,)
print(y.shape)  # (3, 1)
```

---

## 创建数组的常用方法

### 1. 从 Python 序列创建

```python
np.array([1, 2, 3])
np.array((1, 2, 3))
np.array([[1, 2], [3, 4]])
```

### 2. 创建等差序列

```python
# 左闭右开：不包含 10
print(np.arange(0, 10, 2))
# [0 2 4 6 8]
```

`arange` 更适合整数步长。处理浮点区间时，通常优先使用 `linspace`：

```python
# 在 0 和 1 之间生成 5 个等间距的数，包含两端
print(np.linspace(0, 1, 5))
# [0.   0.25 0.5  0.75 1.  ]
```

### 3. 创建特殊数组

```python
print(np.zeros((2, 3)))       # 全 0
print(np.ones((2, 3)))        # 全 1
print(np.full((2, 3), 7))     # 全部填充为 7
print(np.eye(3))              # 3 阶单位矩阵
```

`np.empty` 只分配内存，不负责清零：

```python
arr = np.empty((2, 3))
print(arr)
```

它的初始内容不可预测，因此必须在读取前完整赋值。**不要把 `empty` 当作"空数组"或"全 0 数组"。**

### 4. 按已有数组的形状创建

```python
base = np.array([[1, 2], [3, 4]])

print(np.zeros_like(base))
print(np.ones_like(base))
print(np.full_like(base, 9))
```

这类函数能自动继承原数组的形状和数据类型，在工程代码中非常实用。

---

## 索引与切片：读取你想要的数据

### 1. 一维数组索引

```python
arr = np.array([10, 20, 30, 40, 50])

print(arr[0])     # 10
print(arr[-1])    # 50
print(arr[1:4])   # [20 30 40]
print(arr[::2])   # [10 30 50]
print(arr[::-1])  # [50 40 30 20 10]
```

切片遵循 Python 的左闭右开规则：`start` 包含，`stop` 不包含。

### 2. 二维数组索引

```python
matrix = np.array([
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
])

print(matrix[1, 2])      # 第 2 行第 3 列：6
print(matrix[1])         # 第 2 行：[4 5 6]
print(matrix[:, 0])      # 第 1 列：[1 4 7]
print(matrix[:2, 1:])    # 前两行、后两列
# [[2 3]
#  [5 6]]
```

### 3. 布尔索引：按条件筛选

```python
scores = np.array([58, 72, 91, 66, 85])

mask = scores >= 60
print(mask)
# [False  True  True  True  True]

print(scores[mask])
# [72 91 66 85]
```

也可以直接写：

```python
passed = scores[scores >= 60]
```

组合多个条件时，使用 `&`、`|`、`~`，并为每个条件加括号：

```python
selected = scores[(scores >= 70) & (scores < 90)]
print(selected)
# [72 85]
```

不要写成下面这样：

```python
# 错误示例
# scores >= 70 and scores < 90
```

`and` 和 `or` 面向单个布尔值，不能直接对整个 NumPy 布尔数组逐元素运算。

### 4. 花式索引：按位置批量选取

```python
arr = np.array([10, 20, 30, 40, 50])

print(arr[[0, 2, 4]])
# [10 30 50]
```

二维数组也可以按指定行号选取：

```python
matrix = np.arange(12).reshape(4, 3)
print(matrix[[3, 0, 2]])
```

花式索引和布尔索引通常产生**副本**；普通切片通常产生**视图**。后文会详细解释二者的区别。

---

## 向量化：告别不必要的 for 循环

所谓向量化，就是把"逐个元素处理"改写成"对整个数组执行运算"。

### 1. 基本算术运算

```python
a = np.array([1, 2, 3])
b = np.array([10, 20, 30])

print(a + b)   # [11 22 33]
print(a - b)   # [ -9 -18 -27]
print(a * b)   # [10 40 90]
print(b / a)   # [10. 10. 10.]
print(a ** 2)  # [1 4 9]
```

这里的 `*` 表示**逐元素相乘**，不是矩阵乘法。矩阵乘法使用 `@` 或 `np.matmul`。

### 2. 通用函数 ufunc

NumPy 提供了大量逐元素运算函数：

```python
x = np.array([1, 4, 9, 16])

print(np.sqrt(x))
print(np.exp(x))
print(np.log(x))
print(np.sin(x))
print(np.abs(np.array([-2, 3, -5])))
```

这些函数通常可以直接作用于任意维度的数组。

### 3. 条件计算

```python
scores = np.array([58, 72, 91, 66, 85])
labels = np.where(scores >= 60, "及格", "不及格")

print(labels)
```

将数值限制在指定范围：

```python
temperatures = np.array([-5, 12, 26, 43])
print(np.clip(temperatures, 0, 35))
# [ 0 12 26 35]
```

### 4. np.vectorize 不等于性能向量化

`np.vectorize` 可以让普通函数以"数组形式"调用，但它本质上通常仍在逐元素执行 Python 函数，主要价值是接口方便，**不一定更快**。

```python
def classify(x):
    return "正数" if x > 0 else "非正数"

vectorized_classify = np.vectorize(classify)
print(vectorized_classify(np.array([-2, 0, 3])))
```

追求性能时，应优先组合 NumPy 原生运算，而不是把 Python 函数简单包进 `np.vectorize`。

---

## 广播机制：NumPy 最强大也最容易困惑的能力

广播允许不同形状的数组在满足规则时进行运算，而不必真的复制数据。

### 1. 标量与数组

```python
arr = np.array([1, 2, 3])
print(arr + 10)
# [11 12 13]
```

可以把标量 10 想象成被扩展成 `[10, 10, 10]`，但 NumPy 通常不会真的创建这个完整副本。

### 2. 广播规则

从两个数组形状的**最右侧维度**开始逐个比较。两个维度可以兼容，当且仅当：

- 两者相等；
- 其中一个为 1；
- 某一方缺少该维度。

例如：

```
(3, 4)
(4,)
```

右侧维度 4 与 4 相等，第二个数组缺少左侧维度，因此可以广播。

### 3. 为每一列应用不同权重

```python
scores = np.array([
    [80, 90, 70, 85],
    [60, 75, 88, 92],
    [95, 82, 76, 89]
])

weights = np.array([0.2, 0.3, 0.1, 0.4])
weighted_scores = scores * weights

print(weighted_scores)
```

`scores` 的形状是 `(3, 4)`，`weights` 的形状是 `(4,)`。权重会自动作用到每一行。

### 4. 列标准化

```python
x = np.array([
    [10, 100],
    [20, 120],
    [30, 140]
], dtype=float)

column_mean = x.mean(axis=0)
column_std = x.std(axis=0)

z_score = (x - column_mean) / column_std
```

`column_mean` 和 `column_std` 的形状都是 `(2,)`，可以与 `(3, 2)` 的 `x` 广播。

### 5. 用 keepdims=True 保留维度

```python
row_mean = x.mean(axis=1, keepdims=True)
print(row_mean.shape)
# (3, 1)

centered = x - row_mean
```

如果不保留维度，`x.mean(axis=1)` 的形状是 `(3,)`，它不能按预期与 `(3, 2)` 进行"逐行相减"。`keepdims=True` 经常能让广播逻辑更加清晰。

---

## 聚合与统计：真正理解 axis

`axis` 是 NumPy 学习中的关键难点。最稳妥的理解方式是：

> **axis=n 表示沿着第 n 个维度进行压缩。**

```python
arr = np.array([
    [1, 2, 3],
    [4, 5, 6]
])
```

### 1. 对全部元素聚合

```python
print(arr.sum())
# 21
```

### 2. axis=0：压缩行，得到每一列的结果

```python
print(arr.sum(axis=0))
# [5 7 9]
```

原形状 `(2, 3)` 去掉第 0 维后，结果形状为 `(3,)`。

### 3. axis=1：压缩列，得到每一行的结果

```python
print(arr.sum(axis=1))
# [6 15]
```

原形状 `(2, 3)` 去掉第 1 维后，结果形状为 `(2,)`。

### 4. 常用统计函数

```python
print(arr.mean())          # 平均值
print(arr.std())           # 标准差
print(arr.var())           # 方差
print(arr.min())           # 最小值
print(arr.max())           # 最大值
print(arr.argmin())        # 最小值在展平数组中的位置
print(arr.argmax())        # 最大值在展平数组中的位置
print(np.median(arr))      # 中位数
print(np.quantile(arr, 0.75))  # 75% 分位数
```

累计运算：

```python
x = np.array([1, 2, 3, 4])

print(np.cumsum(x))   # [ 1  3  6 10]
print(np.cumprod(x))  # [ 1  2  6 24]
```

### 5. 含缺失值的数据

普通聚合函数遇到 NaN 时，结果往往也是 NaN：

```python
x = np.array([1.0, np.nan, 3.0])

print(np.mean(x))     # nan
print(np.nanmean(x))  # 2.0
```

类似函数还有：

```python
np.nansum(x)
np.nanstd(x)
np.nanmin(x)
np.nanmax(x)
np.nanmedian(x)
```

判断缺失值时应使用 `np.isnan`：

```python
print(np.isnan(x))
# [False  True False]
```

**不要用 `x == np.nan`**，因为按照浮点数规则，NaN 与任何值比较都不相等，包括它自己。

---

## 数组变形：让数据适配算法

### 1. reshape

```python
arr = np.arange(12)

matrix = arr.reshape(3, 4)
print(matrix)
# [[ 0  1  2  3]
#  [ 4  5  6  7]
#  [ 8  9 10 11]]
```

使用 `-1` 让 NumPy 自动推断某个维度：

```python
print(arr.reshape(2, -1).shape)
# (2, 6)
```

元素总数必须保持不变，否则会报错。

### 2. 展平数组

```python
matrix = np.arange(6).reshape(2, 3)

view_like = matrix.ravel()
copy_array = matrix.flatten()
```

通常：

- `ravel()` 尽可能返回**视图**，更节省内存；
- `flatten()` 总是返回**副本**，更独立但会占用额外内存。

### 3. 转置

```python
matrix = np.array([
    [1, 2, 3],
    [4, 5, 6]
])

print(matrix.T)
# 形状从 (2, 3) 变成 (3, 2)
```

对于高维数组，可以显式指定轴顺序：

```python
x = np.zeros((2, 3, 4))
y = x.transpose(1, 0, 2)

print(y.shape)
# (3, 2, 4)
```

### 4. 增加与删除长度为 1 的维度

```python
x = np.array([1, 2, 3])

row_vector = x[np.newaxis, :]
column_vector = x[:, np.newaxis]

print(row_vector.shape)     # (1, 3)
print(column_vector.shape)  # (3, 1)
```

也可以使用：

```python
np.expand_dims(x, axis=0)
np.expand_dims(x, axis=1)
```

删除长度为 1 的维度：

```python
x = np.zeros((1, 3, 1))
print(np.squeeze(x).shape)
# (3,)
```

生产代码中，建议为 `squeeze` 指定 `axis`，避免误删本来需要保留的维度。

---

## 数组拼接与拆分

### 1. concatenate：沿已有维度拼接

```python
a = np.array([[1, 2], [3, 4]])
b = np.array([[5, 6], [7, 8]])

print(np.concatenate([a, b], axis=0))
# 纵向拼接，结果形状 (4, 2)

print(np.concatenate([a, b], axis=1))
# 横向拼接，结果形状 (2, 4)
```

### 2. stack：创建一个新维度

```python
x = np.array([1, 2, 3])
y = np.array([4, 5, 6])

print(np.stack([x, y], axis=0).shape)  # (2, 3)
print(np.stack([x, y], axis=1).shape)  # (3, 2)
```

常用快捷函数：

```python
np.vstack([x, y])
np.hstack([x, y])
np.column_stack([x, y])
```

选择函数时，先明确"沿已有轴拼接"还是"新增一个轴"，不要只凭函数名称猜测。

### 3. 拆分数组

```python
arr = np.arange(12).reshape(3, 4)

left, right = np.split(arr, 2, axis=1)
print(left.shape)   # (3, 2)
print(right.shape)  # (3, 2)
```

当不能等分时，可以指定切分位置：

```python
parts = np.split(arr, [1, 3], axis=1)
# 会按照列索引 1 和 3 分成三部分
```

---

## 视图与副本：最容易埋下隐蔽 Bug 的地方

NumPy 为了节省内存和提高效率，很多操作不会复制数据，而是创建"视图"。**视图与原数组共享底层数据。**

### 1. 普通切片通常返回视图

```python
arr = np.array([10, 20, 30, 40, 50])
sub = arr[1:4]

sub[:] = 99

print(sub)
# [99 99 99]

print(arr)
# [10 99 99 99 50]
```

修改 `sub` 后，原数组 `arr` 也发生了变化。

### 2. 需要独立数据时显式复制

```python
arr = np.array([10, 20, 30, 40, 50])
sub = arr[1:4].copy()

sub[:] = 99
print(arr)
# [10 20 30 40 50]
```

### 3. 花式索引通常返回副本

```python
arr = np.array([10, 20, 30, 40, 50])
selected = arr[[1, 2, 3]]
selected[:] = 99

print(arr)
# 原数组通常不受影响
```

### 4. 检查是否共享内存

```python
print(np.shares_memory(arr, arr[1:4]))
# True
```

经验法则：

- 只读分析时，视图通常更高效；
- 数据即将被修改且不能影响原数组时，立即 `.copy()`；
- 函数是否修改输入数组，应在接口文档和变量命名中明确说明。

---

## 数据类型：精度、内存与兼容性的平衡

NumPy 数组通常是同质的，也就是所有元素采用同一种 dtype。

### 1. 常见数据类型

```
np.int8  np.int16  np.int32  np.int64
np.float32  np.float64
np.bool_  np.complex64  np.complex128
```

查看类型范围：

```python
print(np.iinfo(np.int32))
print(np.finfo(np.float32))
```

### 2. 类型转换

```python
x = np.array([1.2, 2.8, 3.5])
y = x.astype(np.int32)

print(y)
# [1 2 3]
```

浮点数转整数通常是**截断**小数部分，而不是四舍五入。需要四舍五入时应先使用：

```python
rounded = np.rint(x).astype(np.int32)
```

### 3. 整数数组的原地除法陷阱

```python
x = np.array([1, 2, 3])

# 可能因无法把浮点结果安全写回整数数组而报错
# x /= 2
```

更稳妥的写法：

```python
x = x.astype(float)
x /= 2
```

或者：

```python
x = np.array([1, 2, 3]) / 2
```

### 4. 避免无意产生 object 类型

```python
mixed = np.array([1, "2", 3.0], dtype=object)
print(mixed.dtype)
```

object 数组存放的是 Python 对象引用，很多 NumPy 的性能优势会因此减弱。纯数值计算中，应尽量使用明确的数值类型。

### 5. 浮点数比较

不要直接假定浮点计算结果能精确相等：

```python
print(0.1 + 0.2 == 0.3)
# False
```

NumPy 中推荐使用：

```python
print(np.isclose(0.1 + 0.2, 0.3))

actual = np.array([0.1 + 0.2, 1.0])
expected = np.array([0.3, 1.0])
print(np.allclose(actual, expected))
```

---

## 现代随机数生成：使用 Generator

推荐使用 `np.random.default_rng()` 创建独立随机数生成器：

```python
import numpy as np

rng = np.random.default_rng(42)
```

指定种子后，同一段代码更容易复现实验结果。

### 1. 常用随机分布

```python
print(rng.random(5))
# [0, 1) 区间均匀分布

print(rng.integers(0, 10, size=5))
# 0 到 9 的随机整数

print(rng.normal(loc=0, scale=1, size=5))
# 均值 0、标准差 1 的正态分布

print(rng.uniform(-1, 1, size=5))
# [-1, 1) 区间均匀分布
```

### 2. 随机抽样

```python
items = np.array(["A", "B", "C", "D"])

print(rng.choice(items, size=2, replace=False))
```

带权抽样：

```python
print(
    rng.choice(
        items,
        size=5,
        replace=True,
        p=[0.1, 0.2, 0.3, 0.4]
    )
)
```

### 3. 打乱顺序

```python
arr = np.arange(10)
rng.shuffle(arr)  # 原地修改
print(arr)
```

需要返回新数组、不修改原数组时：

```python
arr = np.arange(10)
shuffled = rng.permutation(arr)
```

---

## 线性代数：从矩阵乘法到方程求解

### 1. 矩阵乘法

```python
A = np.array([
    [1, 2],
    [3, 4]
])

B = np.array([
    [5, 6],
    [7, 8]
])

print(A @ B)
print(np.matmul(A, B))
```

`A * B` 是逐元素相乘，`A @ B` 才是矩阵乘法。

### 2. 向量点积

```python
x = np.array([1, 2, 3])
y = np.array([4, 5, 6])

print(x @ y)
# 32
```

### 3. 求解线性方程组

对于方程 `Ax = b`，使用 `np.linalg.solve`：

```python
A = np.array([
    [3.0, 1.0],
    [1.0, 2.0]
])

b = np.array([9.0, 8.0])

x = np.linalg.solve(A, b)
print(x)
# [2. 3.]
```

通常不建议为了求解 x 而显式计算 `np.linalg.inv(A) @ b`。直接求解一般更清晰，也通常更稳定。

### 4. 常用线性代数函数

```python
np.linalg.det(A)      # 行列式
np.linalg.matrix_rank(A)
np.linalg.norm(A)     # 范数
np.linalg.inv(A)      # 逆矩阵
np.linalg.eig(A)      # 特征值和特征向量
np.linalg.svd(A)      # 奇异值分解
```

对实对称矩阵或复厄米矩阵，优先考虑 `np.linalg.eigh`，它利用了矩阵结构。

---

## 排序、去重与查找

### 1. 排序

```python
x = np.array([30, 10, 40, 20])

print(np.sort(x))
# [10 20 30 40]
```

获取排序后的原始索引：

```python
indices = np.argsort(x)
print(indices)
# [1 3 0 2]

print(x[indices])
# [10 20 30 40]
```

### 2. 只找最大的前 K 个元素

如果不需要完整排序，`partition` 往往更合适：

```python
x = np.array([12, 3, 25, 7, 18, 30])
k = 3

top_k_unsorted = np.partition(x, -k)[-k:]
print(top_k_unsorted)
```

结果中的前三大元素不保证内部有序。如需有序，再对这部分排序即可。

### 3. 去重与计数

```python
x = np.array([3, 1, 2, 3, 2, 3])

values, counts = np.unique(x, return_counts=True)
print(values)  # [1 2 3]
print(counts)  # [1 2 3]
```

对于非负整数类别计数，还可以使用：

```python
labels = np.array([0, 2, 1, 2, 2, 0])
print(np.bincount(labels))
# [2 1 3]
```

### 4. 在有序数组中查找插入位置

```python
sorted_x = np.array([10, 20, 30, 40])
print(np.searchsorted(sorted_x, 25))
# 2
```

---

## 数据读写：保存和加载数组

### 1. 保存单个数组

```python
arr = np.arange(10)
np.save("data.npy", arr)
```

加载：

```python
loaded = np.load("data.npy")
```

`.npy` 可以保留数组的形状和数据类型。

### 2. 保存多个数组

```python
x = np.arange(5)
y = np.linspace(0, 1, 5)

np.savez("dataset.npz", x=x, y=y)
```

压缩保存：

```python
np.savez_compressed("dataset_compressed.npz", x=x, y=y)
```

加载：

```python
data = np.load("dataset.npz")
print(data["x"])
print(data["y"])
```

### 3. 文本格式

```python
matrix = np.array([[1.2, 3.4], [5.6, 7.8]])
np.savetxt("matrix.csv", matrix, delimiter=",", fmt="%.2f")

loaded = np.loadtxt("matrix.csv", delimiter=",")
```

对于缺失值、混合类型、复杂表头和日期字段较多的表格数据，Pandas 通常更方便；对于同质数值矩阵，NumPy 的读写方式更直接。

---

## 性能优化：从"能运行"到"运行得好"

### 1. 优先使用数组运算

低效写法：

```python
x = np.arange(1_000_000)
result = []

for value in x:
    result.append(value * 2 + 1)
```

向量化写法：

```python
result = x * 2 + 1
```

### 2. 预分配结果数组

循环无法避免时，不要频繁向 Python 列表或 NumPy 数组末尾追加大批数据。

```python
n = 1000
result = np.empty(n, dtype=float)

for i in range(n):
    result[i] = i ** 0.5
```

尤其不要在循环中反复使用 `np.append`。它通常会创建新数组并复制旧数据。

### 3. 避免 object 类型

纯数值计算尽量使用整数、浮点数或布尔类型。object 数组会让大量操作退回 Python 对象层面。

### 4. 减少不必要的中间数组

下面的表达式可能创建多个中间结果：

```python
result = (x - x.mean()) / x.std()
```

多数场景下这种可读性优先的写法完全可以接受。但当数组巨大、内存紧张时，可以分步复用变量：

```python
mean = x.mean()
std = x.std()

result = x.astype(float, copy=True)
result -= mean
result /= std
```

不要为了"少一行代码"而牺牲可读性；只有在性能分析确认瓶颈后再优化。

### 5. 用广播代替显式复制

```python
matrix = np.arange(12).reshape(3, 4)
offsets = np.array([10, 20, 30, 40])

result = matrix + offsets
```

无需先把 `offsets` 复制成 3 行。

### 6. 正确测量性能

在 Jupyter Notebook 中可以使用：

```
%timeit x * 2 + 1
```

普通 Python 脚本可以使用 `timeit` 模块。不要只运行一次就下结论，因为系统调度、缓存和初始化都会影响单次结果。

### 7. 先选择正确算法，再做微优化

完整排序是 O(n log n)；只找前 K 大元素时，`partition` 可能更合适。矩阵方程应优先 `solve`，而不是先求逆。算法选择通常比局部代码技巧更重要。

---

## 进阶表达：einsum、条件选择与批量计算

### 1. einsum：用下标描述张量运算

矩阵乘法：

```python
A = np.arange(6).reshape(2, 3)
B = np.arange(12).reshape(3, 4)

C = np.einsum("ij,jk->ik", A, B)
print(C)
```

按行计算两个矩阵对应行的点积：

```python
x = np.array([[1, 2, 3], [4, 5, 6]])
y = np.array([[7, 8, 9], [1, 2, 3]])

row_dot = np.einsum("ij,ij->i", x, y)
print(row_dot)
```

`einsum` 很强大，但可读性成本较高。简单矩阵乘法优先使用 `@`；当运算涉及多个轴、转置、求和的组合时，再考虑 `einsum`。

### 2. 多条件分类

```python
scores = np.array([45, 62, 78, 91])

conditions = [
    scores < 60,
    (scores >= 60) & (scores < 80),
    scores >= 80
]

choices = ["不及格", "良好", "优秀"]
labels = np.select(conditions, choices, default="未知")

print(labels)
```

### 3. 批量距离计算

假设有多个二维点，希望计算每个点到原点的欧氏距离：

```python
points = np.array([
    [3, 4],
    [5, 12],
    [8, 15]
])

distances = np.linalg.norm(points, axis=1)
print(distances)
# [ 5. 13. 17.]
```

计算两组点之间的两两距离：

```python
A = np.array([[0, 0], [1, 1], [2, 2]])
B = np.array([[1, 0], [3, 3]])

# A[:, None, :] 形状：(3, 1, 2)
# B[None, :, :] 形状：(1, 2, 2)
diff = A[:, None, :] - B[None, :, :]
distances = np.linalg.norm(diff, axis=2)

print(distances.shape)
# (3, 2)
```

这段代码同时用到了增加维度、广播和沿轴聚合，是 NumPy 高维计算的典型模式。

---

## 综合实战一：构建一套用户评分模型

假设我们有 1000 名用户，每名用户有四项指标：活跃度、消费额、留存天数和互动次数。目标是完成缺失值处理、标准化、加权评分，并找出得分最高的用户。

### 第一步：生成模拟数据

```python
import numpy as np

rng = np.random.default_rng(42)

features = np.column_stack([
    rng.normal(50, 10, 1000),   # 活跃度
    rng.normal(500, 120, 1000), # 消费额
    rng.normal(180, 40, 1000),  # 留存天数
    rng.normal(30, 8, 1000)     # 互动次数
])

# 随机制造部分缺失值
missing_rows = rng.choice(features.shape[0], size=30, replace=False)
features[missing_rows, 1] = np.nan

print(features.shape)
# (1000, 4)
```

### 第二步：用每列中位数填补缺失值

```python
column_medians = np.nanmedian(features, axis=0)

missing_positions = np.where(np.isnan(features))
features[missing_positions] = column_medians[missing_positions[1]]
```

`missing_positions[1]` 表示每个缺失值所在的列，因此可以取到对应列的中位数。

也可以采用更直观的逐列写法：

```python
for col in range(features.shape[1]):
    mask = np.isnan(features[:, col])
    features[mask, col] = column_medians[col]
```

当逻辑较复杂时，可读性比强行写成一行更重要。

### 第三步：标准化各项指标

```python
means = features.mean(axis=0)
stds = features.std(axis=0)

# 防止某列完全相同导致除以 0
safe_stds = np.where(stds == 0, 1.0, stds)
normalized = (features - means) / safe_stds
```

### 第四步：计算加权总分

```python
weights = np.array([0.25, 0.35, 0.25, 0.15])
final_scores = normalized @ weights
```

这里使用矩阵乘法：`(1000, 4) @ (4,) -> (1000,)`。

### 第五步：找出得分最高的 10 名用户

```python
top_n = 10
top_indices = np.argsort(final_scores)[-top_n:][::-1]

print("Top 10 用户索引：", top_indices)
print("Top 10 用户得分：", final_scores[top_indices])
```

对于超大数据集，只需要前 10 名时可以先用 `argpartition`：

```python
candidate_indices = np.argpartition(final_scores, -top_n)[-top_n:]
top_indices = candidate_indices[
    np.argsort(final_scores[candidate_indices])[::-1]
]
```

这个案例串联了 NumPy 的核心能力：

- 数组创建；
- 缺失值判断；
- 布尔索引；
- 按列聚合；
- 广播；
- 标准化；
- 矩阵乘法；
- 排序与 Top-K。

---

## 综合实战二：用蒙特卡洛方法估算圆周率

在边长为 2 的正方形中随机撒点。若点落在单位圆内，则满足 `x² + y² <= 1`。单位圆面积为 π，正方形面积为 4，因此圆内点比例约等于 π / 4。

```python
import numpy as np

rng = np.random.default_rng(42)
n = 1_000_000

points = rng.uniform(-1, 1, size=(n, 2))
inside_circle = np.sum(points ** 2, axis=1) <= 1

pi_estimate = 4 * inside_circle.mean()
print(pi_estimate)
```

这段代码没有针对 100 万个点编写 Python 循环，而是一次性完成：

1. 批量生成二维随机点；
2. 批量平方；
3. 按行求和；
4. 批量判断是否在圆内；
5. 计算布尔数组的平均值。

布尔值在求平均时，`True` 按 1、`False` 按 0 参与计算，因此平均值就是命中比例。

随机模拟的结果不会每次都完全相同，样本越多，估计通常越稳定，但计算和内存消耗也会增加。

---

## 十个高频错误与排查方法

**错误 1：数组不能直接用于 if**

```python
x = np.array([1, 2, 3])

# 错误
# if x > 1:
#     ...
```

`x > 1` 得到多个布尔值，Python 不知道你想判断"全部满足"还是"任意满足"。

```python
if np.all(x > 0):
    print("全部大于 0")

if np.any(x > 2):
    print("至少一个大于 2")
```

**错误 2：混淆 `*` 与 `@`**

```python
A * B  # 逐元素相乘
A @ B  # 矩阵乘法
```

**错误 3：广播失败**

```
operands could not be broadcast together
```

排查时先打印：

```python
print(a.shape)
print(b.shape)
```

再从最右侧维度逐项检查兼容性。

**错误 4：切片修改了原数组**

```python
sub = arr[1:4]
# 如果不希望共享数据：
sub = arr[1:4].copy()
```

**错误 5：忘记 axis 的方向**

判断聚合后结果形状：

```python
print(arr.shape)
print(arr.sum(axis=0).shape)
print(arr.sum(axis=1).shape)
```

"被指定的轴会被压缩"是最可靠的记忆方式。

**错误 6：用 `==` 比较浮点结果**

```python
np.isclose(a, b)
np.allclose(array_a, array_b)
```

**错误 7：使用 `np.empty` 后直接读取**

`empty` 中是未初始化数据，必须先完整写入。

**错误 8：对整数数组执行会产生浮点结果的原地运算**

```python
x = x.astype(float)
x /= 2
```

**错误 9：把 `np.vectorize` 当成加速器**

它主要改善调用方式，不保证性能。应优先使用 NumPy 原生 ufunc、广播和聚合函数。

**错误 10：循环中反复 `np.append`**

预先分配数组，或先收集到列表，最后一次性 `np.array` 转换。

---

## 调试与测试技巧

### 1. 优先检查形状和类型

```python
print("shape:", arr.shape)
print("dtype:", arr.dtype)
print("ndim:", arr.ndim)
```

大量 NumPy 问题本质上都是形状或类型不符合预期。

### 2. 控制打印格式

```python
np.set_printoptions(
    precision=3,
    suppress=True,
    linewidth=120
)
```

- `precision`：小数显示位数；
- `suppress=True`：尽量避免使用科学计数法；
- `linewidth`：每行显示宽度。

### 3. 在关键位置添加断言

```python
assert features.ndim == 2
assert features.shape[1] == 4
assert np.isfinite(final_scores).all()
```

### 4. 使用 NumPy 测试工具

```python
actual = np.array([0.30000001, 1.0])
expected = np.array([0.3, 1.0])

np.testing.assert_allclose(actual, expected, rtol=1e-5, atol=1e-8)
```

测试数值算法时，不要只验证形状，也要验证边界值、空输入、缺失值、极大或极小数值等情况。

---

## NumPy 核心 API 速查表

| 任务 | 常用写法 |
| --- | --- |
| 创建数组 | `np.array(data)` |
| 等差序列 | `np.arange(start, stop, step)` |
| 等间距序列 | `np.linspace(start, stop, num)` |
| 全 0 / 全 1 | `np.zeros(shape)` / `np.ones(shape)` |
| 指定填充值 | `np.full(shape, value)` |
| 单位矩阵 | `np.eye(n)` |
| 查看形状 | `arr.shape` |
| 查看维度 | `arr.ndim` |
| 查看类型 | `arr.dtype` |
| 改变形状 | `arr.reshape(...)` |
| 转置 | `arr.T` / `arr.transpose(...)` |
| 展平 | `arr.ravel()` / `arr.flatten()` |
| 增加维度 | `arr[:, None]` / `np.expand_dims` |
| 删除单例维度 | `np.squeeze(arr, axis=...)` |
| 条件筛选 | `arr[arr > 0]` |
| 条件选择 | `np.where(condition, a, b)` |
| 限制范围 | `np.clip(arr, low, high)` |
| 拼接 | `np.concatenate` / `np.stack` |
| 求和 | `arr.sum(axis=...)` |
| 平均值 | `arr.mean(axis=...)` |
| 标准差 | `arr.std(axis=...)` |
| 最大值位置 | `arr.argmax(axis=...)` |
| 忽略缺失值平均 | `np.nanmean(arr, axis=...)` |
| 排序 | `np.sort` / `np.argsort` |
| Top-K 候选 | `np.partition` / `np.argpartition` |
| 去重计数 | `np.unique(..., return_counts=True)` |
| 矩阵乘法 | `A @ B` |
| 方程求解 | `np.linalg.solve(A, b)` |
| 向量范数 | `np.linalg.norm(x, axis=...)` |
| 保存数组 | `np.save` / `np.savez_compressed` |
| 加载数组 | `np.load` |
| 随机数生成器 | `np.random.default_rng(seed)` |

---

## 从入门到精通的学习路线

### 第一阶段：建立数组思维

先熟练掌握：

- `array`、`arange`、`linspace`；
- `shape`、`ndim`、`dtype`；
- 基础索引和切片；
- `reshape` 与转置。

这个阶段的目标，是看到表格或矩阵时能立刻写出它的形状。

### 第二阶段：掌握向量化与广播

重点练习：

- 数组四则运算；
- 布尔索引；
- `where`、`clip`；
- 不同形状数组之间的广播；
- `axis` 与 `keepdims`。

这个阶段的目标，是把常见的逐元素循环改写成数组表达式。

### 第三阶段：理解内存和数值细节

深入理解：

- 视图与副本；
- 数据类型和类型转换；
- 浮点误差；
- 缺失值；
- 中间数组与内存占用。

这个阶段决定了代码能否在真实项目中保持正确和稳定。

### 第四阶段：解决真实问题

将 NumPy 用于：

- 数据清洗与标准化；
- 统计分析；
- 图像像素处理；
- 蒙特卡洛模拟；
- 线性代数；
- 批量距离与相似度计算。

真正的"精通"并不是记住所有 API，而是遇到问题时能迅速完成三件事：

1. 把问题抽象成数组和形状；
2. 判断哪些轴需要对齐、广播或聚合；
3. 在正确性、可读性、速度和内存之间做出合理取舍。

---

## 结语

NumPy 看起来只是一个数组库，但它真正改变的是编程思维：从"逐个处理元素"，转向"描述整组数据之间的关系"。

学习 NumPy 时，不要只背函数名称。每写一段代码，都问自己三个问题：

- 输入数组的 shape 是什么？
- 运算发生在哪个 axis 上？
- 结果是视图还是副本？

当你能够自然地回答这三个问题，广播、标准化、批量矩阵运算乃至高维张量处理都会变得清晰。

最后送你一句适合 NumPy 学习的总结：

> **先想形状，再写运算；先保证正确，再优化性能。**

把本文中的示例亲手运行一遍，再尝试改动数组形状、数据类型和轴参数，你会比单纯阅读获得更多。
