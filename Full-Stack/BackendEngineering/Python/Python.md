# [Python 从入门到精通：一篇文章构建完整知识体系](https://mp.weixin.qq.com/s/1sBnEMSFSM9y5fTNZxMBXg)

> 这是一个关于"苏晚"的故事——一个在"望舒咨询"做分析师的姑娘。她的日常是被 Excel 支配的：几十个表合并、报表手工贴、数据大了就卡死。直到有一天，她发现隔壁组的实习生用几行代码十分钟干完了她一天的活。你会跟着苏晚一起，从"会写几行 Python"走到"能把需求拆成模块、写出可维护的工程"。读完之后你会发现：Python 的语法并不复杂，真正困难的是——如何把零散知识连接成体系，并最终写出可维护、可扩展、可部署的程序。

---

## 故事的起点：Excel 撑不住的那一天

苏晚在"望舒咨询"做了三年分析师。她的日常是：合并报表、清洗数据、写周报。

那天下午，老板扔给她一个任务：把过去 12 个月的销售数据（来自 36 个 Excel 文件）合并、清洗、按客户分类，明天早上要。

苏晚打开第一个文件，正要开始"复制粘贴大业"，隔壁工位的实习生递来一杯咖啡："晚姐，我帮你试试？"

十分钟后，实习生跑了三行代码，36 个文件合并完成，还自动生成了分类汇总表。苏晚看着屏幕上滚动的输出，沉默了。

她问实习生："这是什么？"

"Python。"

那天晚上，苏晚没有回家，她在公司电脑上装好了 Python，输入了人生中的第一行代码：

```python
print("Hello, Python!")
```

她给自己定了个目标：**把 Python 学到能真正解决工作问题的程度。**

真正掌握 Python，至少包含四个层次：

1. 能看懂并写出正确代码；
2. 能把需求拆解成模块；
3. 能写出便于测试和维护的工程；
4. 能理解性能、并发、部署与架构之间的取舍。

这个故事，就是她从"会写几行 Python"走向"能用 Python 解决问题"的完整路线图。

---

## 第一站：为什么学习 Python？

苏晚的第一课，是搞清楚 Python 到底是什么、能干什么。

Python 是一门强调可读性和开发效率的高级编程语言。它既适合第一次接触编程的学习者，也被大量用于真实的生产系统。

Python 常见的应用方向包括：

- 自动化办公与批量处理；
- Web 后端开发；
- 数据分析与数据可视化；
- 人工智能与机器学习；
- 网络爬虫与信息采集；
- 测试开发与运维工具；
- 科学计算与工程仿真；
- 桌面应用、游戏脚本和硬件控制。

Python 最大的优势，不只是"语法简单"，而是它拥有**庞大的生态系统**。许多复杂任务，都可以借助成熟的第三方库快速完成。

例如：

```python
from pathlib import Path

for file in Path(".").glob("*.txt"):
    print(file.name)
```

这几行代码就能遍历当前目录中的所有文本文件。

但苏晚记住了一句很重要的话：**会写几行 Python，不等于真正掌握 Python。**

---

## 第二站：安装 Python 与搭建开发环境

### 检查 Python 是否安装

打开终端或命令提示符，输入：

```bash
python --version
```

部分系统需要使用：

```bash
python3 --version
```

如果显示 Python 版本号，说明已经安装成功。

### 进入交互式环境

在终端输入 `python`，进入后可以直接执行：

```python
print("Hello, Python!")
```

退出交互环境：

```python
exit()
```

交互式环境适合快速验证想法，但正式项目应该写在 `.py` 文件中。

### 选择编辑器

- Visual Studio Code：轻量、插件丰富；
- PyCharm：功能完整，适合大型 Python 工程；
- Jupyter Notebook：适合数据分析、教学和实验；
- 命令行编辑器：适合服务器环境和自动化工作流。

### 第一个 Python 文件

创建 `hello.py`：

```python
name = input("请输入你的名字：")
print(f"你好，{name}！欢迎学习 Python。")
```

运行：

```bash
python hello.py
```

到这里，苏晚完成了从代码编写到程序运行的完整流程。

---

## 第三站：变量与基本数据类型

变量可以理解为"给数据起名字"。

```python
name = "Alice"
age = 20
height = 1.68
is_student = True
```

Python 会根据赋值自动判断类型。

```python
print(type(name))
print(type(age))
print(type(height))
print(type(is_student))
```

常见基本类型：

### 数值运算

```python
a = 10
b = 3
print(a + b)   # 加法
print(a - b)   # 减法
print(a * b)   # 乘法
print(a / b)   # 真除法
print(a // b)  # 整除
print(a % b)   # 取余
print(a ** b)  # 幂运算
```

### 类型转换

```python
age_text = "18"
age = int(age_text)

price = 99
price_text = str(price)

value = float("3.14")
```

用户输入默认是字符串：

```python
number = int(input("请输入一个整数："))
print(number * 2)
```

如果忘记转换，`"10" + "20"` 得到的是 `"1020"`，而不是 `30`。

---

## 第四站：字符串——最常用的数据类型之一

### 创建字符串

```python
text1 = "Python"
text2 = '编程'
text3 = """这是一个可以换行的字符串"""
```

### 字符串索引与切片

```python
word = "Python"
print(word[0])      # P
print(word[-1])     # n
print(word[0:3])    # Pyt
print(word[::2])    # Pto
print(word[::-1])   # nohtyP
```

切片的基本格式：

```
序列[开始位置:结束位置:步长]
```

结束位置本身不包含在结果中。

### 常用字符串方法

```python
text = "  Hello Python  "
print(text.strip())
print(text.lower())
print(text.upper())
print(text.replace("Python", "World"))
print(text.split())
```

判断与查找：

```python
filename = "report.pdf"
print(filename.endswith(".pdf"))
print("port" in filename)
print(filename.find("pdf"))
```

### 格式化字符串

推荐使用 f-string：

```python
name = "小明"
score = 95.5
message = f"{name}的成绩是 {score:.1f} 分"
print(message)
```

f-string 既清晰又高效，是现代 Python 中最常用的字符串格式化方式。

---

## 第五站：条件判断——让程序学会选择

基本结构：

```python
age = 20
if age >= 18:
    print("成年人")
else:
    print("未成年人")
```

多分支判断：

```python
score = 86
if score >= 90:
    grade = "A"
elif score >= 80:
    grade = "B"
elif score >= 60:
    grade = "C"
else:
    grade = "D"
print(grade)
```

### 比较运算符

```
==  # 等于
!=  # 不等于
>   # 大于
<   # 小于
>=  # 大于等于
<=  # 小于等于
```

### 逻辑运算符

```python
age = 20
has_ticket = True
if age >= 18 and has_ticket:
    print("允许进入")
```

- `and`：多个条件同时满足；
- `or`：至少一个条件满足；
- `not`：条件取反。

### 真值判断

以下值通常会被视为假：

```
False
None
0
0.0
""
[]
{}
set()
```

因此可以这样写：

```python
items = []
if not items:
    print("列表为空")
```

这比 `if len(items) == 0:` 更符合 Python 风格。

---

## 第六站：循环——重复执行任务

### for 循环

```python
for number in range(1, 6):
    print(number)
```

`range(1, 6)` 会生成 1、2、3、4、5。

遍历字符串：

```python
for char in "Python":
    print(char)
```

遍历列表：

```python
names = ["Alice", "Bob", "Charlie"]
for name in names:
    print(name)
```

### while 循环

```python
count = 1
while count <= 5:
    print(count)
    count += 1
```

### break、continue 与 else

```python
for number in range(1, 11):
    if number == 3:
        continue
    if number == 8:
        break
    print(number)
```

- `continue`：跳过本轮；
- `break`：结束整个循环。

循环还可以带 `else`：

```python
target = 7
for number in range(1, 10):
    if number == target:
        print("找到了")
        break
else:
    print("没有找到")
```

只有循环没有被 `break` 提前终止时，`else` 才会执行。

---

## 第七站：四大常用容器

Python 中最常用的容器是列表、元组、字典和集合。

### 列表 list

列表是有序、可修改的序列。

```python
fruits = ["苹果", "香蕉", "橙子"]
fruits.append("葡萄")
fruits.insert(1, "梨")
fruits.remove("香蕉")
print(fruits)
```

常用操作：

```python
numbers = [5, 2, 8, 1]
numbers.sort()
print(numbers)
numbers.sort(reverse=True)
print(numbers)
print(len(numbers))
print(max(numbers))
print(min(numbers))
print(sum(numbers))
```

列表推导式：

```python
squares = [x ** 2 for x in range(1, 6)]
print(squares)
```

带条件：

```python
even_squares = [x ** 2 for x in range(1, 11) if x % 2 == 0]
```

> 列表推导式适合表达简单转换，复杂逻辑应使用普通循环，避免牺牲可读性。

### 元组 tuple

元组有序，但创建后不能修改。

```python
point = (10, 20)
x, y = point
print(x, y)
```

元组常用于：表示坐标、返回多个值、保存不希望被修改的数据。

```python
def get_user():
    return "Alice", 20

name, age = get_user()
```

### 字典 dict

字典用键值对存储数据。

```python
user = {
    "name": "Alice",
    "age": 20,
    "city": "Hangzhou",
}
print(user["name"])
print(user.get("email", "未填写"))
```

新增和修改：

```python
user["email"] = "alice@example.com"
user["age"] = 21
```

遍历：

```python
for key, value in user.items():
    print(key, value)
```

字典推导式：

```python
squares = {x: x ** 2 for x in range(1, 6)}
```

### 集合 set

集合中的元素不重复。

```python
tags = {"Python", "Web", "Python", "AI"}
print(tags)
```

集合运算：

```python
a = {1, 2, 3}
b = {3, 4, 5}
print(a | b)  # 并集
print(a & b)  # 交集
print(a - b)  # 差集
print(a ^ b)  # 对称差集
```

集合特别适合去重和成员判断。苏晚后来处理 36 个 Excel 里的重复客户名，用的就是集合去重。

---

## 第八站：函数——从"写代码"走向"组织代码"

函数把一段逻辑封装起来，可以重复调用。

```python
def greet(name):
    return f"你好，{name}！"

message = greet("小明")
print(message)
```

### 参数与返回值

```python
def calculate_total(price, quantity, discount=1.0):
    total = price * quantity * discount
    return round(total, 2)

print(calculate_total(99, 2))
print(calculate_total(99, 2, 0.8))
```

### 关键字参数

```python
result = calculate_total(
    price=99,
    quantity=3,
    discount=0.9,
)
```

使用关键字参数可以增强可读性。

### 可变参数

```python
def total(*numbers):
    return sum(numbers)

print(total(1, 2, 3, 4))
```

接收关键字参数：

```python
def show_profile(**profile):
    for key, value in profile.items():
        print(key, value)

show_profile(name="Alice", age=20, city="Shanghai")
```

### 参数默认值的陷阱

不要使用可变对象作为默认值：

```python
# 不推荐
def add_item(item, items=[]):
    items.append(item)
    return items
```

正确写法：

```python
def add_item(item, items=None):
    if items is None:
        items = []
    items.append(item)
    return items
```

原因是默认参数只会在函数定义时创建一次。

### 作用域

```python
name = "全局变量"

def show():
    name = "局部变量"
    print(name)

show()
print(name)
```

一般应尽量减少对全局变量的依赖，通过参数传入数据，通过返回值输出结果。

---

## 第九站：模块、包与第三方库

当代码越来越多时，应拆分到不同文件。

假设有 `calculator.py`：

```python
def add(a, b):
    return a + b

def subtract(a, b):
    return a - b
```

在另一个文件中导入：

```python
from calculator import add

print(add(10, 20))
```

### 主程序入口

```python
def main():
    print("程序开始运行")

if __name__ == "__main__":
    main()
```

这段结构可以防止模块被导入时自动执行主逻辑。

### 安装第三方库

```bash
python -m pip install requests
```

推荐使用 `python -m pip`，这样可以更明确地使用当前 Python 环境对应的 pip。

使用库：

```python
import requests

response = requests.get(
    "https://example.com",
    timeout=10,
)
print(response.status_code)
```

### 虚拟环境

不同项目可能依赖不同版本的第三方库，因此应该使用虚拟环境。

创建：

```bash
python -m venv .venv
```

macOS 或 Linux 激活：

```bash
source .venv/bin/activate
```

Windows 激活：

```
.venv\Scripts\activate
```

导出依赖：

```bash
python -m pip freeze > requirements.txt
```

恢复依赖：

```bash
python -m pip install -r requirements.txt
```

> 虚拟环境是 Python 工程化的第一步。苏晚说："没学虚拟环境之前，我的项目依赖一团乱麻——装了这个库，那个项目就挂了。"

---

## 第十站：异常处理——让程序优雅地面对错误

程序运行过程中可能出现文件不存在、网络超时、格式错误等问题。

```python
try:
    number = int(input("请输入整数："))
    result = 100 / number
except ValueError:
    print("输入内容不是整数")
except ZeroDivisionError:
    print("除数不能为零")
else:
    print(f"结果是：{result}")
finally:
    print("程序执行结束")
```

各部分含义：

- `try`：可能出错的代码；
- `except`：捕获并处理异常；
- `else`：没有异常时执行；
- `finally`：无论是否异常都会执行。

### 主动抛出异常

```python
def set_age(age):
    if age < 0:
        raise ValueError("年龄不能为负数")
    return age
```

异常不是"失败的标志"，而是程序表达错误状态的一种机制。

### 不要捕获所有异常后什么都不做

不推荐：

```python
try:
    do_something()
except:
    pass
```

这种写法会隐藏真正的问题。

更合理的方式是捕获明确异常，并记录必要信息：

```python
import logging

try:
    do_something()
except OSError as exc:
    logging.exception("操作系统错误：%s", exc)
```

---

## 第十一站：文件与目录操作

现代 Python 推荐使用 `pathlib`。

```python
from pathlib import Path

path = Path("data.txt")
path.write_text("Hello, Python!", encoding="utf-8")
content = path.read_text(encoding="utf-8")
print(content)
```

### 遍历目录

```python
from pathlib import Path

folder = Path("documents")
for file in folder.glob("*.md"):
    print(file.name)
```

递归遍历：

```python
for file in folder.rglob("*.py"):
    print(file)
```

### 使用 with 自动关闭文件

```python
with open("data.txt", "r", encoding="utf-8") as file:
    content = file.read()
```

`with` 会在代码块结束后自动释放资源。

### JSON 数据

```python
import json

user = {
    "name": "Alice",
    "age": 20,
    "skills": ["Python", "SQL"],
}

with open("user.json", "w", encoding="utf-8") as file:
    json.dump(user, file, ensure_ascii=False, indent=2)
```

读取：

```python
with open("user.json", "r", encoding="utf-8") as file:
    user = json.load(file)
print(user["name"])
```

### CSV 数据

```python
import csv

rows = [
    ["姓名", "成绩"],
    ["小明", 90],
    ["小红", 95],
]

with open("scores.csv", "w", encoding="utf-8-sig", newline="") as file:
    writer = csv.writer(file)
    writer.writerows(rows)
```

苏晚发现，她过去用手工粘贴一周的报表合并，用 `pathlib` + `csv` 十分钟就能写完——而且还能重复跑。

---

## 第十二站：面向对象编程

面向对象编程把数据和操作数据的方法组织在一起。

```python
class BankAccount:
    def __init__(self, owner, balance=0):
        self.owner = owner
        self.balance = balance

    def deposit(self, amount):
        if amount <= 0:
            raise ValueError("存款金额必须大于零")
        self.balance += amount

    def withdraw(self, amount):
        if amount > self.balance:
            raise ValueError("余额不足")
        self.balance -= amount

    def __str__(self):
        return f"{self.owner}：余额 {self.balance:.2f} 元"
```

使用：

```python
account = BankAccount("Alice", 1000)
account.deposit(500)
account.withdraw(200)
print(account)
```

### 类与实例

- 类：对象的模板；
- 实例：根据类创建出的具体对象；
- 属性：对象保存的数据；
- 方法：对象能够执行的操作。

### 继承

```python
class Animal:
    def speak(self):
        raise NotImplementedError

class Dog(Animal):
    def speak(self):
        return "汪汪"

class Cat(Animal):
    def speak(self):
        return "喵喵"
```

### 组合优于过度继承

复杂系统中，不要为了复用几行代码建立深层继承关系。

```python
class Engine:
    def start(self):
        return "发动机启动"

class Car:
    def __init__(self, engine):
        self.engine = engine

    def start(self):
        return self.engine.start()
```

这种"对象中包含对象"的方式叫组合，通常比复杂继承更灵活。

### dataclass

对于主要用于保存数据的类，可以使用 `dataclass`：

```python
from dataclasses import dataclass

@dataclass
class Product:
    name: str
    price: float
    stock: int = 0
```

使用：

```python
product = Product("键盘", 299.0, 20)
print(product)
```

---

## 第十三站：迭代器、生成器与惰性计算

### 可迭代对象

列表、字符串、字典等都可以被 `for` 遍历。

```python
numbers = [1, 2, 3]
iterator = iter(numbers)
print(next(iterator))
print(next(iterator))
print(next(iterator))
```

### 生成器

生成器使用 `yield` 逐个产生数据，而不是一次性全部放入内存。

```python
def count_up_to(limit):
    number = 1
    while number <= limit:
        yield number
        number += 1

for value in count_up_to(5):
    print(value)
```

### 生成器表达式

```python
squares = (x ** 2 for x in range(1_000_000))
```

与列表推导式相比，生成器不会一次性创建一百万个元素，更节省内存。

适用场景：

- 读取大型文件；
- 处理日志流；
- 分批读取数据库；
- 构建数据处理管道。

苏晚处理"百万行级"的销售数据时，生成器让她第一次体会到"内存不被吃爆"的感觉。

---

## 第十四站：装饰器与上下文管理器

### 装饰器

装饰器可以在不修改原函数代码的情况下，为函数增加功能。

```python
from functools import wraps
from time import perf_counter

def timer(func):
    @wraps(func)
    def wrapper(*args, **kwargs):
        start = perf_counter()
        result = func(*args, **kwargs)
        elapsed = perf_counter() - start
        print(f"{func.__name__} 耗时 {elapsed:.6f} 秒")
        return result
    return wrapper
```

使用：

```python
@timer
def calculate():
    return sum(range(1_000_000))

calculate()
```

装饰器常用于：权限检查、日志记录、缓存、性能统计、重试机制、Web 路由注册。

### 上下文管理器

`with` 背后的机制就是上下文管理器。

```python
from contextlib import contextmanager
from time import perf_counter

@contextmanager
def measure_time(name):
    start = perf_counter()
    try:
        yield
    finally:
        elapsed = perf_counter() - start
        print(f"{name} 耗时：{elapsed:.6f} 秒")
```

使用：

```python
with measure_time("计算任务"):
    total = sum(range(1_000_000))
```

---

## 第十五站：类型注解——让代码更清晰

Python 是动态类型语言，但可以使用类型注解表达设计意图。

```python
def calculate_average(scores: list[float]) -> float:
    if not scores:
        raise ValueError("成绩列表不能为空")
    return sum(scores) / len(scores)
```

定义数据结构：

```python
from dataclasses import dataclass

@dataclass
class User:
    name: str
    age: int
    email: str | None = None
```

类型注解的价值：

- 提高代码可读性；
- 帮助编辑器自动补全；
- 提前发现类型错误；
- 让大型项目更容易维护。

注意：类型注解主要用于静态检查，并不会自动阻止运行时传入错误类型。

---

## 第十六站：并发编程——线程、进程与异步

Python 中常见的并发方式有三种。

### 多线程

适合网络请求、文件读写等 I/O 密集型任务。

```python
from concurrent.futures import ThreadPoolExecutor
from urllib.request import urlopen

def fetch(url):
    with urlopen(url, timeout=10) as response:
        return url, response.status

urls = [
    "https://example.com",
    "https://www.python.org",
]

with ThreadPoolExecutor(max_workers=4) as executor:
    for url, status in executor.map(fetch, urls):
        print(url, status)
```

### 多进程

适合大量计算、图像处理等 CPU 密集型任务。

```python
from concurrent.futures import ProcessPoolExecutor

def square(number):
    return number ** 2

if __name__ == "__main__":
    with ProcessPoolExecutor() as executor:
        results = executor.map(square, range(10))
        print(list(results))
```

### asyncio 异步编程

适合大量并发 I/O 连接。

```python
import asyncio

async def task(name, delay):
    await asyncio.sleep(delay)
    return f"{name} 完成"

async def main():
    results = await asyncio.gather(
        task("任务A", 1),
        task("任务B", 2),
        task("任务C", 1.5),
    )
    print(results)

asyncio.run(main())
```

### 如何选择？

不要为了"高级"而并发。并发会增加调试、异常处理和状态管理的复杂度。

---

## 第十七站：数据库基础

以 SQLite 为例，它不需要单独安装数据库服务。

```python
import sqlite3

connection = sqlite3.connect("app.db")
connection.execute("""
CREATE TABLE IF NOT EXISTS users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    age INTEGER NOT NULL
)
""")
connection.execute(
    "INSERT INTO users (name, age) VALUES (?, ?)",
    ("Alice", 20),
)
connection.commit()
```

查询：

```python
cursor = connection.execute(
    "SELECT id, name, age FROM users WHERE age >= ?",
    (18,),
)
for row in cursor:
    print(row)
connection.close()
```

### 为什么要使用参数化查询？

不要这样拼接 SQL：

```python
# 不安全
sql = f"SELECT * FROM users WHERE name = '{name}'"
```

应该使用占位符：

```python
cursor = connection.execute(
    "SELECT * FROM users WHERE name = ?",
    (name,),
)
```

参数化查询可以减少 SQL 注入风险。在大型项目中，通常还会使用 ORM，将数据库表映射成 Python 对象。

---

## 第十八站：Web 开发的核心思路

Python Web 开发常见架构包括：

1. 客户端发送 HTTP 请求；
2. Web 框架匹配路由；
3. 业务逻辑处理数据；
4. 数据库保存或查询；
5. 服务器返回 HTML 或 JSON。

一个简化的接口可能像这样：

```python
from flask import Flask, jsonify

app = Flask(__name__)

@app.get("/api/hello")
def hello():
    return jsonify({
        "message": "Hello, Python Web!"
    })

if __name__ == "__main__":
    app.run(debug=True)
```

安装依赖：

```bash
python -m pip install flask
```

真实项目还需要考虑：参数校验、身份认证、权限管理、数据库事务、日志与监控、缓存、限流、跨域配置、测试、生产部署。

> 学习 Web 开发时，不要只关注框架语法，更要理解 HTTP、数据库、认证、状态管理和系统边界。

---

## 第十九站：自动化办公与批量处理

Python 非常适合处理重复性工作——这正是苏晚学 Python 的初衷。

### 示例：批量重命名文件

```python
from pathlib import Path

folder = Path("photos")
for index, file in enumerate(
    sorted(folder.glob("*.jpg")),
    start=1,
):
    new_name = f"旅行照片_{index:03d}{file.suffix}"
    file.rename(file.with_name(new_name))
```

### 示例：统计文本中的词频

```python
from collections import Counter
import re

text = Path("article.txt").read_text(encoding="utf-8")
words = re.findall(r"[A-Za-z]+", text.lower())
counter = Counter(words)

for word, count in counter.most_common(10):
    print(word, count)
```

自动化项目的关键不只是"能运行"，还应做到：

- 运行前检查输入；
- 重要操作可预览；
- 避免覆盖原文件；
- 出错时保留日志；
- 支持重复执行；
- 对批量修改提供回滚方案。

苏晚把这条记在了本子上："自动化脚本的第一原则——**别让脚本比手工操作更危险。**"

---

## 第二十站：数据分析入门

Python 数据分析常见工具包括：

- NumPy：高性能数组计算；
- pandas：表格数据处理；
- Matplotlib：数据可视化；
- Jupyter：交互式分析环境。

示例：

```python
import pandas as pd

data = {
    "name": ["小明", "小红", "小刚"],
    "math": [90, 95, 82],
    "english": [88, 91, 85],
}

df = pd.DataFrame(data)
df["average"] = (
    df["math"] + df["english"]
) / 2
print(df)
print(df["average"].mean())
```

数据分析的一般流程：

1. 明确问题；
2. 获取数据；
3. 清洗数据；
4. 探索数据；
5. 建立指标或模型；
6. 可视化结果；
7. 输出结论；
8. 验证结论是否可靠。

> 工具只是手段，最重要的是问题意识和数据质量。

苏晚后来用 pandas 十分钟复现了她过去一周的报表工作——她笑着说："那 36 个 Excel，是我 Python 之路的起点，也是终点。"

---

## 第二十一站：测试——让代码修改后仍然可靠

### 使用 assert

```python
def add(a, b):
    return a + b

assert add(2, 3) == 5
assert add(-1, 1) == 0
```

`assert` 适合简单验证，但正式项目应使用测试框架。

### 使用 pytest

待测试代码：

```python
def divide(a, b):
    if b == 0:
        raise ValueError("除数不能为零")
    return a / b
```

测试代码：

```python
import pytest

def test_divide():
    assert divide(10, 2) == 5

def test_divide_by_zero():
    with pytest.raises(ValueError):
        divide(10, 0)
```

运行：

```bash
python -m pytest
```

### 测试什么？

重点测试：核心业务逻辑、边界条件、异常输入、容易回归的功能、关键数据转换、权限与安全规则。

> 不必追求每一行代码都被测试，但关键逻辑必须可验证。

---

## 第二十二站：日志——比 print 更专业的调试方式

```python
import logging

logging.basicConfig(
    level=logging.INFO,
    format=(
        "%(asctime)s | %(levelname)s | "
        "%(name)s | %(message)s"
    ),
)

logger = logging.getLogger(__name__)

logger.info("程序启动")
logger.warning("剩余磁盘空间不足")
```

发生异常时：

```python
try:
    result = 10 / 0
except ZeroDivisionError:
    logger.exception("计算失败")
```

日志级别常见有：

- `DEBUG`：调试细节；
- `INFO`：正常运行信息；
- `WARNING`：潜在问题；
- `ERROR`：功能执行失败；
- `CRITICAL`：严重错误。

> 生产环境中，应避免使用大量无结构的 `print()`。

苏晚第一次体会到日志的价值，是她的报表脚本半夜跑挂、第二天全靠 `logger` 的堆栈定位到了问题——"print 只能看到'挂了'，日志能看到'为什么挂'。"

---

## 第二十三站：代码风格与可维护性

优秀代码首先是写给人看的，其次才是给机器执行的。

### 使用清晰命名

不推荐：

```python
x = 0
for i in d:
    x += i
```

推荐：

```python
total_price = 0
for price in prices:
    total_price += price
```

### 一个函数只做一件事

不推荐把读取文件、解析数据、写数据库、发送邮件全部塞进一个函数。更好的结构：

```python
def load_data(path):
    ...

def parse_data(raw_data):
    ...

def save_records(records):
    ...

def send_report(summary):
    ...
```

### 避免重复代码

当相似逻辑出现多次时，考虑抽成函数、类或配置。

### 使用常量表达含义

```python
MAX_RETRY_COUNT = 3
REQUEST_TIMEOUT_SECONDS = 10
```

比散落在代码中的 `3` 和 `10` 更容易理解。

### 注释解释"为什么"

不推荐：

```python
count += 1  # count 加 1
```

更有价值的注释：

```python
# 接口按页返回数据，因此成功处理当前页后再移动游标
page_index += 1
```

---

## 第二十四站：项目目录应该怎样组织？

一个中小型项目可以这样组织：

```
my_project/
├── pyproject.toml
├── README.md
├── .gitignore
├── src/
│   └── my_project/
│       ├── __init__.py
│       ├── config.py
│       ├── services.py
│       └── main.py
├── tests/
│   ├── test_services.py
│   └── test_main.py
└── scripts/
    └── import_data.py
```

各目录职责：

- `src/`：正式业务代码；
- `tests/`：测试代码；
- `scripts/`：一次性或运维脚本；
- `README.md`：使用说明；
- `pyproject.toml`：项目与依赖配置；
- `.gitignore`：忽略缓存、虚拟环境和敏感文件。

一个成熟项目，还应明确区分：接口层、业务层、数据访问层、配置、基础设施、测试、部署文件。

---

## 第二十五站：配置与敏感信息管理

不要把密码、密钥和数据库连接字符串直接写进代码。

不推荐：

```python
API_KEY = "真实密钥"
```

更合理的方式是使用环境变量：

```python
import os

api_key = os.environ["API_KEY"]
```

启动程序前设置：

```bash
export API_KEY="your-secret-key"
python app.py
```

开发环境可以使用 `.env` 文件，但要把它加入 `.gitignore`，避免提交到代码仓库。

配置通常分为：开发环境、测试环境、预发布环境、生产环境。代码应保持一致，差异由配置控制。

---

## 第二十六站：性能优化——先测量，再优化

性能优化的第一原则是：**不要凭感觉优化。**

### 使用计时工具

```python
from time import perf_counter

start = perf_counter()
result = sum(range(1_000_000))
elapsed = perf_counter() - start
print(f"耗时：{elapsed:.6f} 秒")
```

### 选择合适的数据结构

判断成员是否存在：

```python
target = 999_999
numbers_list = list(range(1_000_000))
numbers_set = set(numbers_list)
```

在大量数据中，集合的成员判断通常比列表更适合。

### 避免不必要的中间对象

```python
# 会创建完整列表
total = sum([x * x for x in range(1_000_000)])

# 使用生成器，内存占用更低
total = sum(x * x for x in range(1_000_000))
```

### 使用成熟库

对于数值计算、图像处理、机器学习等任务，成熟库往往把核心运算放到底层高性能实现中，通常比纯 Python 循环更快。

### 优化顺序

1. 确认程序真的慢；
2. 定位耗时位置；
3. 优化算法；
4. 优化数据结构；
5. 减少 I/O；
6. 使用缓存；
7. 再考虑并发或底层扩展。

算法层面的优化，通常比微小语法技巧更有效。

---

## 第二十七站：缓存、重试与限流

真实系统需要面对不稳定网络和重复计算。

### 函数缓存

```python
from functools import lru_cache

@lru_cache(maxsize=256)
def fibonacci(n):
    if n < 2:
        return n
    return fibonacci(n - 1) + fibonacci(n - 2)
```

### 简单重试

```python
import time

def retry(operation, max_attempts=3):
    last_error = None
    for attempt in range(1, max_attempts + 1):
        try:
            return operation()
        except OSError as exc:
            last_error = exc
            if attempt < max_attempts:
                time.sleep(attempt)
    raise last_error
```

重试时需要注意：

- 只重试可能恢复的错误；
- 设置最大次数；
- 逐步增加等待时间；
- 避免重复执行有副作用的操作；
- 记录每次失败原因。

### 幂等性

如果同一个请求执行一次和执行多次得到的最终状态一致，就具有幂等性。

例如"将订单状态设置为已取消"通常可以设计成幂等操作，而"账户余额减 100 元"默认不是幂等操作。

> 幂等性是分布式系统、支付系统和任务队列中的重要概念。

---

## 第二十八站：常见设计原则

### 单一职责

一个模块或函数只负责一种明确的职责。

### 依赖倒置

业务逻辑不应该直接依赖某个具体数据库或网络库，而应依赖抽象接口。

```python
class UserRepository:
    def find_by_id(self, user_id):
        raise NotImplementedError
```

不同实现可以连接 SQLite、MySQL 或远程接口。

### 分离纯逻辑与副作用

纯函数更容易测试：

```python
def calculate_discount(price, rate):
    return price * (1 - rate)
```

文件、网络、数据库等副作用尽量放在系统边界。

### 显式优于隐式

参数、配置和数据流越明确，系统越容易理解。

### 简单优于过度设计

不要在只有几十行代码的小脚本中套用复杂架构。设计应该服务于当前复杂度，并为未来变化留下适度空间。

---

## 第二十九站：从零开始的五个实战项目

只看语法很难真正掌握 Python。苏晚给自己列了五个递进项目。

### 项目一：命令行待办事项

功能：添加任务、查看任务、标记完成、删除任务、保存到 JSON 文件。

练习：列表和字典、函数、文件读写、异常处理、命令行交互。

### 项目二：批量文件整理器

功能：按扩展名分类、预览移动结果、自动创建目录、记录操作日志、支持撤销。

练习：`pathlib`、日志、配置文件、安全检查、自动化脚本设计。

### 项目三：天气或资讯聚合器

功能：请求公开接口、解析 JSON、本地缓存、网络失败重试、输出 Markdown 报告。

练习：HTTP 请求、API 调用、超时处理、数据清洗、模块化设计。

### 项目四：个人记账系统

功能：收入和支出录入、分类统计、月度报表、SQLite 存储、导出 CSV。

练习：数据库、SQL、分层设计、数据校验、报表生成。

### 项目五：完整 Web 应用

功能：用户注册和登录、数据增删改查、权限控制、数据库迁移、自动测试、容器化部署。

练习：Web 框架、ORM、用户认证、安全、测试、部署、工程化。

每个项目都应经历以下过程：

```
需求分析 → 数据设计 → 功能拆分 → 编码 → 测试
→ 重构 → 文档 → 部署 → 复盘
```

---

## 第三十站：Python 学习中最常见的十个误区

苏晚把团队和自己在学习路上踩过的坑，整理成了"误区清单"：

### 误区一：只看教程，不写项目

编程能力来自解决问题，而不是来自观看视频的时长。

### 误区二：背语法，不理解数据流

应关注数据从哪里来、经过什么处理、最终到哪里去。

### 误区三：过度追求"一行代码"

代码越短不一定越好。可读、可测试、可维护更重要。

### 误区四：遇到错误就复制答案

应该先读异常类型、错误位置和调用栈，再尝试定位根因。

### 误区五：不使用虚拟环境

这会导致项目依赖互相污染。

### 误区六：所有代码写在一个文件中

随着需求增长，单文件会迅速变得难以维护。

### 误区七：过早使用复杂框架

先理解问题，再选择工具。

### 误区八：忽略测试

没有测试的项目，修改一次就可能破坏另一个功能。

### 误区九：忽略文档和命名

未来接手代码的人，往往就是几个月后的自己。

### 误区十：把"精通"理解为记住全部 API

真正的精通是理解原则、知道如何查资料，并能在约束条件下做出合理设计。

---

## 第三十一站：从入门到精通的学习路线

### 第一阶段：语法入门

建议掌握：变量与数据类型、字符串、条件判断、循环、列表/字典/集合、函数、文件读写、异常处理。

阶段目标：可以独立完成 200～500 行的小工具。

### 第二阶段：编程能力

建议掌握：模块与包、面向对象、迭代器与生成器、装饰器、上下文管理器、标准库、调试与日志、单元测试。

阶段目标：可以把需求拆分成多个模块，代码结构清晰。

### 第三阶段：选择一个专业方向

**Web 开发**：HTTP、Web 框架、数据库、ORM、用户认证、缓存、部署。

**数据分析**：NumPy、pandas、Matplotlib、SQL、统计学、数据清洗。

**人工智能**：线性代数、概率统计、NumPy、机器学习、深度学习框架、模型训练与部署。

**自动化与运维**：文件系统、网络请求、Shell、Linux、日志、任务调度、容器技术。

### 第四阶段：工程化

建议掌握：Git、代码规范、类型检查、自动测试、持续集成、配置管理、安全、性能分析、容器化部署、监控与告警。

### 第五阶段：架构与长期维护

重点不再是"会不会写"，而是：如何划分模块边界、如何控制依赖、如何保证数据一致性、如何处理失败、如何扩展系统、如何降低维护成本、如何在性能/复杂度和开发效率之间取舍。

---

## 第三十二站：如何阅读优秀代码与调试

### 阅读代码的推荐顺序

阅读代码时，不要从第一行开始机械地往下看。推荐顺序：

1. 阅读 README，了解项目用途；
2. 找到程序入口；
3. 看目录结构；
4. 找核心数据模型；
5. 找主要业务流程；
6. 跟踪一次完整调用；
7. 阅读测试；
8. 最后研究工具函数和边界处理。

阅读时可以持续回答几个问题：输入是什么？输出是什么？状态保存在哪里？哪些地方可能失败？模块之间如何通信？哪些代码属于核心业务？哪些代码只是基础设施？

> 能读懂成熟项目，是从中级走向高级的重要能力。

### 调试的五个步骤

遇到错误时，使用以下流程：

**第一步：稳定复现**——明确什么输入、什么环境、什么步骤会触发问题。

**第二步：读完整异常信息**——重点关注异常类型、最后一段错误描述、具体文件、行号、调用栈。

**第三步：缩小范围**——通过日志、断点或临时输出，定位问题发生在哪个步骤。

**第四步：检查假设**——变量真的是你以为的类型吗？文件真的存在吗？接口真的返回 JSON 吗？数据库事务真的提交了吗？异步函数真的被 `await` 了吗？

**第五步：写回归测试**——修复问题后，补一个可以稳定复现该问题的测试，防止以后再次出现。

---

## 第三十三站：学习方法论——比路线图更重要的东西

路线图是"学什么"，这一站是"怎么学"。苏晚带新人的时候，把前人踩过的坑浓缩成了几条铁律。

### 编程能力的真实权重

很多人以为学编程就是"把语法学透"，大错特错。真实的权重是这样的：

| 排名 | 核心能力 | 占比 |
|------|----------|------|
| 1 | 查阅文档、搜索现成解决方案 | 50% |
| 2 | 拆解业务问题，组合现有工具实现需求 | 30% |
| 3 | 基础语法掌握 | 15% |
| 4 | 算法、高级数据结构等进阶内容 | 5% |

举一个真实场景：统计一个文件夹下所有 txt 文件的单词总数。

- **新手思路**：翻开教程，依次学 `open()`、`read()`、`split()`，再学遍历、路径、编码、异常……学完一堆知识点还没动手，心态先垮了。
- **职场思路**：直接搜索 "python count words in all text files in directory"，参考现成方案，改几处参数跑通，任务完成。

编程不是闭卷考试。**会查、会搜、会复用，才是程序员的核心能力。**

### 按需学习，而不是通读教材

入门第一本教材不要超过 200 页，更不要追求"全书通读"。推荐节奏：

1. 7 天快速刷完一本薄教材（《Python 编程：从入门到实践》前 9 章 /《笨办法学 Python》前 26 个练习）；
2. 立刻上手做小项目；
3. 遇到不懂的知识点，再回头查阅书本与文档。

看书只是工具，写代码才是目的。这种"按需学习"的效率，是从头到尾通读教材的数倍。

### 先做出能跑的"垃圾项目"

不要等"学完基础"才动手。做项目会倒逼你发现短板，再回头补齐对应知识；简历上"完整项目经历"远比"熟练掌握若干模块"有说服力。就像学开车，熟读汽车原理手册永远学不会上路。

正确顺序：**先做出能跑的版本，再迭代优化**——而不是等完美之后再动手。

### 排错时限法则：卡住 30 分钟就求助

很多新手在一个报错上死磕四五个小时，白白消耗学习热情。高效的排错节奏：

- **0～15 分钟**：自己阅读报错提示，复制关键文本去搜索引擎检索；
- **15～30 分钟**：把完整报错和代码交给 AI，请它帮忙定位原因；
- **超过 30 分钟**：去 SegmentFault、Stack Overflow 社区发帖提问。

学会高效提问，比会写代码更重要。这也和上一站的调试五步骤相辅相成：先自己走流程，走到时限就借力。

### 学习留存率：看懂 ≠ 掌握

心理学有一个学习留存率规律：阅读留存约 10%，听课约 20%，演示约 30%，动手输出可达 90%。

每学一个知识点，立刻写代码验证——哪怕只是复制示例、改个数字、观察输出变化。看完教程觉得"我懂了"，是最低效的学习状态。

### AI 时代的定位

大模型写代码的能力越来越强，有人因此焦虑："AI 什么都能写，我学 Python 还有意义吗？"恰恰相反：

- AI 能输出代码，但它不理解你的业务真实需求；
- AI 经常生成有 Bug 的代码，需要你来判断对错；
- AI 会调用各种库，需要你判断方案是否合理。

未来普通人的定位是**业务问题专家 + AI 工具使用者**，而不是手动敲代码的苦力。而"能判断 AI 写得对不对"，本身就需要你在这一站之前的所有积累。

### 找到同伴，尽早暴露

自学最大的敌人是三天打鱼两天晒网。加入学习社群、找水平略高于你的同伴互相 Review 代码、参加 LeetCode 周赛——同辈的正向压力是最好的学习燃料。

另外，不要等"完全准备好"再投简历或展示作品。面试邀约说明方向正确，面试官的提问就是免费的学习指南针，哪怕失利，面试本身也是高强度实战训练。**行动永远大于完美。**

---

## 结语：真正"精通 Python"意味着什么？

故事讲完了。

三个月后，苏晚用 Python 重建了部门的报表体系：36 个 Excel 的合并脚本、自动化的周报生成、pandas 数据分析流程，甚至给团队写了一个内部的小工具站。她不再是"会用 Python 的分析师"，而是"用 Python 解决问题的人"。

精通不是知道每个标准库函数，也不是能写出最炫技的语法。真正的精通体现在：

- 面对陌生需求，能快速拆解问题；
- 知道什么时候写脚本，什么时候做工程；
- 能选择合适的数据结构和并发模型；
- 能写出清晰的模块边界；
- 能通过测试保证修改安全；
- 能定位性能瓶颈，而不是盲目优化；
- 能处理异常、超时、重试和数据一致性；
- 能把程序部署到真实环境；
- 能阅读和维护别人的代码；
- 能在复杂度、性能与开发效率之间做出取舍。

Python 只是工具。真正拉开差距的，是计算思维、工程思维和持续实践。

Python 的入门门槛很低，但它的能力边界非常广。学习初期，你可能会把注意力放在变量、循环和函数上；进入项目阶段后，你会开始思考模块、测试和数据库；再往后，你会关注性能、并发、安全、部署和架构。

这条路没有一个绝对的"学完"时刻。更有效的方法是：

> 学一小块，做一个项目；遇到问题，再补知识；完成项目后，重构一次。

当你能够把一个真实需求变成可靠、清晰、可维护的程序时，你就已经不再只是"会 Python"，而是在真正使用 Python 解决问题。

> 愿你写下的每一行 Python，都不仅能够运行，也能够被理解、被测试、被维护。

---

## 附录：常用命令速查

```bash
# 查看 Python 版本
python --version

# 创建虚拟环境
python -m venv .venv

# 安装依赖
python -m pip install package_name

# 导出依赖
python -m pip freeze > requirements.txt

# 安装项目依赖
python -m pip install -r requirements.txt

# 运行 Python 文件
python main.py

# 运行测试
python -m pytest

# 启动简单静态文件服务器
python -m http.server 8000
```

## 附录：精选极简资源清单

资源不是越多越好。选定一份主线资料完整跟完，远比五十套教程各看五分钟强。

### 入门书籍

1. 《Python 编程：从入门到实践》——零基础首选；
2. 《笨办法学 Python》——练习驱动，适合动手型学习者；
3. 《Python Cookbook》——进阶工具书，遇到问题按需查阅。

### 免费视频

- B 站：筛选高播放量的零基础 Python 教程，选定一套完整跟完，不要频繁换课；
- YouTube：Corey Schafer 的 Python 系列（英文，讲解质量极高）。

### 必备网站

- Python 官方中文文档；
- Real Python；
- LeetCode 中文版。

### 工具清单

- 编辑器：VS Code（日常脚本）/ PyCharm 社区版（大型项目）/ Jupyter Notebook（数据分析）；
- 版本管理：Git + GitHub；
- 包管理：pip、pipx；
- 代码格式化：Black。

### 新手必做的一条配置

国内环境建议先配置 pip 清华镜像源，下载速度可以从几十 KB/s 提升到几十 MB/s：

```bash
pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple
```

## 附录：日常编码检查清单

提交代码前，可以检查：

- 变量和函数命名是否清晰；
- 函数是否过长；
- 是否存在重复代码；
- 是否处理异常输入；
- 是否关闭文件、连接等资源；
- 是否写入了密码或密钥；
- 核心逻辑是否有测试；
- 日志是否包含必要上下文；
- README 是否说明运行方式；
- 新环境能否按说明成功启动。