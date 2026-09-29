# [Pandas 从入门到精通：一篇文章掌握数据清洗、分析与工程实践](https://mp.weixin.qq.com/s/lIydn-q5WcEAg8V5khvcmQ)

> Excel 能处理一张表，SQL 能查询数据库，而 Pandas 把二者常用的数据处理能力带进了 Python。它不仅适合数据分析师，也适合开发者、算法工程师、科研人员和需要批量处理表格数据的普通用户。在真实项目中，我们拿到的数据通常并不"干净"：日期格式不统一、数字列混入了文本、一张表拆成多个文件、同一用户出现多次、缺失值重复值和异常值并存、数据量大到 Excel 难以流畅打开、分析结果需要每天自动更新。Pandas 的价值，就在于把这些重复、繁琐且容易出错的工作，变成可复用、可测试、可自动执行的代码。本文将从零开始，逐步讲清 Pandas 的核心概念与高频操作，并通过一个完整案例，把数据读取、清洗、分析、汇总和导出串成一条完整流水线。

---

## Pandas 是什么？

Pandas 是 Python 生态中最常用的结构化数据处理库之一，核心目标是高效处理带有行列标签的表格数据。

它尤其适合以下任务：

1. 读取 CSV、Excel、JSON、Parquet、SQL 等数据；
2. 清洗缺失值、重复值和异常数据；
3. 筛选、排序、转换和计算字段；
4. 分组统计、透视分析和交叉汇总；
5. 合并多张数据表；
6. 处理时间序列；
7. 将结果导出到文件或数据库；
8. 构建自动化数据处理流程。

Pandas 最重要的两个对象是：

- **Series**：一维带标签数据；
- **DataFrame**：二维表格数据。

你可以把 DataFrame 理解成一张"可编程的 Excel 工作表"，但它同时拥有 Python、NumPy、SQL 风格的数据处理能力。

截至本文编写时，Pandas 稳定文档版本为 3.0.4。Pandas 3.0 中尤其需要注意两个变化：

- 字符串列默认推断为新的 `str` 类型，而不再默认使用 `object`；
- Copy-on-Write 成为默认且唯一模式，链式赋值不再是可靠写法。

后文会专门讲解这两个变化。

---

## 安装与开发环境

### 1. 使用 pip 安装

```bash
python -m pip install pandas
```

如果需要读取 Excel：

```bash
python -m pip install "pandas[excel]"
```

常用的数据分析组合：

```bash
python -m pip install pandas numpy matplotlib pyarrow openpyxl jupyter
```

各包作用如下：

| 包 | 作用 |
| --- | --- |
| pandas | 表格数据处理 |
| numpy | 数值计算 |
| matplotlib | 基础绘图 |
| pyarrow | Parquet、Arrow 数据类型与高效字符串存储 |
| openpyxl | 读取和写入 .xlsx 文件 |
| jupyter | 交互式分析环境 |

### 2. 使用 Conda 安装

```bash
conda create -n pandas-env python pandas
conda activate pandas-env
```

也可以从 conda-forge 安装：

```bash
conda install -c conda-forge pandas
```

### 3. 检查版本

```python
import pandas as pd

print(pd.__version__)
```

### 4. 推荐使用虚拟环境

不同项目可能依赖不同版本的 Pandas、NumPy 和 PyArrow。为避免依赖冲突，建议每个项目使用独立虚拟环境。

使用标准库 venv：

```bash
python -m venv .venv
```

macOS 或 Linux：

```bash
source .venv/bin/activate
```

Windows PowerShell：

```powershell
.venv\Scripts\Activate.ps1
```

---

## 建立正确的 Pandas 心智模型

学习 Pandas 时，最重要的不是记忆几十个 API，而是理解三个基础概念：

> **DataFrame = 数据 + 索引 + 数据类型**

### 1. 数据

数据就是表格中的实际值，例如姓名、价格、日期和订单数量。

### 2. 索引

Pandas 的每一行和每一列都有标签。

- 行标签叫 `index`；
- 列标签保存在 `columns` 中。

索引不是简单的行号，它会参与数据选择、对齐、连接和计算。

### 3. 数据类型

每一列都有自己的 dtype，例如：

- `int64`：整数；
- `float64`：浮点数；
- `bool`：布尔值；
- `str`：字符串；
- `datetime64[ns]`：日期时间；
- `category`：分类数据；
- `Int64`：允许缺失值的可空整数；
- `boolean`：允许缺失值的可空布尔类型。

很多 Pandas 问题，本质上都与索引或数据类型有关。例如，字符串 `"100"` 看起来像数字，但不能直接完成正确的数值计算；日期 `"2026-07-21"` 如果仍是字符串，也无法方便地按月份或星期统计。

---

## Series：一维带标签数据

### 1. 创建 Series

```python
import pandas as pd

scores = pd.Series(
    [95, 88, 76],
    index=["Alice", "Bob", "Carol"],
    name="score",
)

print(scores)
# Alice    95
# Bob      88
# Carol    76
# Name: score, dtype: int64
```

### 2. 访问元素

```python
print(scores["Alice"])
print(scores.iloc[0])
```

这里有两个重要概念：

- `.loc[]` 或标签访问：按照标签选择；
- `.iloc[]`：按照整数位置选择。

推荐显式书写：

```python
scores.loc["Alice"]
scores.iloc[0]
```

### 3. 向量化计算

```python
adjusted = scores + 5
passed = scores >= 80

print(adjusted)
print(passed)
```

Pandas 会一次性对整列数据进行运算。与 Python 循环相比，这种写法通常更简洁，也更高效。

### 4. 常用统计

```python
print(scores.mean())
print(scores.max())
print(scores.min())
print(scores.median())
print(scores.describe())
```

---

## DataFrame：二维表格的核心

### 1. 使用字典创建 DataFrame

```python
data = {
    "name": ["Alice", "Bob", "Carol"],
    "age": [25, 30, 28],
    "city": ["杭州", "上海", "绍兴"],
    "score": [95, 88, 91],
}

df = pd.DataFrame(data)
print(df)
```

### 2. 使用记录列表创建

```python
records = [
    {"name": "Alice", "age": 25, "city": "杭州"},
    {"name": "Bob", "age": 30, "city": "上海"},
    {"name": "Carol", "age": 28, "city": "绍兴"},
]

df = pd.DataFrame(records)
```

### 3. 查看基本属性

```python
print(df.shape)       # 行数和列数
print(df.columns)     # 列名
print(df.index)       # 行索引
print(df.dtypes)      # 每列数据类型
print(df.size)        # 元素总数
print(df.ndim)        # 维度
```

### 4. 快速预览

```python
df.head()       # 前 5 行
df.head(10)     # 前 10 行
df.tail()       # 后 5 行
df.sample(3)    # 随机抽取 3 行
```

### 5. 数据概览

```python
df.info()
df.describe()
df.describe(include="all")
```

在拿到陌生数据后，建议首先执行：

```python
print(df.shape)
print(df.head())
print(df.info())
print(df.isna().sum())
```

这四步可以快速判断数据规模、字段含义、类型和缺失情况。

---

## 读取与写入数据

Pandas 的大量工作都从 `read_*` 开始，以 `to_*` 结束。

### 1. CSV

读取：

```python
df = pd.read_csv("orders.csv")
```

常用参数：

```python
df = pd.read_csv(
    "orders.csv",
    usecols=["order_id", "user_id", "amount", "order_date"],
    dtype={
        "order_id": "str",
        "user_id": "str",
    },
    parse_dates=["order_date"],
    na_values=["", "NULL", "N/A", "-"],
)
```

导出：

```python
df.to_csv(
    "clean_orders.csv",
    index=False,
    encoding="utf-8-sig",
)
```

在 Windows 或需要用 Excel 打开中文 CSV 时，`utf-8-sig` 通常能减少乱码问题。

### 2. Excel

读取单个工作表：

```python
df = pd.read_excel(
    "sales.xlsx",
    sheet_name="订单",
)
```

读取所有工作表：

```python
sheets = pd.read_excel(
    "sales.xlsx",
    sheet_name=None,
)

orders = sheets["订单"]
users = sheets["用户"]
```

写入多个工作表：

```python
with pd.ExcelWriter("report.xlsx", engine="openpyxl") as writer:
    orders.to_excel(writer, sheet_name="订单明细", index=False)
    users.to_excel(writer, sheet_name="用户汇总", index=False)
```

### 3. JSON

```python
df = pd.read_json("data.json")
df.to_json(
    "output.json",
    orient="records",
    force_ascii=False,
    indent=2,
)
```

嵌套 JSON 可以使用：

```python
raw = [
    {
        "user": {"id": 1, "name": "Alice"},
        "order": {"amount": 199.0},
    }
]

df = pd.json_normalize(raw)
```

结果会得到类似：

```
user.id  user.name  order.amount
1        Alice      199.0
```

### 4. Parquet

```python
df = pd.read_parquet("orders.parquet")
df.to_parquet("orders_clean.parquet", index=False)
```

与 CSV 相比，Parquet 通常具有以下优势：

- 保留数据类型；
- 支持列式存储；
- 文件通常更小；
- 读取指定列更高效；
- 更适合分析型数据流程。

### 5. SQL

```python
from sqlalchemy import create_engine

engine = create_engine("sqlite:///shop.db")

df = pd.read_sql(
    "SELECT * FROM orders WHERE amount > 100",
    con=engine,
)

df.to_sql(
    "orders_clean",
    con=engine,
    if_exists="replace",
    index=False,
)
```

生产环境中不要直接拼接用户输入生成 SQL，应使用参数化查询。

---

## 选择行与列：[]、loc 和 iloc

这是 Pandas 最核心、也最容易混淆的部分。

### 1. 选择一列

```python
name_series = df["name"]
```

返回的是 Series。

### 2. 选择多列

```python
subset = df[["name", "city"]]
```

返回的是 DataFrame。

### 3. 使用 loc 按标签选择

```python
df.loc[0]
df.loc[0:2]
df.loc[0:2, ["name", "score"]]
```

注意：

> **loc 的标签切片通常包含结束标签。**

### 4. 使用 iloc 按位置选择

```python
df.iloc[0]
df.iloc[0:3]
df.iloc[0:3, 0:2]
```

注意：

> **iloc 遵循 Python 切片习惯，不包含结束位置。**

### 5. 条件筛选

```python
high_score = df[df["score"] >= 90]
```

多个条件要使用：

- `&`：并且；
- `|`：或者；
- `~`：取反。

并且每个条件都要加括号：

```python
result = df[
    (df["score"] >= 90)
    & (df["city"].isin(["杭州", "绍兴"]))
]
```

错误示范：

```python
# 不推荐
df[df["score"] >= 90 and df["age"] < 30]
```

### 6. between、isin 和字符串条件

```python
df[df["age"].between(25, 30)]
df[df["city"].isin(["杭州", "上海"])]
df[df["name"].str.startswith("A", na=False)]
```

### 7. 使用 query

```python
min_score = 90

result = df.query(
    "score >= @min_score and city in ['杭州', '绍兴']"
)
```

`query()` 在表达式复杂时可读性较好，但动态拼接外部字符串时仍应注意安全与可维护性。

---

## 新增、修改、删除和排序

### 1. 新增列

```python
df["passed"] = df["score"] >= 60
df["score_rate"] = df["score"] / 100
```

### 2. 基于多列计算

```python
orders["amount"] = (
    orders["quantity"]
    * orders["unit_price"]
    * (1 - orders["discount"])
)
```

### 3. 使用 assign

```python
df = df.assign(
    passed=df["score"] >= 60,
    level=lambda x: pd.cut(
        x["score"],
        bins=[0, 60, 80, 90, 100],
        labels=["不及格", "及格", "良好", "优秀"],
        include_lowest=True,
    ),
)
```

`assign()` 适合方法链写法，并且可以让中间转换过程更加清楚。

### 4. 条件赋值

推荐使用 `.loc` 一次完成选择和赋值：

```python
df.loc[df["score"] >= 90, "level"] = "优秀"
df.loc[df["score"] < 60, "level"] = "不及格"
```

### 5. 修改列名

```python
df = df.rename(
    columns={
        "name": "student_name",
        "score": "exam_score",
    }
)
```

统一列名格式：

```python
df.columns = (
    df.columns
    .str.strip()
    .str.lower()
    .str.replace(" ", "_")
)
```

### 6. 删除列或行

```python
df = df.drop(columns=["unused_column"])
df = df.drop(index=[0, 2])
```

### 7. 排序

```python
df = df.sort_values(
    by=["city", "score"],
    ascending=[True, False],
)

df = df.sort_index()
```

### 8. 重置索引

```python
df = df.reset_index(drop=True)
```

---

## 数据清洗：真实项目的主战场

数据分析中，大量时间都花在数据清洗上。

一套常见流程是：

> **统一列名 → 检查类型 → 处理缺失值 → 删除重复值 → 修正异常值 → 验证结果**

### 1. 检查缺失值

```python
df.isna()
df.isna().sum()
df.isna().mean()
```

查看缺失率：

```python
missing_report = (
    df.isna()
    .mean()
    .mul(100)
    .sort_values(ascending=False)
    .rename("missing_percent")
)
```

### 2. 删除缺失值

```python
df.dropna()
df.dropna(subset=["order_id", "user_id"])
df.dropna(axis="columns", how="all")
```

不要看到缺失值就全部删除。删除前要判断：

- 缺失是否随机；
- 缺失行是否仍有分析价值；
- 删除后是否引入偏差；
- 能否使用业务规则补全。

### 3. 填充缺失值

```python
df["city"] = df["city"].fillna("未知")
df["score"] = df["score"].fillna(df["score"].median())
```

分组填充：

```python
df["salary"] = df["salary"].fillna(
    df.groupby("department")["salary"].transform("median")
)
```

时间序列前向填充：

```python
df["price"] = df["price"].ffill()
```

后向填充：

```python
df["price"] = df["price"].bfill()
```

### 4. 检查重复值

```python
df.duplicated()
df.duplicated().sum()
```

按照业务主键判断：

```python
duplicates = df[
    df.duplicated(
        subset=["order_id"],
        keep=False,
    )
]
```

删除重复：

```python
df = df.drop_duplicates(
    subset=["order_id"],
    keep="last",
)
```

关键问题不是"这一整行是否相同"，而是：

> **在业务上，哪些字段共同决定一条记录是否唯一？**

### 5. 处理异常空格和大小写

```python
df["city"] = df["city"].str.strip()
df["email"] = df["email"].str.strip().str.lower()
```

统一同义值：

```python
city_map = {
    "Hangzhou": "杭州",
    "杭州市": "杭州",
    "Shanghai": "上海",
    "上海市": "上海",
}

df["city"] = df["city"].replace(city_map)
```

### 6. 处理异常值

使用业务范围过滤：

```python
df = df[df["age"].between(0, 120)]
df = df[df["amount"] >= 0]
```

使用四分位距识别异常值：

```python
q1 = df["amount"].quantile(0.25)
q3 = df["amount"].quantile(0.75)
iqr = q3 - q1

lower = q1 - 1.5 * iqr
upper = q3 + 1.5 * iqr

outliers = df[
    ~df["amount"].between(lower, upper)
]
```

统计异常不等于业务异常。高额订单可能是正常大客户，因此应结合业务背景判断。

---

## 数据类型：很多隐蔽错误的根源

### 1. 查看类型

```python
df.dtypes
df.info()
```

### 2. 使用 astype

```python
df["user_id"] = df["user_id"].astype("str")
df["category"] = df["category"].astype("category")
```

### 3. 安全转换数字

```python
df["amount"] = pd.to_numeric(
    df["amount"],
    errors="coerce",
)
```

无法转换的值会变成缺失值，之后可以统一检查：

```python
invalid_amount = df[df["amount"].isna()]
```

### 4. 转换日期

```python
df["order_date"] = pd.to_datetime(
    df["order_date"],
    errors="coerce",
)
```

指定格式通常更明确：

```python
df["order_date"] = pd.to_datetime(
    df["order_date"],
    format="%Y-%m-%d",
    errors="coerce",
)
```

### 5. 使用可空整数和布尔类型

普通 NumPy 整数列不能直接保存缺失值。Pandas 提供了可空类型：

```python
df["quantity"] = df["quantity"].astype("Int64")
df["is_member"] = df["is_member"].astype("boolean")
```

注意大小写：

- `int64`：NumPy 整数类型；
- `Int64`：Pandas 可空整数类型。

### 6. 自动转换为合适的可空类型

```python
df = df.convert_dtypes()
```

### 7. 分类类型

当一列只有少量重复类别时，可以使用 `category`：

```python
df["region"] = df["region"].astype("category")
```

适合：

- 省份；
- 部门；
- 商品类别；
- 订单状态；
- 用户等级。

它可能减少内存占用，并让类别语义更加明确。

### 8. Pandas 3.0 的字符串类型

在 Pandas 3.0 中，字符串数据默认推断为 `str`，而不是传统的 `object`。

```python
s = pd.Series(["Python", "Pandas", None])
print(s.dtype)
# str
```

新的字符串类型只允许存储字符串或缺失值。不要再依赖下面这种混合类型写法：

```python
# 不推荐：同一列混合字符串和整数
s.iloc[0] = 100
```

需要混合任意 Python 对象时，应明确判断这是否真的是合理的数据设计。

---

## 字符串处理

Pandas 通过 `.str` 访问器对整列字符串进行向量化处理。

```python
df["name"] = df["name"].str.strip()
df["name_upper"] = df["name"].str.upper()
df["name_length"] = df["name"].str.len()
```

### 1. 包含判断

```python
df[df["email"].str.contains("@example.com", na=False)]
```

正则表达式：

```python
df["is_mobile"] = df["phone"].str.fullmatch(
    r"1[3-9]\d{9}",
    na=False,
)
```

### 2. 分割字符串

```python
parts = df["full_name"].str.split(
    " ",
    n=1,
    expand=True,
)

df["first_name"] = parts[0]
df["last_name"] = parts[1]
```

### 3. 提取信息

```python
df["year"] = df["text"].str.extract(
    r"(\d{4})",
    expand=False,
)
```

### 4. 替换文本

```python
df["product_name"] = df["product_name"].str.replace(
    r"\s+",
    " ",
    regex=True,
)
```

### 5. 字符串拼接

```python
df["label"] = (
    df["city"].fillna("未知")
    + "-"
    + df["category"].fillna("其他")
)
```

---

## 日期与时间序列

### 1. 日期转换

```python
df["order_date"] = pd.to_datetime(
    df["order_date"],
    errors="coerce",
)
```

### 2. 提取日期特征

```python
df["year"] = df["order_date"].dt.year
df["month"] = df["order_date"].dt.month
df["day"] = df["order_date"].dt.day
df["weekday"] = df["order_date"].dt.day_name()
df["quarter"] = df["order_date"].dt.quarter
df["is_month_end"] = df["order_date"].dt.is_month_end
```

按月生成周期：

```python
df["order_month"] = df["order_date"].dt.to_period("M")
```

### 3. 日期计算

```python
today = pd.Timestamp.today().normalize()

df["days_since_order"] = (
    today - df["order_date"]
).dt.days
```

### 4. 设置时间索引

```python
ts = (
    df.set_index("order_date")
    .sort_index()
)
```

### 5. 重采样

按天：

```python
daily_sales = ts["amount"].resample("D").sum()
```

按月：

```python
monthly_sales = ts["amount"].resample("ME").sum()
```

### 6. 滚动窗口

```python
daily_sales_7d = daily_sales.rolling(
    window=7,
    min_periods=1,
).mean()
```

### 7. 时区

```python
timestamps = pd.to_datetime(
    df["created_at"],
    utc=True,
)

df["created_at_shanghai"] = timestamps.dt.tz_convert(
    "Asia/Shanghai"
)
```

涉及跨地区业务时，建议数据库中统一保存 UTC，展示时再转换到本地时区。

---

## 分组统计：groupby

groupby 对应经典的：

> **Split → Apply → Combine（拆分 → 计算 → 合并）**

### 1. 单字段分组

```python
city_sales = (
    df.groupby("city")["amount"]
    .sum()
)
```

### 2. 多字段分组

```python
summary = (
    df.groupby(["city", "category"])["amount"]
    .sum()
)
```

### 3. 多指标聚合

```python
summary = (
    df.groupby("city")
    .agg(
        order_count=("order_id", "nunique"),
        user_count=("user_id", "nunique"),
        total_sales=("amount", "sum"),
        avg_order_value=("amount", "mean"),
        max_order_value=("amount", "max"),
    )
    .reset_index()
)
```

推荐使用"命名聚合"，因为输出列名清晰，不需要后续再整理多层列索引。

### 4. agg 与 transform 的区别

agg 会压缩行数：

```python
city_mean = (
    df.groupby("city")["amount"]
    .mean()
)
```

transform 返回与原数据等长的结果：

```python
df["city_avg_amount"] = (
    df.groupby("city")["amount"]
    .transform("mean")
)

df["amount_vs_city_avg"] = (
    df["amount"] / df["city_avg_amount"]
)
```

### 5. 过滤分组

```python
active_users = df.groupby("user_id").filter(
    lambda group: len(group) >= 3
)
```

不过在大数据集上，应尽量用聚合后再筛选的方式替代复杂 Python lambda。

---

## 透视表与交叉表

### 1. pivot_table

```python
report = pd.pivot_table(
    df,
    index="city",
    columns="category",
    values="amount",
    aggfunc="sum",
    fill_value=0,
    margins=True,
)
```

它类似 Excel 数据透视表。

### 2. crosstab

统计频数：

```python
table = pd.crosstab(
    df["city"],
    df["order_status"],
)
```

按行计算比例：

```python
ratio = pd.crosstab(
    df["city"],
    df["order_status"],
    normalize="index",
)
```

---

## 多表合并：merge、join 与 concat

真实项目中，数据通常分散在多张表里。例如：

- `orders`：订单表；
- `users`：用户表；
- `products`：商品表。

### 1. merge

```python
result = orders.merge(
    users,
    on="user_id",
    how="left",
)
```

常见连接方式：

| how | 含义 |
| --- | --- |
| inner | 只保留两边都匹配的记录 |
| left | 保留左表全部记录 |
| right | 保留右表全部记录 |
| outer | 保留两边全部记录 |

### 2. 不同字段名连接

```python
result = orders.merge(
    users,
    left_on="buyer_id",
    right_on="user_id",
    how="left",
)
```

### 3. 防止多对多连接导致数据爆炸

```python
result = orders.merge(
    users,
    on="user_id",
    how="left",
    validate="many_to_one",
)
```

常用验证方式：

- `one_to_one`；
- `one_to_many`；
- `many_to_one`；
- `many_to_many`。

还可以检查匹配情况：

```python
checked = orders.merge(
    users,
    on="user_id",
    how="left",
    indicator=True,
)

print(checked["_merge"].value_counts())
```

### 4. concat

纵向追加：

```python
all_orders = pd.concat(
    [orders_jan, orders_feb, orders_mar],
    ignore_index=True,
)
```

横向拼接：

```python
result = pd.concat(
    [features_a, features_b],
    axis=1,
)
```

### 5. 批量读取多个文件

```python
from pathlib import Path

files = Path("data").glob("orders_*.csv")

orders = pd.concat(
    [pd.read_csv(file) for file in files],
    ignore_index=True,
)
```

生产项目中，建议同时保存来源文件名：

```python
frames = []

for file in Path("data").glob("orders_*.csv"):
    part = pd.read_csv(file)
    part["source_file"] = file.name
    frames.append(part)

orders = pd.concat(frames, ignore_index=True)
```

---

## 数据重塑：宽表与长表

### 1. melt：宽表转长表

原始宽表：

| name | math | physics | chemistry |
| --- | --- | --- | --- |
| Alice | 95 | 92 | 90 |
| Bob | 88 | 85 | 91 |

转换：

```python
long_df = df.melt(
    id_vars="name",
    value_vars=["math", "physics", "chemistry"],
    var_name="subject",
    value_name="score",
)
```

结果：

| name | subject | score |
| --- | --- | --- |
| Alice | math | 95 |
| Alice | physics | 92 |
| Alice | chemistry | 90 |
| Bob | math | 88 |

长表通常更适合分组统计和可视化。

### 2. pivot：长表转宽表

```python
wide_df = long_df.pivot(
    index="name",
    columns="subject",
    values="score",
)
```

如果同一组合存在多条记录，应使用 `pivot_table` 并指定聚合函数。

### 3. stack 与 unstack

```python
stacked = wide_df.stack()
restored = stacked.unstack()
```

### 4. explode

当单元格中保存列表时：

```python
df = pd.DataFrame({
    "user": ["Alice", "Bob"],
    "tags": [
        ["Python", "Pandas"],
        ["SQL"],
    ],
})

exploded = df.explode("tags")
```

---

## 索引与自动对齐

Pandas 的一个重要特性是：

> **运算时优先按照索引标签对齐，而不是只按位置计算。**

```python
s1 = pd.Series(
    [10, 20],
    index=["A", "B"],
)

s2 = pd.Series(
    [1, 2],
    index=["B", "C"],
)

print(s1 + s2)
```

结果只有标签 B 能匹配，其余位置会产生缺失值。

需要指定缺失补充值时：

```python
result = s1.add(s2, fill_value=0)
```

DataFrame 同样会按照行索引和列名对齐。因此，在执行赋值、拼接和计算前，应确认：

```python
print(df.index)
print(df.columns)
```

不要把 Pandas 完全当成"只有位置、没有标签"的二维数组。

---

## 方法链：让数据流程更清晰

零散地不断修改变量，容易让分析过程变得难以追踪。方法链可以把数据处理步骤从上到下表达出来：

```python
result = (
    pd.read_csv("orders.csv")
    .rename(columns=str.lower)
    .drop_duplicates(subset=["order_id"])
    .assign(
        order_date=lambda x: pd.to_datetime(
            x["order_date"],
            errors="coerce",
        ),
        amount=lambda x: (
            x["quantity"]
            * x["unit_price"]
            * (1 - x["discount"].fillna(0))
        ),
    )
    .dropna(subset=["order_id", "order_date"])
    .query("amount > 0")
    .groupby("region", as_index=False)
    .agg(
        order_count=("order_id", "nunique"),
        total_sales=("amount", "sum"),
    )
    .sort_values("total_sales", ascending=False)
)
```

优点：

- 转换顺序清楚；
- 减少临时变量；
- 更容易拆分和测试；
- 便于加入日志与数据验证。

当链式表达式太长时，可以使用 `.pipe()`：

```python
def clean_columns(frame: pd.DataFrame) -> pd.DataFrame:
    frame = frame.copy()
    frame.columns = (
        frame.columns
        .str.strip()
        .str.lower()
        .str.replace(" ", "_")
    )
    return frame


def remove_invalid_amount(
    frame: pd.DataFrame,
) -> pd.DataFrame:
    return frame.loc[frame["amount"] > 0]


result = (
    pd.read_csv("orders.csv")
    .pipe(clean_columns)
    .pipe(remove_invalid_amount)
)
```

---

## Pandas 3.0 与 Copy-on-Write

### 1. 什么是 Copy-on-Write？

Copy-on-Write，简称 CoW，可以理解为：

> **派生对象在用户看来像独立副本，但底层可以暂时共享数据；只有真正修改时，才在必要位置复制。**

这使副本与视图的行为更一致，也可以避免不必要的复制。

### 2. 链式赋值不再工作

错误示范：

```python
df[df["score"] >= 90]["level"] = "优秀"
```

这段代码经过了两次索引操作。Pandas 3.0 中，链式赋值不会按预期修改原始 DataFrame。

正确写法：

```python
df.loc[
    df["score"] >= 90,
    "level",
] = "优秀"
```

再例如：

```python
# 不推荐
df["score"][0] = 100
```

正确写法：

```python
df.loc[0, "score"] = 100
```

### 3. 修改子集不会自动修改原表

```python
subset = df["score"]
subset.iloc[0] = 100
```

在 Copy-on-Write 语义下，修改 `subset` 不会修改原始 `df`。

如果目标就是修改原表，应直接写：

```python
df.loc[df.index[0], "score"] = 100
```

### 4. 减少不必要的中间引用

```python
# 可能让旧对象继续持有共享数据
df2 = df.reset_index(drop=True)
df2.iloc[0, 0] = 100
```

如果旧的 `df` 后续不再使用，可以直接重新赋值：

```python
df = df.reset_index(drop=True)
df.iloc[0, 0] = 100
```

---

## 性能优化：从正确写法到高效写法

性能优化应遵循以下顺序：

> **先保证结果正确 → 再定位瓶颈 → 优先优化算法和数据结构 → 最后考虑底层加速**

### 1. 优先使用向量化

不推荐：

```python
result = []

for value in df["amount"]:
    result.append(value * 1.05)

df["amount_with_tax"] = result
```

推荐：

```python
df["amount_with_tax"] = df["amount"] * 1.05
```

### 2. 少用 iterrows

不推荐：

```python
for index, row in df.iterrows():
    df.loc[index, "amount"] = (
        row["quantity"] * row["unit_price"]
    )
```

推荐：

```python
df["amount"] = (
    df["quantity"] * df["unit_price"]
)
```

如果确实需要逐行遍历，`itertuples()` 通常比 `iterrows()` 更合适：

```python
for row in df.itertuples(index=False):
    print(row.order_id, row.amount)
```

### 3. 不要把 apply(axis=1) 当成万能工具

```python
# 通常较慢
df["amount"] = df.apply(
    lambda row: row["quantity"] * row["unit_price"],
    axis=1,
)
```

应优先写成：

```python
df["amount"] = (
    df["quantity"] * df["unit_price"]
)
```

`apply` 更适合没有直接向量化表达方式、且数据规模可接受的场景。

### 4. 读取时只加载需要的列

```python
df = pd.read_csv(
    "large.csv",
    usecols=[
        "order_id",
        "user_id",
        "amount",
        "order_date",
    ],
)
```

### 5. 读取时指定类型

```python
df = pd.read_csv(
    "large.csv",
    dtype={
        "order_id": "str",
        "user_id": "str",
        "region": "category",
    },
)
```

这样可以减少类型推断成本，并降低类型错误风险。

### 6. 分块读取大文件

```python
chunks = pd.read_csv(
    "large_orders.csv",
    chunksize=100_000,
)

summaries = []

for chunk in chunks:
    chunk["amount"] = pd.to_numeric(
        chunk["amount"],
        errors="coerce",
    )

    summary = (
        chunk.groupby("region", as_index=False)
        .agg(total_sales=("amount", "sum"))
    )

    summaries.append(summary)

result = (
    pd.concat(summaries, ignore_index=True)
    .groupby("region", as_index=False)
    .agg(total_sales=("total_sales", "sum"))
)
```

### 7. 使用合适的文件格式

对于重复分析的数据：

- 原始交换文件可以使用 CSV；
- 中间分析结果优先考虑 Parquet；
- 需要人工查看时再导出 Excel。

### 8. 检查内存占用

```python
df.info(memory_usage="deep")
```

逐列统计：

```python
memory = (
    df.memory_usage(deep=True)
    .sort_values(ascending=False)
)

print(memory)
```

### 9. 分类列使用 category

```python
df["region"] = df["region"].astype("category")
```

对于低基数重复字符串，这通常能明显节省内存。

### 10. 使用 query 和 eval

```python
filtered = df.query(
    "quantity > 2 and unit_price >= 100"
)

df.eval(
    "amount = quantity * unit_price",
    inplace=True,
)
```

对于较大数据和复杂表达式，Pandas 可以借助 numexpr 加速部分运算。但是否更快取决于数据规模和表达式，不能把它当作所有场景的固定优化。

### 11. 更进一步的优化

如果向量化后仍然存在明确的计算瓶颈，可以考虑：

- NumPy；
- Numba；
- Cython；
- PyArrow；
- 数据库下推计算；
- DuckDB；
- Polars；
- Dask；
- Spark。

Pandas 不是分布式计算框架。当数据量明显超过单机内存时，继续堆叠 Pandas 技巧未必是最佳方案。

---

## 常见陷阱与调试方法

**陷阱 1：链式赋值**

错误：

```python
df[df["age"] > 18]["adult"] = True
```

正确：

```python
df.loc[df["age"] > 18, "adult"] = True
```

**陷阱 2：用 `==` 判断缺失值**

错误：

```python
df[df["city"] == None]
df[df["amount"] == float("nan")]
```

正确：

```python
df[df["city"].isna()]
df[df["amount"].notna()]
```

**陷阱 3：数字列实际上是字符串**

```python
print(df["amount"].dtype)
print(df["amount"].head())
```

转换：

```python
df["amount"] = pd.to_numeric(
    df["amount"],
    errors="coerce",
)
```

**陷阱 4：日期列仍然是字符串**

```python
df["date"] = pd.to_datetime(
    df["date"],
    errors="coerce",
)
```

**陷阱 5：loc 与 iloc 混淆**

```python
df.loc[0:2]   # 标签切片，通常包含 2
df.iloc[0:2]  # 位置切片，不包含位置 2
```

**陷阱 6：合并后行数异常增加**

```python
print(orders["user_id"].duplicated().sum())
print(users["user_id"].duplicated().sum())
```

连接时加入验证：

```python
result = orders.merge(
    users,
    on="user_id",
    how="left",
    validate="many_to_one",
)
```

**陷阱 7：索引自动对齐导致结果错位**

赋值前检查索引：

```python
print(left.index.equals(right.index))
```

只想按位置赋值时，应确保语义明确：

```python
df["new_column"] = other_series.to_numpy()
```

但这样会主动放弃标签对齐保护，使用前必须确认长度和顺序完全一致。

**陷阱 8：静默修改原始数据**

在编写清洗函数时，可以明确复制输入：

```python
def clean_orders(
    orders: pd.DataFrame,
) -> pd.DataFrame:
    result = orders.copy()
    result.columns = result.columns.str.lower()
    return result
```

Pandas 3.0 的 CoW 让行为更可预测，但函数是否允许修改输入，仍应通过代码设计明确表达。

---

## 完整实战：电商订单数据分析

下面通过一个小型项目，把前面的知识串起来。

### 1. 构造原始数据

```python
import pandas as pd

orders = pd.DataFrame({
    "order_id": [
        "A001", "A002", "A003", "A003",
        "A004", "A005", "A006", "A007",
    ],
    "user_id": [
        "U01", "U02", "U01", "U01",
        "U03", "U04", "U02", "U05",
    ],
    "region": [
        "杭州", "上海", "杭州 ", "杭州 ",
        "绍兴", None, "上海", "杭州",
    ],
    "category": [
        "数码", "图书", "数码", "数码",
        "家居", "图书", "家居", "数码",
    ],
    "quantity": [1, 2, 1, 1, 3, 1, 2, 1],
    "unit_price": [
        "5999", "59", "799", "799",
        "129", "invalid", "299", "3999",
    ],
    "discount": [
        0.05, 0, 0.10, 0.10,
        None, 0, 0.05, 0.20,
    ],
    "order_date": [
        "2026-01-03", "2026-01-05", "2026-02-10", "2026-02-10",
        "2026-02-18", "错误日期", "2026-03-02", "2026-03-11",
    ],
    "status": [
        "paid", "paid", "paid", "paid",
        "refunded", "paid", "paid", "paid",
    ],
})
```

这份数据故意包含了多个常见问题：

- A003 重复；
- "杭州 " 末尾有空格；
- 地区有缺失值；
- 单价列混入 `"invalid"`；
- 折扣有缺失值；
- 日期包含错误值；
- 存在退款订单。

### 2. 编写清洗函数

```python
def clean_orders(
    frame: pd.DataFrame,
) -> pd.DataFrame:
    result = frame.copy()

    result.columns = (
        result.columns
        .str.strip()
        .str.lower()
    )

    result["region"] = (
        result["region"]
        .str.strip()
        .fillna("未知")
    )

    result["unit_price"] = pd.to_numeric(
        result["unit_price"],
        errors="coerce",
    )

    result["discount"] = (
        pd.to_numeric(
            result["discount"],
            errors="coerce",
        )
        .fillna(0)
        .clip(lower=0, upper=1)
    )

    result["quantity"] = (
        pd.to_numeric(
            result["quantity"],
            errors="coerce",
        )
        .astype("Int64")
    )

    result["order_date"] = pd.to_datetime(
        result["order_date"],
        errors="coerce",
    )

    result = result.drop_duplicates(
        subset=["order_id"],
        keep="last",
    )

    result = result.dropna(
        subset=[
            "order_id",
            "user_id",
            "quantity",
            "unit_price",
            "order_date",
        ]
    )

    result = result.loc[
        (result["quantity"] > 0)
        & (result["unit_price"] >= 0)
    ]

    result["gross_amount"] = (
        result["quantity"]
        * result["unit_price"]
    )

    result["net_amount"] = (
        result["gross_amount"]
        * (1 - result["discount"])
    )

    result["is_refunded"] = (
        result["status"] == "refunded"
    )

    result["recognized_revenue"] = (
        result["net_amount"]
        .where(~result["is_refunded"], 0)
    )

    result["order_month"] = (
        result["order_date"]
        .dt.to_period("M")
        .astype("str")
    )

    return result.reset_index(drop=True)
```

执行：

```python
cleaned = clean_orders(orders)

print(cleaned)
print(cleaned.info())
```

### 3. 数据质量检查

清洗代码执行完不代表数据一定正确。应加入显式验证：

```python
assert cleaned["order_id"].is_unique
assert cleaned["order_id"].notna().all()
assert cleaned["user_id"].notna().all()
assert cleaned["unit_price"].ge(0).all()
assert cleaned["quantity"].gt(0).all()
assert cleaned["discount"].between(0, 1).all()
assert cleaned["order_date"].notna().all()
```

也可以生成质量报告：

```python
quality_report = pd.Series({
    "row_count": len(cleaned),
    "column_count": cleaned.shape[1],
    "duplicate_order_id": (
        cleaned["order_id"]
        .duplicated()
        .sum()
    ),
    "missing_user_id": (
        cleaned["user_id"]
        .isna()
        .sum()
    ),
    "negative_price": (
        cleaned["unit_price"]
        .lt(0)
        .sum()
    ),
})

print(quality_report)
```

### 4. 计算核心指标

```python
kpis = pd.Series({
    "订单数": cleaned["order_id"].nunique(),
    "用户数": cleaned["user_id"].nunique(),
    "销售额": cleaned["recognized_revenue"].sum(),
    "平均订单金额": (
        cleaned["recognized_revenue"].mean()
    ),
    "退款订单数": cleaned["is_refunded"].sum(),
    "退款率": cleaned["is_refunded"].mean(),
})

print(kpis)
```

### 5. 地区汇总

```python
region_summary = (
    cleaned.groupby(
        "region",
        as_index=False,
    )
    .agg(
        order_count=(
            "order_id",
            "nunique",
        ),
        user_count=(
            "user_id",
            "nunique",
        ),
        revenue=(
            "recognized_revenue",
            "sum",
        ),
        avg_order_value=(
            "recognized_revenue",
            "mean",
        ),
    )
    .sort_values(
        "revenue",
        ascending=False,
    )
)

print(region_summary)
```

### 6. 月度趋势

```python
monthly_summary = (
    cleaned.groupby(
        "order_month",
        as_index=False,
    )
    .agg(
        order_count=(
            "order_id",
            "nunique",
        ),
        revenue=(
            "recognized_revenue",
            "sum",
        ),
    )
    .sort_values("order_month")
)

monthly_summary["revenue_growth"] = (
    monthly_summary["revenue"]
    .pct_change()
)

print(monthly_summary)
```

### 7. 商品类别透视表

```python
category_pivot = pd.pivot_table(
    cleaned,
    index="region",
    columns="category",
    values="recognized_revenue",
    aggfunc="sum",
    fill_value=0,
    margins=True,
)

print(category_pivot)
```

### 8. 用户价值分析

```python
user_summary = (
    cleaned.groupby(
        "user_id",
        as_index=False,
    )
    .agg(
        order_count=(
            "order_id",
            "nunique",
        ),
        total_revenue=(
            "recognized_revenue",
            "sum",
        ),
        first_order=(
            "order_date",
            "min",
        ),
        last_order=(
            "order_date",
            "max",
        ),
    )
)

user_summary["avg_order_value"] = (
    user_summary["total_revenue"]
    / user_summary["order_count"]
)

print(user_summary)
```

### 9. 导出分析结果

```python
with pd.ExcelWriter(
    "sales_report.xlsx",
    engine="openpyxl",
) as writer:
    cleaned.to_excel(
        writer,
        sheet_name="清洗后订单",
        index=False,
    )

    region_summary.to_excel(
        writer,
        sheet_name="地区汇总",
        index=False,
    )

    monthly_summary.to_excel(
        writer,
        sheet_name="月度趋势",
        index=False,
    )

    category_pivot.to_excel(
        writer,
        sheet_name="类别透视",
    )

    user_summary.to_excel(
        writer,
        sheet_name="用户价值",
        index=False,
    )
```

同时保存高效中间格式：

```python
cleaned.to_parquet(
    "cleaned_orders.parquet",
    index=False,
)
```

至此，我们已经完成了一条完整数据处理链路：

> **原始数据 → 清洗 → 类型转换 → 去重 → 指标计算 → 分组统计 → 透视分析 → 结果导出**

---

## 让 Pandas 代码走向工程化

学习阶段在 Notebook 中运行代码很方便，但长期项目需要更清晰的工程结构。

一种简单目录结构：

```
pandas-project/
├── data/
│   ├── raw/
│   └── processed/
├── reports/
├── notebooks/
├── src/
│   ├── __init__.py
│   ├── io.py
│   ├── cleaning.py
│   ├── metrics.py
│   └── pipeline.py
├── tests/
│   └── test_cleaning.py
├── requirements.txt
└── README.md
```

### 1. 把清洗逻辑封装成函数

```python
def normalize_region(
    series: pd.Series,
) -> pd.Series:
    mapping = {
        "杭州市": "杭州",
        "上海市": "上海",
        "绍兴市": "绍兴",
    }

    return (
        series
        .astype("str")
        .str.strip()
        .replace(mapping)
    )
```

### 2. 为函数添加类型标注

```python
import pandas as pd

def summarize_sales(
    orders: pd.DataFrame,
) -> pd.DataFrame:
    return (
        orders.groupby(
            "region",
            as_index=False,
        )
        .agg(
            revenue=("amount", "sum"),
        )
    )
```

### 3. 加入断言与校验

```python
def validate_orders(
    orders: pd.DataFrame,
) -> None:
    required = {
        "order_id",
        "user_id",
        "amount",
        "order_date",
    }

    missing_columns = required - set(orders.columns)

    if missing_columns:
        raise ValueError(
            f"缺少必要字段：{sorted(missing_columns)}"
        )

    if not orders["order_id"].is_unique:
        raise ValueError("order_id 必须唯一")

    if orders["amount"].lt(0).any():
        raise ValueError("amount 不能为负数")
```

### 4. 写最小单元测试

```python
import pandas as pd

def test_clean_orders_removes_duplicate_order_id():
    raw = pd.DataFrame({
        "order_id": ["A001", "A001"],
        "user_id": ["U01", "U01"],
        "quantity": [1, 1],
        "unit_price": [100, 100],
        "discount": [0, 0],
        "order_date": [
            "2026-01-01",
            "2026-01-01",
        ],
        "region": ["杭州", "杭州"],
        "category": ["图书", "图书"],
        "status": ["paid", "paid"],
    })

    result = clean_orders(raw)

    assert len(result) == 1
    assert result["order_id"].is_unique
```

### 5. 记录处理日志

```python
import logging

logging.basicConfig(
    level=logging.INFO,
    format=(
        "%(asctime)s "
        "%(levelname)s "
        "%(message)s"
    ),
)

logging.info(
    "读取原始订单：%s 行",
    len(orders),
)

cleaned = clean_orders(orders)

logging.info(
    "清洗后订单：%s 行",
    len(cleaned),
)
```

### 6. 不要依赖人工步骤

理想的数据流程应能通过一个命令重新生成全部结果：

```bash
python -m src.pipeline
```

而不是：

1. 手动打开 Excel；
2. 删除几行；
3. 修改某个单元格；
4. 复制到另一张表；
5. 再运行一半代码。

只要中间存在不可复现的人工修改，最终结果就难以审计和维护。

---

## Pandas 与 Excel、SQL、NumPy 的关系

### Pandas 与 Excel

Pandas 更适合：

- 批量处理多个文件；
- 自动重复执行；
- 数据量较大；
- 操作步骤复杂；
- 需要版本控制；
- 需要测试和复现。

Excel 更适合：

- 快速人工查看；
- 临时小规模编辑；
- 与业务人员共享；
- 交互式制作简单报表。

两者不是互相取代，而是经常配合使用：**Pandas 负责自动处理，Excel 负责人工阅读和交付。**

### Pandas 与 SQL

SQL 擅长：

- 从数据库筛选和聚合大量数据；
- 利用数据库索引；
- 多用户并发；
- 权限、事务和数据持久化。

Pandas 擅长：

- 复杂的数据清洗；
- 灵活的探索分析；
- 与 Python 算法和可视化结合；
- 处理本地文件。

最佳实践通常是：**能在数据库中高效完成的筛选和聚合，尽量在 SQL 层完成；把需要灵活转换和分析的数据再交给 Pandas。**

### Pandas 与 NumPy

NumPy 是高效数值数组计算的基础，Pandas 在其上提供了：

- 行列标签；
- 异构列类型；
- 缺失值处理；
- 分组；
- 合并；
- 时间序列；
- 表格输入输出。

当任务是纯数值矩阵计算时，NumPy 可能更直接；当数据具有字段、索引和业务含义时，Pandas 通常更方便。

---

## 高频 API 速查表

**查看数据**

```python
df.head()
df.tail()
df.sample()
df.info()
df.describe()
df.shape
df.dtypes
```

**选择数据**

```python
df["column"]
df[["a", "b"]]
df.loc[rows, columns]
df.iloc[rows, columns]
df.query("amount > 100")
```

**清洗数据**

```python
df.isna()
df.fillna()
df.dropna()
df.duplicated()
df.drop_duplicates()
df.replace()
```

**类型转换**

```python
df.astype()
pd.to_numeric()
pd.to_datetime()
df.convert_dtypes()
```

**排序与重命名**

```python
df.sort_values()
df.sort_index()
df.rename()
df.reset_index()
```

**分组统计**

```python
df.groupby()
df.agg()
df.transform()
pd.pivot_table()
pd.crosstab()
```

**合并数据**

```python
pd.concat()
df.merge()
df.join()
```

**重塑数据**

```python
df.melt()
df.pivot()
df.pivot_table()
df.stack()
df.unstack()
df.explode()
```

**时间序列**

```python
series.dt.year
series.dt.month
df.resample()
df.rolling()
df.shift()
df.pct_change()
```

**输入输出**

```python
pd.read_csv()
pd.read_excel()
pd.read_json()
pd.read_parquet()
pd.read_sql()

df.to_csv()
df.to_excel()
df.to_json()
df.to_parquet()
df.to_sql()
```

---

## 从入门到精通的学习路线

### 第一阶段：掌握基础操作

目标：

- 创建 Series 和 DataFrame；
- 读取 CSV、Excel；
- 查看数据结构；
- 使用 loc、iloc；
- 条件筛选；
- 新增和修改列；
- 处理缺失值和重复值。

练习项目：

- 清洗一份学生成绩表；
- 汇总每科平均分；
- 找出各科前十名；
- 导出成绩报告。

### 第二阶段：完成常规数据分析

目标：

- 掌握 groupby；
- 掌握 merge 和 concat；
- 使用 pivot_table；
- 处理字符串和日期；
- 编写方法链。

练习项目：

- 电商订单分析；
- 用户消费分层；
- 月度销售趋势；
- 多文件合并；
- 地区与品类透视表。

### 第三阶段：理解性能和工程化

目标：

- 使用向量化替代循环；
- 优化数据类型；
- 使用 Parquet；
- 分块读取；
- 编写清洗函数；
- 添加断言、日志和测试；
- 理解 Copy-on-Write。

练习项目：

- 构建每日自动报表；
- 处理百万行 CSV；
- 建立数据质量检查；
- 将分析脚本改造成可复用包。

### 第四阶段：形成数据系统思维

真正的"精通"不等于背完 API，而是能够回答：

1. 这张表每一行代表什么？
2. 哪些字段构成业务主键？
3. 哪些缺失值可以填充，哪些不能？
4. 一次合并为什么增加了行数？
5. 统计口径是否一致？
6. 日期和时区是否正确？
7. 数据类型是否符合业务语义？
8. 处理流程能否复现？
9. 结果能否验证？
10. Pandas 是否仍是当前数据规模下最合适的工具？

---

## 常见问题

### 1. Pandas 能处理多大的数据？

没有统一答案，取决于：

- 可用内存；
- 列数和数据类型；
- 字符串数量；
- 中间计算是否复制数据；
- 是否分块处理；
- 是否使用 Parquet 和分类类型。

经验上，不要只比较"文件大小"和"内存大小"。CSV 读取后会解析成内存对象，实际占用可能远大于磁盘文件。

### 2. 为什么读取 CSV 后编号前面的 0 消失了？

例如邮编、订单号、身份证明编号被推断成数字。

应在读取时指定字符串类型：

```python
df = pd.read_csv(
    "data.csv",
    dtype={
        "order_id": "str",
        "zip_code": "str",
    },
)
```

### 3. 为什么中文 CSV 用 Excel 打开乱码？

导出时尝试：

```python
df.to_csv(
    "output.csv",
    index=False,
    encoding="utf-8-sig",
)
```

### 4. 为什么 merge 后行数翻倍？

通常是连接键在两边都不唯一，产生多对多匹配。

检查：

```python
left["key"].value_counts().head()
right["key"].value_counts().head()
```

并使用：

```python
left.merge(
    right,
    on="key",
    validate="many_to_one",
)
```

### 5. 为什么 apply 很慢？

`apply(axis=1)` 常常逐行调用 Python 函数，无法充分利用底层向量化能力。应优先寻找：

- 列运算；
- `np.where`；
- `Series.where`；
- `Series.mask`；
- `map`；
- `replace`；
- `groupby().transform()`；
- 字符串 `.str`；
- 日期 `.dt`。

### 6. 什么时候应该离开 Pandas？

可以考虑其他方案的情况：

- 数据远超单机内存；
- 需要分布式计算；
- 需要低延迟并发服务；
- 大量计算应直接在数据库完成；
- 纯数值矩阵运算更适合 NumPy；
- 对速度和多线程利用有更高要求。

工具选择应由任务决定，而不是由熟悉程度决定。

---

## 结语

Pandas 的入门并不难，真正的难点在于面对真实数据时，能够同时处理：

- 数据类型；
- 缺失与异常；
- 业务主键；
- 表之间的关系；
- 统计口径；
- 性能；
- 可复现性；
- 数据质量。

建议记住下面这条主线：

> **读取数据 → 理解结构 → 清洗类型 → 筛选转换 → 分组合并 → 验证结果 → 导出复用**

当你不再只是"把代码跑通"，而是能解释每一列的含义、每一步转换的依据、每个指标的口径，并让整个流程可以反复执行和验证时，才真正从"会用 Pandas"走向了"精通 Pandas"。

---

## 参考资料

1. [Pandas 官方网站](https://pandas.pydata.org/)
2. [Pandas 安装文档](https://pandas.pydata.org/docs/getting_started/install.html)
3. [Pandas 入门教程](https://pandas.pydata.org/docs/getting_started/intro_tutorials/)
4. [Pandas 用户指南](https://pandas.pydata.org/docs/user_guide/)
5. [Pandas 3.0.0 发布说明](https://pandas.pydata.org/docs/whatsnew/v3.0.0.html)
6. [Copy-on-Write 指南](https://pandas.pydata.org/docs/user_guide/copy_on_write.html)
7. [Pandas 3.0 字符串类型迁移指南](https://pandas.pydata.org/docs/user_guide/migration-3-strings.html)
8. [Pandas 性能优化指南](https://pandas.pydata.org/docs/user_guide/enhancingperf.html)
