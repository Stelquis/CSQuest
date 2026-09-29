# [TensorFlow从入门到精通：从第一个张量到生产级人工智能系统](https://mp.weixin.qq.com/s/Ct5zMPPHQ3ieNCbhZPos5w)

> 这是一个关于"灯塔风控"的故事——一个靠 ML 模型拦截欺诈交易的金融科技小团队，和它从"只敢在离线环境跑 Notebook"到"训练、导出、量化、部署、监控全链路打通"的完整旅程。你会跟着闻笛一起，从张量和 GradientTape 讲到 Keras 三种建模方式、tf.data 流水线、迁移学习、分布式训练和 TFLite 端侧部署。读完之后你会发现：TensorFlow 的价值不只是帮你训练一个模型，而是帮助你把机器学习想法变成可以验证、优化、交付和持续迭代的系统。

---

## 故事的起点：99% 的准确率，却拦不住欺诈

"灯塔风控"是四个人组成的机器学习团队，为一家支付公司做欺诈交易识别。核心模型是个卷积网络，跑在一个多人共享的 JupyterHub 里，代码是三个月前照着教程拼的 Notebook：训练和评估混在一个 cell 里，数据预处理靠手工复制粘贴，模型文件靠 U 盘拷贝。

上线那天，团队负责人闻笛在评审会上报了一组漂亮的数字：测试集准确率 99%。

一周后，运营说欺诈交易没少拦。闻笛拉了线上数据一算，明白了：欺诈交易只占 0.3%，一个永远输出"正常"的模型也能拿到 99.7% 的准确率。**99% 的准确率，是个用错了指标的胜利。**

更糟的事接连发生：

- 同事把特征预处理逻辑改了一行，没人知道模型已经和线上的预处理对不上了；
- 训练到 19 个 epoch 机器重启，一切从头开始；
- 想把模型部署到手机端做实时拦截，打开 TensorFlow 文档才发现自己对 SavedModel 一无所知。

TensorFlow 并不只是一个"搭神经网络的工具"。它是一套覆盖数据处理、模型构建、自动求导、加速训练、实验管理和多端部署的完整机器学习工程体系。当你第一次接触 TensorFlow，可能会被 Tensor、GradientTape、tf.function、tf.data、Keras、SavedModel 等概念包围。很多教程会教你用十几行代码训练一个手写数字分类器，却没有解释这些模块之间究竟是什么关系。

闻笛在白板上画了一条完整的生产线，然后宣布：从今天起，灯塔风控的模型代码不再叫" Notebook"，要能独立设计、训练、诊断、保存和部署一个真实系统。

这个故事，就是她带队走完的路线图。

---

## 第一站：TensorFlow 到底是什么

TensorFlow 是一个开源机器学习框架，核心能力可以概括为四层：

1. **数值计算层**：通过张量和算子完成矩阵运算、卷积、概率计算等操作。
2. **自动微分层**：自动计算损失函数对模型参数的梯度。
3. **模型开发层**：通过 Keras 快速定义、训练、评估和保存神经网络。
4. **工程部署层**：将模型部署到服务器、浏览器、移动端、嵌入式设备或分布式计算环境。

可以把 TensorFlow 理解成一条机器学习生产线：

```
原始数据
   ↓
tf.data 数据流水线
   ↓
TensorFlow / Keras 模型
   ↓
自动求导与优化器
   ↓
训练、验证与实验记录
   ↓
模型导出
   ↓
服务器 / 浏览器 / 手机 / 边缘设备
```

截至 2026 年 7 月，TensorFlow 的稳定版本主线已经进入 2.21，TensorFlow 2.16 及之后的版本默认配合 Keras 3。Keras 3 是多后端框架，但在本文中我们始终以 TensorFlow 作为计算后端。

TensorFlow 适合以下场景：

- 图像分类、目标检测、图像分割；
- 文本分类、序列建模、Transformer；
- 时间序列预测；
- 推荐系统与排序模型；
- 表格数据建模；
- 大规模分布式训练；
- Android、iOS、Web 和 IoT 端侧推理；
- 需要完整训练、监控、导出和部署链路的工程项目。

---

## 第二站：学习 TensorFlow 前需要掌握什么

学习 TensorFlow 不要求先成为数学专家，但至少应该具备以下基础。

### 1. Python 基础

需要熟悉：变量、列表、字典；函数和类；NumPy 数组；虚拟环境与 pip；基本文件操作。

### 2. 必要数学知识

重点包括：向量和矩阵；矩阵乘法；导数、偏导数和链式法则；均值、方差和概率分布；损失函数与梯度下降。

### 3. 机器学习基本概念

至少理解：特征和标签；训练集、验证集和测试集；过拟合与欠拟合；分类和回归；批次、轮次和学习率。

不必等所有知识都学完再开始。最有效的方法，是**一边写 TensorFlow，一边补齐数学和机器学习基础**。

---

## 第三站：安装 TensorFlow 与环境配置

### 1. 推荐使用虚拟环境

不要把所有机器学习库都安装到系统 Python 中。建议为每个项目创建独立环境：

```bash
python3 -m venv .venv
```

macOS 或 Linux 激活环境：

```bash
source .venv/bin/activate
```

Windows PowerShell 激活环境：

```powershell
.venv\Scripts\Activate.ps1
```

升级安装工具：

```bash
python -m pip install --upgrade pip setuptools wheel
```

### 2. CPU 环境

```bash
pip install tensorflow
```

安装后验证：

```bash
python -c "import tensorflow as tf; print(tf.__version__)"
```

继续检查张量计算：

```bash
python -c "import tensorflow as tf; print(tf.reduce_sum(tf.random.normal([1000, 1000])))"
```

### 3. Linux 或 WSL2 中的 NVIDIA GPU 环境

在受支持的 Linux 或 Windows WSL2 环境中，可以使用：

```bash
pip install "tensorflow[and-cuda]"
```

验证 GPU：

```bash
python -c "import tensorflow as tf; print(tf.config.list_physical_devices('GPU'))"
```

如果输出中出现 GPU 设备，说明 TensorFlow 已识别显卡。

### 4. macOS 注意事项

TensorFlow 官方安装文档目前不提供 macOS 官方 GPU 支持，直接安装 `pip install tensorflow` 即可使用 CPU 运行。Apple Silicon 可以运行 TensorFlow，但依赖自定义 C++ 扩展的第三方包不一定都提供 ARM 原生版本。

### 5. Windows 注意事项

TensorFlow 2.10 是最后一个支持 Windows 原生 NVIDIA GPU 的版本。使用较新的 TensorFlow 时，推荐：Windows 原生环境运行 CPU，或通过 WSL2 使用 NVIDIA GPU。

### 6. TensorBoard 需要单独确认

TensorFlow 2.21 开始不再把 TensorBoard 作为依赖自动安装。需要时执行：

```bash
pip install tensorboard
```

### 7. 建议固定依赖版本

创建 `requirements.txt`：

```text
tensorflow==2.21.0
tensorboard
numpy
pandas
matplotlib
scikit-learn
```

安装：

```bash
pip install -r requirements.txt
```

对于长期项目，还可以使用 `pip freeze` 保存精确环境：

```bash
pip freeze > requirements-lock.txt
```

新项目建议优先选择 TensorFlow 当前支持的 Python 版本。TensorFlow 2.21 已移除 Python 3.9 支持，安装前应查看官方版本兼容表。

---

## 第四站：第一个 TensorFlow 程序

创建 `hello_tensorflow.py`：

```python
import tensorflow as tf

print("TensorFlow version:", tf.__version__)

x = tf.constant([[1.0, 2.0], [3.0, 4.0]])
y = tf.constant([[5.0, 6.0], [7.0, 8.0]])

print("逐元素相加：")
print(x + y)

print("矩阵乘法：")
print(tf.matmul(x, y))
```

运行：

```bash
python hello_tensorflow.py
```

TensorFlow 2 默认开启**即时执行模式**，也就是每一行运算会立刻得到结果。这种体验与 NumPy 很接近，便于学习和调试。

---

## 第五站：张量——TensorFlow 的基本数据结构

### 1. 什么是张量

张量可以理解为多维数组：

- 标量：0 维张量；
- 向量：1 维张量；
- 矩阵：2 维张量；
- 图像批次：常见的 4 维张量；
- 视频批次：可能是 5 维张量。

```python
import tensorflow as tf

scalar = tf.constant(3.14)
vector = tf.constant([1, 2, 3])
matrix = tf.constant([[1, 2], [3, 4]])
images = tf.zeros([32, 224, 224, 3])

print(scalar.shape)  # ()
print(vector.shape)  # (3,)
print(matrix.shape)  # (2, 2)
print(images.shape)  # (32, 224, 224, 3)
```

图像张量 `[32, 224, 224, 3]` 的含义是：

```
32    → 批次大小
224   → 图像高度
224   → 图像宽度
3     → RGB通道数
```

### 2. 数据类型

常见类型包括：`tf.float32`（神经网络最常用）、`tf.float16`（混合精度训练常用）、`tf.int32`（类别编号、索引）、`tf.int64`（大整数索引）、`tf.bool`（布尔掩码）、`tf.string`（文本和文件路径）。

```python
x = tf.constant([1, 2, 3], dtype=tf.float32)
y = tf.cast(x, tf.int32)
```

**类型不匹配是 TensorFlow 初学者最常见的错误之一。**模型输入通常应统一为 float32，标签类型则取决于损失函数。

### 3. 创建张量

```python
zeros = tf.zeros([2, 3])
ones = tf.ones([2, 3])
random_normal = tf.random.normal([2, 3], mean=0.0, stddev=1.0)
random_uniform = tf.random.uniform([2, 3], minval=0.0, maxval=1.0)
sequence = tf.range(0, 10, 2)
```

### 4. 改变形状

```python
x = tf.range(12)
x1 = tf.reshape(x, [3, 4])
x2 = tf.reshape(x, [2, 2, 3])
x3 = tf.expand_dims(x1, axis=0)
x4 = tf.squeeze(x3, axis=0)
```

注意：reshape 只改变数据的组织方式，不改变元素数量。

### 5. 拼接与堆叠

```python
x = tf.constant([[1, 2], [3, 4]])
y = tf.constant([[5, 6], [7, 8]])

concat_result = tf.concat([x, y], axis=0)
stack_result = tf.stack([x, y], axis=0)
```

区别在于：

- `concat` 在已有维度上连接；
- `stack` 创建一个新维度。

### 6. 广播机制

```python
x = tf.constant([[1.0, 2.0], [3.0, 4.0]])
bias = tf.constant([10.0, 20.0])
print(x + bias)
```

`bias` 会自动扩展到每一行。神经网络中的偏置相加就是广播机制的典型应用。

### 7. TensorFlow 与 NumPy 互操作

```python
import numpy as np
import tensorflow as tf

array = np.array([1.0, 2.0, 3.0])
tensor = tf.convert_to_tensor(array)
back_to_numpy = tensor.numpy()
```

在即时执行模式下，可以调用 `.numpy()` 获取 NumPy 数组。但在 `tf.function` 构建的计算图内部，不应依赖 `.numpy()`。

---

## 第六站：变量——模型真正要学习的参数

`tf.Tensor` 通常是不可变的数据，而 `tf.Variable` 用于保存可更新状态，例如神经网络的权重和偏置。

```python
import tensorflow as tf

weight = tf.Variable(2.0, name="weight")
print(weight.numpy())

weight.assign(3.0)
weight.assign_add(1.0)
weight.assign_sub(0.5)
print(weight.numpy())
```

在神经网络中，一层全连接计算可以表示为：

```
y = xW + b
```

其中：x 是输入；W 是权重变量；b 是偏置变量；y 是输出。

Keras 层会自动创建和管理这些变量，因此日常建模通常不需要手工维护 `tf.Variable`。但理解变量，是理解优化器和模型保存机制的基础。

---

## 第七站：自动求导——TensorFlow 如何让模型学习

神经网络训练的核心是：

1. 前向计算得到预测；
2. 计算预测与真实值之间的损失；
3. 求损失对参数的梯度；
4. 沿梯度反方向更新参数。

TensorFlow 使用 `tf.GradientTape` 自动记录计算过程。

### 1. 计算一元函数导数

假设 `y = x² + 3x + 1`：

```python
import tensorflow as tf

x = tf.Variable(2.0)
with tf.GradientTape() as tape:
    y = x ** 2 + 3 * x + 1
dy_dx = tape.gradient(y, x)
print(dy_dx.numpy())  # 7.0
```

因为 `dy/dx = 2x + 3`，当 `x = 2` 时，导数等于 7。

### 2. 训练一个最简单的线性模型

目标数据满足近似关系 `y = 3x + 2`，我们让 TensorFlow 自动学习参数 w 和 b：

```python
import tensorflow as tf

x = tf.constant([0.0, 1.0, 2.0, 3.0, 4.0])
y_true = tf.constant([2.0, 5.0, 8.0, 11.0, 14.0])

w = tf.Variable(tf.random.normal([]))
b = tf.Variable(tf.zeros([]))

learning_rate = 0.01

for step in range(1000):
    with tf.GradientTape() as tape:
        y_pred = w * x + b
        loss = tf.reduce_mean(tf.square(y_pred - y_true))

    dw, db = tape.gradient(loss, [w, b])
    w.assign_sub(learning_rate * dw)
    b.assign_sub(learning_rate * db)

    if step % 100 == 0:
        print(
            f"step={step}, loss={loss.numpy():.6f}, "
            f"w={w.numpy():.4f}, b={b.numpy():.4f}"
        )
```

最终 w 会接近 3，b 会接近 2。这段程序已经包含了神经网络训练的完整本质：

```
参数初始化
   ↓
前向传播
   ↓
损失计算
   ↓
反向传播
   ↓
参数更新
   ↓
重复迭代
```

---

## 第八站：Keras——TensorFlow 的高级模型开发接口

直接操作张量和梯度非常灵活，但真实神经网络往往包含几十甚至上百层。Keras 对层、模型、损失函数、优化器、指标和训练循环进行了统一封装。

TensorFlow 2.16 之后默认配合 Keras 3。本文采用：

```python
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
```

Keras 构建模型有三种主要方式——接下来三站逐一拆解。

---

## 第九站：方式一——Sequential 顺序模型

当网络结构是简单的单输入、单输出、逐层堆叠时，Sequential 最方便。

```python
from tensorflow import keras
from tensorflow.keras import layers

model = keras.Sequential([
    layers.Input(shape=(784,)),
    layers.Dense(256, activation="relu"),
    layers.Dropout(0.3),
    layers.Dense(128, activation="relu"),
    layers.Dense(10, activation="softmax"),
])
model.summary()
```

数据流为：

```
784维输入
   ↓
Dense(256) + ReLU
   ↓
Dropout
   ↓
Dense(128) + ReLU
   ↓
Dense(10) + Softmax
```

适合：多层感知机、简单卷积网络、线性堆叠结构。

不适合：多输入或多输出、残差连接、共享层、分支和合并结构。

---

## 第十站：方式二——Functional API 函数式模型

函数式 API 可以像搭建计算图一样连接层，是实际项目中最常用的方式。

```python
from tensorflow import keras
from tensorflow.keras import layers

inputs = keras.Input(shape=(784,), name="pixels")
x = layers.Dense(256, activation="relu")(inputs)
x = layers.Dropout(0.3)(x)
x = layers.Dense(128, activation="relu")(x)
outputs = layers.Dense(10, activation="softmax", name="class_probs")(x)

model = keras.Model(inputs=inputs, outputs=outputs)
model.summary()
```

### 残差连接示例

```python
inputs = keras.Input(shape=(128,))
x = layers.Dense(128, activation="relu")(inputs)
residual = x
x = layers.Dense(128, activation="relu")(x)
x = layers.Dense(128)(x)
x = layers.Add()([x, residual])
x = layers.Activation("relu")(x)
outputs = layers.Dense(10, activation="softmax")(x)

model = keras.Model(inputs, outputs)
```

函数式 API 适合：ResNet 等残差网络、多模态模型、多任务学习、编码器—解码器、复杂计算图。

---

## 第十一站：方式三——继承 Model 自定义模型

当模型具有动态控制流、自定义状态或复杂研究逻辑时，可以继承 `keras.Model`。

```python
from tensorflow import keras
from tensorflow.keras import layers


class Classifier(keras.Model):
    def __init__(self, num_classes=10):
        super().__init__()
        self.dense1 = layers.Dense(256, activation="relu")
        self.dropout = layers.Dropout(0.3)
        self.dense2 = layers.Dense(num_classes, activation="softmax")

    def call(self, inputs, training=False):
        x = self.dense1(inputs)
        x = self.dropout(x, training=training)
        return self.dense2(x)


model = Classifier(num_classes=10)
```

三种方式的取舍：Sequential 胜在简单直接，Functional API 胜在结构表达力，子类化胜在灵活性。灯塔风控最终统一采用 Functional API——预处理层可以和模型一起保存，不容易遗漏归一化步骤。

---

## 第十二站：完整实战——MNIST 手写数字分类

下面用卷积神经网络完成一个端到端项目，这正是闻笛给团队定的第一个标准模板。

### 1. 导入依赖

```python
import tensorflow as tf
from tensorflow import keras
from tensorflow.keras import layers
```

### 2. 设置随机种子

```python
keras.utils.set_random_seed(42)
```

这有助于提高实验可复现性，但不同硬件和并行计算环境下仍可能存在微小差异。

### 3. 加载并预处理数据

```python
(x_train, y_train), (x_test, y_test) = keras.datasets.mnist.load_data()

x_train = x_train.astype("float32") / 255.0
x_test = x_test.astype("float32") / 255.0
x_train = x_train[..., None]
x_test = x_test[..., None]

print(x_train.shape)  # (60000, 28, 28, 1)
print(y_train.shape)  # (60000,)
```

### 4. 构建 tf.data 流水线

```python
batch_size = 128
autotune = tf.data.AUTOTUNE

train_ds = (
    tf.data.Dataset.from_tensor_slices((x_train, y_train))
    .shuffle(buffer_size=len(x_train))
    .batch(batch_size)
    .prefetch(autotune)
)

test_ds = (
    tf.data.Dataset.from_tensor_slices((x_test, y_test))
    .batch(batch_size)
    .prefetch(autotune)
)
```

### 5. 定义模型

```python
model = keras.Sequential([
    layers.Input(shape=(28, 28, 1)),
    layers.Conv2D(32, kernel_size=3, padding="same", activation="relu"),
    layers.BatchNormalization(),
    layers.MaxPooling2D(),
    layers.Conv2D(64, kernel_size=3, padding="same", activation="relu"),
    layers.BatchNormalization(),
    layers.MaxPooling2D(),
    layers.Conv2D(128, kernel_size=3, padding="same", activation="relu"),
    layers.GlobalAveragePooling2D(),
    layers.Dropout(0.3),
    layers.Dense(10, activation="softmax"),
])
model.summary()
```

### 6. 编译模型

```python
model.compile(
    optimizer=keras.optimizers.Adam(learning_rate=1e-3),
    loss=keras.losses.SparseCategoricalCrossentropy(),
    metrics=[keras.metrics.SparseCategoricalAccuracy(name="accuracy")],
)
```

这里的关键对应关系是：

- 标签是整数 0～9，使用 SparseCategoricalCrossentropy；
- 输出层有 10 个神经元；
- 输出使用 Softmax，得到类别概率；
- 优化器使用 Adam。

### 7. 配置回调函数

```python
callbacks = [
    keras.callbacks.ModelCheckpoint(
        filepath="checkpoints/best.keras",
        monitor="val_accuracy",
        save_best_only=True,
    ),
    keras.callbacks.EarlyStopping(
        monitor="val_loss",
        patience=3,
        restore_best_weights=True,
    ),
    keras.callbacks.ReduceLROnPlateau(
        monitor="val_loss",
        factor=0.5,
        patience=1,
        min_lr=1e-6,
    ),
    keras.callbacks.TensorBoard(
        log_dir="logs/mnist",
        histogram_freq=1,
    ),
]
```

### 8. 训练模型

```python
history = model.fit(
    train_ds,
    validation_data=test_ds,
    epochs=20,
    callbacks=callbacks,
)
```

### 9. 评估模型

```python
loss, accuracy = model.evaluate(test_ds)
print(f"test loss: {loss:.4f}")
print(f"test accuracy: {accuracy:.4f}")
```

### 10. 推理

```python
probabilities = model.predict(x_test[:5])
predictions = tf.argmax(probabilities, axis=1)
print("预测：", predictions.numpy())
print("真实：", y_test[:5])
```

至此，我们完成了一个标准深度学习项目的全流程：

```
加载数据 → 数据预处理 → 构建输入流水线 → 定义模型
→ 编译模型 → 训练与验证 → 测试评估 → 模型推理
```

---

## 第十三站：compile、fit、evaluate 和 predict 到底做了什么

### 1. compile：配置学习规则

```python
model.compile(
    optimizer="adam",
    loss="sparse_categorical_crossentropy",
    metrics=["accuracy"],
)
```

compile 不会真正开始训练，它只是告诉模型：用什么优化器更新参数；用什么损失函数衡量误差；训练过程中记录哪些指标。

### 2. fit：执行训练循环

```python
history = model.fit(
    x_train,
    y_train,
    batch_size=128,
    epochs=10,
    validation_split=0.2,
)
```

fit 内部大致执行：

```python
for epoch in epochs:
    for batch in dataset:
        前向传播
        计算损失
        计算梯度
        更新参数
    在验证集上评估
    执行回调函数
```

### 3. evaluate：在不更新参数的情况下评估

```python
model.evaluate(x_test, y_test)
```

评估阶段不会执行反向传播，也不会更新权重。

### 4. predict：只做前向推理

```python
predictions = model.predict(new_samples)
```

适合批量预测。单个小批次也可以直接调用模型：

```python
predictions = model(new_samples, training=False)
```

---

## 第十四站：损失函数应该怎么选

### 1. 回归任务

```python
keras.losses.MeanSquaredError()
keras.losses.MeanAbsoluteError()
keras.losses.Huber()
```

典型输出层：

```python
layers.Dense(1)
```

### 2. 二分类任务

标签通常为 0 或 1：

```python
layers.Dense(1, activation="sigmoid")
```

损失函数：

```python
keras.losses.BinaryCrossentropy()
```

### 3. 多分类：整数标签

标签形如 `0, 3, 1, 8, 2 ...`：

```python
layers.Dense(num_classes, activation="softmax")
```

损失函数：

```python
keras.losses.SparseCategoricalCrossentropy()
```

### 4. 多分类：One-Hot 标签

标签形如 `[0, 0, 1, 0, 0]`：

```python
keras.losses.CategoricalCrossentropy()
```

### 5. from_logits 参数

如果输出层没有激活函数：

```python
layers.Dense(num_classes)
```

则损失函数应使用：

```python
keras.losses.SparseCategoricalCrossentropy(from_logits=True)
```

**不要同时使用线性输出和 `from_logits=False`，也不要在输出已经 Softmax 后再设置 `from_logits=True`。**

---

## 第十五站：优化器与学习率

### 1. SGD

```python
optimizer = keras.optimizers.SGD(
    learning_rate=0.01,
    momentum=0.9,
)
```

特点：理论清晰；泛化表现常常很好；对学习率更敏感；大型视觉模型中依然常见。

### 2. Adam

```python
optimizer = keras.optimizers.Adam(learning_rate=1e-3)
```

特点：收敛快；对初始学习率相对不敏感；是多数项目的可靠起点。

### 3. AdamW

```python
optimizer = keras.optimizers.AdamW(
    learning_rate=1e-3,
    weight_decay=1e-4,
)
```

AdamW 将权重衰减与梯度更新解耦，Transformer 和现代视觉模型中非常常见。

### 4. 学习率调度

指数衰减：

```python
schedule = keras.optimizers.schedules.ExponentialDecay(
    initial_learning_rate=1e-3,
    decay_steps=1000,
    decay_rate=0.96,
    staircase=True,
)
optimizer = keras.optimizers.Adam(schedule)
```

余弦衰减：

```python
schedule = keras.optimizers.schedules.CosineDecay(
    initial_learning_rate=1e-3,
    decay_steps=10000,
)
```

**训练效果不好时，优先检查学习率，而不是盲目增加网络层数。**

---

## 第十六站：tf.data——构建高性能数据流水线

当数据量很小时，可以直接把 NumPy 数组传给 `model.fit`。但在真实项目中，数据可能来自图片目录、CSV、TFRecord、数据库或分布式存储，这时应使用 tf.data。

### 1. 从内存创建 Dataset

```python
features = tf.random.normal([1000, 20])
labels = tf.random.uniform([1000], maxval=2, dtype=tf.int32)

dataset = tf.data.Dataset.from_tensor_slices((features, labels))
```

### 2. 常见流水线操作

```python
dataset = (
    dataset
    .shuffle(1000)
    .batch(32)
    .prefetch(tf.data.AUTOTUNE)
)
```

推荐顺序通常是：

```
读取 → 打乱 → 预处理 → 批处理 → 预取
```

### 3. 使用 map 预处理

```python
def preprocess(image, label):
    image = tf.cast(image, tf.float32) / 255.0
    return image, label

train_ds = train_ds.map(
    preprocess,
    num_parallel_calls=tf.data.AUTOTUNE,
)
```

### 4. cache 与 prefetch

```python
train_ds = (
    train_ds
    .cache()
    .shuffle(10000)
    .batch(64)
    .prefetch(tf.data.AUTOTUNE)
)
```

- `cache()` 避免每个 epoch 重复读取和预处理；
- `prefetch()` 让 CPU 准备下一批数据时，GPU 同时计算当前批次；
- 如果数据无法全部装入内存，可使用磁盘缓存路径或不使用缓存。

### 5. 从图片目录加载

目录结构：

```
dataset/
├── cats/
│   ├── 001.jpg
│   └── 002.jpg
└── dogs/
    ├── 001.jpg
    └── 002.jpg
```

加载：

```python
train_ds = keras.utils.image_dataset_from_directory(
    "dataset",
    validation_split=0.2,
    subset="training",
    seed=42,
    image_size=(224, 224),
    batch_size=32,
)

val_ds = keras.utils.image_dataset_from_directory(
    "dataset",
    validation_split=0.2,
    subset="validation",
    seed=42,
    image_size=(224, 224),
    batch_size=32,
)
```

### 6. 数据增强

```python
data_augmentation = keras.Sequential([
    layers.RandomFlip("horizontal"),
    layers.RandomRotation(0.1),
    layers.RandomZoom(0.1),
    layers.RandomContrast(0.1),
])
```

放入模型：

```python
inputs = keras.Input(shape=(224, 224, 3))
x = data_augmentation(inputs)
x = layers.Rescaling(1.0 / 255)(x)
# 后续网络……
```

将预处理层放进模型有两个好处：

- 训练与推理采用同一套预处理；
- 模型导出后不容易遗漏归一化步骤。

---

## 第十七站：卷积神经网络 CNN

卷积神经网络适合处理具有局部空间结构的数据，尤其是图像。

### 1. 卷积层

```python
layers.Conv2D(
    filters=64,
    kernel_size=3,
    strides=1,
    padding="same",
    activation="relu",
)
```

参数含义：

- `filters`：输出通道数；
- `kernel_size`：卷积核大小；
- `strides`：移动步长；
- `padding="same"`：尽量保持空间尺寸；
- `activation`：激活函数。

### 2. 池化层

```python
layers.MaxPooling2D(pool_size=2)
```

池化用于降低空间尺寸，减少计算量并扩大感受野。

### 3. GlobalAveragePooling

```python
layers.GlobalAveragePooling2D()
```

相比 Flatten，全局平均池化参数更少，过拟合风险更低，现代分类网络中非常常见。

### 4. 一个更规范的 CNN 模块

```python
def conv_block(x, filters):
    x = layers.Conv2D(filters, 3, padding="same", use_bias=False)(x)
    x = layers.BatchNormalization()(x)
    x = layers.Activation("relu")(x)
    x = layers.MaxPooling2D()(x)
    return x
```

---

## 第十八站：序列模型——RNN、LSTM 与 GRU

RNN 用于处理时间序列、文本、语音等顺序数据。

### 1. LSTM 分类器

```python
inputs = keras.Input(shape=(100, 64))
x = layers.LSTM(128)(inputs)
x = layers.Dropout(0.3)(x)
outputs = layers.Dense(5, activation="softmax")(x)
model = keras.Model(inputs, outputs)
```

输入形状：

```
(batch_size, sequence_length, feature_dim)
```

### 2. 双向 LSTM

```python
x = layers.Bidirectional(layers.LSTM(128))(inputs)
```

双向网络同时利用前后文，适合完整文本分类；但不适合要求严格因果性的实时生成任务。

### 3. GRU

```python
x = layers.GRU(128)(inputs)
```

GRU 结构通常比 LSTM 简单，参数更少，是很实用的替代选择。

如今很多自然语言处理任务会优先使用 Transformer，但 RNN 仍适用于中小规模时序任务和资源受限场景。

---

## 第十九站：注意力机制与 Transformer

Keras 提供 `MultiHeadAttention` 层，可以构建 Transformer 模块：

```python
from tensorflow import keras
from tensorflow.keras import layers


class TransformerBlock(layers.Layer):
    def __init__(self, embed_dim, num_heads, ff_dim, dropout=0.1):
        super().__init__()
        self.attention = layers.MultiHeadAttention(
            num_heads=num_heads,
            key_dim=embed_dim // num_heads,
        )
        self.ffn = keras.Sequential([
            layers.Dense(ff_dim, activation="gelu"),
            layers.Dense(embed_dim),
        ])
        self.norm1 = layers.LayerNormalization(epsilon=1e-6)
        self.norm2 = layers.LayerNormalization(epsilon=1e-6)
        self.dropout1 = layers.Dropout(dropout)
        self.dropout2 = layers.Dropout(dropout)

    def call(self, inputs, training=False, mask=None):
        attention_output = self.attention(
            inputs,
            inputs,
            attention_mask=mask,
        )
        attention_output = self.dropout1(attention_output, training=training)
        x = self.norm1(inputs + attention_output)
        ffn_output = self.ffn(x)
        ffn_output = self.dropout2(ffn_output, training=training)
        return self.norm2(x + ffn_output)
```

Transformer 的关键结构包括：多头注意力；前馈网络；残差连接；Layer Normalization；Dropout；位置编码或位置嵌入。

"会调用注意力层"只是入门。真正掌握 Transformer，还要理解掩码、序列长度、计算复杂度和 KV 结构。

---

## 第二十站：迁移学习——小数据集的最佳实践

迁移学习的基本思想是：先加载在大规模数据集上训练好的模型，再针对自己的任务训练少量新增层。

### 1. 加载预训练模型

```python
base_model = keras.applications.EfficientNetB0(
    include_top=False,
    weights="imagenet",
    input_shape=(224, 224, 3),
)
base_model.trainable = False
```

### 2. 添加分类头

```python
inputs = keras.Input(shape=(224, 224, 3))
x = keras.applications.efficientnet.preprocess_input(inputs)
x = base_model(x, training=False)
x = layers.GlobalAveragePooling2D()(x)
x = layers.Dropout(0.3)(x)
outputs = layers.Dense(5, activation="softmax")(x)
model = keras.Model(inputs, outputs)
```

### 3. 训练新分类头

```python
model.compile(
    optimizer=keras.optimizers.Adam(1e-3),
    loss="sparse_categorical_crossentropy",
    metrics=["accuracy"],
)
model.fit(train_ds, validation_data=val_ds, epochs=10)
```

### 4. 微调

```python
base_model.trainable = True
for layer in base_model.layers[:-20]:
    layer.trainable = False

model.compile(
    optimizer=keras.optimizers.Adam(1e-5),
    loss="sparse_categorical_crossentropy",
    metrics=["accuracy"],
)
model.fit(train_ds, validation_data=val_ds, epochs=5)
```

**微调时必须降低学习率，否则可能迅速破坏预训练权重。**

推荐流程：

```
冻结骨干网络 → 训练新增分类头 → 解冻少量高层
→ 使用更小学习率微调 → 比较验证集表现
```

---

## 第二十一站：如何防止过拟合

过拟合表现为：训练集指标持续改善，但验证集指标停止改善甚至恶化。

1. **增加数据**：这是最根本的方法。更多且更真实的数据通常比复杂技巧更有效。
2. **数据增强**：适用于图像、音频和文本等任务。
3. **Dropout**：

```python
layers.Dropout(0.5)
```

训练时随机丢弃部分神经元输出，减少特征之间的过度依赖。

4. **L2 正则化**：

```python
layers.Dense(
    128,
    activation="relu",
    kernel_regularizer=keras.regularizers.l2(1e-4),
)
```

5. **权重衰减**：

```python
keras.optimizers.AdamW(
    learning_rate=1e-3,
    weight_decay=1e-4,
)
```

6. **EarlyStopping**：

```python
keras.callbacks.EarlyStopping(
    monitor="val_loss",
    patience=5,
    restore_best_weights=True,
)
```

7. **降低模型容量**：如果数据很少，不要盲目使用巨大网络。减少层数和通道数往往更有效。

---

## 第二十二站：BatchNormalization 与 LayerNormalization

### BatchNormalization

```python
x = layers.Dense(128, use_bias=False)(inputs)
x = layers.BatchNormalization()(x)
x = layers.Activation("relu")(x)
```

常用于 CNN 和传统深层网络。它利用批次统计量进行归一化，因此批次过小时可能不稳定。

### LayerNormalization

```python
x = layers.LayerNormalization()(x)
```

常用于 Transformer、序列模型和小批次场景。它在单个样本的特征维度上归一化，不依赖批次统计量。

两者不是可以随意互换的装饰层，应根据模型结构和数据特点选择。

---

## 第二十三站：自定义层

当内置层无法满足需求时，可以继承 `keras.layers.Layer`：

```python
from tensorflow import keras


class ScaleLayer(keras.layers.Layer):
    def __init__(self, **kwargs):
        super().__init__(**kwargs)

    def build(self, input_shape):
        self.scale = self.add_weight(
            name="scale",
            shape=(input_shape[-1],),
            initializer="ones",
            trainable=True,
        )

    def call(self, inputs):
        return inputs * self.scale
```

使用：

```python
inputs = keras.Input(shape=(32,))
x = ScaleLayer()(inputs)
outputs = keras.layers.Dense(1)(x)
model = keras.Model(inputs, outputs)
```

自定义层时应注意：

- 在 `build` 中创建依赖输入形状的权重；
- 在 `call` 中实现前向计算；
- 不要在每次 `call` 时重复创建变量；
- 如需保存构造参数，应实现 `get_config`。

---

## 第二十四站：自定义训练循环

`model.fit` 适合大多数监督学习任务。以下情况可能需要自定义训练循环：GAN、强化学习、对比学习、多个优化器、特殊梯度处理、非标准损失组合、研究型训练算法。

### 1. 一个标准自定义训练步骤

```python
import tensorflow as tf
from tensorflow import keras

optimizer = keras.optimizers.Adam(1e-3)
loss_fn = keras.losses.SparseCategoricalCrossentropy()
train_accuracy = keras.metrics.SparseCategoricalAccuracy()


@tf.function
def train_step(x_batch, y_batch):
    with tf.GradientTape() as tape:
        predictions = model(x_batch, training=True)
        loss = loss_fn(y_batch, predictions)
        if model.losses:
            loss += tf.add_n(model.losses)
    gradients = tape.gradient(loss, model.trainable_variables)
    optimizer.apply_gradients(zip(gradients, model.trainable_variables))
    train_accuracy.update_state(y_batch, predictions)
    return loss
```

训练循环：

```python
for epoch in range(10):
    train_accuracy.reset_state()
    for x_batch, y_batch in train_ds:
        loss = train_step(x_batch, y_batch)
    print(
        f"epoch={epoch + 1}, "
        f"loss={loss.numpy():.4f}, "
        f"accuracy={train_accuracy.result().numpy():.4f}"
    )
```

### 2. 梯度裁剪

在 RNN 或不稳定训练中，可以限制梯度大小：

```python
gradients, global_norm = tf.clip_by_global_norm(gradients, 5.0)
optimizer.apply_gradients(zip(gradients, model.trainable_variables))
```

### 3. 多优化器训练

GAN 通常分别更新生成器和判别器：

```
生成器损失 → 生成器优化器
判别器损失 → 判别器优化器
```

这类逻辑很难仅通过普通 compile 表达，自定义训练循环更合适。

---

## 第二十五站：tf.function 与计算图

TensorFlow 2 默认使用即时执行，调试方便，但纯 Python 调度会带来额外开销。`tf.function` 可以把 Python 函数转换为 TensorFlow 计算图：

```python
@tf.function
def add_and_square(x, y):
    return tf.square(x + y)
```

优势包括：减少 Python 调用开销；进行图级优化；提升可移植性；更适合导出和部署；配合分布式训练和加速器。

### 常见陷阱一：依赖 Python 副作用

```python
values = []


@tf.function
def bad_function(x):
    values.append(x)
    return x * 2
```

Python 列表操作并不一定会在每次图执行时按直觉发生。

### 常见陷阱二：输入形状频繁变化导致重复追踪

不同 Python 类型或不同张量形状可能触发 retracing。可以指定输入签名：

```python
@tf.function(
    input_signature=[tf.TensorSpec(shape=[None, 32], dtype=tf.float32)]
)
def predict_fn(x):
    return model(x, training=False)
```

学习原则是：

- 先用即时执行写对代码；
- 再用 `tf.function` 优化热点路径；
- 不要一开始就把所有函数图化。

---

## 第二十六站：TensorBoard——看见训练过程

TensorBoard 可以可视化：训练和验证损失；准确率等指标；学习率变化；模型计算图；权重和梯度分布；图像、文本、音频；性能分析结果。

### 1. 使用回调记录日志

```python
callback = keras.callbacks.TensorBoard(
    log_dir="logs/experiment_001",
    histogram_freq=1,
    profile_batch="10,20",
)
```

### 2. 启动 TensorBoard

```bash
tensorboard --logdir logs
```

然后在浏览器访问终端显示的本地地址。

### 3. 自定义标量日志

```python
writer = tf.summary.create_file_writer("logs/custom")
with writer.as_default():
    tf.summary.scalar("learning_rate", 0.001, step=1)
```

不要只盯着最终准确率。优秀的模型开发者会观察：训练损失是否平稳下降；验证损失何时开始反弹；学习率是否合理；梯度是否爆炸或消失；数据加载是否成为瓶颈。

---

## 第二十七站：混合精度训练

现代 GPU 和 TPU 对低精度计算有专门加速能力。混合精度训练通常使用：float16 或 bfloat16 执行部分计算；float32 保存关键变量或进行数值敏感操作。

启用：

```python
from tensorflow.keras import mixed_precision

mixed_precision.set_global_policy("mixed_float16")
```

模型输出层建议保持 float32：

```python
outputs = layers.Dense(
    num_classes,
    activation="softmax",
    dtype="float32",
)(x)
```

混合精度可能带来：更高吞吐量；更低显存占用；更大批次；在支持硬件上缩短训练时间。但在 CPU 或不支持低精度加速的硬件上，不一定有收益。

---

## 第二十八站：XLA 与 JIT 编译

Keras 编译模型时可尝试开启 JIT：

```python
model.compile(
    optimizer="adam",
    loss="sparse_categorical_crossentropy",
    metrics=["accuracy"],
    jit_compile=True,
)
```

XLA 可以融合算子并优化计算图，但并不是所有算子和模型都兼容。建议：

1. 先保证模型正确；
2. 建立性能基线；
3. 再开启 JIT；
4. 对比吞吐量和显存占用；
5. 遇到不支持算子时关闭或局部优化。

**不要把"开启了加速选项"等同于"模型一定更快"。性能优化必须以测量为依据。**

---

## 第二十九站：分布式训练

TensorFlow 使用 `tf.distribute.Strategy` 支持多 GPU、多机器和 TPU。

### 1. 单机多 GPU

```python
strategy = tf.distribute.MirroredStrategy()
print("副本数量：", strategy.num_replicas_in_sync)

with strategy.scope():
    model = keras.Sequential([
        layers.Input(shape=(784,)),
        layers.Dense(256, activation="relu"),
        layers.Dense(10, activation="softmax"),
    ])
    model.compile(
        optimizer="adam",
        loss="sparse_categorical_crossentropy",
        metrics=["accuracy"],
    )
```

关键点：模型、优化器以及需要同步的变量应在 `strategy.scope()` 中创建。

### 2. 常见策略

- `MirroredStrategy`：单机多 GPU；
- `MultiWorkerMirroredStrategy`：多机同步训练；
- `TPUStrategy`：TPU；
- `ParameterServerStrategy`：参数服务器架构。

### 3. 全局批次大小

多设备训练时：

```
全局批次大小 = 每个副本批次大小 × 副本数量
```

扩大批次后，通常还需要重新调整学习率和学习率预热策略。

---

## 第三十站：模型保存、恢复与导出

### 1. 保存完整 Keras 模型

```python
model.save("classifier.keras")
```

加载：

```python
restored_model = keras.models.load_model("classifier.keras")
```

`.keras` 格式适合继续训练、评估和在 Keras 中恢复完整模型。

### 2. 只保存权重

```python
model.save_weights("classifier.weights.h5")
```

加载时必须先创建相同结构：

```python
model.load_weights("classifier.weights.h5")
```

### 3. 导出 SavedModel 推理模型

Keras 3 中可以使用：

```python
model.export("exported_model")
```

加载底层 SavedModel：

```python
loaded = tf.saved_model.load("exported_model")
```

### 4. 使用 Checkpoint 管理训练状态

```python
checkpoint = tf.train.Checkpoint(
    optimizer=optimizer,
    model=model,
)
manager = tf.train.CheckpointManager(
    checkpoint,
    directory="training_checkpoints",
    max_to_keep=5,
)
manager.save()
```

Checkpoint 适合自定义训练循环，可以保存模型、优化器和训练步数等状态。

---

## 第三十一站：部署到移动端与边缘设备

TensorFlow Lite 的能力正在演进为 Google 的新一代端侧运行时 LiteRT。在现有 TensorFlow 工作流中，仍可通过 TFLite 转换器把模型转换为 `.tflite` 文件。

### 1. 从 SavedModel 转换

```python
converter = tf.lite.TFLiteConverter.from_saved_model("exported_model")
tflite_model = converter.convert()

with open("model.tflite", "wb") as file:
    file.write(tflite_model)
```

### 2. 动态范围量化

```python
converter = tf.lite.TFLiteConverter.from_saved_model("exported_model")
converter.optimizations = [tf.lite.Optimize.DEFAULT]
tflite_model = converter.convert()
```

量化可以：减小模型体积；降低内存占用；提高部分设备上的推理速度；但可能带来精度损失。

### 3. 端侧部署流程

```
训练Keras模型 → 导出SavedModel → 转换为TFLite/LiteRT模型
→ 量化与兼容性测试 → 集成Android或iOS应用 → 在真实设备测延迟、内存和功耗
```

端侧模型不能只看桌面环境准确率，还必须关注：模型体积；冷启动时间；单次推理延迟；峰值内存；电量消耗；算子兼容性；不同设备上的稳定性。

---

## 第三十二站：部署到服务器和浏览器

### 1. 服务器推理

常见路线包括：Python Web 服务加载 Keras 模型；TensorFlow Serving 托管 SavedModel；容器化后部署到 Kubernetes；在云端使用 GPU、TPU 或弹性推理实例。

一个最小化 FastAPI 思路如下：

```python
from fastapi import FastAPI
import numpy as np
from tensorflow import keras

app = FastAPI()
model = keras.models.load_model("classifier.keras")


@app.post("/predict")
def predict(features: list[float]):
    x = np.asarray([features], dtype=np.float32)
    probabilities = model.predict(x, verbose=0)[0]
    class_id = int(np.argmax(probabilities))
    return {
        "class_id": class_id,
        "probabilities": probabilities.tolist(),
    }
```

生产环境还需要补充：输入校验；批量推理；超时和异常处理；模型版本管理；日志和监控；灰度发布；安全限制。

### 2. 浏览器推理

TensorFlow.js 可在浏览器或 Node.js 中训练和运行模型。适合：数据不离开用户设备；交互式 AI 网页；摄像头实时识别；轻量文本、音频或图像模型。

浏览器部署要重点控制模型体积和首屏加载时间。

---

## 第三十三站：表格数据建模

不是所有任务都需要卷积或 Transformer。对于结构化表格数据，常见流程是：

1. 区分数值特征和类别特征；
2. 缺失值处理；
3. 数值归一化；
4. 类别编码或嵌入；
5. 拼接所有特征；
6. 送入多层感知机。

示例：

```python
age_input = keras.Input(shape=(1,), name="age")
income_input = keras.Input(shape=(1,), name="income")

normalizer = layers.Normalization()
# 实际项目中应先 normalizer.adapt(training_values)

age = normalizer(age_input)
income = normalizer(income_input)

features = layers.Concatenate()([age, income])
x = layers.Dense(64, activation="relu")(features)
x = layers.Dense(32, activation="relu")(x)
output = layers.Dense(1, activation="sigmoid")(x)

model = keras.Model(
    inputs={"age": age_input, "income": income_input},
    outputs=output,
)
```

对于很多中小型表格任务，梯度提升树可能比神经网络更合适。选择模型时应以验证结果和部署需求为准，而不是只追求"深度学习"。

---

## 第三十四站：时间序列预测

时间序列任务通常需要先构造滑动窗口。假设使用过去 24 个时间点预测未来 1 个时间点：

```python
sequence_length = 24

train_ds = keras.utils.timeseries_dataset_from_array(
    data=series[:-1],
    targets=series[sequence_length:],
    sequence_length=sequence_length,
    batch_size=64,
)
```

可以选择：

- 线性模型：建立强基线；
- 多层感知机：处理固定窗口；
- 1D CNN：提取局部时间模式；
- LSTM/GRU：处理顺序依赖；
- Transformer：处理长距离依赖；
- 混合模型：结合趋势、周期和外生变量。

**时间序列最容易犯的错误是数据泄漏。**划分训练集和测试集时必须保持时间顺序，不能随机打乱未来数据到训练集。

---

## 第三十五站：模型评估不能只看准确率

### 二分类常见指标

- Accuracy；
- Precision；
- Recall；
- F1；
- ROC-AUC；
- PR-AUC。

```python
model.compile(
    optimizer="adam",
    loss="binary_crossentropy",
    metrics=[
        keras.metrics.BinaryAccuracy(name="accuracy"),
        keras.metrics.Precision(name="precision"),
        keras.metrics.Recall(name="recall"),
        keras.metrics.AUC(name="auc"),
    ],
)
```

当正负样本极不平衡时，准确率可能具有欺骗性。例如 99% 样本是正常类别，模型永远预测正常也能得到 99% 准确率——这正是灯塔风控踩过的坑。

### 回归常见指标

- MAE；
- MSE；
- RMSE；
- MAPE；
- R²，通常可在训练后通过其他工具计算。

指标选择应反映真实业务成本。例如疾病筛查更关注漏诊率，垃圾邮件过滤可能更关心误伤正常邮件的比例。

---

## 第三十六站：类别不平衡处理

### 1. 类别权重

```python
class_weight = {
    0: 1.0,
    1: 5.0,
}

model.fit(
    train_ds,
    epochs=10,
    class_weight=class_weight,
)
```

### 2. 样本权重

可以对每个样本指定不同权重。

### 3. 重采样

- 少数类过采样；
- 多数类欠采样；
- 构造平衡批次。

### 4. 调整决策阈值

二分类不一定必须使用 0.5 作为阈值。应结合 Precision-Recall 曲线和业务成本选择阈值。

---

## 第三十七站：超参数调优

常见超参数包括：学习率；批次大小；层数；每层宽度；Dropout 比率；权重衰减；数据增强强度；优化器类型；学习率调度策略。

调优顺序建议：

1. 先确保数据和标签正确；
2. 建立简单基线；
3. 调学习率；
4. 调模型容量；
5. 处理正则化；
6. 调数据增强；
7. 最后进行自动化搜索。

**不要一开始就搜索几十个参数。错误的数据管道不会因为超参数搜索而变正确。**

Keras Tuner 可用于随机搜索、贝叶斯优化等自动调参任务，但每次实验都应记录代码版本、数据版本和随机种子。

---

## 第三十八站：调试 TensorFlow 模型的系统方法

### 第一步：检查输入

```python
for x_batch, y_batch in train_ds.take(1):
    print(x_batch.shape, x_batch.dtype)
    print(y_batch.shape, y_batch.dtype)
    print(tf.reduce_min(x_batch), tf.reduce_max(x_batch))
```

确认：形状是否正确；数值范围是否合理；标签是否与样本对应；是否存在 NaN 或 Inf。

### 第二步：让模型过拟合一个小批次

取几十个样本反复训练。如果模型连一个小批次都无法拟合，通常说明：网络或损失函数配置错误；标签编码不匹配；梯度没有正常传播；学习率不合理；数据预处理有问题。

### 第三步：检查模型输出

```python
outputs = model(x_batch, training=False)
print(outputs.shape)
print(outputs[:2])
```

### 第四步：检查梯度

```python
with tf.GradientTape() as tape:
    predictions = model(x_batch, training=True)
    loss = loss_fn(y_batch, predictions)

gradients = tape.gradient(loss, model.trainable_variables)

for variable, gradient in zip(model.trainable_variables, gradients):
    print(variable.name, gradient is None)
```

如果某些关键参数梯度为 None，说明它们没有参与损失计算或计算路径被错误切断。

### 第五步：关闭图模式定位问题

调试时可以：

```python
model.compile(
    optimizer="adam",
    loss="sparse_categorical_crossentropy",
    run_eagerly=True,
)
```

问题解决后再关闭 `run_eagerly`，恢复性能。

---

## 第三十九站：常见错误与解决方法

### 1. 输入形状不匹配

错误示例：

```
expected shape=(None, 224, 224, 3), found shape=(32, 28, 28, 1)
```

解决：检查模型的 Input、图片尺寸和通道数。

### 2. 标签与损失函数不匹配

- 整数标签：SparseCategoricalCrossentropy；
- One-Hot 标签：CategoricalCrossentropy；
- 二分类：BinaryCrossentropy。

### 3. 输出层神经元数量错误

10 类分类应输出 10 个值，而不是 1 个值。

### 4. loss 变成 NaN

可能原因：学习率过大；输入中有 NaN/Inf；数值范围过大；对零取对数；梯度爆炸；低精度训练数值不稳定。

检查：

```python
tf.debugging.check_numerics(tensor, "tensor contains NaN or Inf")
```

### 5. GPU 未被识别

先运行：

```python
print(tf.config.list_physical_devices("GPU"))
```

再确认：系统平台是否受支持；NVIDIA 驱动是否正确；是否在 WSL2 或 Linux 环境；安装命令是否使用 `tensorflow[and-cuda]`；虚拟环境是否正确激活。

### 6. 显存不足

解决方法：减小批次大小；减小输入尺寸；减少模型宽度或层数；启用混合精度；使用梯度累积；避免一次性把全部数据放到 GPU。

### 7. 训练速度很慢

检查：是否使用 prefetch；map 是否开启并行；数据预处理是否成为瓶颈；GPU 是否真正工作；批次是否太小；是否频繁 retracing；是否在每一步调用 `.numpy()`；是否使用大量 Python 循环。

### 8. 保存后无法加载自定义层

需要注册可序列化对象，或在加载时传入 custom_objects。推荐：

```python
@keras.saving.register_keras_serializable(package="MyLayers")
class ScaleLayer(keras.layers.Layer):
    ...
```

---

## 第四十站：TensorFlow 工程目录设计

一个可维护的项目可以采用：

```
my_tensorflow_project/
├── README.md
├── requirements.txt
├── configs/
│   └── baseline.yaml
├── data/
│   ├── raw/
│   ├── processed/
│   └── splits/
├── src/
│   ├── datasets.py
│   ├── models.py
│   ├── losses.py
│   ├── metrics.py
│   ├── train.py
│   ├── evaluate.py
│   └── export.py
├── tests/
│   ├── test_datasets.py
│   └── test_models.py
├── checkpoints/
├── logs/
└── exports/
```

配置文件示例：

```yaml
experiment_name: mnist_cnn
seed: 42
batch_size: 128
epochs: 20
learning_rate: 0.001
weight_decay: 0.0001
input_shape: [28, 28, 1]
num_classes: 10
```

工程化的核心不是"文件夹多"，而是把以下内容明确分离：数据定义；模型定义；训练入口；评估逻辑；导出逻辑；实验配置；测试代码。

---

## 第四十一站：可复现训练的关键细节

1. **固定随机种子**：

```python
keras.utils.set_random_seed(42)
```

2. **保存依赖版本**：

```bash
pip freeze > requirements-lock.txt
```

3. **保存配置**。每次实验保存：数据集版本；模型配置；优化器配置；随机种子；Git 提交编号；最终指标；最佳模型路径。

4. **不要修改测试集**。验证集用于调参，测试集只用于最终评估。反复根据测试集调整模型，会使测试结果失去客观性。

5. **建立基线**。在复杂模型之前，先训练：常数预测器；线性模型；小型神经网络。只有复杂模型显著超过简单基线，复杂度才是合理的。

---

## 第四十二站：从会用到精通的五个阶段

**第一阶段：会调用 API。**能够创建张量；使用 Sequential；调用 compile 和 fit；完成简单分类和回归。

**第二阶段：理解训练原理。**能够手写 GradientTape；理解损失、梯度和优化器；解释训练集与验证集曲线；诊断过拟合和欠拟合。

**第三阶段：能够设计模型。**能够使用 Functional API；构建 CNN、RNN、Transformer；编写自定义层；使用迁移学习和微调。

**第四阶段：能够优化系统。**能够优化 tf.data；使用混合精度；减少 retracing；进行多 GPU 训练；使用 TensorBoard Profile 分析瓶颈。

**第五阶段：能够交付产品。**能够管理数据、代码和模型版本；构建可复现实验；导出和量化模型；部署服务器或端侧；监控线上延迟、漂移和业务指标。

真正的"精通"不是记住更多 API，而是能在数据、模型、训练、性能和部署之间做正确取舍。

---

## 第四十三站：30 天 TensorFlow 学习路线

### 第 1 周：张量与训练基础

第 1～2 天：安装环境；学习 Tensor、shape、dtype；熟悉常见张量操作。

第 3～4 天：学习 tf.Variable；理解 GradientTape；手写线性回归。

第 5～7 天：学习 Sequential；完成 MNIST 分类；掌握 compile、fit、evaluate。

### 第 2 周：模型与数据流水线

第 8～10 天：学习 Functional API；理解多输入、多输出和残差连接。

第 11～12 天：系统学习 tf.data；掌握 map、batch、cache、prefetch。

第 13～14 天：完成一个真实图片分类项目；加入数据增强和回调函数。

### 第 3 周：高级模型与训练

第 15～17 天：学习 CNN；理解卷积、池化和感受野。

第 18～19 天：学习 LSTM、GRU；完成时间序列或文本分类。

第 20～21 天：学习注意力与 Transformer；编写自定义层和自定义训练步骤。

### 第 4 周：工程与部署

第 22～23 天：TensorBoard；系统调试模型；记录实验。

第 24～25 天：混合精度；tf.function；输入流水线优化。

第 26～27 天：保存模型；SavedModel；Checkpoint。

第 28～29 天：转换 TFLite/LiteRT；编写服务器推理接口。

第 30 天：整理完整项目；编写 README；复盘模型效果、性能和可维护性。

---

## 第四十四站：推荐实战项目

**初级项目：**MNIST 手写数字分类；房价回归预测；鸢尾花分类；电影评论情感分类；简单时间序列预测。

**中级项目：**猫狗图像分类；花卉迁移学习；新闻多分类；用户流失预测；多变量电力负荷预测；图像自动编码器。

**高级项目：**图像分割；目标检测；对比学习；Transformer 文本分类；多模态分类；推荐系统；GAN；多 GPU 训练；手机端实时识别；训练、服务和监控一体化系统。

每个项目都应至少包含：数据分析；基线模型；训练与验证曲线；错误样本分析；模型保存；推理脚本；README 文档。

---

## 第四十五站：学习 TensorFlow 最常见的误区

**误区一：只会复制官方示例。**复制代码能快速入门，但必须主动修改：换数据集；换输入尺寸；换损失函数；增加评估指标；修改网络结构；导出并部署模型。

**误区二：模型越大越好。**模型容量必须与数据量、任务难度、计算预算和部署环境匹配。

**误区三：训练准确率高就是成功。**训练准确率只说明模型记住了训练数据。真正重要的是验证集、测试集和真实业务数据表现。

**误区四：GPU 利用率低就增加模型。**GPU 利用率低可能是数据加载、CPU 预处理、磁盘读取或批次太小导致。应该先分析瓶颈。

**误区五：框架 API 就是深度学习原理。**TensorFlow 会替你计算梯度，但不会替你选择正确的目标函数、数据切分方式和评估指标。

**误区六：跑通模型就等于可以上线。**上线还需要考虑输入校验、异常处理、模型版本、延迟、内存、安全、监控和回滚。

---

## 第四十六站：TensorFlow、PyTorch 和 JAX 怎么选

没有任何框架适合所有场景。

**TensorFlow 的优势：**Keras 上手快；tf.data 数据流水线成熟；分布式训练体系完整；端侧和跨平台部署能力强；适合构建训练到部署的一体化工程链路。

**PyTorch 的优势：**Python 风格自然；研究生态活跃；调试体验直观；开源大模型项目广泛使用。

**JAX 的优势：**函数式变换能力强；jit、grad、vmap 等组合灵活；大规模科学计算和前沿研究中很有吸引力。

Keras 3 已经支持多后端，这意味着模型开发接口与底层计算框架的边界正在变得更加灵活。

选择建议：

- 想快速开发并重视多端部署：TensorFlow/Keras；
- 偏研究和大模型开源生态：PyTorch；
- 偏函数式计算与高性能研究：JAX；
- 团队已有成熟技术栈：优先延续现有体系。

---

## 第四十七站：进阶学习清单

完成本文后，可以继续学习：TensorFlow Probability；TensorFlow Recommenders；TensorFlow Decision Forests；TensorFlow Federated；KerasCV、KerasNLP 或 KerasHub；TensorFlow Model Garden；自定义算子；XLA 编译；DTensor 与大规模分布式模型；模型量化、剪枝和蒸馏；数据漂移与模型监控；MLOps 与持续训练。

不要同时铺开所有方向。应根据项目需要选择一条深入：

```
计算机视觉 | 自然语言处理 | 推荐系统 | 时间序列 | 端侧AI | 分布式训练 | MLOps
```

---

## 终点站：结语——从会写模型，到会构建 AI 系统

TensorFlow 入门并不难。几行 Keras 代码就能训练一个神经网络，但"从入门到精通"需要完成三次认知升级。

**第一次升级**，是从"调用 API"到理解张量、梯度、损失函数和优化器。

**第二次升级**，是从"训练单个模型"到掌握数据流水线、实验设计、错误分析和性能优化。

**第三次升级**，是从"离线准确率"到完整考虑模型导出、设备约束、服务稳定性、版本管理和线上监控。

最有效的学习方式始终是：

```
学一个概念 → 写一个最小示例 → 放进真实项目
→ 制造并解决错误 → 测量效果和性能 → 总结成可复用模板
```

当你可以独立回答以下问题时，就已经真正跨过了 TensorFlow 的入门阶段：

- 我的输入张量形状和数据类型是什么？
- 为什么选择这个损失函数？
- 梯度是否正常传播？
- 模型为什么过拟合或欠拟合？
- 数据流水线是否拖慢训练？
- 如何恢复中断的训练？
- 如何导出并在目标设备运行？
- 如何知道新模型真的比旧模型更好？

---

三个月后的那个季度评审会上，闻笛放的不再是 Notebook 截图，而是一条完整的链路：`tf.data` 流水线读取版本固定的特征数据，Functional API 模型带着类权重训练，TensorBoard 曲线里验证集 Precision/Recall 稳步爬升，EarlyStopping 在最优点停住，`.keras` 检查点自动保存，`model.export()` 导出的 SavedModel 经量化后在手机端跑出 12ms 的单次推理延迟。线上拦截率比三个月前翻了一倍——这次用的是业务成本算出来的指标。

没有人再提"99% 的准确率"。TensorFlow 的价值，不只是帮你训练一个模型，而是帮助你把机器学习想法变成可以验证、优化、交付和持续迭代的系统。

正如闻笛在团队 README 首页写下的那句话：

> "模型的价值不在训练完成的那个瞬间，而在它被部署、监控并持续迭代的一生。"

## 参考资料 / 官方延伸阅读

- [TensorFlow 官网](https://www.tensorflow.org/)
- [TensorFlow 安装指南](https://www.tensorflow.org/install/pip)
- [TensorFlow Core 指南](https://www.tensorflow.org/guide)
- [张量指南](https://www.tensorflow.org/guide/tensor)
- [tf.data 指南](https://www.tensorflow.org/guide/data)
- [Keras 指南](https://www.tensorflow.org/guide/keras)
- [Keras 3 入门](https://keras.io/getting_started/)
- [自定义训练循环](https://www.tensorflow.org/guide/keras/writing_a_training_loop_from_scratch)
- [迁移学习与微调](https://www.tensorflow.org/guide/keras/transfer_learning)
- [分布式训练](https://www.tensorflow.org/guide/distributed_training)
- [TensorBoard](https://www.tensorflow.org/tensorboard)
- [LiteRT](https://www.tensorflow.org/lite)
- [TensorFlow GitHub Releases](https://github.com/tensorflow/tensorflow/releases)

> 版本提示：TensorFlow 迭代较快（2.21 已移除 Python 3.9 支持、TensorBoard 不再自动安装、TFLite 正演进为 LiteRT）。实际使用前，请以所装版本的官方文档为准核对 API、平台支持与参数。