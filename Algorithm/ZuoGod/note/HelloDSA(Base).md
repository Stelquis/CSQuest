***

* [左神](https://space.bilibili.com/8888480)

* [力扣 （LeetCode） 全球极客挚爱的技术成长平台](https://leetcode.cn/)

* [牛客网 - 找工作神器|笔试题库|面试经验|实习招聘内推，求职就业一站解决\_牛客网](https://www.nowcoder.com/)

* [首页 - 洛谷 | 计算机科学教育新生态](https://www.luogu.com.cn/)

***

# ✅001【入门】学习算法的语言问题

熟练掌握一门编程语言（C、C++、Python、✨**Java**、JavaScript、Golang、Rust、Cangjie）

***

# ✅002【入门】从社会实验到入门提醒

随机社会基尼系数实验

***

# ✅003【入门】二进制和位运算

计算机的底层只有二进制，因此只能进行二进制位运算的操作。

`int`：32 位

`long`：64 位

无符号二进制整数

有符号二进制整数

* 最高位是符号位

* 首位为 `0`则为正

* 首位为 `1`则为负

计算机中数据的存储表达形式：以四位为例

* 1:0001

* -1:0001-1=0000 取反 1111

* 8:1000

* -8:1000-1=0111 取反 1000

* -7:1001

* 7:1001 取反 0110+1=0111

**进制**

二进制：`0b`作为开头

十六进制：`0x`作为开头

**位运算**

* **左移**：`＜＜`整体左移，拿 `0`补空位（非负数：$×2^n$）

* **右移**：

  * `＞＞`整体右移（非负数：$÷2^n$）

    * 正数：`0`补空位

    * 负数：`符号位`补空位

  * `＞＞＞`整体右移

    * 正数：`0`补空位

    * 负数：`0`补空位

* **取反**：`~`作为开头

  * 相反数：对于二进制就是先取反后 +1

    * `-7=~7+1`

    * 负数有符号整数的最小值的相反数是它本身（因为溢出）

    * -8:1000 取反 0111+1=1000

* **或**：`|`作为开头

  * **逻辑或**：`||`

* **与**：`&`作为开头

  * **逻辑与**：`&&`

* **异或**：`^`作为开头

> **在不考虑溢出（溢出位丢失，计算机不会检查是否溢出）的前提下，如此设计实现了正负数自由简单快速加运算。**

**eg.确定某个二进制数的第 n 位数字**：

num=0110 1100

&#x20; 7654 3210

int：第 6 位=num&（1<<6）=0 或非 0（即 1）

`第6位 = num & (1 << 6) != 0 ? 1 : 0;`

long：第 48 位=num&（1L<<48）

`第48位 = num & (1L << 48) != 0 ? 1 : 0;`

***

# ✅004【入门】选择、冒泡、插入排序

> 都假定为**升序**

**选择**：i ～ n-1 范围内，找到最小值放在 i 位置处，然后 i+1 ～ n-1 范围内重复。

```java
// 选择排序
public static void selectionSort(int[] arr) {
    if (arr == null || arr.length < 2) {
        return;
    }
    for (int minIndex, i = 0; i < arr.length - 1; i++) {
        // minIndex表示的是i~n-1范围内最小值的位置
        minIndex = i;
        for (int j = i + 1; j < arr.length; j++) {
            if (arr[j] < arr[minIndex]) {
                minIndex = j;
            }
        }
        swap(arr, i, minIndex);
    }
}
```



**冒泡**：0 ～ i 范围内，相邻位置较大的数滚下去，最大值来到 i 位置，然后 0 ～ i-1 位置上继续。



```java
// 冒泡排序
public static void bubbleSort(int[] arr) {
    if (arr == null || arr.length < 2) {
        return;
    }
    for (int end = arr.length - 1; end > 0; end--) {
        for (int i = 0; i < end; i++) {
            if (arr[i] > arr[i + 1]) {
                swap(arr, i, i + 1);
            }
        }
    }
}
```



**插入**：0 ～ i 范围内已经有序，新来的数从右往左滑到不再小的位置处插入，然后重复。



```java
// 插入排序
public static void insertionSort(int[] arr) {
    if (arr == null || arr.length < 2) {
        return;
    }
    for (int i = 1; i < arr.length; i++) {
        for (int j = i - 1; j >= 0 && arr[j] > arr[j + 1]; j--) {
            swap(arr, j, j + 1);
        }
    }
}
```



***



# ✅005【入门】对数器



1. **暴力解**



2. **最优解**



3) 随机样本产生器（长度随机、大小随机）



4) 相同输入，对比结果



5. 打印不同，对比纠错



```java
import java.util.Arrays;

public class Solution {

    public static void main(String[] args) {
        // 随机数组最大长度
        int N = 25;
        // 随机数组每个值，在[1~V]随机
        int V = 1000;
        // 测试次数
        int testTimes = 50;
        // 测试开始
        System.out.println("测试开始");
        for (int i = 0; i < testTimes; i++) {
            // 随机得到一个长度，长度在[1~N]
            int n = (int) (Math.random() * N) + 1;
            // 随机得到一个数组，长度为n，数值大小[1~V]
            int[] arr = randomArray(n, V);
            System.out.println("测试案例：" + Arrays.toString(arr));
            // 拷贝数组
            int[] arr1 = copyArray(arr);
            int[] arr2 = copyArray(arr);
            int[] arr3 = copyArray(arr);
            // 数组排序
            Arrays.sort(arr);
            selectionSort(arr1);
            bubbleSort(arr2);
            insertionSort(arr3);
            // 结果检验
            System.out.println("排序结果：" + "\n" + Arrays.toString(arr));
            System.out.println(Arrays.toString(arr1));
            if (!Arrays.equals(arr, arr1))
                System.out.println("选择排序出错！");
            System.out.println(Arrays.toString(arr2));
            if (!Arrays.equals(arr, arr2))
                System.out.println("冒泡排序出错！");
            System.out.println(Arrays.toString(arr3));
            if (!Arrays.equals(arr, arr3))
                System.out.println("插入排序出错！");
        }
    }

    // 交换
    public static void swap(int[] arr, int i, int j) {
        int temp = arr[i];
        arr[i] = arr[j];
        arr[j] = temp;
    }

    // 选择排序
    public static void selectionSort(int[] arr) {
        if (arr == null || arr.length < 2) {
            return;
        }
        for (int minIndex, i = 0; i < arr.length - 1; i++) {
            // minIndex表示的是i~n-1范围内最小值的位置
            minIndex = i;
            for (int j = i + 1; j < arr.length; j++) {
                if (arr[j] < arr[minIndex]) {
                    minIndex = j;
                }
            }
            swap(arr, i, minIndex);
        }
    }

    // 冒泡排序
    public static void bubbleSort(int[] arr) {
        if (arr == null || arr.length < 2) {
            return;
        }
        for (int end = arr.length - 1; end > 0; end--) {
            for (int i = 0; i < end; i++) {
                if (arr[i] > arr[i + 1]) {
                    swap(arr, i, i + 1);
                }
            }
        }
    }

    // 插入排序
    public static void insertionSort(int[] arr) {
        if (arr == null || arr.length < 2) {
            return;
        }
        for (int i = 1; i < arr.length; i++) {
            for (int j = i - 1; j >= 0 && arr[j] > arr[j + 1]; j--) {
                swap(arr, j, j + 1);
            }
        }
    }

    // 随机数组
    public static int[] randomArray(int n, int v) {
        int[] arr = new int[n];
        for (int i = 0; i < n; i++) {
            arr[i] = (int) (Math.random() * v) + 1;
        }
        return arr;
    }

    // 复制数组
    public static int[] copyArray(int[] arr) {
        int[] ans = new int[arr.length];
        for (int i = 0; i < arr.length; i++) {
            ans[i] = arr[i];
        }
        return ans;
    }
}
```



***



# ✅006【入门】二分搜索入门



有序数组中确定 num **是否存在**



```java
// 有序数组num是否存在（升序数组）（二分）
public static boolean ifExistErFen(int[] arr, int num) {
    if (arr == null || arr.length == 0) {
        return false;
    }
    int l = 0, r = arr.length - 1, m = 0;
    while (l <= r) {
        m = (l + r) / 2;
        if (arr[m] == num) {
            return true;
        } else if (arr[m] > num) {
            r = m - 1;
        } else {
            l = m + 1;
        }
    }
    return false;
}
```



有序数组中&#x627E;**>=num 的最左位置**



```java
// 有序数组>=num最左位置
public static int findMinLeft(int[] arr, int num) {
    int l = 0, r = arr.length - 1, m = 0;
    int ans = -1;
    while (l <= r) {
        m = (l + r) / 2;
        // 防止两数相加结果溢出
        // m=l+(r-l)/2;
        // m=l+(r-l)>>2;
        if (arr[m] >= num) {
            ans = m;
            r = m - 1;
        } else {
            l = m + 1;
        }
    }
    return ans;
}
```



有序数组中&#x627E;**<=num 的最右位置**



```java
// 有序数组<=num最右位置
public static int findMaxRight(int[] arr, int num) {
    int l = 0, r = arr.length - 1, m = 0;
    int ans = -1;
    while (l <= r) {
        m = (l + r) / 2;
        // 防止两数相加结果溢出
        // m=l+(r-l)/2;
        // m=l+(r-l)>>2;
        if (arr[m] <= num) {
            ans = m;
            l = m + 1;
        } else {
            r = m - 1;
        }
    }
    return ans;
}
```



二分搜索不一定发生在有序数组（**寻找峰值**问题）



* 峰值元素是指其值严格大于相邻值的元素



* 假定 arr\[-1]=nums\[n]=-∞



* 所有可能情况：



  1. \[0]位置是峰值



  2. \[n-1]位置是峰值



  3) \[mid]位置是峰值



  4) 峰值在左侧



  5. 峰值在右侧



## [Leetcode【中】162.寻找峰值](https://leetcode.cn/problems/find-peak-element/description/)



```java
// 寻找峰值（无序数组&相邻位置不相等）
public static int findPeakElement(int[] arr) {
    int n = arr.length;
    if (arr.length == 1) {
        return 0;
    }
    if (arr[0] > arr[1]) {
        return 0;
    } else if (arr[n - 1] > arr[n - 2]) {
        return n - 1;
    } else {
        int l = 1, r = n - 2, m = 0, ans = -1;
        while (l <= r) {
            m = (l + r) / 2;
            if (arr[m - 1] > arr[m]) {
                r = m - 1;
            } else if (arr[m] < arr[m + 1]) {
                l = m + 1;
            } else {
                ans = m;
                break;
            }
        }
        return ans;
    }
}
```



```java
import java.util.Arrays;

public class Solution {

    public static void main(String[] args) {
        // 随机数组最大长度
        int N = 100;
        // 随机数组每个值，在[1~V]随机
        int V = 1000;
        int testTime = 10000;
        System.out.println("测试开始");
        for (int i = 0; i < testTime; i++) {
            int n = (int) (Math.random() * N) + 1;
            int[] arr = randomArray(n, V);
            Arrays.sort(arr);
            int num = (int) (Math.random() * V);
            if (ifExistErFen(arr, num) != ifExitBaoLi(arr, num)) {
                System.out.println("出错了：" + arr);
            }
        }
        System.out.println("测试结束");
    }

    // 有序数组num是否存在（升序数组）（暴力）
    public static boolean ifExitBaoLi(int[] arr, int num) {
        for (int temp : arr) {
            if (temp == num) {
                return true;
            }
        }
        return false;
    }

    // 有序数组num是否存在（升序数组）（二分）
    public static boolean ifExistErFen(int[] arr, int num) {
        if (arr == null || arr.length == 0) {
            return false;
        }
        int l = 0, r = arr.length - 1, m = 0;
        while (l <= r) {
            m = (l + r) / 2;
            if (arr[m] == num) {
                return true;
            } else if (arr[m] > num) {
                r = m - 1;
            } else {
                l = m + 1;
            }
        }
        return false;
    }

    // 有序数组>=num最左位置
    public static int findMinLeft(int[] arr, int num) {
        int l = 0, r = arr.length - 1, m = 0;
        int ans = -1;
        while (l <= r) {
            m = (l + r) / 2;
            // 防止两数相加结果溢出
            // m=l+(r-l)/2;
            // m=l+(r-l)>>2;
            if (arr[m] >= num) {
                ans = m;
                r = m - 1;
            } else {
                l = m + 1;
            }
        }
        return ans;
    }

    // 有序数组<=num最右位置
    public static int findMaxRight(int[] arr, int num) {
        int l = 0, r = arr.length - 1, m = 0;
        int ans = -1;
        while (l <= r) {
            m = (l + r) / 2;
            // 防止两数相加结果溢出
            // m=l+(r-l)/2;
            // m=l+(r-l)>>2;
            if (arr[m] <= num) {
                ans = m;
                l = m + 1;
            } else {
                r = m - 1;
            }
        }
        return ans;
    }

    // 寻找峰值（无序数组&相邻位置不相等）
    public static int findPeakElement(int[] arr) {
        int n = arr.length;
        if (arr.length == 1) {
            return 0;
        }
        if (arr[0] > arr[1]) {
            return 0;
        } else if (arr[n - 1] > arr[n - 2]) {
            return n - 1;
        } else {
            int l = 1, r = n - 2, m = 0, ans = -1;
            while (l <= r) {
                m = (l + r) / 2;
                if (arr[m - 1] > arr[m]) {
                    r = m - 1;
                } else if (arr[m] < arr[m + 1]) {
                    l = m + 1;
                } else {
                    ans = m;
                    break;
                }
            }
            return ans;
        }
    }

    // 随机数组
    public static int[] randomArray(int n, int v) {
        int[] arr = new int[n];
        for (int i = 0; i < n; i++) {
            arr[i] = (int) (Math.random() * v) + 1;
        }
        return arr;
    }
}
```



***



# ✅007【入门】复杂度



**常数操作**，固定时间的操作，执行时间和数据量无关。



* 位运算<加减乘除<寻址<哈希函数



**时间复杂度**，一个和数据量有关、只要高阶项、不要低阶项、不要常数项的操作次数表达式。



严格**固定流程**的算法，强调的是**最差情况**！比如插入排序。



算法流程利用**随机行为**作为重要部分时，要看**平均或期望（概率上）的时间复发度**，最差的时间复杂度没有意义。



**时间复杂度的内涵**：描述了算法运行时间和数据量大小的关系，而且当数据量很大时，这种关系相当的本质，并且排除了低阶项、常数项的干扰。



**空间复杂度**，强调额外空间：常数项时间，放弃理论分析，选择用实验来确定，因为不同常数操作的时间不同。



* 入参、出参不算额外空间



* 没有申请辅助数组，只使用几个变量：O（1）



* 申请了长度为 n 的辅助数组：O（N）



**最优解**：优先满足时间复杂度最优，然后尽量少用空间的方案。



**时间复杂度的均摊**：动态数组（拷贝粘贴）、并查集、单调队列、单调栈、哈希表。



不要依据**代码结构**来判断时间复杂度：



* 只使用一个 while 循环的冒泡排序，时间复杂度为 O（N^2）。



* **调和级数**：



  $$N/1+N/2+……+N/N=O(N*logN)$$

**常见复杂度**：



$$O(1)<O(logN)<O(N)<O(N*logN)<O(N^2)<O(N^k)<O(2^N)<O(k^N)<O(N!)$$

***



# ✅008【入门】算法和数据结构大致分类



**数据结构**：任何一种数据结构都是由二者拼凑出来的



* **连续结构**：数组



* **跳转结构**：链表



**算法**：



* **硬计算类算法**：精确求解



* **软计算类算法**：逼近求解



## 算法竞赛



!



!



***



# ✅009【入门】链表及其反转堆栈诠释



**按值传递**



* int、long、byte、short



* float、double、boolean、char



* String



**按引用传递**



* 其余类型



* 传递时，拷贝一份，但是二者指向同一片内存空间，当修改指向区域时对原变量无影响，修改指向区域内的数据时对原变量有影响。



**单链表**



```java
// 单链表节点
public static class ListNode {
    public int val;
    public ListNode next;

    public ListNode(int val) {
        this.val = val;
    }

    public ListNode(int val, ListNode next) {
        this.val = val;
        this.next = next;
    }
}
```



## [Leetcode【易】206.反转链表](https://leetcode.cn/problems/reverse-linked-list/description/)



```java
// 单链表反转
public static ListNode reverseList(ListNode head) {
    ListNode pre = null;
    ListNode next = null;
    while (head != null) {
        next = head.next;
        head.next = pre;
        pre = head;
        head = next;
    }
    return pre;
}
```



**双链表**



```java
// 双链表节点
public static class DoubleListNode {
    public int val;
    public DoubleListNode last;
    public DoubleListNode next;

    public DoubleListNode(int val) {
        this.val = val;
    }
}
```



**反转双链表**



```java
// 双链表反转
public static DoubleListNode reverseDoubleList(DoubleListNode head) {
    DoubleListNode pre = null;
    DoubleListNode next = null;
    while (head != null) {
        next = head.next;
        head.next = pre;
        head.last = next;
        pre = head;
        head = next;
    }
    return pre;
}
```



***



# ✅010【入门】合并两个有序链表



将两个升序链表合并为一个新的升序链表



## [Leetcode【易】21.合并两个有序链表](https://leetcode.cn/problems/merge-two-sorted-lists/description/)



```java
// 合并有序链表（升序）
public static ListNode mergeTwoLists(ListNode head1, ListNode head2) {
    if (head1 == null || head2 == null) {
        return head1 == null ? head2 : head1;
    }
    ListNode head = head1.val <= head2.val ? head1 : head2;
    ListNode cur1 = head.next;
    ListNode cur2 = head == head1 ? head2 : head1;
    ListNode pre = head;
    while (cur1 != null && cur2 != null) {
        if (cur1.val <= cur2.val) {
            pre.next = cur1;
            cur1 = cur1.next;
        } else {
            pre.next = cur2;
            cur2 = cur2.next;
        }
        pre = pre.next;
    }
    pre.next = cur1 != null ? cur1 : cur2;
    return head;
}
```



***



# ✅011【入门】链表相加



两个非空链表，表示两个非负整数



每个整数的每位数字按照逆序方式存储，每个节点存储一位数字



以相同链表形式返回二链表相加的结果



## [Leetcode【中】002.两数相加](https://leetcode.cn/problems/add-two-numbers/submissions/644029081/)



```java
// 链表相加
public static ListNode addTwoNumbers(ListNode h1, ListNode h2) {
    ListNode answer = null, cur = null;
    int carry = 0;
    for (int sum, val; h1 != null
            || h2 != null; h1 = h1 == null ? null : h1.next, h2 = h2 == null ? null : h2.next) {
        sum = (h1 == null ? 0 : h1.val) + (h2 == null ? 0 : h2.val) + carry;
        val = sum % 10;
        carry = sum / 10;
        if (answer == null) {
            answer = new ListNode(val);
            cur = answer;
        } else {
            cur.next = new ListNode(val);
            cur = cur.next;
        }
    }
    if (carry == 1) {
        cur.next = new ListNode(carry);
    }
    return answer;
}
```



***



# ✅012【入门】划分链表



一个链表的头节点 head 和一个特定值 x



对链表进行分割，所有小于 x 的节点都出现在大于或等于 x 的节点之前



## [Leetcode【中】86.分隔链表](https://leetcode.cn/problems/partition-list/description/)



```java
// 划分链表
public static ListNode partition(ListNode head, int x) {
    // <x的区域
    ListNode leftHead = null, leftTail = null;
    // >x的区域
    ListNode rightHead = null, rightTail = null;
    ListNode next = null;
    while (head != null) {
        next = head.next;
        head.next = null;
        if (head.val < x) {
            if (leftHead == null) {
                leftHead = head;
            } else {
                leftTail.next = head;
            }
            leftTail = head;
        } else {
            if (rightHead == null) {
                rightHead = head;
            } else {
                rightTail.next = head;
            }
            rightTail = head;
        }
        head = next;
    }
    if (leftHead == null) {
        return rightHead;
    }
    leftTail.next = rightHead;
    return leftHead;
}
```



***



# ✅013【入门】队列和栈



**队列**：先进先出



* **链表**



```java
public static class Queue1 {
    // 单向链表
    public Queue<Integer> queue = new LinkedList<>();

    // 判断是否为空
    public boolean isEmpty() {
        return queue.isEmpty();
    }

    // 队尾加入num
    public void offer(int num) {
        queue.offer(num);
    }

    // 队头弹出num
    public int poll() {
        return queue.poll();
    }

    // 返回队头但不弹出
    public int peek() {
        return queue.peek();
    }

    // 返回队列大小
    public int size() {
        return queue.size();
    }
}
```



* **数组**（数据量确定）



```java
public static class Queue2 {
    // 数组
    public int[] queue;
    public int l;
    public int r;

    // 初始化数组队列
    public Queue2(int n) {
        queue = new int[n];
        l = 0;
        r = 0;
    }

    // 队尾加入num
    public void offer(int num) {
        queue[r++] = num;
    }

    // 队头弹出num
    public int poll() {
        return queue[l++];
    }

    // 返回队头
    public int head() {
        return queue[l];
    }

    // 返回队尾
    public int tail() {
        return queue[r - 1];
    }

    // 返回队列大小
    public int size() {
        return r - l;
    }
}
```



**栈**：后进先出



* **动态数组**



```java
public static class Stack1 {
    // 动态数组
    public Stack<Integer> stack = new Stack<>();

    // 判断栈是否为空
    public boolean isEmpty() {
        return stack.isEmpty();
    }

    // num压入栈
    public void push(int num) {
        stack.push(num);
    }

    // 弹出栈
    public int pop() {
        return stack.pop();
    }

    // 返回栈头
    public int peek() {
        return stack.peek();
    }

    // 返回栈大小
    public int size() {
        return stack.size();
    }
}
```



* **数组**



```java
public static class Stack2 {
    // 数组
    public int[] stack;
    public int size;

    // 初始化数组栈
    public Stack2(int n) {
        stack = new int[n];
        size = 0;
    }

    // 判断栈是否为空
    public boolean isEmpty() {
        return size == 0;
    }

    // num压入栈
    public void push(int num) {
        stack[size++] = num;
    }

    // 弹出栈
    public int pop() {
        return stack[--size];
    }

    // 返回栈头
    public int peek() {
        return stack[size - 1];
    }

    // 返回栈大小
    public int size() {
        return size;
    }
}
```



**循环队列**



## [Leetcode【中】622.设计循环队列](https://leetcode.cn/problems/design-circular-queue/submissions/644131964/)



```java
public static class MyCircularQueue {
    public int[] queue;
    public int l, r, size, limit;

    public MyCircularQueue(int n) {
        queue = new int[n];
        limit = n;
        l = 0;
        r = 0;
        size = 0;
    }

    // 判断循环队列是否为空
    public boolean isEmpty() {
        return size == 0;
    }

    // 判断循环队列是否为满
    public boolean isFull() {
        return size == limit;
    }

    // 队尾加入
    public boolean enQueue(int value) {
        if (isFull()) {
            return false;
        } else {
            queue[r] = value;
            r = r == limit - 1 ? 0 : (r + 1);
            size++;
            return true;
        }
    }

    // 队头弹出
    public boolean deQueue() {
        if (isEmpty()) {
            return false;
        } else {
            l = l == limit - 1 ? 0 : (l + 1);
            size--;
            return true;
        }
    }

    // 返回队头
    public int Front() {
        if (isEmpty()) {
            return -1;
        } else {
            return queue[l];
        }
    }

    // 返回队尾
    public int Rear() {
        if (isEmpty()) {
            return -1;
        } else {
            int last = r == 0 ? (limit - 1) : (r - 1);
            return queue[last];
        }
    }
}
```



***



# ✅014【入门】队列和栈相互成全



**两个栈**实现先入先出的**队列**



只能使用标准栈操作



## [Leetcode【易】232.用栈实现队列](https://leetcode.cn/problems/implement-queue-using-stacks/description/)



```java
public static class MyQueue {
    public Stack<Integer> in;
    public Stack<Integer> out;

    // 初始化
    public MyQueue() {
        in = new Stack<>();
        out = new Stack<>();
    }

    // 倒数据：从in栈倒到out栈
    private void inToOut() {
        if (out.empty()) {
            while (!in.empty()) {
                out.push(in.pop());
            }
        }
    }

    public void push(int x) {
        in.push(x);
        inToOut();
    }

    public int pop() {
        inToOut();
        return out.pop();
    }

    public int peek() {
        inToOut();
        return out.peek();
    }

    public boolean empty() {
        return in.isEmpty() && out.isEmpty();
    }
}
```



**两个队列实现**后入先出的**栈**



只能使用队列的基本操作



## [Leetcode【易】225.用队列实现栈](https://leetcode.cn/problems/implement-stack-using-queues/description/)



```java
public static class MyStack {
    Queue<Integer> queue;

    public MyStack() {
        queue = new LinkedList<Integer>();
    }

    public void push(int x) {
        int n = queue.size();
        queue.offer(x);
        for (int i = 0; i < n; i++) {
            queue.offer(queue.poll());
        }
    }

    public int pop() {
        return queue.poll();
    }

    public int top() {
        return queue.peek();
    }

    public boolean empty() {
        return queue.isEmpty();
    }
}
```



***



# ✅015【入门】最小栈



设计一个能够**在常数时间范围内检索到最小元素**的栈



## [Leetcode【中】155.最小栈](https://leetcode.cn/problems/min-stack/description/)



官方实现好的栈



```java
public static class MinStack1 {
    // 调用已实现的栈
    public Stack<Integer> data;
    public Stack<Integer> min;

    public MinStack1() {
        data = new Stack<Integer>();
        min = new Stack<Integer>();
    }

    public void push(int val) {
        data.push(val);
        if (min.isEmpty() || val <= min.peek()) {
            min.push(val);
        } else {
            min.push(min.peek());
        }
    }

    public void pop() {
        data.pop();
        min.pop();
    }

    public int top() {
        return data.peek();
    }

    public int getMin() {
        return min.peek();
    }
}
```



自定义数组实现栈



```java
public static class MinStack2 {
    // 使用数组实现栈
    public final int MAXN = 8001;

    public int[] data;
    public int[] min;
    int size;

    public MinStack2() {
        data = new int[MAXN];
        min = new int[MAXN];
        size = 0;
    }

    public void push(int val) {
        data[size] = val;
        if (size == 0 || val <= min[size - 1]) {
            min[size] = val;
        } else {
            min[size] = min[size - 1];
        }
        size++;
    }

    public void pop() {
        size--;
    }

    public int top() {
        return data[size - 1];
    }

    public int getMin() {
        return min[size - 1];
    }
}
```



***



# ✅016【入门】双端队列



## [Leetcode【中】641.设计循环双端队列](https://leetcode.cn/problems/design-circular-deque/)



**双链表**实现



```java
public static class MyCircularDeque1 {
    public Deque<Integer> deque = new LinkedList<>();
    public int size;
    public int limit;

    public MyCircularDeque1(int k) {
        size = 0;
        limit = k;
    }

    public boolean insertFront(int value) {
        if (isFull()) {
            return false;
        } else {
            deque.offerFirst(value);
            size++;
            return true;
        }
    }

    public boolean insertLast(int value) {
        if (isFull()) {
            return false;
        } else {
            deque.offerLast(value);
            size++;
            return true;
        }
    }

    public boolean deleteFront() {
        if (isEmpty()) {
            return false;
        } else {
            size--;
            deque.pollFirst();
            return true;
        }
    }

    public boolean deleteLast() {
        if (isEmpty()) {
            return false;
        } else {
            size--;
            deque.pollLast();
            return true;
        }
    }

    public int getFront() {
        if (isEmpty()) {
            return -1;
        } else {
            return deque.peekFirst();
        }
    }

    public int getRear() {
        if (isEmpty()) {
            return -1;
        } else {
            return deque.peekLast();
        }
    }

    public boolean isFull() {
        return size == limit;
    }

    public boolean isEmpty() {
        return size == 0;
    }
}
```



**固定数组**实现



```java
public static class MyCircularDeque2 {
    public int[] deque;
    public int l, r, size, limit;

    public MyCircularDeque2(int k) {
        deque = new int[k];
        l = r = size = 0;
        limit = k;
    }

    public boolean insertFront(int value) {
        if (isFull()) {
            return false;
        } else {
            if (isEmpty()) {
                l = r = 0;
                deque[0] = value;
            } else {
                l = (l == 0) ? (limit - 1) : (l - 1);
                deque[l] = value;
            }
            size++;
            return true;
        }
    }

    public boolean insertLast(int value) {
        if (isFull()) {
            return false;
        } else {
            if (isEmpty()) {
                l = r = 0;
                deque[0] = value;
            } else {
                r = (r == limit - 1) ? (0) : (r + 1);
                deque[r] = value;
            }
            size++;
            return true;
        }
    }

    public boolean deleteFront() {
        if (isEmpty()) {
            return false;
        } else {
            l = (l == limit - 1) ? (0) : (l + 1);
            size--;
            return true;
        }
    }

    public boolean deleteLast() {
        if (isEmpty()) {
            return false;
        } else {
            r = (r == 0) ? (limit - 1) : (r - 1);
            size--;
            return true;
        }
    }

    public int getFront() {
        if (isEmpty()) {
            return -1;
        } else {
            return deque[l];
        }
    }

    public int getRear() {
        if (isEmpty()) {
            return -1;
        } else {
            return deque[r];
        }
    }

    public boolean isEmpty() {
        return size == 0;
    }

    public boolean isFull() {
        return size == limit;
    }
}
```



***



# ✅017【入门】二叉树及其三种序



**二叉树**：



* 每一个节点有左节点、右节点



* 位于底层的节点指向空



```java
class TreeNode {
    int val;
    TreeNode left;
    TreeNode right;

    TreeNode() {
    }

    TreeNode(int val) {
        this.val = val;
    }

    TreeNode(int val, TreeNode left, TreeNode right) {
        this.val = val;
        this.left = left;
        this.right = right;
    }
}
```



**递归序：**



* **递归中：任意一个节点只要不空，必然会到达三次**



* 时间复杂度：O（N）



* 空间复杂度：O（H）



```java
// 递归序：
// 1、2、4、4、4、2、5、5、5、2、
// 1、3、6、6、6、3、7、7、7、3、
// 1
public static void fun(TreeNode head) {
    if (head == null) {
        return;
    }
    // 1
    fun(head.left);
    // 2
    fun(head.right);
    // 3
}
```



**先序**：中 → 左 → 右：1、2、4、5、3、6、7



```java
// 先序遍历
public static void preOrder(TreeNode head, List<Integer> ans) {
    if (head == null) {
        return;
    }
    ans.add(head.val);
    preOrder(head.left, ans);
    preOrder(head.right, ans);
}

public List<Integer> preorderTraversalDigui(TreeNode root) {
    List<Integer> ans = new ArrayList<>();
    preOrder(root, ans);
    return ans;
}
```



**中序**：左 → 中 → 右：4、2、5、1、6、3、7



```java
// 中序遍历
public static void inOrder(TreeNode head, List<Integer> ans) {
    if (head == null) {
        return;
    }
    inOrder(head.left, ans);
    ans.add(head.val);
    inOrder(head.right, ans);
}

public List<Integer> inorderTraversalDigui(TreeNode root) {
    List<Integer> ans = new ArrayList<>();
    inOrder(root, ans);
    return ans;
}
```



**后序**：左 → 右 → 中：4、5、2、6、7、3、1



```java
// 后续遍历
public static void posOrder(TreeNode head, List<Integer> ans) {
    if (head == null) {
        return;
    }
    posOrder(head.left, ans);
    posOrder(head.right, ans);
    ans.add(head.val);
}

public List<Integer> postorderTraversalDigui(TreeNode root) {
    List<Integer> ans = new ArrayList<>();
    posOrder(root, ans);
    return ans;
}
```



***



# ✅018【入门】二叉树遍历非递归实现



**非递归：每个节点进栈和出栈的次数是有限的**



* 时间复杂度：O（N）



* 空间复杂度：O（H）



  * H：树的高度



**先序**：中 → 左 → 右：1、2、4、5、3、6、7



## [Leetcode【易】144.二叉树的前序遍历](https://leetcode.cn/problems/binary-tree-preorder-traversal/description/)



```java
// 先序遍历（非递归栈）
public static List<Integer> preorderTraversal(TreeNode head) {
    List<Integer> ans = new ArrayList<>();
    if (head != null) {
        Stack<TreeNode> stack = new Stack<>();
        stack.push(head);
        while (!stack.isEmpty()) {
            head = stack.pop();
            ans.add(head.val);
            if (head.right != null) {
                stack.push(head.right);
            }
            if (head.left != null) {
                stack.push(head.left);
            }
        }
    }
    return ans;
}
```



**中序**：左 → 中 → 右：4、2、5、1、6、3、7



## [Leetcode【易】94.二叉树的中序遍历](https://leetcode.cn/problems/binary-tree-inorder-traversal/description/)



```java
// 中序遍历（非递归栈）
public static List<Integer> inorderTraversal(TreeNode head) {
    List<Integer> ans = new ArrayList<>();
    if (head != null) {
        Stack<TreeNode> stack = new Stack<>();
        while (!stack.isEmpty() || head != null) {
            if (head != null) {
                stack.push(head);
                head = head.left;
            } else {
                head = stack.pop();
                ans.add(head.val);
                head = head.right;
            }
        }
    }
    return ans;
}
```



**后序**：左 → 右 → 中：4、5、2、6、7、3、1



## [Leetcode【易】145.二叉树的后序遍历](https://leetcode.cn/problems/binary-tree-postorder-traversal/description/)



* 两个栈（先序微调倒推）



```java
// 后序遍历（非递归两个栈：先序微调反转）
public static List<Integer> postorderTraversalTwo(TreeNode head) {
    List<Integer> ans = new ArrayList<>();
    if (head != null) {
        Stack<TreeNode> stack = new Stack<>();
        Stack<TreeNode> collect = new Stack<>();
        stack.push(head);
        while (!stack.isEmpty()) {
            head = stack.pop();
            collect.push(head);
            if (head.left != null) {
                stack.push(head.left);
            }
            if (head.right != null) {
                stack.push(head.right);
            }
        }
        while (!collect.isEmpty()) {
            ans.add(collect.pop().val);
        }
    }
    return ans;
}
```



* 一个栈（标记）



```java
// 后序遍历（非递归一个栈）
public static List<Integer> postorderTraversalOne(TreeNode head) {
    List<Integer> ans = new ArrayList<>();
    if (head != null) {
        Stack<TreeNode> stack = new Stack<>();
        stack.push(head);
        while (!stack.isEmpty()) {
            TreeNode cur = stack.peek();
            if (cur.left != null && head != cur.left && head != cur.right) {
                // 有左树且未打印
                stack.push(cur.left);
            } else if (cur.right != null && head != cur.right) {
                // 有右树且未打印
                stack.push(cur.right);
            } else {
                // 没有左右树、左右树都已打印
                ans.add(cur.val);
                head = stack.pop();
            }
        }
    }
    return ans;
}
```



***



# ✅019【必备】算法笔试处理输入输出



* Leetcode 填函数风格



* ACM 完整程序风格



  * 规定数据量（BufferedReader（一次读相当多的内容到内存中，减少访问文件 IO 操作的次数）、StreamTokenizer、PrintWriter）



  * 按行读（没有数据规模）（BufferedReader、PrintWriter）



  * Scanner（一次读一行到内存中，访问文件次数较多）、System.out &#x7684;**&#x20;IO 效率慢**



* 不推荐使用：临时动态空间



* 推荐使用：**全局静态空间**



```java
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StreamTokenizer;

public class Solution {

    // 题目给定的最大数据量
    public static int MAXN = 201;
    public static int MAXM = 201;
    // 当前数据的实际数据
    public static int n;
    public static int m;
    // 申请足够大的矩阵空间
    public static int[][] arr = new int[MAXN][MAXM];

    public static String line;
    public static String[] parts;
    public static int sum;

    public static void main(String[] args) throws IOException {

        // 明确规定数据量

        // 一次从文件中读相当多的数据到内存中
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        // 一个一个读数字，省略掉所有的空格和回车（也不区分二者）
        StreamTokenizer in = new StreamTokenizer(br);
        // 内存托管区，保存结果数据
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        // 文件没有结束就继续
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            m = (int) in.nval;
            // int[][] arr=new int[n][m];
            for (int i = 0; i < n; i++) {
                for (int j = 0; j < m; j++) {
                    in.nextToken();
                    arr[i][j] = (int) in.nval;
                }
            }
            out.println(arr);
        }
        // 内存托管区的数据一次性刷新到文件中
        out.flush();
        br.close();
        out.close();

        // 按行读

        BufferedReader in2 = new BufferedReader(new InputStreamReader(System.in));
        PrintWriter out2 = new PrintWriter(new OutputStreamWriter(System.out));
        while ((line = in2.readLine()) != null) {
            parts = line.split(" ");
            sum = 0;
            for (String num : parts) {
                sum += Integer.valueOf(num);
            }
            out2.println(sum);
        }
        out2.flush();
        in2.close();
        out2.close();
    }
}
```



***



# ✅020【必备】递归和 master 公式



```java
public class Solution {

    public static int maxValue(int[] arr) {
        return fun(arr, 0, arr.length - 1);
    }

    public static int fun(int[] arr, int l, int r) {
        if (l == r) {
            return arr[l];
        }
        int mid = (l + r) / 2;
        int lMax = fun(arr, l, mid);
        int rMax = fun(arr, mid + 1, r);
        return Math.max(lMax, rMax);
    }

    public static void main(String[] args) {
        int[] arr = { 3, 8, 7, 6, 4, 5, 2, 0, 1, 9 };
        System.out.println(maxValue(arr));
    }
}
```



base case：问题小的不能再小



**递归**底层是利用**系统栈**来实现的



任何递归都一定可以改为非递归`，不用系统压栈（系统`栈空间，比较少）（存在最大递归深度），自己压栈（内存空间，比较多）



**master 公式**



* 所有子问题规模相同（**即 b 必须相同，这样才有 a 个子问题的复杂度**）的递归才可以使用：$$T(n)=a*T(\frac{n}{b})+O(n^c)$$



  * 如上例子的递归：$$T(N)=2*T(\frac{N}{2})+O(N^0)$$



* 如果\$$log（b，a）\<c\$$，复杂度：$$O(n^c)$$



* 如果\$$log（b，a）>c\$$，复杂度：$$O(n^{log(b,a)})$$



* 如果\$$log（b，a）==c\$$，复杂度：$$O(n^c*logn)$$



$$T(N)=2*T(\frac{N}{2})+O(N*logN)$$: $$O(N*(logN)^2)$$



***



# ✅021【必备】归并排序



**左部分排好序，右部分排好序，利用 merge 过程让左右整体有序**



* merge 过程：谁小拷贝谁，直到左右两部分所有的数字耗尽，拷贝回原数组原位置



**递归版**：$$T(N)=2*T(\frac{N}{2})+O(N)$$



* 时间复杂度：$$O(N*logN)$$



* 额外空间复杂度：$$O(N)$$



**非递归版：**&#x6B65;长（1、2、4、8、……大于数组长度的第一个）



* 时间复杂度：$$O(N*logN)$$



* 额外空间复杂度：$$O(N)$$



## [Leetcode【中】912.排序数组](https://leetcode.cn/problems/sort-an-array/description/)



```java
public class Solution {

    public static int MAXN = 100001;
    public static int[] help = new int[MAXN];
    public static int n;

    public int[] sortArray(int[] nums) {
        n = nums.length;
        mergeSort1(0, n - 1, nums);
        // mergeSort2(nums);
        return nums;
    }

    // 归并排序升序（递归）
    public static void mergeSort1(int l, int r, int[] arr) {
        if (l == r) {
            return;
        }
        int m = (l + r) / 2;
        mergeSort1(l, m, arr);
        mergeSort1(m + 1, r, arr);
        merge(l, m, r, arr);
    }

    // 递归排序升序（非递归）
    public static void mergeSort2(int[] arr) {
        // O(lonN)
        for (int l, m, r, step = 1; step < n; step <<= 1) {
            l = 0;
            // O(N)
            while (l < n) {
                m = l + step - 1;
                if (m + 1 > n - 1) {
                    // 已经没有右侧了
                    break;
                }
                r = Math.min(l + (step << 1) - 1, n - 1);
                merge(l, m, r, arr);
                l = r + 1;
            }
        }
    }

    public static void merge(int l, int m, int r, int[] arr) {
        int i = l;
        int a = l;
        int b = m + 1;
        while (a <= m && b <= r) {
            help[i++] = arr[a] <= arr[b] ? arr[a++] : arr[b++];
        }
        // 左右指针，必有一个越界一个不越界
        while (a <= m) {
            help[i++] = arr[a++];
        }
        while (b <= r) {
            help[i++] = arr[b++];
        }
        for (i = l; i <= r; i++) {
            arr[i] = help[i];
        }
    }
}
```



## [洛谷【 普及 −】P1177 .【模板】排序](https://www.luogu.com.cn/problem/P1177#ide)



```java
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StreamTokenizer;

public class Solution {

    public static int MAXN = 100001;
    public static int[] arr = new int[MAXN];
    public static int[] help = new int[MAXN];
    public static int n;

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            for (int i = 0; i < n; i++) {
                in.nextToken();
                arr[i] = (int) in.nval;
            }
            // mergeSort1(0, n - 1);
            mergeSort2();
            for (int i = 0; i < n; i++) {
                out.print(arr[i] + " ");
            }
            out.println();
        }
        out.flush();
        br.close();
        out.close();
    }

    // 归并排序升序（递归）
    public static void mergeSort1(int l, int r) {
        if (l == r) {
            return;
        }
        int m = (l + r) / 2;
        mergeSort1(l, m);
        mergeSort1(m + 1, r);
        merge(l, m, r);
    }

    // 递归排序升序（非递归）
    public static void mergeSort2() {
        // O(lonN)
        for (int l, m, r, step = 1; step < n; step <<= 1) {
            l = 0;
            // O(N)
            while (l < n) {
                m = l + step - 1;
                if (m + 1 > n - 1) {
                    // 已经没有右侧了
                    break;
                }
                r = Math.min(l + (step << 1) - 1, n - 1);
                merge(l, m, r);
                l = r + 1;
            }
        }
    }

    public static void merge(int l, int m, int r) {
        int i = l;
        int a = l;
        int b = m + 1;
        while (a <= m && b <= r) {
            help[i++] = arr[a] <= arr[b] ? arr[a++] : arr[b++];
        }
        // 左右指针，必有一个越界一个不越界
        while (a <= m) {
            help[i++] = arr[a++];
        }
        while (b <= r) {
            help[i++] = arr[b++];
        }
        for (i = l; i <= r; i++) {
            arr[i] = help[i];
        }
    }
}
```



***



# ✅022【必备】归并分治



一个问题



* 在大范围上的答案=左部分答案+右部分答案+跨越左右产生的答案



* 计算“跨域左右产生的答案”时，如果左右各自部分有序（归并排序），会不会假话计算



如果以上二者都满足，大概率可以使用归并分治



## [牛客【中】CD21.计算数组的小和](https://www.nowcoder.com/practice/edfe05a1d45c4ea89101d936cac32469)



```java
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StreamTokenizer;

public class Solution {

    public static int MAXN = 100001;
    public static int[] arr = new int[MAXN];
    public static int[] help = new int[MAXN];
    public static int n;

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            for (int i = 0; i < n; i++) {
                in.nextToken();
                arr[i] = (int) in.nval;
            }
            out.println(smallSum(0, n - 1));
        }
        out.flush();
        br.close();
        out.close();
    }

    public static long smallSum(int l, int r) {
        if (l == r) {
            return 0;
        }
        int m = (l + r) / 2;
        return smallSum(l, m) + smallSum(m + 1, r) + merge(l, m, r);
    }

    public static long merge(int l, int m, int r) {
        // 统计，跨左右的小和
        long ans = 0;
        for (int i = l, j = m + 1, sum = 0; j <= r; j++) {
            while (i <= m && arr[i] <= arr[j]) {
                sum += arr[i++];
            }
            ans += sum;
        }

        int i = l;
        int a = l;
        int b = m + 1;
        while (a <= m && b <= r) {
            help[i++] = arr[a] <= arr[b] ? arr[a++] : arr[b++];
        }
        while (a <= m) {
            help[i++] = arr[a++];
        }
        while (b <= r) {
            help[i++] = arr[b++];
        }
        for (int k = l; k <= r; k++) {
            arr[k] = help[k];
        }
        return ans;
    }
}
```



## [Leetcode【难】493.翻转对](https://leetcode.cn/problems/reverse-pairs/description/)



```java
public static int MAX = 50001;
public static int[] helpArr = new int[MAX];

public int reversePairs(int[] nums) {
    return countPairs(nums, 0, nums.length - 1);
}

public static int countPairs(int[] arr, int l, int r) {
    if (l == r) {
        return 0;
    }
    int m = (l + r) / 2;
    return countPairs(arr, l, m) + countPairs(arr, m + 1, r) + mergePairs(arr, l, m, r);
}

public static int mergePairs(int[] arr, int l, int m, int r) {
    int count = 0;

    for (int i = l, j = m + 1; i <= m; i++) {
        while (j <= r && (long) arr[i] > 2 * (long) arr[j]) {
            j++;
        }
        count += j - m - 1;
    }

    int i = l;
    int a = l;
    int b = m + 1;
    while (a <= m && b <= r) {
        helpArr[i++] = arr[a] <= arr[b] ? arr[a++] : arr[b++];
    }
    while (a <= m) {
        helpArr[i++] = arr[a++];
    }
    while (b <= r) {
        helpArr[i++] = arr[b++];
    }
    for (int k = l; k <= r; k++) {
        arr[k] = helpArr[k];
    }

    return count;
}
```



***



# ✅023【必备】随机快速排序



**随机快速排序**



* **普通快速排序**：选择的数字是当前范围上固定位置



  * 时间复杂度：$$O(N^2)$$



  * 额外空间复杂度：$$O(N)$$



* **随机快速排序**：选择的数字是当前范围内随机位置



  * 时间复杂度：$$O(N*logN)$$



    * **期望**估计复杂度



  * 额外空间复杂度：$$O(logN)$$



* **随机快速排序 PLUS**（荷兰国旗问题）：随机选出一个数字 x，数组在数分时搞定所有值都是 x 的数字



```java
public class Solution {

    public static int MAX = 50001;
    public static int[] arr = new int[MAX];

    public int[] sortArray(int[] nums) {
        for (int i = 0; i < nums.length; i++) {
            arr[i] = nums[i];
        }
        quickSort1(0, nums.length - 1);
        for (int i = 0; i < nums.length; i++) {
            nums[i] = arr[i];
        }
        return nums;
    }

    // 随机快排（经典不推荐：升序）
    public static void quickSort1(int l, int r) {
        if (l >= r) {
            return;
        }
        int x = arr[l + (int) (Math.random() * (r - l + 1))];
        int mid = partition1(l, r, x);
        quickSort1(l, mid - 1);
        quickSort1(mid + 1, r);
    }

    public static int partition1(int l, int r, int x) {
        // small：arr[l...a-1]小于x的区域
        // xi：记录任意一个x在小于<=x区域的位置
        int small = l, xi = 0;
        for (int i = l; i <= r; i++) {
            if (arr[i] <= x) {
                swap(small, i);
                if (arr[small] == x) {
                    xi = small;
                }
                small++;
            }
        }
        swap(xi, small - 1);
        return small - 1;
    }

    public static void swap(int i, int j) {
        int tmp = arr[i];
        arr[i] = arr[j];
        arr[j] = tmp;
    }

    public static int first;
    public static int last;

    // 随机快排（优化版：升序）
    public static void quickSort2(int l, int r) {
        if (l >= r) {
            return;
        }
        int x = arr[l + (int) (Math.random() * (r - l + 1))];
        partition2(l, r, x);
        int small = first;
        int big = last;
        quickSort2(l, small - 1);
        quickSort2(big + 1, r);
    }

    // 荷兰国旗问题
    // 数组arr分为三部分
    // <x放左边，=x放中间，>x放右边
    public static void partition2(int l, int r, int x) {
        first = l;
        last = r;
        int i = l;
        while (i <= last) {
            if (arr[i] == x) {
                i++;
            } else if (arr[i] < x) {
                swap(first++, i++);
            } else {
                swap(last--, i);
            }
        }
    }
}
```



***



# ✅024【必备】随机选择算法



无序数组中寻找第 k 大的数



* 给定数组 nums 和整数 k，返回数组中第 k 最大的元素



* 方案



  * 快排



  * 时间复杂度：$$O(N)$$



  * 额外空间复杂度：$$O(1)$$



## [Leetcode【中】215.数组汇总第 K 个最大的元素](https://leetcode.cn/problems/kth-largest-element-in-an-array/description/)



```java
public class Solution {
    // 第k大=升序第nums.length-k小
    public static int findKthLargest(int[] nums, int k) {
        return randomizedSelect(nums, nums.length - k);
    }

    public static int randomizedSelect(int[] arr, int i) {
        int ans = 0;
        for (int l = 0, r = arr.length - 1; l <= r;) {
            partition(arr, l, r, arr[l + (int) (Math.random() * (r - l + 1))]);
            if (i < first) {
                r = first - 1;
            } else if (i > last) {
                l = last + 1;
            } else {
                ans = arr[i];
                break;
            }
        }
        return ans;
    }

    // 荷兰国旗问题
    public static int first, last;

    public static void partition(int[] arr, int l, int r, int x) {
        first = l;
        last = r;
        int i = l;
        while (i <= last) {
            if (arr[i] == x) {
                i++;
            } else if (arr[i] < x) {
                swap(arr, first++, i++);
            } else {
                swap(arr, i, last--);
            }
        }
    }

    public static void swap(int[] arr, int i, int j) {
        int tmp = arr[i];
        arr[i] = arr[j];
        arr[j] = tmp;
    }
}
```



***



# ✅025【必备】堆结构和堆排序



**完全二叉树**



* 大小&#x7531;**&#x20;size&#x20;**&#x63A7;制



* i 的父节点：$$（i-1）/2$$



* i 的左节点：$$i*2+1$$



* i 的右节点：$$i*2+2$$



**大根堆**



* 大的在上边



**小根堆**



* 大的在外边



```java
// 复杂度O(logN)
// i位置的数变大了，向上调整大根堆
public static void heapInsert(int[] arr, int i) {
    while (arr[i] > arr[(i - 1) / 2]) {
        swap(arr, i, (i - 1) / 2);
        i = (i - 1) / 2;
    }
}

// i位置的数变小了，向下调衡大根堆
public static void heapify(int[] arr, int i, int size) {
    int l = i * 2 + 1;
    while (l < size) {
        int best = l + 1 < size && arr[l + 1] > arr[l] ? l + 1 : l;
        best = arr[best] > arr[i] ? best : i;
        if (best == i) {
            break;
        }
        swap(arr, best, i);
        i = best;
        l = i * 2 + 1;
    }
}

// 交换
public static void swap(int[] arr, int i, int j) {
    int tmp = arr[i];
    arr[i] = arr[j];
    arr[j] = tmp;
}
```



**堆排序**



* 第一种



  * 从顶到底建大根堆：



    * 时间复杂度：$$log(N!)收敛于O(N*logN)$$



  * 依次弹出堆内最值



    * 时间复杂度：$$O(N*logN)$$



  * 时间复杂度：$$O(N*logN)$$



  * 空间复杂度：$$O(1)$$



* 第二种



  * 从底到顶建大根堆



    * 时间复杂度：$$N/2*1+N/4*2+N/8*3+n/16*4+...收敛于O(N)$$



  * 依次弹出堆内最值



    * 时间复杂度：$$O(N*logN)$$



  * 时间复杂度：$$O(N*logN)$$



  * 空间复杂度：$$O(1)$$



```java
// 堆排序（从顶到底建立大根堆）
public static void heapSort1(int[] arr) {
    int n = arr.length;
    for (int i = 0; i < n; i++) {
        heapInsert(arr, i);
    }
    int size = n;
    while (size > 1) {
        swap(arr, 0, --size);
        heapify(arr, 0, size);
    }
}

// 堆排序（从底到顶建立大根堆）
public static void heapSort2(int[] arr) {
    int n = arr.length;
    for (int i = n - 1; i >= 0; i--) {
        heapify(arr, i, n);
    }
    int size = n;
    while (size > 1) {
        swap(arr, 0, --size);
        heapify(arr, 0, size);
    }
}
```



***



# ✅026【必备】哈希表、有序表、比较器



**哈希表**



* 增删改查时间复杂度：\$$O（1）\$$，只不过是大常数



* 在范围固定、可控的情况下，可以用数组结构代替



```java
import java.util.HashMap;
import java.util.HashSet;

public class Solution {
    public static void main(String[] args) {
        // Integer、Long、Double、Float
        // Byte、Short、Character、Boolean
        // String特征相同：按值比较（作key）
        String str1 = new String("hello");
        String str2 = new String("hello");
        // false，不同的内存地址
        System.out.println(str1 == str2);
        // true，值相同
        System.out.println(str1.equals(str2));

        HashSet<String> set = new HashSet<>();
        set.add(str1);
        // true
        System.out.println(set.contains("hello"));
        // true，值相同
        System.out.println(set.contains(str2));
        set.add(str2);
        // 1
        System.out.println(set.size());
        set.remove(str1);
        set.clear();
        // true
        System.out.println(set.isEmpty());

        HashMap<String, String> map = new HashMap<>();
        map.put(str1, "world");
        // true
        System.out.println(map.containsKey("hello"));
        // true
        System.out.println(map.containsKey(str2));
        // world
        System.out.println(map.get(str2));
        map.clear();
        // true
        System.out.println(map.isEmpty());

        // 按内存地址作key
        Student stu1 = new Student(1, "star");
        Student stu2 = new Student(1, "star");
        HashMap<Student, String> mapStu = new HashMap<>();
        mapStu.put(stu1, "stu1");
        // true
        System.out.println(mapStu.containsKey(stu1));
        // false
        System.out.println(mapStu.containsKey(stu2));
        // 2
        System.out.println(mapStu.size());

    }

    public static class Student {
        public int age;
        public String name;

        public Student(int age, String name) {
            this.age = age;
            this.name = name;
        }
    }
}
```



**有序表**



* 增删改查等操作时间复杂度：$$O(logN)$$



```java
import java.util.PriorityQueue;
import java.util.TreeMap;
import java.util.TreeSet;

public class Solution {
    public static void main(String[] args) {
        // 有序表底层是红黑树（大部分功能类似哈希表）
        TreeMap<Integer, String> treeMap = new TreeMap<>();
        treeMap.put(1, "1");
        treeMap.put(2, "2");
        treeMap.put(3, "3");
        treeMap.put(4, "4");
        treeMap.put(5, "5");
        treeMap.put(6, "6");
        treeMap.put(7, "7");
        treeMap.put(8, "8");
        treeMap.put(9, "9");
        treeMap.put(10, "10");
        // 10
        System.out.println(treeMap.size());
        // 1、key最小的
        System.out.println(treeMap.firstKey());
        // 10、key最大的
        System.out.println(treeMap.lastKey());
        // 10、<=10的最大key
        System.out.println(treeMap.floorKey(10));
        // 10、>=10的最小key
        System.out.println(treeMap.ceilingKey(10));

        TreeSet<Integer> set = new TreeSet<>();
        set.add(1);
        set.add(2);
        set.add(2);
        set.add(3);
        set.add(3);
        // 自动去重
        // 3
        System.out.println(set.size());

        // 堆（默认小根堆）
        PriorityQueue<Integer> heap = new PriorityQueue<>();
        heap.add(1);
        heap.add(2);
        heap.add(2);
        heap.add(3);
        heap.add(3);
        // 5（不去重）
        System.out.println(heap.size());
    }
}
```



**比较器**



```java
import java.util.Arrays;
import java.util.Comparator;
import java.util.TreeSet;

public class Solution {

    public static class Employee {
        public int company;
        public int age;

        public Employee(int company, int age) {
            this.company = company;
            this.age = age;
        }
    }

    public static class EmployeeComparator implements Comparator<Employee> {
        @Override
        public int compare(Employee o1, Employee o2) {
            // 任何比较器都默认：
            // 返回负数第一个参数优先级高
            // 返回正数第二个参数优先级高

            // 谁年龄小，谁优先级高
            return o1.age - o2.age;

            // 谁年龄大，谁优先级高
            // return o2.age-o1.age;
        }
    }

    public static void main(String[] args) {
        Employee e1 = new Employee(2, 27);
        Employee s2 = new Employee(1, 60);
        Employee s3 = new Employee(4, 19);
        Employee s4 = new Employee(3, 23);
        Employee s5 = new Employee(1, 35);
        Employee s6 = new Employee(3, 55);
        Employee[] arr = { e1, s2, s3, s4, s5, s6 };
        Arrays.sort(arr, new EmployeeComparator());

        Arrays.sort(arr, (a, b) -> a.age - b.age);

        Arrays.sort(arr, (a, b) -> a.company != b.company ? (a.company - b.company) : (a.age - b.age));

        // 有序表对于可以比较的，无需多余参数
        // 有序表对于自定义类这种无法比较的，需要我们自定义比较器
        TreeSet<Employee> treeSet1 = new TreeSet<>(new EmployeeComparator());

        // 默认的有序表会自动去重
        // 不想去充，需要定制比较器
        TreeSet<Employee> treeSet2 = new TreeSet<>(
                (a, b) -> a.company != b.company ? (a.company - b.company)
                        : (a.age != b.age ? (a.age - b.age) : a.toString().compareTo(b.toString())));
    }
}
```



**字符串比大小**



```java
// 字典序
String str1 = "ab";
String str2 = "b";
// 小于0，第一个字符串小于第二个字符串
// 等于0，第一个字符串等于第二个字符串
// 大于0，第一个字符串大于第二个字符串
System.out.println(str1.compareTo(str2));
```



***



# ✅027【必备】堆结构常见题



## [Leetcode【难】LCR078.合并 K 个升序列表](https://leetcode.cn/problems/vvXgSW/description/)



**K 条链表，N 个节点**



* 时间复杂度：



  * $$O(N*logK)$$（最多 K 个元素的堆排序）



* 空间复杂度：



  * $$O(K)$$（堆中最多 K 个元素）



```java
import java.util.PriorityQueue;

public class Solution {

    public static class ListNode {
        public int val;
        public ListNode next;

        public ListNode() {
        }

        public ListNode(int val) {
            this.val = val;
        }

        public ListNode(int val, ListNode next) {
            this.val = val;
            this.next = next;
        }
    }

    public static ListNode mergeKLists(ListNode[] arr) {
        // 小根堆
        PriorityQueue<ListNode> heap = new PriorityQueue<>((a, b) -> a.val - b.val);
        for (ListNode h : arr) {
            if (h != null) {
                heap.add(h);
            }
        }
        // 如果全部为空
        if (heap.isEmpty()) {
            return null;
        }
        // 头节点
        ListNode h = heap.poll();
        ListNode pre = h;
        if (pre.next != null) {
            heap.add(pre.next);
        }
        while (!heap.isEmpty()) {
            ListNode cur = heap.poll();
            pre.next = cur;
            pre = cur;
            if (cur.next != null) {
                heap.add(cur.next);
            }
        }
        return h;
    }
}
```



## [牛客【】线段重合\*\*](https://www.nowcoder.com/practice/1ae8d0b6bb4e4bcdbf64ec491f63fc37)



```java
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StreamTokenizer;
import java.util.Arrays;

public class Solution {
    public static int MAXN = 10001;

    public static int[][] line = new int[MAXN][2];

    public static int n;
    // 小根堆
    public static int[] heap = new int[MAXN];
    // 堆的大小
    public static int size;

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            for (int i = 0; i < n; i++) {
                in.nextToken();
                line[i][0] = (int) in.nval;
                in.nextToken();
                line[i][1] = (int) in.nval;
            }
            out.println(compute());
        }
        out.flush();
        br.close();
        out.close();
    }

    public static int compute() {
        // 清空堆
        size = 0;

        Arrays.sort(line, 0, n, (a, b) -> a[0] - b[0]);

        int ans = 0;
        for (int i = 0; i < n; i++) {
            while (size > 0 && heap[0] <= line[i][0]) {
                pop();
            }
            add(line[i][1]);
            ans = Math.max(ans, size);
        }
        return ans;
    }

    public static void add(int x) {
        heap[size] = x;
        int i = size++;
        while (heap[i] < heap[(i - 1) / 2]) {
            swap(i, (i - 1) / 2);
            i = (i - 1) / 2;
        }
    }

    public static void pop() {
        swap(0, --size);
        int i = 0, l = 1;
        while (l < size) {
            int best = l + 1 < size && heap[l + 1] < heap[l] ? l + 1 : l;
            best = heap[best] < heap[i] ? best : i;
            if (best == i) {
                break;
            }
            swap(i, best);
            i = best;
            l = i * 2 + 1;
        }
    }

    public static void swap(int i, int j) {
        int tmp = heap[i];
        heap[i] = heap[j];
        heap[j] = tmp;
    }
}
```



## [Leetcode【中】2406. 将区间分为最少组数](https://leetcode.cn/problems/minimum-operations-to-halve-array-sum/description/)



```java
class Solution {
    public int minGroups(int[][] intervals) {
        int n = intervals.length;
        Arrays.sort(intervals, (a, b) -> a[0] - b[0]);
        PriorityQueue<Integer> heap = new PriorityQueue<>();
        int ans = 0;
        for (int i = 0; i < n; i++) {
            while (!heap.isEmpty() && heap.peek() < intervals[i][0]) {
                heap.poll();
            }
            heap.add(intervals[i][1]);
            ans = Math.max(ans, heap.size());
        }
        return ans;
    }
}
```



## [Leetcode【中】2208. 将数组和减半的最少操作次数](https://leetcode.cn/problems/minimum-operations-to-halve-array-sum/description/)



```java
import java.util.PriorityQueue;

public class Solution {
    public int halveArray(int[] nums) {
        return halveArray2(nums);
    }

    public static int halveArray1(int[] nums) {
        PriorityQueue<Double> heap = new PriorityQueue<>((a, b) -> b.compareTo(a));
        double sum = 0;
        for (int num : nums) {
            heap.add((double) num);
            sum += num;
        }
        sum /= 2;
        int ans = 0;
        for (double minus = 0, cur; minus < sum; ans++, minus += cur) {
            cur = heap.poll() / 2;
            heap.add(cur);
        }
        return ans;
    }

    public static int MAXN = 100001;
    public static long[] heap = new long[MAXN];
    public static int size;

    public static int halveArray2(int[] nums) {
        size = nums.length;
        long sum = 0;
        for (int i = size - 1; i >= 0; i--) {
            heap[i] = (long) nums[i] << 20;
            sum += heap[i];
            heapify(i);
        }
        sum /= 2;
        int ans = 0;
        for (long minus = 0; minus < sum; ans++) {
            heap[0] /= 2;
            minus += heap[0];
            heapify(0);
        }
        return ans;
    }

    public static void heapify(int i) {
        int l = i * 2 + 1;
        while (l < size) {
            int best = l + 1 < size && heap[l + 1] > heap[l] ? l + 1 : l;
            best = heap[best] > heap[i] ? best : i;
            if (best == i) {
                break;
            }
            swap(best, i);
            i = best;
            l = i * 2 + 1;
        }
    }

    public static void swap(int i, int j) {
        long tmp = heap[i];
        heap[i] = heap[j];
        heap[j] = tmp;
    }
}
```



***



# ✅028【必备】基数排序



**基于比较的排序：**



* 只需要定义好两个对象之间怎么比较即可，对象的数据特征并不关心



**不急于比较的排序：**



* 和比较无关的排序，对数据的特征有要求



**计数排序、基数排序**对数据的数值范围有要求，否则的就值得使用



**基数排序**



* 技巧



  * 前缀数量分区



  * 数字提取某一位



* 时间复杂度：$$O(N*K)$$



* 空间复杂度：$$O(N+K)$$



```java
import java.util.Arrays;

public class Solution {
    public static int BASE = 10;

    public static int MAXN = 50001;

    public static int[] help = new int[MAXN];
    public static int[] cnts = new int[BASE];

    public static int[] sortArray(int[] arr) {
        if (arr.length > 1) {
            int n = arr.length;
            int min = arr[0];
            for (int i = 0; i < n; i++) {
                min = Math.min(min, arr[i]);
            }
            int max = 0;
            for (int i = 0; i < n; i++) {
                arr[i] -= min;
                max = Math.max(max, arr[i]);
            }
            radixSort(arr, n, bits(max));
            for (int i = 0; i < n; i++) {
                arr[i] += min;
            }
        }
        return arr;
    }

    public static int bits(int num) {
        int ans = 0;
        while (num > 0) {
            ans++;
            num /= BASE;
        }
        return ans;
    }

    // 基数排序（非负）
    // 对于存在负数的，所有数-min最后在+min
    public static int[] radixSort(int[] arr, int n, int bits) {
        for (int offset = 1; bits > 0; offset *= BASE, bits--) {
            Arrays.fill(cnts, 0);
            for (int i = 0; i < n; i++) {
                cnts[(arr[i] / offset) % BASE]++;
            }
            for (int i = 1; i < BASE; i++) {
                cnts[i] = cnts[i] + cnts[i - 1];
            }
            for (int i = n - 1; i >= 0; i--) {
                help[--cnts[(arr[i] / offset) % BASE]] = arr[i];
            }
            for (int i = 0; i < n; i++) {
                arr[i] = help[i];
            }
        }
        return arr;
    }
}
```



***



# ✅029【必备】重要排序算法总结



**稳定性**



* 同样大小的样本在排序前后的相对位置保持不变



|                     | 时间复杂度        | 空间复杂度   | 稳定性 |
| ------------------- | ------------ | ------- | --- |
| 选择排序（SelectionSort） | O(N^2)       | O(1)    | ✕   |
| 冒泡排序（BubbleSort）    | O(N^2)       | O(1)    | ✓   |
| 插入排序（InsertionSort） | O(N^2)       | O(1)    | ✓   |
| 归并排序（MergeSort）     | O(N\*logN) | O(N)    | ✓   |
| 快速排序（QuickSort）     | O(N\*logN) | O(logN) | ✕   |
| 堆排序（HeapSort）       | O(N\*logN) | O(1)    | ✕   |
| 计数排序（CountSort）     | O(N)         | O(M)    | ✓   |
| 基数排序（RadixSort）     | O(N)         | O(M)    | ✓   |



**算法选择**



* 数据量非常小做到非常迅速：插入排序



* 性能优异、实现简单、不在乎稳定性：随机快排



* 性能优异、不在乎额外空间、具有稳定性：归并排序



* 性能优异，对额外空间有要求、不在乎稳定性：堆排序



***



# ✅030【必备】异或运算



**异或运算**



* 无进位相加



  * 01101110^10011101=11110011



* 满足交换律和结合律



* 若 A^B=C→A=B^C



**两数交换**



```java
// 异或交换两个数（两个数的内存位置需要不同）
int a = 10;
int b = 20;
a = a ^ b;
// b=(a^b)^b
b = a ^ b;
a = a ^ b;
```



## [牛客【】两数较大者](https://www.nowcoder.com/practice/d2707eaf98124f1e8f1d9c18ad487f76)



```java
public class Solution {

    // 0变1，1变0
    public static int flip(int n) {
        return n ^ 1;
    }

    // 非负数返回1
    // 负数返回0
    public static int sign(int n) {
        return flip(n >>> 31);
    }

    // 可能溢出
    public static int getMax1(int a, int b) {
        int c = a - b;
        // c<0,a<b,returnA=0,returnB=1
        // c>0,a>b,returnA=1,returnB=0
        int returnA = sign(c);
        int returnB = flip(returnA);
        return a * returnA + b * returnB;
    }

    // 没有任何问题
    public static int getMax2(int a, int b) {
        int c = a - b;
        // a的符号
        int sa = sign(a);
        // b的符号
        int sb = sign(b);
        // c的符号
        // sc>0,a>b
        // sc<0,a<b
        int sc = sign(c);
        // a和b的符号
        int diffAB = sa ^ sb;
        int sameAB = flip(diffAB);
        int returnA = diffAB * sa + sameAB * sc;
        int returnB = flip(returnA);
        return a * returnA + b * returnB;
    }
}
```



## [Leetcode【易】268.丢失的数字](https://leetcode.cn/problems/missing-number/description/)



```java
public class Solution {
    public static int missingNumber(int[] nums) {
        int eorAll = 0, eorHave = 0;
        for (int i = 0; i < nums.length; i++) {
            eorAll ^= i;
            eorHave ^= nums[i];
        }
        eorAll ^= nums.length;
        return eorAll ^ eorHave;
    }
}
```



## [Leetcode【易】136.只出现一次的数字](https://leetcode.cn/problems/single-number/description/)



```java
public class Solution {
    public int singleNumber(int[] nums) {
        int eor = 0;
        for (int num : nums) {
            eor ^= num;
        }
        return eor;
    }
}
```



## Brian Kernighan 算法



提取出二进制状态中最右侧的 1：A&（～ A+1），也就是 A 和 A 的补码取与



## [Leetcode【中】260.只出现一次的数字 III](https://leetcode.cn/problems/single-number-iii/description/)



```java
public class Solution {
    public int[] singleNumber(int[] nums) {
        int eor1 = 0;
        for (int num : nums) {
            eor1 ^= num;
        }
        // eor1=a^b
        // 提取a和b一定不一样的一位（最右侧的1）
        int rightOne = eor1 & (-eor1);
        int eor2 = 0;
        for (int num : nums) {
            if ((num & rightOne) == 0) {
                eor2 ^= num;
            }
        }
        return new int[] { eor2, eor1 ^ eor2 };
    }
}
```



## [Leetcode【易】137.只出现一次的数字 II](https://leetcode.cn/problems/single-number-ii/description/)



```java
public class Solution {

    public int singleNumber(int[] nums) {
        return findSingleNumber(nums, 3);
    }

    public int findSingleNumber(int[] nums, int m) {
        int[] cnts = new int[32];
        for (int num : nums) {
            for (int i = 0; i < 32; i++) {
                cnts[i] += (num >> i) & 1;
            }
        }
        int ans = 0;
        for (int i = 0; i < 32; i++) {
            if (cnts[i] % m != 0) {
                ans |= 1 << i;
            }
        }
        return ans;
    }
}
```



***



# ✅031【必备】位运算



## [Leetcode【易】231.2 的幂](https://leetcode.cn/problems/power-of-two/description/)



```java
class Solution {
    public boolean isPowerOfTwo(int n) {
        // 2的幂，二进制只有一个1
        return n > 0 && n == (n & -n);
    }
}
```



## [Leetcode【易】326.3 的幂](https://leetcode.cn/problems/power-of-three/description/)



```java
class Solution {
    public boolean isPowerOfThree(int n) {
        // 一个数是3的幂，那么这个数一定只含有3这个质数因子
        // 1162261467是int范围内，最大的3的幂，是3的19次方
        // 如果一个数是3的幂，那么他一定可以被上述的数整除
        return n > 0 && 1162261467 % n == 0;
    }

    public static void main(String[] args) {
        System.out.println(Integer.MAX_VALUE);
        long max = 1;
        int count = 0;
        // System.out.println(max);
        while (max < Integer.MAX_VALUE / 3) {
            max *= 3;
            count++;
        }
        System.out.println(max);
        System.out.println(count);
    }
}
```



返回大于等于 n 的最小 2 次幂



```java
public class Solution{
    public static int near2MinPower(int n){
        if(n<=0){
            return 1;
        }
        n--;
        n|=n>>>1;
        n|=n>>>2;
        n|=n>>>4;
        n|=n>>>8;
        n|=n>>>16;
        return ++n;
    }

    public static void main(String[] args) {
        int n = 100;
        System.out.println(near2MinPower(n));
    }
}
```



## [Leetcode【中】201.数字范围按位与](https://leetcode.cn/problems/bitwise-and-of-numbers-range/description/)



```java
public class Solution {
    public int rangeBitwiseAnd(int left, int right) {
        while (left < right) {
            // 去掉right的二进制表示中最右边的1
            right -= (right & -right);
        }
        return right;
    }
}
```



## [Leetcode【易】190.颠倒二进位制](https://leetcode.cn/problems/reverse-bits/)



```java
public class Solution {
    public int reverseBits(int n) {
        n = ((n & 0Xaaaaaaaa) >>> 1 | (n & 0X55555555) << 1);
        n = ((n & 0Xcccccccc) >>> 2 | (n & 0X33333333) << 2);
        n = ((n & 0Xf0f0f0f0) >>> 4 | (n & 0X0f0f0f0f) << 4);
        n = ((n & 0Xff00ff00) >>> 8 | (n & 0X00ff00ff) << 8);
        n = (n >>> 16) | (n << 16);
        return n;
    }
}
```



## [Leetcode【易】461.汉明距离](https://leetcode.cn/problems/hamming-distance/description/)



&#x20;[汉明距离](https://baike.baidu.com/item/%E6%B1%89%E6%98%8E%E8%B7%9D%E7%A6%BB) ：这两个数字对应二进制位不同的位置的数目。



```java
class Solution {
    public int hammingDistance(int x, int y) {
        return countOnes(x ^ y);
    }

    public static int countOnes(int n) {
        n = (n & 0X55555555) + ((n >>> 1) & 0X55555555);
        n = (n & 0X33333333) + ((n >>> 2) & 0X33333333);
        n = (n & 0X0f0f0f0f) + ((n >>> 4) & 0X0f0f0f0f);
        n = (n & 0X00ff00ff) + ((n >>> 8) & 0X00ff00ff);
        n = (n & 0X0000ffff) + ((n >>> 16) & 0X0000ffff);
        return n;
    }
}
```



***



# ✅032【必备】位图



**位图**



* 用 bit 组成的数组存放值，用 bit 状态 1、0 代表存在或不存在，取值和存值操作都使用位运算



* 限制



  * 必须为连续范围且不能过大



* 好处



  * 极大节省空间



```java
import java.util.HashSet;

public class Solution {

    public static class Bitset {
        public int[] set;

        public Bitset(int n) {
            // a/b如果想要向上取整
            // (a+b-1)/b
            set = new int[(n + 31) / 32];
        }

        public void add(int num) {
            set[num / 32] |= 1 << (num % 32);
        }

        public void remove(int num) {
            set[num / 32] &= ~(1 << (num % 32));
        }

        public void reverse(int num) {
            set[num / 32] ^= 1 << (num % 32);
        }

        public boolean contains(int num) {
            return ((set[num / 32] >> (num % 32)) & 1) == 1;
        }
    }

    public static void main(String[] args) {
        int n = 1000;
        int testTime = 1000;
        Bitset bitset = new Bitset(n);
        HashSet<Integer> hashSet = new HashSet<>();
        for (int i = 0; i < testTime; i++) {
            double decide = Math.random();
            int number = (int) (Math.random() * n);
            if (decide < 0.33) {
                bitset.add(number);
                hashSet.add(number);
            } else if (decide < 0.66) {
                bitset.remove(number);
                hashSet.remove(number);
            } else {
                bitset.reverse(number);
                if (hashSet.contains(number)) {
                    hashSet.remove(number);
                } else {
                    hashSet.add(number);
                }
            }
        }
        for (int i = 0; i < n; i++) {
            if (bitset.contains(i) != hashSet.contains(i)) {
                System.out.println("出错了");
            }
        }
        System.out.println("测试结束");
    }
}
```



## [Leetcode【中】2166.设计位集](https://leetcode.cn/problems/design-bitset/description/)



```java
public class Solution {
    public class Bitset {

        private int[] set;
        private final int size;
        private int zeros;
        private int ones;
        private boolean reverse;

        // 初始化n个位，所有位都是0
        public Bitset(int n) {
            set = new int[(n + 31) / 32];
            size = n;
            zeros = n;
            ones = 0;
            reverse = false;
        }

        // 把idx位置的数字加入到位图
        public void fix(int idx) {
            int index = idx / 32;
            int bit = idx % 32;
            if (!reverse) {
                // 位图所有位维持原始含义
                // 0：不存在
                // 1：存在
                if ((set[index] & (1 << bit)) == 0) {
                    zeros--;
                    ones++;
                    set[index] |= (1 << bit);
                }
            } else {
                // 位图所有位的状态已经反转
                // 0：存在
                // 1：不存在
                if ((set[index] & (1 << bit)) != 0) {
                    zeros--;
                    ones++;
                    set[index] ^= (1 << bit);
                }
            }
        }

        // 把idx位置的数字从位图中移除
        public void unfix(int idx) {
            int index = idx / 32;
            int bit = idx % 32;
            if (!reverse) {
                if ((set[index] & (1 << bit)) != 0) {
                    ones--;
                    zeros++;
                    set[index] ^= (1 << bit);
                }
            } else {
                if ((set[index] & (1 << bit)) == 0) {
                    ones--;
                    zeros++;
                    set[index] |= (1 << bit);
                }
            }
        }

        // 把位图所有位的状态反转
        public void flip() {
            reverse = !reverse;
            int tmp = zeros;
            zeros = ones;
            ones = tmp;
        }

        // 检查位图是否所有位都是1
        public boolean all() {
            return ones == size;
        }

        // 检查位图是否至少有一个位是1
        public boolean one() {
            return ones > 0;
        }

        // 检查位图中1的个数
        public int count() {
            return ones;
        }

        // 返回位图中的所有位
        public String toString() {
            StringBuilder sb = new StringBuilder();
            for (int i = 0, k = 0, number, status; i < size; k++) {
                number = set[k];
                for (int j = 0; j < 32 && i < size; j++, i++) {
                    status = (number >> j) & 1;
                    status ^= reverse ? 1 : 0;
                    sb.append(status);
                }
            }
            return sb.toString();
        }
    }
}
```



***



# ✅033【必备】位运算实现加减乘除



* ➕：利用每一步的无进位相加的结果+进位记录不停计算，直到进位消失



* ➖：利用加法，和一个数字 x 的相反数（～ x+1）相加



* ✖️：小学乘法



* ➗：为了防止溢出，被除数右移，而不是除数左移，从高位到低位依次尝试



## [Leetcode【中】29.两数相除](https://leetcode.cn/problems/divide-two-integers/description/)



```java
public class Solution {
    // !!!a+b
    public static int add(int a, int b) {
        int ans = a;
        while (b != 0) {
            // ans：a和b的无进位相加结果
            ans = a ^ b;
            // b：a和b相加时的进位信息
            // a和b与上同为1时则需要进位
            b = (a & b) << 1;
            a = ans;
        }
        return ans;
    }

    // a-b
    public static int minus(int a, int b) {
        return add(a, neg(b));
    }

    // n的相反数
    public static int neg(int n) {
        return add(~n, 1);
    }

    // a*b
    public static int multiply(int a, int b) {
        int ans = 0;
        while (b != 0) {
            // b的最低位为1时，ans需要加上a
            if ((b & 1) == 1) {
                ans = add(ans, a);
            }
            // a左移一位，b右移一位
            a <<= 1;
            b >>>= 1;
        }
        return ans;
    }

    // a/b（a和b都不是整数最小值）
    // 整数最小转换不了绝对值
    public static int div(int a, int b) {
        int x = a < 0 ? neg(a) : a;
        int y = b < 0 ? neg(b) : b;
        int ans = 0;
        for (int i = 30; i >= 0; i = minus(i, 1)) {
            if ((x >> i) >= y) {
                ans |= (1 << i);
                x = minus(x, y << i);
            }
        }
        return a < 0 ^ b < 0 ? neg(ans) : ans;
    }

    // MIN_VALUE= -2147483648
    // MAX_VLAUE= 2147483648
    public static int MIN = Integer.MIN_VALUE;

    // 所有情况的整除运算
    // 结果>0向下取整
    // 结果<0向上取整
    public static int divide(int a, int b) {
        if (a == MIN && b == MIN) {
            return 1;
        }
        if (a != MIN && b != MIN) {
            return div(a, b);
        }
        if (b == MIN) {
            return 0;
        }
        if (a == MIN && b == neg(1)) {
            return Integer.MAX_VALUE;
        }
        if (a == MIN) {
            a = add(a, b > 0 ? b : neg(b));
            int ans = div(a, b);
            return add(ans, b > 0 ? neg(1) : 1);
        }
        return 0;
    }
}
```



***



# ✅034【必备】链表高频题和必备技巧



## [Leetcode【易】160.相交链表](https://leetcode.cn/problems/intersection-of-two-linked-lists/description/)



```java
public class Solution {
    public static class ListNode {
        public int val;
        public ListNode next;
    }

    public static ListNode getIntersectionNode(ListNode h1, ListNode h2) {
        if (h1 == null || h2 == null) {
            return null;
        }
        ListNode a = h1, b = h2;
        int diff = 0;
        while (a.next != null) {
            a = a.next;
            diff++;
        }
        while (b.next != null) {
            b = b.next;
            diff--;
        }
        if (a != b) {
            return null;
        }
        if (diff >= 0) {
            a = h1;
            b = h2;
        } else {
            a = h2;
            b = h1;
        }
        diff = Math.abs(diff);
        while (diff-- != 0) {
            a = a.next;
        }
        while (a != b) {
            a = a.next;
            b = b.next;
        }
        return a;
    }
}
```



## [Leetcode【难】25.K 个一组翻转链表](https://leetcode.cn/problems/reverse-nodes-in-k-group/description/)



```java
public class Solution {
    public static class ListNode {
        public int val;
        public ListNode next;
    }

    public static ListNode reverseKGroup(ListNode head, int k) {
        ListNode start = head;
        ListNode end = teamEnd(start, k);
        if (end == null) {
            return head;
        }
        // 第一组单独分析
        head = end;
        reverse(start, end);
        ListNode lastTeamEnd = start;
        while (lastTeamEnd.next != null) {
            start = lastTeamEnd.next;
            end = teamEnd(start, k);
            if (end == null) {
                return head;
            }
            reverse(start, end);
            lastTeamEnd.next = end;
            lastTeamEnd = start;
        }
        return head;
    }

    // 从当前组开始节点s，往下数k个找到当前组的结束节点返回
    public static ListNode teamEnd(ListNode s, int k) {
        while (--k != 0 && s != null) {
            s = s.next;
        }
        return s;
    }

    // 翻转链表
    // s -> a -> b -> c -> e -> 下一组的开始节点
    // e -> c -> b -> a -> s -> 下一组的开始节点
    public static void reverse(ListNode s, ListNode e) {
        e = e.next;
        ListNode pre = null, cur = s, next = null;
        while (cur != e) {
            next = cur.next;
            cur.next = pre;
            pre = cur;
            cur = next;
        }
        s.next = e;
    }
}
```



## [Leetcode【中】138.随机链表的复制](https://leetcode.cn/problems/copy-list-with-random-pointer/description/)



```java
public class Solution {
    public static class Node {
        public int val;
        public Node next;
        public Node random;

        public Node(int v) {
            val = v;
        }
    }

    public static Node copyRandomList(Node head) {
        if (head == null) {
            return null;
        }
        Node cur = head;
        Node next = null;
        // 1 -> 2 -> 3 -> ...
        // 1 -> 1' -> 2 -> 2' -> 3 -> 3' -> ...
        while (cur != null) {
            next = cur.next;
            cur.next = new Node(cur.val);
            cur.next.next = next;
            cur = next;
        }
        cur = head;
        Node copy = null;
        // 设置每一个节点的random指针
        while (cur != null) {
            next = cur.next.next;
            copy = cur.next;
            copy.random = cur.random != null ? cur.random.next : null;
            cur = next;
        }
        Node ans = head.next;
        cur = head;
        // 新老链表分离
        while (cur != null) {
            next = cur.next.next;
            copy = cur.next;
            cur.next = next;
            copy.next = next != null ? next.next : null;
            cur = next;
        }
        // 返回新链表头节点
        return ans;
    }
}
```



## [Leetcode【易】234.回文链表](https://leetcode.cn/problems/palindrome-linked-list/description/)



```java
public class Solution {
    public static class ListNode {
        public int val;
        public ListNode next;
    }

    public static boolean isPalindrome(ListNode head) {
        if (head == null || head.next == null) {
            return true;
        }
        ListNode slow = head, fast = head;
        // 找中点
        while (fast.next != null && fast.next.next != null) {
            slow = slow.next;
            fast = fast.next.next;
        }
        // 后半截链表逆序
        ListNode pre = slow;
        ListNode cur = slow.next;
        ListNode next = null;
        pre.next = null;
        while (cur != null) {
            next = cur.next;
            cur.next = pre;
            pre = cur;
            cur = next;
        }
        // head -> ... -> slow <- ... <- pre
        boolean ans = true;
        ListNode left = head;
        ListNode right = pre;
        while (left != null && right != null) {
            if (left.val != right.val) {
                ans = false;
                break;
            }
            left = left.next;
            right = right.next;
        }
        // 链表返回原来状态
        // head -> ... -> (head)slow(pre) <- ... <- pre
        cur = pre.next;
        pre.next = null;
        next = null;
        while (cur != null) {
            next = cur.next;
            cur.next = pre;
            pre = cur;
            cur = next;
        }
        return ans;
    }
}
```



## [Leetcode【中】142.环形链表 II](https://leetcode.cn/problems/linked-list-cycle-ii/description/)



```java
public class Solution {
    public static class ListNode {
        public int val;
        public ListNode next;
    }

    public static ListNode detectCycle(ListNode head) {
        if (head == null || head.next == null || head.next.next == null) {
            return null;
        }
        ListNode slow = head.next;
        ListNode fast = head.next.next;
        while (slow != fast) {
            if (fast.next == null || fast.next.next == null) {
                return null;
            }
            slow = slow.next;
            fast = fast.next.next;
        }
        fast = head;
        while (slow != fast) {
            slow = slow.next;
            fast = fast.next;
        }
        return slow;
    }
}
```



## [Leetcode【中】148.排序链表](https://leetcode.cn/problems/sort-list/description/)



```java
public class Solution {
    public static class ListNode {
        public int val;
        public ListNode next;
    }

    // 时间复杂度O(N*logN)
    // 空间复杂度O(1)
    // 具有稳定性
    // 的链表排序算法
    public static ListNode sortList(ListNode head) {
        // 链表长度
        int n = 0;
        ListNode cur = head;
        while (cur != null) {
            n++;
            cur = cur.next;
        }
        // l1...r1 每组的左部分
        // l2...r2 每组的右部分
        // next 下一组的开头
        // lastTeamEnd 上一组的结尾
        ListNode l1, r1, l2, r2, next, lastTeamEnd;
        for (int step = 1; step < n; step <<= 1) {
            // 第一组决定链表头部
            l1 = head;
            r1 = findEnd(l1, step);
            l2 = r1.next;
            r2 = findEnd(l2, step);
            next = r2.next;
            r1.next = null;
            r2.next = null;
            merge(l1, r1, l2, r2);
            head = start;
            lastTeamEnd = end;
            while (next != null) {
                l1 = next;
                r1 = findEnd(l1, step);
                l2 = r1.next;
                if (l2 == null) {
                    lastTeamEnd.next = l1;
                    break;
                }
                r2 = findEnd(l2, step);
                next = r2.next;
                r1.next = null;
                r2.next = null;
                merge(l1, r1, l2, r2);
                lastTeamEnd.next = start;
                lastTeamEnd = end;
            }
        }
        return head;
    }

    // 包括s在内，往下数k个节点返回
    // 如果不够，返回最后一个数的非空节点
    public static ListNode findEnd(ListNode s, int k) {
        while (s.next != null && --k != 0) {
            s = s.next;
        }
        return s;
    }

    public static ListNode start;
    public static ListNode end;

    // l1...r1->null
    // l2...r2->null
    public static void merge(ListNode l1, ListNode r1, ListNode l2, ListNode r2) {
        ListNode pre;
        if (l1.val <= l2.val) {
            start = l1;
            pre = l1;
            l1 = l1.next;
        } else {
            start = l2;
            pre = l2;
            l2 = l2.next;
        }
        while (l1 != null && l2 != null) {
            if (l1.val <= l2.val) {
                pre.next = l1;
                pre = l1;
                l1 = l1.next;
            } else {
                pre.next = l2;
                pre = l2;
                l2 = l2.next;
            }
        }
        if (l1 != null) {
            pre.next = l1;
            end = r1;
        } else {
            pre.next = l2;
            end = r2;
        }
    }
}
```



***



# ✅035【必备】数据结构设计高频题



## [牛客【】设计有 setAll 功能的哈希表](https://www.nowcoder.com/practice/7c4559f138e74ceb9ba57d76fd169967)



```java
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;
import java.io.StreamTokenizer;
import java.util.HashMap;

public class Soluion {

    public static HashMap<Integer, int[]> map = new HashMap<>();
    public static int setAllValue;
    public static int setAllTime;
    public static int cnt;

    public static void put(int k, int v) {
        if (map.containsKey(k)) {
            int[] value = map.get(k);
            value[0] = v;
            value[1] = cnt++;
        } else {
            map.put(k, new int[] { v, cnt++ });
        }
    }

    public static void setAll(int v) {
        setAllValue = v;
        setAllTime = cnt++;
    }

    public static int get(int k) {
        if (!map.containsKey(k)) {
            return -1;
        }
        int[] value = map.get(k);
        if (value[1] > setAllTime) {
            return value[0];
        } else {
            return setAllValue;
        }
    }

    public static int n, op, a, b;

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            map.clear();
            setAllValue = 0;
            setAllTime = -1;
            cnt = 0;
            n = (int) in.nval;
            for (int i = 0; i < n; i++) {
                in.nextToken();
                op = (int) in.nval;
                if (op == 1) {
                    in.nextToken();
                    a = (int) in.nval;
                    in.nextToken();
                    b = (int) in.nval;
                    put(a, b);
                } else if (op == 2) {
                    in.nextToken();
                    a = (int) in.nval;
                    out.println(get(a));
                } else {
                    in.nextToken();
                    a = (int) in.nval;
                    setAll(a);
                }
            }
        }
        out.flush();
        out.close();
        br.close();
    }
}
```



## [Leetcode【中】146.LRU 缓存](https://leetcode.cn/problems/lru-cache/)



```java
import java.util.HashMap;

public class Solution {
    class LRUCache {
        class DoubleNode {
            public int key;
            public int val;
            public DoubleNode last;
            public DoubleNode next;

            public DoubleNode(int k, int v) {
                key = k;
                val = v;
            }
        }

        class DoubleList {
            private DoubleNode head;
            private DoubleNode tail;

            public DoubleList() {
                head = null;
                tail = null;
            }

            public void addNode(DoubleNode newNode) {
                if (newNode == null) {
                    return;
                }
                if (head == null) {
                    head = newNode;
                    tail = newNode;
                } else {
                    tail.next = newNode;
                    newNode.last = tail;
                    tail = newNode;
                }
            }

            public void moveNodeToTail(DoubleNode node) {
                if (tail == node) {
                    return;
                }
                if (head == node) {
                    head = node.next;
                    head.last = null;
                } else {
                    node.last.next = node.next;
                    node.next.last = node.last;
                }
                node.last = tail;
                node.next = null;
                tail.next = node;
                tail = node;
            }

            public DoubleNode removHead() {
                if (head == null) {
                    return null;
                }
                DoubleNode ans = head;
                if (head == tail) {
                    head = null;
                    tail = null;
                } else {
                    head = ans.next;
                    ans.next = null;
                    head.last = null;
                }
                return ans;
            }
        }

        private HashMap<Integer, DoubleNode> keyNodeMap;
        private DoubleList nodeList;
        private final int capacity;

        public LRUCache(int cap) {
            keyNodeMap = new HashMap<>();
            nodeList = new DoubleList();
            capacity = cap;
        }

        public int get(int key) {
            if (keyNodeMap.containsKey(key)) {
                DoubleNode ans = keyNodeMap.get(key);
                nodeList.moveNodeToTail(ans);
                return ans.val;
            }
            return -1;
        }

        public void put(int key, int value) {
            if (keyNodeMap.containsKey(key)) {
                DoubleNode node = keyNodeMap.get(key);
                node.val = value;
                nodeList.moveNodeToTail(node);
            } else {
                if (keyNodeMap.size() == capacity) {
                    keyNodeMap.remove(nodeList.removHead().key);
                }
                DoubleNode newNode = new DoubleNode(key, value);
                keyNodeMap.put(key, newNode);
                nodeList.addNode(newNode);
            }
        }
    }
}
```



## [Leetcode【中】380.O（1）时间插入、删除和获取随机元素](https://leetcode.cn/problems/insert-delete-getrandom-o1/description/)



```java
import java.util.ArrayList;
import java.util.HashMap;

public class Solution {
    class RandomizedSet {
        public HashMap<Integer, Integer> map;
        public ArrayList<Integer> arr;

        public RandomizedSet() {
            map = new HashMap<>();
            arr = new ArrayList<>();
        }

        public boolean insert(int val) {
            if (map.containsKey(val)) {
                return false;
            }
            map.put(val, arr.size());
            arr.add(val);
            return true;
        }

        public boolean remove(int val) {
            if (!map.containsKey(val)) {
                return false;
            }
            int valIndex = map.get(val);
            int endValue = arr.get(arr.size() - 1);
            map.put(endValue, valIndex);
            arr.set(valIndex, endValue);
            map.remove(val);
            arr.remove(arr.size() - 1);
            return true;
        }

        public int getRandom() {
            return arr.get((int) (Math.random() * arr.size()));
        }
    }
}
```



## [Leetcode【难】381.O（1）时间插入、删除和获取随机元素——允许重复](https://leetcode.cn/problems/insert-delete-getrandom-o1-duplicates-allowed/description/)



```java
import java.util.HashMap;
import java.util.HashSet;
import java.util.ArrayList;

public class Solution {
    class RandomizedCollection {
        public HashMap<Integer, HashSet<Integer>> map;
        public ArrayList<Integer> arr;

        public RandomizedCollection() {
            map = new HashMap<>();
            arr = new ArrayList<>();
        }

        public boolean insert(int val) {
            arr.add(val);
            HashSet<Integer> set = map.getOrDefault(val, new HashSet<Integer>());
            set.add(arr.size() - 1);
            map.put(val, set);
            return set.size() == 1;
        }

        public boolean remove(int val) {
            if (!map.containsKey(val)) {
                return false;
            }
            HashSet<Integer> valSet = map.get(val);
            int valAnyIndex = valSet.iterator().next();
            int endValue = arr.get(arr.size() - 1);
            if (val == endValue) {
                valSet.remove(arr.size() - 1);
            } else {
                HashSet<Integer> endValueSet = map.get(endValue);
                endValueSet.add(valAnyIndex);
                arr.set(valAnyIndex, endValue);
                endValueSet.remove(arr.size() - 1);
                valSet.remove(valAnyIndex);
            }
            arr.remove(arr.size() - 1);
            if (valSet.isEmpty()) {
                map.remove(val);
            }
            return true;
        }

        public int getRandom() {
            return arr.get((int) (Math.random() * arr.size()));
        }

    }
}
```



## [Leetcode【难】295.数据流的中位数](https://leetcode.cn/problems/find-median-from-data-stream/)



```java
import java.util.PriorityQueue;

public class Solution {
    class MedianFinder {

        private PriorityQueue<Integer> maxHeap;
        private PriorityQueue<Integer> minHeap;

        public MedianFinder() {
            maxHeap = new PriorityQueue<>((a, b) -> b - a);
            minHeap = new PriorityQueue<>((a, b) -> a - b);
        }

        public void addNum(int num) {
            if (maxHeap.isEmpty() || maxHeap.peek() >= num) {
                maxHeap.add(num);
            } else {
                minHeap.add(num);
            }
            balance();
        }

        public double findMedian() {
            if (maxHeap.size() == minHeap.size()) {
                return (double) (maxHeap.peek() + minHeap.peek()) / 2;
            } else {
                return maxHeap.size() > minHeap.size() ? maxHeap.peek() : minHeap.peek();
            }
        }

        public void balance() {
            if (Math.abs(maxHeap.size() - minHeap.size()) == 2) {
                if (maxHeap.size() > minHeap.size()) {
                    minHeap.add(maxHeap.poll());
                } else {
                    maxHeap.add(minHeap.poll());
                }
            }
        }

    }
}
```



## [Leetcode【难】895.最大频率栈](https://leetcode.cn/problems/maximum-frequency-stack/description/)



```java
import java.util.HashMap;
import java.util.ArrayList;

public class Solution {
    class FreqStack {
        // 最大次数
        private int topTimes;
        // 每层节点
        private HashMap<Integer, ArrayList<Integer>> cntValues = new HashMap<>();
        // 每个数的出现次数
        private HashMap<Integer, Integer> valueTimes = new HashMap<>();

        public void push(int val) {
            valueTimes.put(val, valueTimes.getOrDefault(val, 0) + 1);
            int curTopTimes = valueTimes.get(val);
            if (!cntValues.containsKey(curTopTimes)) {
                cntValues.put(curTopTimes, new ArrayList<>());
            }
            ArrayList<Integer> curTimeValues = cntValues.get(curTopTimes);
            curTimeValues.add(val);
            topTimes = Math.max(topTimes, curTopTimes);
        }

        public int pop() {
            ArrayList<Integer> topTimeValues = cntValues.get(topTimes);
            int ans = topTimeValues.remove(topTimeValues.size() - 1);
            if (topTimeValues.size() == 0) {
                cntValues.remove(topTimes--);
            }
            int times = valueTimes.get(ans);
            if (times == 1) {
                valueTimes.remove(ans);
            } else {
                valueTimes.put(ans, times - 1);
            }
            return ans;
        }
    }
}
```



## [Leetcode【难】432.全 O（1）的数据结构](https://leetcode.cn/problems/all-oone-data-structure/description/)



```java
import java.util.HashMap;
import java.util.HashSet;

public class Solution {
    class AllOne {
        // 桶
        class Bucket {
            public HashSet<String> set;
            // 频次
            public int cnt;
            public Bucket last;
            public Bucket next;

            public Bucket(String s, int c) {
                set = new HashSet<>();
                set.add(s);
                cnt = c;
            }
        }

        public void insert(Bucket cur, Bucket pos) {
            cur.next.last = pos;
            pos.next = cur.next;
            cur.next = pos;
            pos.last = cur;
        }

        public void remove(Bucket cur) {
            cur.last.next = cur.next;
            cur.next.last = cur.last;
        }

        // 头桶：频次为0
        public Bucket head;
        // 尾桶：频次为整数最大值
        public Bucket tail;
        HashMap<String, Bucket> map;

        public AllOne() {
            head = new Bucket("", 0);
            tail = new Bucket("", Integer.MAX_VALUE);
            head.next = tail;
            tail.last = head;
            map = new HashMap<>();
        }

        public void inc(String key) {
            if (!map.containsKey(key)) {
                if (head.next.cnt == 1) {
                    map.put(key, head.next);
                    head.next.set.add(key);
                } else {
                    Bucket newBucket = new Bucket(key, 1);
                    map.put(key, newBucket);
                    insert(head, newBucket);
                }
            } else {
                Bucket bucket = map.get(key);
                if (bucket.next.cnt == bucket.cnt + 1) {
                    map.put(key, bucket.next);
                    bucket.next.set.add(key);
                } else {
                    Bucket newBucket = new Bucket(key, bucket.cnt + 1);
                    map.put(key, newBucket);
                    insert(bucket, newBucket);
                }
                bucket.set.remove(key);
                if (bucket.set.isEmpty()) {
                    remove(bucket);
                }
            }
        }

        public void dec(String key) {
            Bucket bucket = map.get(key);
            if (bucket.cnt == 1) {
                map.remove(key);
            } else {
                if (bucket.last.cnt == bucket.cnt - 1) {
                    map.put(key, bucket.last);
                    bucket.last.set.add(key);
                } else {
                    Bucket newBucket = new Bucket(key, bucket.cnt - 1);
                    map.put(key, newBucket);
                    insert(bucket.last, newBucket);
                }
            }
            bucket.set.remove(key);
            if (bucket.set.isEmpty()) {
                remove(bucket);
            }
        }

        public String getMaxKey() {
            return tail.last.set.iterator().next();
        }

        public String getMinKey() {
            return head.next.set.iterator().next();
        }

    }
}
```



***



# ✅036【必备】二叉树高频题目—上—不含树型 dp



## [Leetcode【中】102.二叉树的层序遍历](https://leetcode.cn/problems/binary-tree-level-order-traversal/description/)



```java
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Queue;

public class Solution {
    public static class TreeNode {
        public int val;
        public TreeNode left;
        public TreeNode right;

        public TreeNode() {
        }

        public TreeNode(int val) {
            this.val = val;
        }

        public TreeNode(int val, TreeNode left, TreeNode right) {
            this.val = val;
            this.left = left;
            this.right = right;
        }
    }

    public static List<List<Integer>> levelOrder1(TreeNode root) {
        List<List<Integer>> ans = new ArrayList<>();
        if (root != null) {
            Queue<TreeNode> queue = new LinkedList<>();
            HashMap<TreeNode, Integer> levels = new HashMap<>();
            queue.add(root);
            levels.put(root, 0);
            while (!queue.isEmpty()) {
                TreeNode cur = queue.poll();
                int level = levels.get(cur);
                if (ans.size() == level) {
                    ans.add(new ArrayList<>());
                }
                ans.get(level).add(cur.val);
                if (cur.left != null) {
                    queue.add(cur.left);
                    levels.put(cur.left, level + 1);
                }
                if (cur.right != null) {
                    queue.add(cur.right);
                    levels.put(cur.right, level + 1);
                }
            }
        }
        return ans;
    }

    public static int MAXN = 2001;
    public static TreeNode[] queue = new TreeNode[MAXN];
    public static int l, r;

    public static List<List<Integer>> levelOrder2(TreeNode root) {
        List<List<Integer>> ans = new ArrayList<>();
        if (root != null) {
            l = r = 0;
            queue[r++] = root;
            while (l < r) {
                int size = r - l;
                ArrayList<Integer> list = new ArrayList<>();
                for (int i = 0; i < size; i++) {
                    TreeNode cur = queue[l++];
                    list.add(cur.val);
                    if (cur.left != null) {
                        queue[r++] = cur.left;
                    }
                    if (cur.right != null) {
                        queue[r++] = cur.right;
                    }
                }
                ans.add(list);
            }
        }
        return ans;
    }
}
```



## [Leetcode【中】103.二叉树的锯齿形层序遍历](https://leetcode.cn/problems/binary-tree-zigzag-level-order-traversal/description/)



```java
import java.util.ArrayList;
import java.util.List;

public class Solution {
    public static class TreeNode {
        public int val;
        public TreeNode left;
        public TreeNode right;

        public TreeNode() {
        }

        public TreeNode(int val) {
            this.val = val;
        }

        public TreeNode(int val, TreeNode left, TreeNode right) {
            this.val = val;
            this.left = left;
            this.right = right;
        }
    }

    public static int MAXN = 2001;
    public static TreeNode[] queue = new TreeNode[MAXN];
    public static int l, r;

    public static List<List<Integer>> zigzagLevelOrder(TreeNode root) {
        List<List<Integer>> ans = new ArrayList<>();
        if (root != null) {
            l = r = 0;
            queue[r++] = root;
            // false:从左往右
            // true:从右往左
            boolean reverse = false;
            while (l < r) {
                int size = r - l;
                ArrayList<Integer> list = new ArrayList<Integer>();
                for (int i = reverse ? r - 1 : l, j = reverse ? -1 : 1, k = 0; k < size; i += j, k++) {
                    TreeNode cur = queue[i];
                    list.add(cur.val);
                }
                for (int i = 0; i < size; i++) {
                    TreeNode cur = queue[l++];
                    if (cur.left != null) {
                        queue[r++] = cur.left;
                    }
                    if (cur.right != null) {
                        queue[r++] = cur.right;
                    }
                }
                ans.add(list);
                reverse = !reverse;
            }
        }
        return ans;
    }
}
```



## [Leetcode【中】662.二叉树最大宽度](https://leetcode.cn/problems/maximum-width-of-binary-tree/description/)



```java
public class Solution {
    public static class TreeNode {
        public int val;
        public TreeNode left;
        public TreeNode right;

        public TreeNode() {
        }

        public TreeNode(int val) {
            this.val = val;
        }

        public TreeNode(int val, TreeNode left, TreeNode right) {
            this.val = val;
            this.left = left;
            this.right = right;
        }
    }

    public static int MAXN = 3001;
    public static TreeNode[] nq = new TreeNode[MAXN];
    public static long[] iq = new long[MAXN];
    public static int l, r;

    public static int widthOfBinaryTree(TreeNode root) {
        int ans = 1;
        l = r = 0;
        nq[r] = root;
        iq[r++] = 1;
        while (l < r) {
            int size = r - l;
            ans = Math.max(ans, (int) (iq[r - 1] - iq[l] + 1));
            for (int i = 0; i < size; i++) {
                TreeNode node = nq[l];
                long id = iq[l++];
                if (node.left != null) {
                    nq[r] = node.left;
                    iq[r++] = id * 2;
                }
                if (node.right != null) {
                    nq[r] = node.right;
                    iq[r++] = id * 2 + 1;
                }
            }
        }
        return ans;
    }
}
```



## [Leetcode【易】104.二叉树的最大深度](https://leetcode.cn/problems/maximum-depth-of-binary-tree/description/)



```java
public static int maxDepth(TreeNode root) {
    return root == null ? 0 : Math.max(maxDepth(root.left), maxDepth(root.right)) + 1;
}
```



## [Leetcode【易】111.二叉树的最小深度](https://leetcode.cn/problems/minimum-depth-of-binary-tree/description/)



```java
public static int minDepth(TreeNode root) {
    // 空树
    if (root == null) {
        return 0;
    }
    // 叶子节点
    if (root.left == null && root.right == null) {
        return 1;
    }
    int lDeep = Integer.MAX_VALUE;
    int rDeep = Integer.MAX_VALUE;
    if (root.left != null) {
        lDeep = minDepth(root.left);
    }
    if (root.right != null) {
        rDeep = minDepth(root.right);
    }
    return Math.min(lDeep, rDeep) + 1;
}
```



## [Leetcode【难】297.二叉树的序列化和反序列化](https://leetcode.cn/problems/serialize-and-deserialize-binary-tree/description/)



**中序遍历**无法完成序列化与反序列化



```java
//         __2
//        /
//       1
//       和
//       1__
//          \
//           2
// 补足空位置的中序遍历结果都是{ null, 1, null, 2, null}
```



**先序序列**



```java
public class Codec {
    public String serialize(TreeNode root) {
        StringBuilder sb = new StringBuilder();
        f(root, sb);
        return sb.toString();
    }

    public void f(TreeNode root, StringBuilder sb) {
        if (root == null) {
            sb.append("#,");
        } else {
            sb.append(root.val + ",");
            f(root.left, sb);
            f(root.right, sb);
        }
    }

    public static int cnt;

    public TreeNode deserialize(String str) {
        String[] vals = str.split(",");
        cnt = 0;
        return g(vals);
    }

    public TreeNode g(String[] vals) {
        String cur = vals[cnt++];
        if (cur.equals("#")) {
            return null;
        } else {
            TreeNode head = new TreeNode(Integer.valueOf(cur));
            head.left = g(vals);
            head.right = g(vals);
            return head;
        }
    }
}
```



**层序遍历**



```java
public class Codec {
    public static int MAXN = 10001;
    public static TreeNode[] queue = new TreeNode[MAXN];
    public static int l, r;

    public String serialize(TreeNode root) {
        StringBuilder sb = new StringBuilder();
        if (root != null) {
            sb.append(root.val + ",");
            l = 0;
            r = 0;
            queue[r++] = root;
            while (l < r) {
                root = queue[l++];
                if (root.left != null) {
                    sb.append(root.left.val + ",");
                    queue[r++] = root.left;
                } else {
                    sb.append("#,");
                }
                if (root.right != null) {
                    sb.append(root.right.val + ",");
                    queue[r++] = root.right;
                } else {
                    sb.append("#,");
                }
            }
        }
        return sb.toString();
    }

    public TreeNode deserialize(String str) {
        if (str.equals("")) {
            return null;
        }
        String[] nodes = str.split(",");
        int index = 0;
        TreeNode root = generate(nodes[index++]);
        l = 0;
        r = 0;
        queue[r++] = root;
        while (l < r) {
            TreeNode cur = queue[l++];
            cur.left = generate(nodes[index++]);
            cur.right = generate(nodes[index++]);
            if (cur.left != null) {
                queue[r++] = cur.left;
            }
            if (cur.right != null) {
                queue[r++] = cur.right;
            }
        }
        return root;
    }

    public TreeNode generate(String val) {
        return val.equals("#") ? null : new TreeNode(Integer.valueOf(val));
    }
}
```



## [Leetcode【中】105.从前序与中序遍历序列构造二叉树](https://leetcode.cn/problems/construct-binary-tree-from-preorder-and-inorder-traversal/description/)



```java
public static TreeNode buildTree(int[] pre, int[] in) {
    if (pre == null || in == null || pre.length != in.length) {
        return null;
    }
    HashMap<Integer, Integer> map = new HashMap<>();
    for (int i = 0; i < in.length; i++) {
        map.put(in[i], i);
    }
    return f(pre, 0, pre.length - 1, in, 0, in.length - 1, map);
}

public static TreeNode f(int[] pre, int l1, int r1, int[] in, int l2, int r2, HashMap<Integer, Integer> map) {
    if (l1 > r1) {
        return null;
    }
    TreeNode head = new TreeNode(pre[l1]);
    if (l1 == r1) {
        return head;
    }
    int k = map.get(pre[l1]);
    // int width = k - l2;
    // head.left = f(pre, l1 + 1, l1 + width, in, l2, k - 1, map);
    // head.right = f(pre, l1 + width + 1, r1, in, k + 1, r2, map);
    head.left = f(pre, l1 + 1, l1 + k - l2, in, l2, k - 1, map);
    head.right = f(pre, l1 + k - l2 + 1, r1, in, k + 1, r2, map);
    return head;
}
```



## [Leetcode【中】958.二叉树的完全性验证](https://leetcode.cn/problems/check-completeness-of-a-binary-tree/description/)



```java
public static int MAXN = 101;
public static TreeNode[] queue = new TreeNode[MAXN];
public static int l, r;

// 两个判断条件
// 1、有右节点没有左节点
// 2、一旦发现孩子补全的节点，后续的必须全部是叶子节点
public static boolean isCompleteTree(TreeNode head) {
    if (head == null) {
        return true;
    }
    l = r = 0;
    queue[r++] = head;
    boolean leaf = false;
    while (l < r) {
        head = queue[l++];
        if ((head.left == null && head.right != null)
                ||
                (leaf && (head.left != null || head.right != null))) {
            return false;
        }
        if (head.left != null) {
            queue[r++] = head.left;
        }
        if (head.right != null) {
            queue[r++] = head.right;
        }
        if (head.left == null || head.right == null) {
            leaf = true;
        }
    }
    return true;
}
```



## [Leetcode【易】222.完全二叉树的节点个数](https://leetcode.cn/problems/count-complete-tree-nodes/description/)



```java
public static int countNodes(TreeNode head) {
    if (head == null) {
        return 0;
    }
    return f(head, 1, mostLeft(head, 1));
}

// cur：当前来到的节点
// level：当前来到的节点的层数
// h：整棵树的高度
// 返回：cur这棵子树的节点数
public static int f(TreeNode cur, int level, int h) {
    if (level == h) {
        return 1;
    }
    if (mostLeft(cur.right, level + 1) == h) {
        // cur右树上的最左节点到达了最深处
        return (1 << (h - level)) + f(cur.right, level + 1, h);
    } else {
        // cur右树上的最左节点没达到最深处
        return (1 << (h - level - 1)) + f(cur.left, level + 1, h);
    }
}

// 当前节点cur，处于level层
// 往左深入，返回最深层
public static int mostLeft(TreeNode cur, int level) {
    while (cur != null) {
        level++;
        cur = cur.left;
    }
    return level - 1;
}
```



***



# ✅037【必备】二叉树高频题目—下—不含树型 dp



## [Leetcode【中】236.二叉树的最近公共祖先](https://leetcode.cn/problems/lowest-common-ancestor-of-a-binary-tree/description/)（LCA 问题）



```java
public static TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
    if (root == null || root == p || root == q) {
        return root;
    }
    // 左树搜索
    TreeNode l = lowestCommonAncestor(root.left, p, q);
    // 右树搜索
    TreeNode r = lowestCommonAncestor(root.right, p, q);
    // 左边也搜到，右边也搜到，返回公共头节点
    if (l != null && r != null) {
        return root;
    }
    // 什么都没搜到
    if (l == null && r == null) {
        return null;
    }
    // 一个空，一个不空，返回不空
    return l != null ? l : r;
}
```



## [Leetcode【中】235.二叉搜索树的最近公共祖先](https://leetcode.cn/problems/lowest-common-ancestor-of-a-binary-search-tree/description/)



二叉树中序遍序序列有序



```java
public static TreeNode lowestCommonAncestor(TreeNode root, TreeNode p, TreeNode q) {
    // root从上往下深入
    // 先遇到p，p是答案
    // 先遇到q，q是答案
    // root在p、q之间，root就是答案
    // root在p、q左侧，root往右移动
    // root在p、q右侧，root往左移动
    while (root.val != p.val && root.val != q.val) {
        if (Math.min(p.val, q.val) < root.val && root.val < Math.max(p.val, q.val)) {
            break;
        }
        root = root.val < Math.min(p.val, q.val) ? root.right : root.left;
    }
    return root;
}
```



## [Leetcode【中】113.路径总和 II](https://leetcode.cn/problems/path-sum-ii/description/)



```java
public static List<List<Integer>> pathSum(TreeNode root, int aim) {
    List<List<Integer>> ans = new ArrayList<>();
    if (root != null) {
        List<Integer> path = new ArrayList<>();
        f(root, aim, 0, path, ans);
    }
    return ans;
}

public static void f(TreeNode cur, int aim, int sum, List<Integer> path, List<List<Integer>> ans) {
    if (cur.left == null && cur.right == null) {
        // 叶子节点
        if (cur.val + sum == aim) {
            path.add(cur.val);
            copy(path, ans);
            path.remove(path.size() - 1);
        }
    } else {
        // 非叶子节点
        path.add(cur.val);
        if (cur.left != null) {
            f(cur.left, aim, sum + cur.val, path, ans);
        }
        if (cur.right != null) {
            f(cur.right, aim, sum + cur.val, path, ans);
        }
        path.remove(path.size() - 1);
    }
}

public static void copy(List<Integer> path, List<List<Integer>> ans) {
    List<Integer> copy = new ArrayList<>();
    for (Integer num : path) {
        copy.add(num);
    }
    ans.add(copy);
}
```



## [Leetcode【易】110.平衡二叉树](https://leetcode.cn/problems/balanced-binary-tree/description/)



```java
public static boolean balance;

public static boolean isBalanced(TreeNode root) {
    balance = true;
    height(root);
    return balance;
}

public static int height(TreeNode cur) {
    if (!balance || cur == null) {
        return 0;
    }
    int lh = height(cur.left);
    int rh = height(cur.right);
    if (Math.abs(lh - rh) > 1) {
        balance = false;
    }
    return Math.max(lh, rh) + 1;
}
```



## [Leetcode【中】98.验证二叉搜索树](https://leetcode.cn/problems/validate-binary-search-tree/description/)



```java
// 非递归版
public static int MAXN = 10001;
public static TreeNode[] stack = new TreeNode[MAXN];
public static int r;

public static boolean isValidBST1(TreeNode head) {
    if (head == null) {
        return true;
    }
    TreeNode pre = null;
    r = 0;
    while (r > 0 || head != null) {
        if (head != null) {
            stack[r++] = head;
            head = head.left;
        } else {
            head = stack[--r];
            if (pre != null && pre.val >= head.val) {
                return false;
            }
            pre = head;
            head = head.right;
        }
    }
    return true;
}
```



```java
// 递归版
public static long min, max;

public static boolean isValidBST2(TreeNode head) {
    if (head == null) {
        min = Long.MAX_VALUE;
        max = Long.MIN_VALUE;
        return true;
    }
    boolean lok = isValidBST2(head.left);
    long lmin = min;
    long lmax = max;
    boolean rok = isValidBST2(head.right);
    long rmin = min;
    long rmax = max;
    min = Math.min(Math.min(lmin, rmin), head.val);
    max = Math.max(Math.max(lmax, rmax), head.val);
    return lok && rok && lmax < head.val && head.val < rmin;
}
```



## [Leetcode【中】669.修剪二叉搜索树](https://leetcode.cn/problems/trim-a-binary-search-tree/description/)



```java
public static TreeNode trimBST(TreeNode cur, int low, int high) {
    if (cur == null) {
        return null;
    }
    if (cur.val < low) {
        return trimBST(cur.right, low, high);
    }
    if (cur.val > high) {
        return trimBST(cur.left, low, high);
    }
    // cur在范围内
    cur.left = trimBST(cur.left, low, high);
    cur.right = trimBST(cur.right, low, high);
    return cur;
}
```



## [Leetcode【中】337.打家劫舍 III](https://leetcode.cn/problems/house-robber-iii/description/)



```java
public static int rob(TreeNode root) {
    f(root);
    return Math.max(yes, no);
}

// 完成X子树的遍历，返回后
// 偷X头节点的最大收益
public static int yes;
// 不偷X头节点的最大收益
public static int no;

public static void f(TreeNode root) {
    if (root == null) {
        yes = 0;
        no = 0;
    } else {
        int y = root.val;
        int n = 0;
        f(root.left);
        y += no;
        n += Math.max(yes, no);
        f(root.right);
        y += no;
        n += Math.max(yes, no);
        yes = y;
        no = n;
    }
}
```



***



# ✅038【必备】经典递归过程解析



## [牛客【】字符串的全部子序列](https://www.nowcoder.com/practice/92e6247998294f2c933906fdedbc6e6a)



```java
import java.util.HashSet;

public class Solution {
    public static String[] generatePermutation1(String str) {
        char[] s = str.toCharArray();
        HashSet<String> set = new HashSet<>();
        f1(s, 0, new StringBuilder(), set);
        int m = set.size();
        String[] ans = new String[m];
        int i = 0;
        for (String cur : set) {
            ans[i++] = cur;
        }
        return ans;
    }

    public static void f1(char[] s, int i, StringBuilder path, HashSet<String> set) {
        if (i == s.length) {
            set.add(path.toString());
        } else {
            // 当前目标加到路径
            path.append(s[i]);
            f1(s, i + 1, path, set);
            // 当前目标不在路径
            path.deleteCharAt(path.length() - 1);
            f1(s, i + 1, path, set);
        }
    }

    public static String[] generatePermutation2(String str) {
        char[] s = str.toCharArray();
        HashSet<String> set = new HashSet<>();
        f2(s, 0, new char[s.length], 0, set);
        int m = set.size();
        String[] ans = new String[m];
        int i = 0;
        for (String cur : set) {
            ans[i++] = cur;
        }
        return ans;
    }

    public static void f2(char[] s, int i, char[] path, int size, HashSet<String> set) {
        if (i == s.length) {
            set.add(String.valueOf(path, 0, size));
        } else {
            path[size] = s[i];
            f2(s, i + 1, path, size + 1, set);
            f2(s, i + 1, path, size, set);
        }
    }
}
```



## [Leetcode【中】90.子集 II](https://leetcode.cn/problems/subsets-ii/description/)



```java
import java.lang.reflect.Array;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class Solution {
    public static List<List<Integer>> subsetsWithDup(int[] nums) {
        List<List<Integer>> ans = new ArrayList<>();
        Arrays.sort(nums);
        f(nums, 0, new int[nums.length], 0, ans);
        return ans;
    }

    public static void f(int[] nums, int i, int[] path, int size, List<List<Integer>> ans) {
        if (i == nums.length) {
            ArrayList<Integer> cur = new ArrayList<>();
            for (int j = 0; j < size; j++) {
                cur.add(path[j]);
            }
            ans.add(cur);
        } else {
            // 下一组相等的数的第一个数的位置
            int j = i + 1;
            while (j < nums.length && nums[i] == nums[j]) {
                j++;
            }
            // 当前数，要0个
            f(nums, j, path, size, ans);
            // 剪枝，简化算法
            // 当前数，要1、2、3、……个
            for (; i < j; i++) {
                path[size++] = nums[i];
                f(nums, j, path, size, ans);
            }
        }
    }
}
```



## [Leetcode【中】46.全排列](https://leetcode.cn/problems/permutations/description/)



```java
import java.util.ArrayList;
import java.util.List;

public class Solution {
    public static List<List<Integer>> permute(int[] nums) {
        List<List<Integer>> ans = new ArrayList<>();
        f(nums, 0, ans);
        return ans;
    }

    public static void f(int[] nums, int i, List<List<Integer>> ans) {
        if (i == nums.length) {
            List<Integer> cur = new ArrayList<>();
            for (int num : nums) {
                cur.add(num);
            }
            ans.add(cur);
        } else {
            for (int j = i; j < nums.length; j++) {
                swap(nums, i, j);
                f(nums, i + 1, ans);
                swap(nums, i, j);
            }
        }
    }

    public static void swap(int[] nums, int i, int j) {
        int tmp = nums[i];
        nums[i] = nums[j];
        nums[j] = tmp;
    }
}
```



## [Leetcode【中】全排列 II](https://leetcode.cn/problems/permutations-ii/description/)



```java
import java.util.HashSet;
import java.util.ArrayList;
import java.util.List;

public class Solution {
    public static List<List<Integer>> permuteUnique(int[] nums) {
        List<List<Integer>> ans = new ArrayList<>();
        f(nums, 0, ans);
        return ans;
    }

    public static void f(int[] nums, int i, List<List<Integer>> ans) {
        if (i == nums.length) {
            List<Integer> cur = new ArrayList<>();
            for (int num : nums) {
                cur.add(num);
            }
            ans.add(cur);
        } else {
            HashSet<Integer> set = new HashSet<>();
            for (int j = i; j < nums.length; j++) {
                // nums[j]没有来到过i位置
                if (!set.contains(nums[j])) {
                    set.add(nums[j]);
                    swap(nums, i, j);
                    f(nums, i + 1, ans);
                    swap(nums, i, j);
                }
            }
        }
    }

    public static void swap(int[] nums, int i, int j) {
        int tmp = nums[i];
        nums[i] = nums[j];
        nums[j] = tmp;
    }
}
```



**栈的逆序**



```java
import java.util.Stack;

public class Solution {
    // 递归逆序栈

    public static void reverse(Stack<Integer> stack) {
        if (stack.isEmpty()) {
            return;
        }
        int num = bottomOut(stack);
        reverse(stack);
        stack.push(num);
    }

    // 移除栈底元素
    // 返回栈底元素
    public static int bottomOut(Stack<Integer> stack) {
        int ans = stack.pop();
        if (stack.isEmpty()) {
            return ans;
        } else {
            int last = bottomOut(stack);
            stack.push(ans);
            return last;
        }
    }

    public static void main(String[] args) {
        Stack<Integer> stack = new Stack<Integer>();
        stack.push(1);
        stack.push(2);
        stack.push(3);
        stack.push(4);
        stack.push(5);
        reverse(stack);
        while (!stack.isEmpty()) {
            System.out.println(stack.pop());
        }
    }
}
```



**递归排序一个栈**



```java
import java.util.Stack;

public class Solution {
    // 递归排序栈
    // 栈只提供push、pop、isEmpty三个方法
    // 无序栈→栈顶到栈底从小到大
    // 不使用任何容器
    // 只使用三个基础方法+递归函数

    public static void sort(Stack<Integer> stack) {
        int deep = deep(stack);
        while (deep > 0) {
            int max = max(stack, deep);
            int k = times(stack, deep, max);
            down(stack, deep, max, k);
            deep -= k;
        }
    }

    // 返回栈的深度，不改变数据的排序状况
    public static int deep(Stack<Integer> stack) {
        if (stack.isEmpty()) {
            return 0;
        }
        int num = stack.pop();
        int deep = deep(stack) + 1;
        stack.push(num);
        return deep;
    }

    // 从栈当前顶部开始，往下数deep层，返回最大值
    public static int max(Stack<Integer> stack, int deep) {
        if (deep == 0) {
            return Integer.MIN_VALUE;
        }
        int num = stack.pop();
        // 下一层往后的最大值
        int restMax = max(stack, deep - 1);
        // 比较当前层和下一层往后的最大值
        int max = Math.max(num, restMax);
        stack.push(num);
        return max;
    }

    // 从栈当前顶部开始，往下数deep层，且最大值为max
    // 返回max出现了几次，且不改变数据排序状况
    public static int times(Stack<Integer> stack, int deep, int max) {
        if (deep == 0) {
            return 0;
        }
        int num = stack.pop();
        int restTimes = times(stack, deep - 1, max);
        int times = restTimes + (num == max ? 1 : 0);
        stack.push(num);
        return times;
    }

    // 从栈当前的顶部开始，往下数deep层，且最大值max出现k次
    // 将k个最大值沉底，余下数据状况不变
    public static void down(Stack<Integer> stack, int deep, int max, int k) {
        if (deep == 0) {
            for (int i = 0; i < k; i++) {
                stack.push(max);
            }
        } else {
            int num = stack.pop();
            down(stack, deep - 1, max, k);
            if (num != max) {
                stack.push(num);
            }
        }
    }

    public static void main(String[] args) {
        Stack<Integer> stack = new Stack<>();
        stack.push(1);
        stack.push(5);
        stack.push(4);
        stack.push(5);
        stack.push(3);
        stack.push(2);
        stack.push(3);
        stack.push(1);
        stack.push(4);
        stack.push(2);
        sort(stack);
        while (!stack.isEmpty()) {
            System.out.println(stack.pop());
        }
    }
}
```



## [Leetcode【易】面试题 08.06.汉诺塔问题](https://leetcode.cn/problems/hanota-lcci/)



```java
import java.util.List;

public class Solution {
    public static void hanota(List<Integer> A, List<Integer> B, List<Integer> C) {
        f(A, B, C, A.size());
    }

    public static void f(List<Integer> A, List<Integer> B, List<Integer> C, int n) {
        if (n == 0) {
            return;
        }
        f(A, C, B, n - 1);
        C.add(A.remove(A.size() - 1));
        f(B, A, C, n - 1);
    }
}
```



***



# ✅039【必备】嵌套类问题用递归解析



## [Leetcode【难】224.基本计算器](https://leetcode.cn/problems/basic-calculator/)



```java
import java.util.ArrayList;

public class Solution {

    public static void main(String[] args) {
        System.out.println(calculate("1 + 1"));
    }

    public static int where;

    public static int calculate(String str) {
        where = 0;
        return f(str.replace(" ", "").toCharArray(), 0);
    }

    // 从s[i...]开始计算，遇到字符串结束 或者 ) 停止
    // 返回：自己复杂的这一段的计算结果
    // 返回时，更新全局变量where记录当前计算到哪了
    public static int f(char[] s, int i) {
        int cur = 0;
        ArrayList<Integer> numbers = new ArrayList<>();
        ArrayList<Character> ops = new ArrayList<>();
        while (i < s.length && s[i] != ')') {
            if (s[i] >= '0' && s[i] <= '9') {
                cur = cur * 10 + s[i++] - '0';
            } else if (s[i] != '(') {
                // 遇到了运算符 + - * /
                push(numbers, ops, cur, s[i++]);
                // 数字清空
                cur = 0;
            } else {
                // 遇到左括号
                cur = f(s, i + 1);
                i = where + 1;
            }
        }
        // 最后一个数字
        push(numbers, ops, cur, '+');
        where = i;
        return compute(numbers, ops);
    }

    public static void push(ArrayList<Integer> numbers, ArrayList<Character> ops, int cur, char op) {
        int n = numbers.size();
        if (n == 0 || ops.get(n - 1) == '+' || ops.get(n - 1) == '-') {
            numbers.add(cur);
            ops.add(op);
        } else {
            int topNumber = numbers.get(n - 1);
            char topOp = ops.get(n - 1);
            if (topOp == '*') {
                numbers.set(n - 1, topNumber * cur);
            } else {
                if (cur != 0) {
                    numbers.set(n - 1, topNumber / cur);
                }
            }
            ops.set(n - 1, op);
        }
    }

    public static int compute(ArrayList<Integer> numbers, ArrayList<Character> ops) {
        int n = numbers.size();
        int ans = numbers.get(0);
        for (int i = 1; i < n; i++) {
            ans += ops.get(i - 1) == '+' ? numbers.get(i) : -numbers.get(i);
        }
        return ans;
    }
}
```



## [Leetcode【中】227.基本计算器](https://leetcode.cn/problems/basic-calculator-ii/submissions/650189867/)



```java
import java.util.ArrayList;

public class Solution {

    public static void main(String[] args) {
        System.out.println(calculate("1 + 1"));
    }

    public static int where;

    public static int calculate(String str) {
        where = 0;
        return f(str.replace(" ", "").toCharArray(), 0);
    }

    // 从s[i...]开始计算，遇到字符串结束 或者 ) 停止
    // 返回：自己复杂的这一段的计算结果
    // 返回时，更新全局变量where记录当前计算到哪了
    public static int f(char[] s, int i) {
        int cur = 0;
        ArrayList<Integer> numbers = new ArrayList<>();
        ArrayList<Character> ops = new ArrayList<>();
        while (i < s.length && s[i] != ')') {
            if (s[i] >= '0' && s[i] <= '9') {
                cur = cur * 10 + s[i++] - '0';
            } else if (s[i] != '(') {
                // 遇到了运算符 + - * /
                push(numbers, ops, cur, s[i++]);
                // 数字清空
                cur = 0;
            } else {
                // 遇到左括号
                cur = f(s, i + 1);
                i = where + 1;
            }
        }
        // 最后一个数字
        push(numbers, ops, cur, '+');
        where = i;
        return compute(numbers, ops);
    }

    public static void push(ArrayList<Integer> numbers, ArrayList<Character> ops, int cur, char op) {
        int n = numbers.size();
        if (n == 0 || ops.get(n - 1) == '+' || ops.get(n - 1) == '-') {
            numbers.add(cur);
            ops.add(op);
        } else {
            int topNumber = numbers.get(n - 1);
            char topOp = ops.get(n - 1);
            if (topOp == '*') {
                numbers.set(n - 1, topNumber * cur);
            } else {
                if (cur != 0) {
                    numbers.set(n - 1, topNumber / cur);
                }
            }
            ops.set(n - 1, op);
        }
    }

    public static int compute(ArrayList<Integer> numbers, ArrayList<Character> ops) {
        int n = numbers.size();
        int ans = numbers.get(0);
        for (int i = 1; i < n; i++) {
            ans += ops.get(i - 1) == '+' ? numbers.get(i) : -numbers.get(i);
        }
        return ans;
    }
}
```



## [牛客【】 表达式求值](https://www.nowcoder.com/practice/c215ba61c8b1443b996351df929dc4d4)



```java
import java.util.ArrayList;

public class Solution {

    public static void main(String[] args) {
        System.out.println(calculate("1 + 1"));
    }

    public static int where;

    public static int calculate(String str) {
        where = 0;
        return f(str.replace(" ", "").toCharArray(), 0);
    }

    // 从s[i...]开始计算，遇到字符串结束 或者 ) 停止
    // 返回：自己复杂的这一段的计算结果
    // 返回时，更新全局变量where记录当前计算到哪了
    public static int f(char[] s, int i) {
        int cur = 0;
        ArrayList<Integer> numbers = new ArrayList<>();
        ArrayList<Character> ops = new ArrayList<>();
        while (i < s.length && s[i] != ')') {
            if (s[i] >= '0' && s[i] <= '9') {
                cur = cur * 10 + s[i++] - '0';
            } else if (s[i] != '(') {
                // 遇到了运算符 + - * /
                push(numbers, ops, cur, s[i++]);
                // 数字清空
                cur = 0;
            } else {
                // 遇到左括号
                cur = f(s, i + 1);
                i = where + 1;
            }
        }
        // 最后一个数字
        push(numbers, ops, cur, '+');
        where = i;
        return compute(numbers, ops);
    }

    public static void push(ArrayList<Integer> numbers, ArrayList<Character> ops, int cur, char op) {
        int n = numbers.size();
        if (n == 0 || ops.get(n - 1) == '+' || ops.get(n - 1) == '-') {
            numbers.add(cur);
            ops.add(op);
        } else {
            int topNumber = numbers.get(n - 1);
            char topOp = ops.get(n - 1);
            if (topOp == '*') {
                numbers.set(n - 1, topNumber * cur);
            } else {
                if (cur != 0) {
                    numbers.set(n - 1, topNumber / cur);
                }
            }
            ops.set(n - 1, op);
        }
    }

    public static int compute(ArrayList<Integer> numbers, ArrayList<Character> ops) {
        int n = numbers.size();
        int ans = numbers.get(0);
        for (int i = 1; i < n; i++) {
            ans += ops.get(i - 1) == '+' ? numbers.get(i) : -numbers.get(i);
        }
        return ans;
    }
}
```



## [Leetcode【中】394.字符串解码](https://leetcode.cn/problems/decode-string/description/)



```java
public class Solution {

    public static int where;

    public static String decodeString(String str) {
        where = 0;
        return f(str.toCharArray(), 0);
    }

    // s[i....]开始计算，遇到字符串终止 或者 遇到 ] 停止
    // 返回 : 自己负责的这一段字符串的结果
    // 返回之间，更新全局变量where，为了上游函数知道从哪继续！
    public static String f(char[] s, int i) {
        StringBuilder path = new StringBuilder();
        int cnt = 0;
        while (i < s.length && s[i] != ']') {
            if ((s[i] >= 'a' && s[i] <= 'z') || (s[i] >= 'A' && s[i] <= 'Z')) {
                path.append(s[i++]);
            } else if (s[i] >= '0' && s[i] <= '9') {
                cnt = cnt * 10 + s[i++] - '0';
            } else {
                // 遇到了"["
                path.append(get(cnt, f(s, i + 1)));
                i = where + 1;
                cnt = 0;
            }
        }
        where = i;
        return path.toString();
    }

    public static String get(int cnt, String str) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < cnt; i++) {
            sb.append(str);
        }
        return sb.toString();
    }
}
```



## [Leetcode【难】726.原子的数量](https://leetcode.cn/problems/number-of-atoms/description/)



```java
import java.util.TreeMap;

public class Solution {

    public static int where;

    public static String countOfAtoms(String str) {
        where = 0;
        TreeMap<String, Integer> map = f(str.toCharArray(), 0);
        StringBuilder ans = new StringBuilder();
        for (String key : map.keySet()) {
            ans.append(key);
            int cnt = map.get(key);
            if (cnt > 1) {
                ans.append(cnt);
            }
        }
        return ans.toString();
    }

    public static TreeMap<String, Integer> f(char[] s, int i) {
        // 总表
        TreeMap<String, Integer> ans = new TreeMap<>();
        // 之前的名字
        StringBuilder name = new StringBuilder();
        // 之前的有序表
        TreeMap<String, Integer> pre = null;
        // 之前的翻几倍
        int cnt = 0;
        while (i < s.length && s[i] != ')') {
            if (s[i] >= 'A' && s[i] <= 'Z' || s[i] == '(') {
                fill(ans, name, pre, cnt);
                name.setLength(0);
                pre = null;
                cnt = 0;
                if (s[i] >= 'A' && s[i] <= 'Z') {
                    name.append(s[i++]);
                } else {
                    // 遇到(
                    pre = f(s, i + 1);
                    i = where + 1;
                }
            } else if (s[i] >= 'a' && s[i] <= 'z') {
                name.append(s[i++]);
            } else {
                cnt = cnt * 10 + s[i++] - '0';
            }
        }
        fill(ans, name, pre, cnt);
        where = i;
        return ans;
    }

    public static void fill(TreeMap<String, Integer> ans, StringBuilder name, TreeMap<String, Integer> pre, int cnt) {
        if (name.length() > 0 || pre != null) {
            cnt = cnt == 0 ? 1 : cnt;
            if (name.length() > 0) {
                String key = name.toString();
                ans.put(key, ans.getOrDefault(key, 0) + cnt);
            } else {
                for (String key : pre.keySet()) {
                    ans.put(key, ans.getOrDefault(key, 0) + pre.get(key) * cnt);
                }
            }
        }
    }
}
```



***



# ✅040【必备】N 皇后问题——位运算实现



## [Leetcode【难】51.N 皇后](https://leetcode.cn/problems/n-queens/)



```java
import java.util.ArrayList;
import java.util.List;

public class Solution {

    public static void main(String[] args) {
        System.out.println(solveNQueens1(4));
    }

    // 用数组表示路径
    public static List<List<String>> solveNQueens1(int n) {
        if (n < 1) {
            return new ArrayList<>();
        }
        List<List<String>> ans = new ArrayList<>();
        f1(0, new int[n], n, ans);
        return ans;
    }

    // i：当前来到的行
    // path：0~i-1行的摆放位置
    // n皇后
    public static void f1(int i, int[] path, int n, List<List<String>> resilt) {
        if (i == n) {
            List<String> list = new ArrayList<>();
            for (int j = 0; j < n; j++) {
                StringBuilder sb = new StringBuilder();
                for (int k = 0; k < n; k++) {
                    if (path[j] == k) {
                        sb.append("Q");
                    } else {
                        sb.append(".");
                    }
                }
                list.add(sb.toString());
            }
            resilt.add(list);
            return;
        }
        for (int j = 0; j < n; j++) {
            if (check(path, i, j)) {
                path[i] = j;
                f1(i + 1, path, n, resilt);
            }
        }
    }

    // 当年在i行、j列的位置摆了一个
    // 数组下标为行，值为列
    // 检查是否和0~i-1的位置冲突
    public static boolean check(int[] path, int i, int j) {
        for (int k = 0; k < i; k++) {
            if (j == path[k] || Math.abs(i - k) == Math.abs(j - path[k])) {
                return false;
            }
        }
        return true;
    }

    public static List<List<String>> solveNQueens(int n) {
        if (n < 1) {
            return new ArrayList<>();
        }
        // n=5
        // 1<<5=0...100000
        // limit=0..011111
        int limit = (1 << n) - 1;
        List<List<String>> ans = new ArrayList<>();
        int[] path = new int[n];
        f2(limit, 0, 0, 0, 0, path, n, ans);
        return ans;
    }

    // limit：几皇后问题
    // col：列影响
    // left：左斜线影响
    // right：右斜线影响
    // 当前处理行
    // path：0~i-1行的摆放位置
    // n：皇后数量
    // result：结果列表
    public static void f2(int limit, int col, int left, int right, int row, int[] path, int n,
            List<List<String>> resilt) {

        if (col == limit) {
            // 所有皇后放完了
            List<String> list = new ArrayList<>();
            for (int i = 0; i < n; i++) {
                StringBuilder sb = new StringBuilder();
                for (int j = 0; j < n; j++) {
                    if (path[i] == j) {
                        sb.append("Q");
                    } else {
                        sb.append(".");
                    }
                }
                list.add(sb.toString());
            }
            resilt.add(list);
            return;
        }
        // 总限制
        // ban：1不能放，0可以放
        int ban = col | left | right;
        // 优化限制
        // ~ban：1可以放，0不能放
        int condidate = limit & (~ban);

        // 尝试放置皇后
        int place = 0;
        while (condidate != 0) {
            // 提取最右侧的1
            place = condidate & (-condidate);
            condidate ^= place;

            // 记录皇后的位置
            path[row] = Integer.numberOfTrailingZeros(place);
            f2(limit, col | place, (left | place) >> 1, (right | place) << 1, row + 1, path, n, resilt);
        }
    }
}
```



## [Leetcode【难】面试题 08.12.八皇后](https://leetcode.cn/problems/eight-queens-lcci/)



```java
import java.util.ArrayList;
import java.util.List;

public class Solution {

    public static void main(String[] args) {
        System.out.println(solveNQueens1(4));
    }

    // 用数组表示路径
    public static List<List<String>> solveNQueens1(int n) {
        if (n < 1) {
            return new ArrayList<>();
        }
        List<List<String>> ans = new ArrayList<>();
        f1(0, new int[n], n, ans);
        return ans;
    }

    // i：当前来到的行
    // path：0~i-1行的摆放位置
    // n皇后
    public static void f1(int i, int[] path, int n, List<List<String>> resilt) {
        if (i == n) {
            List<String> list = new ArrayList<>();
            for (int j = 0; j < n; j++) {
                StringBuilder sb = new StringBuilder();
                for (int k = 0; k < n; k++) {
                    if (path[j] == k) {
                        sb.append("Q");
                    } else {
                        sb.append(".");
                    }
                }
                list.add(sb.toString());
            }
            resilt.add(list);
            return;
        }
        for (int j = 0; j < n; j++) {
            if (check(path, i, j)) {
                path[i] = j;
                f1(i + 1, path, n, resilt);
            }
        }
    }

    // 当年在i行、j列的位置摆了一个
    // 数组下标为行，值为列
    // 检查是否和0~i-1的位置冲突
    public static boolean check(int[] path, int i, int j) {
        for (int k = 0; k < i; k++) {
            if (j == path[k] || Math.abs(i - k) == Math.abs(j - path[k])) {
                return false;
            }
        }
        return true;
    }

    public static List<List<String>> solveNQueens(int n) {
        if (n < 1) {
            return new ArrayList<>();
        }
        // n=5
        // 1<<5=0...100000
        // limit=0..011111
        int limit = (1 << n) - 1;
        List<List<String>> ans = new ArrayList<>();
        int[] path = new int[n];
        f2(limit, 0, 0, 0, 0, path, n, ans);
        return ans;
    }

    // limit：几皇后问题
    // col：列影响
    // left：左斜线影响
    // right：右斜线影响
    // 当前处理行
    // path：0~i-1行的摆放位置
    // n：皇后数量
    // result：结果列表
    public static void f2(int limit, int col, int left, int right, int row, int[] path, int n,
            List<List<String>> resilt) {

        if (col == limit) {
            // 所有皇后放完了
            List<String> list = new ArrayList<>();
            for (int i = 0; i < n; i++) {
                StringBuilder sb = new StringBuilder();
                for (int j = 0; j < n; j++) {
                    if (path[i] == j) {
                        sb.append("Q");
                    } else {
                        sb.append(".");
                    }
                }
                list.add(sb.toString());
            }
            resilt.add(list);
            return;
        }
        // 总限制
        // ban：1不能放，0可以放
        int ban = col | left | right;
        // 优化限制
        // ~ban：1可以放，0不能放
        int condidate = limit & (~ban);

        // 尝试放置皇后
        int place = 0;
        while (condidate != 0) {
            // 提取最右侧的1
            place = condidate & (-condidate);
            condidate ^= place;

            // 记录皇后的位置
            path[row] = Integer.numberOfTrailingZeros(place);
            f2(limit, col | place, (left | place) >> 1, (right | place) << 1, row + 1, path, n, resilt);
        }
    }
}
```



## [Leetcode【难】52.N 皇后 II](https://leetcode.cn/problems/n-queens-ii/description/)



```java
public class Solution {
    // 用数组表示路径
    public static int totalNQueens(int n) {
        if (n < 1) {
            return 0;
        }
        return f1(0, new int[n], n);
    }

    // i：当前来到的行
    // path：0~i-1行的摆放位置
    // n皇后
    public static int f1(int i, int[] path, int n) {
        if (i == n) {
            return 1;
        }
        int ans = 0;
        for (int j = 0; j < n; j++) {
            if (check(path, i, j)) {
                path[i] = j;
                ans += f1(i + 1, path, n);
            }
        }
        return ans;
    }

    // 当年在i行、j列的位置摆了一个
    // 数组下标为行，值为列
    // 检查是否和0~i-1的位置冲突
    public static boolean check(int[] path, int i, int j) {
        for (int k = 0; k < i; k++) {
            if (j == path[k] || Math.abs(i - k) == Math.abs(j - path[k])) {
                return false;
            }
        }
        return true;
    }

    public static int totalNQueens2(int n) {
        if (n < 1) {
            return 0;
        }
        // n=5
        // 1<<5=0...100000
        // limit=0..011111
        int limit = (1 << n) - 1;
        return f2(limit, 0, 0, 0);
    }

    // limit：几皇后问题
    // col：列影响
    // left：左斜线影响
    // right：右斜线影响
    public static int f2(int limit, int col, int left, int right) {
        if (col == limit) {
            // 所有皇后放完了
            return 1;
        }
        // 总限制
        // ban：1不能放，0可以放
        int ban = col | left | right;
        // 优化限制
        // ~ban：1可以放，0不能放
        int condidate = limit & (~ban);
        // 尝试放置皇后
        int place = 0;
        // 一共多少种有效方法
        int ans = 0;
        while (condidate != 0) {
            // 提取最右侧的1
            place = condidate & (-condidate);
            condidate ^= place;
            ans += f2(limit, col | place, (left | place) >> 1, (right | place) << 1);
        }
        return ans;
    }
}
```



***



# ✅041【必备】最大公约数、同余原理



## **欧几里得算法：辗转相除法**



```java
// 证明辗转相除法就是证明如下关系：
// gcd(a, b) = gcd(b, a % b)
// 假设a % b = r，即需要证明的关系为：gcd(a, b) = gcd(b, r)
// 证明过程：
// 因为a % b = r，所以如下两个等式必然成立
// 1) a = b * q + r，q为0、1、2、3....中的一个整数
// 2) r = a − b * q，q为0、1、2、3....中的一个整数
// 假设u是a和b的公因子，则有: a = s * u, b = t * u
// 把a和b带入2)得到，r = s * u - t * u * q = (s - t * q) * u
// 这说明 : u如果是a和b的公因子，那么u也是r的因子
// 假设v是b和r的公因子，则有: b = x * v, r = y * v
// 把b和r带入1)得到，a = x * v * q + y * v = (x * q + y) * v
// 这说明 : v如果是b和r的公因子，那么v也是a的公因子
// 综上，a和b的每一个公因子 也是 b和r的一个公因子，反之亦然
// 所以，a和b的全体公因子集合 = b和r的全体公因子集合
// 即gcd(a, b) = gcd(b, r)
// 证明结束
```



```java
public class Solution {
    // 欧几里得算法：辗转相除法

    // 最大公约数
    public static long gcd(long a, long b) {
        return b == 0 ? a : gcd(b, a % b);
    }

    // 最小公倍数
    public static long lcm(long a, long b) {
        return (long) a / gcd(a, b) * b;
    }
}
```



## [Leetcode【难】878.第 N 个神奇数字](https://leetcode.cn/problems/nth-magical-number/description/)



```java
public class Solution {
    public static int nthMagicalNumber(int n, int a, int b) {
        long lcm = lcm(a, b);
        long ans = 0;
        for (long l = 0, r = (long) n * Math.min(a, b), m = 0; l <= r;) {
            m = (l + r) / 2;
            if (m / a + m / b - m / lcm >= n) {
                ans = m;
                r = m - 1;
            } else {
                l = m + 1;
            }
        }
        return (int) (ans % 1000000007);
    }

    // 最大公约数
    public static long gcd(long a, long b) {
        return b == 0 ? a : gcd(b, a % b);
    }

    // 最小公倍数
    public static long lcm(long a, long b) {
        return (long) a / gcd(a, b) * b;
    }
}
```



[**同余原理**](https://baike.baidu.com/item/%E5%90%8C%E4%BD%99%E5%AE%9A%E7%90%86/1212360)



```java
import java.math.BigInteger;

public class Solution {
    public static long random() {
        return (long) (Math.random() * Long.MAX_VALUE);
    }

    // 计算 ((a + b) * (c - d) + (a * c - b * d)) % mod 的非负结果
    public static int f1(long a, long b, long c, long d, int mod) {
        BigInteger o1 = new BigInteger(String.valueOf(a));
        BigInteger o2 = new BigInteger(String.valueOf(b));
        BigInteger o3 = new BigInteger(String.valueOf(c));
        BigInteger o4 = new BigInteger(String.valueOf(d));
        // a+b
        BigInteger o5 = o1.add(o2);
        // c-d
        BigInteger o6 = o3.subtract(o4);
        // (a+b)*(c-d)
        BigInteger o7 = o5.multiply(o6);
        // a*c
        BigInteger o8 = o1.multiply(o3);
        // b*d
        BigInteger o9 = o2.multiply(o4);
        // (a*c)-(b*d)
        BigInteger o10 = o8.subtract(o9);
        // ((a+b)*(c-d))+(a*c)-(b*d)
        BigInteger o11 = o7.add(o10);
        // 非负结果
        BigInteger o12 = o11.mod(BigInteger.valueOf(mod));
        return o12.signum() == -1 ? o12.add(new BigInteger(String.valueOf(mod))).intValue() : o12.intValue();

    }

    // 计算 ((a + b) * (c - d) + (a * c - b * d)) % mod 的非负结果
    public static int f2(long a, long b, long c, long d, int mod) {
        int o1 = (int) (a % mod);
        int o2 = (int) (b % mod);
        int o3 = (int) (c % mod);
        int o4 = (int) (d % mod);
        // a+b
        int o5 = (o1 + o2) % mod;
        // c-d
        int o6 = (o3 - o4 + mod) % mod;
        // (a+b)*(c-d)
        int o7 = (int) (((long) o5 * o6) % mod);
        // a*c
        int o8 = (int) (((long) o1 * o3) % mod);
        // b*d
        int o9 = (int) (((long) o2 * o4) % mod);
        // (a*c)-(b*d)
        int o10 = (o8 - o9 + mod) % mod;
        // ((a+b)*(c-d))+(a*c)-(b*d)
        int o11 = (o7 + o10) % mod;
        // 非负结果
        return o11;
    }

    public static void main(String[] args) {
        System.out.println("测试开始");
        long a = random();
        long b = random();
        long c = random();
        long d = random();
        int mod = (int) (random() * 1000000000 + 1);
        System.out.println("a=" + a);
        System.out.println("b=" + b);
        System.out.println("c=" + c);
        System.out.println("d=" + d);
        System.out.println("mod=" + mod);
        System.out.println("f1=" + f1(a, b, c, d, mod));
        System.out.println("f2=" + f2(a, b, c, d, mod));
        System.out.println("测试结束");
    }
}
```



***



# ✅042【必备】对数器打表找规律技巧



* 可以用暴力的实现求入参不大情况下的答案，往往只需要最基本的递归



* 打印入参不大情况下的答案，然后观察规律



* 规律转化为代码，即最优解



使用规格 8 和规格 6 的袋子买苹果问题



```java
public class Solution {

    // 有可以装8个苹果的袋子
    // 有可以装6个苹果的大子
    // 每个袋子必须装满
    // 给定n个苹果，返回至少多少个袋子
    // 如果不存在每个袋子都装满的方案返回-1
    public static void main(String[] args) {
        for (int i = 0; i < 100; i++) {
            System.out.println(i + " : " + bags1(i));
            System.out.println(i + " : " + bags2(i));
            System.out.println("----------------");
        }
    }

    public static int bags1(int apples) {
        int ans = f(apples);
        return ans == Integer.MAX_VALUE ? -1 : ans;
    }

    public static int f(int rest) {
        if (rest < 0) {
            return Integer.MAX_VALUE;
        }
        if (rest == 0) {
            return 0;
        }
        int p1 = f(rest - 8);
        int p2 = f(rest - 6);
        p1 += p1 != Integer.MAX_VALUE ? 1 : 0;
        p2 += p2 != Integer.MAX_VALUE ? 1 : 0;
        return Math.min(p1, p2);
    }

    public static int bags2(int apples) {
        if ((apples & 1) != 0) {
            return -1;
        }
        if (apples < 18) {
            if (apples == 0) {
                return 0;
            }
            if (apples == 6 || apples == 8) {
                return 1;
            }
            if (apples == 12 || apples == 14 || apples == 16) {
                return 2;
            }
            return -1;
        }
        return (apples - 18) / 8 + 3;
    }
}
```



吃草问题



```java
public class Solution {
    // 两人轮流吃草
    // A先吃，B后吃
    // 当前该吃草的人只能吃4的某次方份草
    // 谁先让对方没有草吃谁就赢
    // 谁先没有草吃谁输
    public static void main(String[] args) {
        for (int i = 0; i <= 100; i++) {
            System.out.println("i1" + i + "的结果是" + win1(i));
            System.out.println("i2" + i + "的结果是" + win2(i));
            System.out.println("----------------");
        }
    }

    public static String win1(int n) {
        return f(n, "A");
    }

    // rest：当前还剩多少草
    // cur：当前该谁吃
    public static String f(int rest, String cur) {
        String empty = cur.equals("A") ? "B" : "A";
        if (rest < 5) {
            return (rest == 0 || rest == 2) ? empty : cur;
        }
        int pick = 1;
        while (pick < rest) {
            if (f(rest - pick, empty).equals(cur)) {
                return cur;
            }
            pick *= 4;
        }
        return empty;
    }

    public static String win2(int n) {
        if (n % 5 == 0 || n % 5 == 2) {
            return "B";
        }
        return "A";
    }
}
```



判断某数是否为一系列连续正整数和



```java
public class Solution{
    // 判断一个数是否是若干连续正整数的和
    public static void main(String[] args) {
        for(int i=1;i<=100;i++){
            System.out.println("i1"+i+"的结果是"+isSum1(i));
            System.out.println("i2"+i+"的结果是"+isSum2(i));
            System.out.println("----------------");
        }
    }
    public static boolean isSum1(int n){
        for(int i=1;i<=n/2;i++){
            int sum=i;
            for(int j=i+1;j<=n/2+1;j++){
                sum+=j;
                if(sum==n){
                    return true;
                }
                if(sum>n){
                    break;
                }
            }
        }
        return false;
    }

    public static boolean isSum2(int n){
        return (n&(n-1))!=0;
    }
}
```



长度为 n 的字符串含有一个回文子串的数量



```java
public class Solution {
    // 一个字符串中有且仅有一个回文子串叫做“好串”
    // 一个字符串中只能使用“r”,"e","d"，长度为n，一共有多少种好串
    public static void main(String[] args) {
        for (int i = 1; i <= 100; i++) {
            System.out.println("f1长度为" + i + ", 答案:" + num1(i));
            System.out.println("f2长度为" + i + ", 答案:" + num2(i));
            System.out.println("----------------");
        }
    }

    public static int num1(int n) {
        char[] path = new char[n];
        return f1(path, 0);
    }

    public static int f1(char[] path, int i) {
        if (i == path.length) {
            int cnt = 0;
            for (int l = 0; l < path.length; l++) {
                for (int r = l + 1; r < path.length; r++) {
                    if (is(path, l, r)) {
                        cnt++;
                    }
                    if (cnt > 1) {
                        return 0;
                    }
                }
            }
            return cnt == 1 ? 1 : 0;
        } else {
            int ans = 0;
            path[i] = 'r';
            ans += f1(path, i + 1);
            path[i] = 'e';
            ans += f1(path, i + 1);
            path[i] = 'd';
            ans += f1(path, i + 1);
            return ans;
        }
    }

    public static boolean is(char[] s, int l, int r) {
        while (l < r) {
            if (s[l] != s[r]) {
                return false;
            }
            l++;
            r--;
        }
        return true;
    }

    public static int num2(int n) {
        if (n == 1) {
            return 0;
        }
        if (n == 2) {
            return 3;
        }
        if (n == 3) {
            return 18;
        }
        return (int) (((long) 6 * (n + 1)) % 1000000007);
    }
}
```



***



# ✅043【必备】根据数据量猜解法——天字第一号解法



> 一个基本事实：
>
>
>
> * $$C/C++$$运行时间：1s
>
>
>
> * $$Java/Python/Go$$等其他语言运行时间：1 ～ 2s
>
>
>
> * 对应的常数指令操作量是：$$10^7\sim 10^8$$
>
> *
>
> * 不管什么测试平台
>
>
>
> * 不管什么 CPU



## [牛客【】消灭怪物](https://www.nowcoder.com/practice/d88ef50f8dab4850be8cd4b95514bbbd)



```java
import java.io.*;

public class Solution {
    // 一个打怪游戏
    // n个技能，对应n个伤害
    // 每个技能使用一次
    // 已知怪物m点血量，小于一定值时，技能伤害加倍
    // 最少使用几个技能消灭怪物

    public static int MAXN = 11;
    public static int[] kill = new int[MAXN];
    public static int[] blood = new int[MAXN];

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            int t = (int) in.nval;
            for (int i = 0; i < t; i++) {
                in.nextToken();
                int n = (int) in.nval;
                in.nextToken();
                int m = (int) in.nval;
                for (int j = 0; j < n; j++) {
                    in.nextToken();
                    kill[j] = (int) in.nval;
                    in.nextToken();
                    blood[j] = (int) in.nval;
                }
                int ans = f(n, 0, m);
                out.println(ans == Integer.MAX_VALUE ? -1 : ans);
            }
        }
        out.flush();
        br.close();
        out.close();
    }

    // n：技能数量
    // i：当前来到了第i号技能
    // r：怪兽目前的剩余血量
    public static int f(int n, int i, int r) {
        if (r <= 0) {
            // 之前的决策已经让怪兽挂了！返回使用了多少个节能
            return i;
        }
        if (i == n) {
            // 无效，之前的决策无效
            return Integer.MAX_VALUE;
        }
        int ans = Integer.MAX_VALUE;
        for (int j = i; j < n; j++) {
            swap(i, j);
            ans = Math.min(ans, f(n, i + 1, r - (r > blood[i] ? kill[i] : kill[i] * 2)));
            swap(i, j);
        }
        return ans;
    }

    // i号技能和j号技能，参数交换
    // j号技能要来到i位置，试一下
    public static void swap(int i, int j) {
        int tmp = kill[i];
        kill[i] = kill[j];
        kill[j] = tmp;
        tmp = blood[i];
        blood[i] = blood[j];
        blood[j] = tmp;
    }
}
```



## [Leetcode【难】906.超级回文数](https://leetcode.cn/problems/super-palindromes/description/)



```java
import java.util.ArrayList;
import java.util.List;

public class Solution {
    // 超级回文数
    // 一个正整数本身是回文数
    // 它又是一个回文数的平方
    // 给定一个区间[L,R]
    // 返回这个区间内有多少个超级回文数
    // 1 <= L <= R <= 10^18
    public static int superpalindromesInRange1(String left, String right) {
        long l = Long.valueOf(left);
        long r = Long.valueOf(right);
        // 10^18->10^9
        long limit = (long) Math.sqrt((double) r);
        // seed:10^18->10^9->10^5
        long seed = 1;
        long num = 0;
        // 数量统计
        int ans = 0;
        do {
            // 偶数长度
            // 123->123321
            num = evenEnlarge(seed);
            if (check(num * num, l, r)) {
                ans++;
            }
            // 奇数长度
            // 123->12321
            num = oddEnlarge(seed);
            if (check(num * num, l, r)) {
                ans++;
            }
            seed++;
        } while (num < limit);
        return ans;
    }

    // 扩展为偶数长度回文
    public static long evenEnlarge(long seed) {
        long ans = seed;
        // 123->123321
        while (seed != 0) {
            ans = ans * 10 + seed % 10;
            seed /= 10;
        }
        return ans;
    }

    // 扩展为奇数长度回文
    public static long oddEnlarge(long seed) {
        // 123->12321
        long ans = seed;
        seed /= 10;
        while (seed != 0) {
            ans = ans * 10 + seed % 10;
            seed /= 10;
        }
        return ans;
    }

    // 检查long类型的num是否为回文数1
    public static boolean isPalindrome1(long num) {
        // 转换为字符串
        String str = String.valueOf(num);
        int i = 0;
        int j = str.length() - 1;
        while (i < j) {
            if (str.charAt(i) != str.charAt(j)) {
                return false;
            }
            i++;
            j--;
        }
        return true;
    }

    // 检查long类型的num是否为回文数2
    public static boolean isPalindrome2(long num) {
        // 首尾判断，num一次去除首尾
        long help = 1;
        while (num / help >= 10) {
            help *= 10;
        }
        while (num != 0) {
            if (num / help != num % 10) {
                return false;
            }
            num = num % help / 10;
            help /= 100;
        }
        return true;
    }

    // 检查int类型的num是否为回文数
    public static boolean isPalindrome(int num) {
        if (num < 0) {
            return false;
        }
        int help = 1;
        // 防止溢出
        while (num / help >= 10) {
            help *= 10;
        }
        while (num != 0) {
            if (num / help != num % 10) {
                return false;
            }
            num = num % help / 10;
            help /= 100;
        }
        return true;
    }

    // 检查num是否在[l,r]范围内的回文数
    public static boolean check(long num, long l, long r) {
        return num >= l && num <= r && isPalindrome2(num);
    }

    // 直接打表
    public static int superpalindromesInRange2(String left, String right) {
        long l = Long.valueOf(left);
        long r = Long.valueOf(right);
        int i = 0;
        for (; i < record.length; i++) {
            if (record[i] >= l) {
                break;
            }
        }
        int j = record.length - 1;
        for (; j >= 0; j--) {
            if (record[j] <= r) {
                break;
            }
        }
        return j - i + 1;
    }

    public static List<Long> collect() {
        long l = 1;
        long r = Long.MAX_VALUE;
        long limit = (long) Math.sqrt((double) r);
        long seed = 1;
        long enlarge = 0;
        ArrayList<Long> ans = new ArrayList<>();
        do {
            enlarge = evenEnlarge(seed);
            if (check(enlarge * enlarge, l, r)) {
                ans.add(enlarge * enlarge);
            }
            enlarge = oddEnlarge(seed);
            if (check(enlarge * enlarge, l, r)) {
                ans.add(enlarge * enlarge);
            }
            seed++;
        } while (enlarge < limit);
        // 排序：升序
        ans.sort((a, b) -> a.compareTo(b));
        return ans;
    }

    public static void main(String[] args) {
        List<Long> ans = collect();
        for (long p : ans) {
            System.out.println(p + "L,");
        }
        System.out.println("size : " + ans.size());
    }

    // size=86
    public static long[] record = new long[] {
            1L,
            4L,
            9L,
            121L,
            484L,
            10201L,
            12321L,
            14641L,
            40804L,
            44944L,
            1002001L,
            1234321L,
            4008004L,
            100020001L,
            102030201L,
            104060401L,
            121242121L,
            123454321L,
            125686521L,
            400080004L,
            404090404L,
            10000200001L,
            10221412201L,
            12102420121L,
            12345654321L,
            40000800004L,
            1000002000001L,
            1002003002001L,
            1004006004001L,
            1020304030201L,
            1022325232201L,
            1024348434201L,
            1210024200121L,
            1212225222121L,
            1214428244121L,
            1232346432321L,
            1234567654321L,
            4000008000004L,
            4004009004004L,
            100000020000001L,
            100220141022001L,
            102012040210201L,
            102234363432201L,
            121000242000121L,
            121242363242121L,
            123212464212321L,
            123456787654321L,
            400000080000004L,
            10000000200000001L,
            10002000300020001L,
            10004000600040001L,
            10020210401202001L,
            10022212521222001L,
            10024214841242001L,
            10201020402010201L,
            10203040504030201L,
            10205060806050201L,
            10221432623412201L,
            10223454745432201L,
            12100002420000121L,
            12102202520220121L,
            12104402820440121L,
            12122232623222121L,
            12124434743442121L,
            12321024642012321L,
            12323244744232321L,
            12343456865434321L,
            12345678987654321L,
            40000000800000004L,
            40004000900040004L,
            1000000002000000001L,
            1000220014100220001L,
            1002003004003002001L,
            1002223236323222001L,
            1020100204020010201L,
            1020322416142230201L,
            1022123226223212201L,
            1022345658565432201L,
            1210000024200000121L,
            1210242036302420121L,
            1212203226223022121L,
            1212445458545442121L,
            1232100246420012321L,
            1232344458544432321L,
            1234323468643234321L,
            4000000008000000004L
    };
}
```



## [Leetcode【易】9.回文数](https://leetcode.cn/problems/palindrome-number/description/)



```java
public static boolean isPalindrome(int num) {
    if (num < 0) {
        return false;
    }
    int help = 1;
    // 防止溢出
    while (num / help >= 10) {
        help *= 10;
    }
    while (num != 0) {
        if (num / help != num % 10) {
            return false;
        }
        num = num % help / 10;
        help /= 100;
    }
    return true;
}
```



***



# ✅044【必备】前缀树



前缀树，又叫做字典树，英文名字 trie



* 每个样本都从头节点开始，根据前缀字符或者前缀数字建出来的一颗大树，就是前缀树



* 没有路就新建节点，有路就复用节点



  * 优点：根据前缀信息选择树上的分支，节省大量时间



  * 缺点：浪费空间，和总字符数量、字符种类有关，



## [牛客【】字典树的实现](https://www.nowcoder.com/practice/7f8a8553ddbf4eaab749ec988726702b)



```java
import java.io.*;
import java.util.*;

public class Solution {
    // 字典树、前缀树

    public class Trie1 {
        // 动态结构（类：路的可能性范围比较小）

        static class TrieNode {
            public int pass;
            public int end;
            public TrieNode[] nexts;

            public TrieNode() {
                pass = 0;
                end = 0;
                nexts = new TrieNode[26];
            }
        }

        public static TrieNode root;

        public static void build() {
            root = new TrieNode();
        }

        // 插入目标字符串
        public static void insert(String word) {
            TrieNode node = root;
            node.pass++;
            for (int i = 0, path; i < word.length(); i++) {
                path = word.charAt(i) - 'a';
                if (node.nexts[path] == null) {
                    node.nexts[path] = new TrieNode();
                }
                node = node.nexts[path];
                node.pass++;
            }
            node.end++;
        }

        // 统计目标字符串的数量
        public static int countWord(String word) {
            TrieNode node = root;
            for (int i = 0, path; i < word.length(); i++) {
                path = word.charAt(i) - 'a';
                if (node.nexts[path] == null) {
                    return 0;
                }
                node = node.nexts[path];
            }
            return node.end;
        }

        // 统计以目标字符串片段开头的字符串的数量
        public static int countWordStartWith(String word) {
            TrieNode node = root;
            for (int i = 0, path; i < word.length(); i++) {
                path = word.charAt(i) - 'a';
                if (node.nexts[path] == null) {
                    return 0;
                }
                node = node.nexts[path];
            }
            return node.pass;
        }

        // 擦除一次目标字符串
        public static void erase(String word) {
            if (countWord(word) > 0) {
                TrieNode node = root;
                node.pass--;
                for (int i = 0, path; i < word.length(); i++) {
                    path = word.charAt(i) - 'a';
                    if (--node.nexts[path].pass == 0) {
                        node.nexts[path] = null;
                        return;
                    }
                    node = node.nexts[path];
                }
                node.end--;
            }
        }

        public static int m, op;
        public static String[] words;

        public static void main(String[] args) throws IOException {
            BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
            PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
            String line = null;
            while ((line = in.readLine()) != null) {
                build();
                m = Integer.valueOf(line);
                for (int i = 1; i <= m; i++) {
                    words = in.readLine().split(" ");
                    op = Integer.valueOf(words[0]);
                    if (op == 1) {
                        insert(words[1]);
                    } else if (op == 2) {
                        erase(words[1]);
                    } else if (op == 3) {
                        out.println(countWord(words[1]) > 0 ? "YES" : "NO");
                    } else if (op == 4) {
                        out.println(countWordStartWith(words[1]));
                    }
                }
            }
            out.flush();
            in.close();
            out.close();
        }
    }

    public class Trie2 {
        // 动态结构（哈希表：路的可能性范围比较大）
        static class TrieNode {
            public int pass;
            public int end;
            HashMap<Integer, TrieNode> nexts;

            public TrieNode() {
                pass = 0;
                end = 0;
                nexts = new HashMap<>();
            }
        }

        public static TrieNode root;

        public static void build() {
            root = new TrieNode();
        }

        // 插入目标字符串
        public static void insert(String word) {
            TrieNode node = root;
            node.pass++;
            for (int i = 0, path; i < word.length(); i++) {
                path = word.charAt(i);
                if (!node.nexts.containsKey(path)) {
                    node.nexts.put(path, new TrieNode());
                }
                node = node.nexts.get(path);
                node.pass++;
            }
            node.end++;
        }

        // 统计目标字符串的数量
        public static int countWord(String word) {
            TrieNode node = root;
            for (int i = 0, path; i < word.length(); i++) {
                path = word.charAt(i);
                if (!node.nexts.containsKey(path)) {
                    return 0;
                }
                node = node.nexts.get(path);
            }
            return node.end;
        }

        // 统计以目标字符串片段开头的字符串的数量
        public static int countWordStartWith(String word) {
            TrieNode node = root;
            for (int i = 0, path; i < word.length(); i++) {
                path = word.charAt(i);
                if (!node.nexts.containsKey(path)) {
                    return 0;
                }
                node = node.nexts.get(path);
            }
            return node.pass;
        }

        // 擦除一次目标字符串
        public static void erase(String word) {
            if (countWord(word) > 0) {
                TrieNode node = root;
                node.pass--;
                for (int i = 0, path; i < word.length(); i++) {
                    path = word.charAt(i);
                    if (--node.nexts.get(path).pass == 0) {
                        node.nexts.remove(path);
                        return;
                    }
                    node = node.nexts.get(path);
                }
                node.end--;
            }
        }

        public static int m, op;
        public static String[] words;

        public static void main(String[] args) throws IOException {
            BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
            PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
            String line = null;
            while ((line = in.readLine()) != null) {
                build();
                m = Integer.valueOf(line);
                for (int i = 1; i <= m; i++) {
                    words = in.readLine().split(" ");
                    op = Integer.valueOf(words[0]);
                    if (op == 1) {
                        insert(words[1]);
                    } else if (op == 2) {
                        erase(words[1]);
                    } else if (op == 3) {
                        out.println(countWord(words[1]) > 0 ? "YES" : "NO");
                    } else if (op == 4) {
                        out.println(countWordStartWith(words[1]));
                    }
                }
            }
            out.flush();
            in.close();
            out.close();
        }
    }

    public class Trie3 {
        // 静态数组（空间固定）
        public static int MAXN = 150001;
        public static int[][] tree = new int[MAXN][26];
        public static int[] pass = new int[MAXN];
        public static int[] end = new int[MAXN];
        public static int cnt;

        public static void build() {
            cnt = 1;
        }

        // 插入目标字符串
        public static void insert(String word) {
            int cur = 1;
            pass[cur]++;
            for (int i = 0, path; i < word.length(); i++) {
                path = word.charAt(i) - 'a';
                if (tree[cur][path] == 0) {
                    tree[cur][path] = ++cnt;
                }
                cur = tree[cur][path];
                pass[cur]++;
            }
            end[cur]++;
        }

        // 统计目标字符串的数量
        public static int search(String word) {
            int cur = 1;
            for (int i = 0, path; i < word.length(); i++) {
                path = word.charAt(i) - 'a';
                if (tree[cur][path] == 0) {
                    return 0;
                }
                cur = tree[cur][path];
            }
            return end[cur];
        }

        // 统计以目标字符串片段开头的字符串数量
        public static int prefixNumber(String pre) {
            int cur = 1;
            for (int i = 0, path; i < pre.length(); i++) {
                path = pre.charAt(i) - 'a';
                if (tree[cur][path] == 0) {
                    return 0;
                }
                cur = tree[cur][path];
            }
            return pass[cur];
        }

        // 擦除一次目标字符串
        public static void delete(String word) {
            if (search(word) > 0) {
                int cur = 1;
                pass[cur]--;
                for (int i = 0, path; i < word.length(); i++) {
                    path = word.charAt(i) - 'a';
                    if (--pass[tree[cur][path]] == 0) {
                        tree[cur][path] = 0;
                        return;
                    }
                    cur = tree[cur][path];
                }
                end[cur]--;
            }
        }

        public static void clear() {
            for (int i = 1; i <= cnt; i++) {
                Arrays.fill(tree[i], 0);
                pass[i] = 0;
                end[i] = 0;
            }
        }

        public static int m, op;
        public static String[] words;

        public static void main(String[] args) throws IOException {
            BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
            PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
            String line = null;
            while ((line = in.readLine()) != null) {
                build();
                m = Integer.valueOf(line);
                for (int i = 1; i <= m; i++) {
                    words = in.readLine().split(" ");
                    op = Integer.valueOf(words[0]);
                    if (op == 1) {
                        insert(words[1]);
                    } else if (op == 2) {
                        delete(words[1]);
                    } else if (op == 3) {
                        out.println(search(words[1]) > 0 ? "YES" : "NO");
                    } else if (op == 4) {
                        out.println(prefixNumber(words[1]));
                    }
                }
                clear();
            }
            out.flush();
            in.close();
            out.close();
        }
    }
}
```



***



# ✅045【必备】前缀树相关题目



## [牛客【】接头密钥](https://www.nowcoder.com/practice/c552d3b4dfda49ccb883a6371d9a6932)



```java
import java.util.*;

public class Solution {

    // 接头密钥系统
    // 密钥b的长度不超过密钥a
    // 对于任意0<=i<b.length，有b[i+1]-b[i]==a[i+1]-a[i]
    // 给定m个密钥b的数组，以及n个密钥a的数组
    // 返回一个长度m的数组ans，表示每个密钥b都有多少一致的密钥a

    public static int[] countConsistentKeys(int[][] b, int[][] a) {
        build();
        StringBuilder sb = new StringBuilder();
        // [3,6,50,10]->"3#44#-40#"
        for (int[] nums : a) {
            sb.setLength(0);
            for (int i = 1; i < nums.length; i++) {
                sb.append(String.valueOf(nums[i] - nums[i - 1] + '#'));
            }
            insert(sb.toString());
        }
        int[] ans = new int[b.length];
        for (int i = 0; i < b.length; i++) {
            sb.setLength(0);
            int[] nums = b[i];
            for (int j = 1; j < nums.length; j++) {
                sb.append(String.valueOf(nums[j] - nums[j - 1] + '#'));
            }
            ans[i] = count(sb.toString());
        }
        clear();
        return ans;
    }

    public static int MAXN = 2000001;
    public static int[][] tree = new int[MAXN][12];
    public static int[] pass = new int[MAXN];
    public static int cnt;

    public static void build() {
        cnt = 1;
    }

    // 0~9 # -
    public static int path(char cha) {
        if (cha == '#') {
            return 10;
        } else if (cha == '-') {
            return 11;
        } else {
            return cha - '0';
        }
    }

    public static void insert(String word) {
        int cur = 1;
        pass[cur]++;
        for (int i = 0, path; i < word.length(); i++) {
            path = path(word.charAt(i));
            if (tree[cur][path] == 0) {
                tree[cur][path] = ++cnt;
            }
            cur = tree[cur][path];
            pass[cur]++;
        }
    }

    public static int count(String pre) {
        int cur = 1;
        for (int i = 0, path; i < pre.length(); i++) {
            path = path(pre.charAt(i));
            if (tree[cur][path] == 0) {
                return 0;
            }
            cur = tree[cur][path];
        }
        return pass[cur];
    }

    public static void clear() {
        for (int i = 1; i <= cnt; i++) {
            Arrays.fill(tree[i], 0);
            pass[i] = 0;
        }
    }
}
```



## [Leetcode【中】421.数组中两个数的最大异或值](https://leetcode.cn/problems/maximum-xor-of-two-numbers-in-an-array/description/)



```java
import java.util.*;

public class Solution {

    // 数组中两个数的最大异或值
    // 给定一个整数数组nums
    // 返回nums[i] XOR nums[j]的最大值
    // 1 <= nums.length <= 2 * 10^4
    // 0 <= nums[i] <= 2^31 - 1

    public static int findMaximumXOR1(int[] nums) {
        // 前缀树
        build(nums);
        // 遍历数组中每个数，求每个数的最大异或值
        int ans = 0;
        for (int num : nums) {
            ans = Math.max(ans, maxXor(num));
        }
        clear();
        return ans;
    }

    public static int MAXN = 3000001;
    public static int[][] tree = new int[MAXN][2];
    public static int cnt;
    // 数组中最大值的二进制状态，有多少个前缀0
    public static int high;

    public static void build(int[] nums) {
        cnt = 1;
        int max = Integer.MIN_VALUE;
        for (int num : nums) {
            max = Math.max(max, num);
        }
        // 计算数组中最大值的二进制状态，有多少个前缀0
        high = 31 - Integer.numberOfLeadingZeros(max);
        for (int num : nums) {
            insert(num);
        }
    }

    public static void insert(int num) {
        int cur = 1;
        // 从最高位开始考虑，优先考虑1，实在不行再选择0
        for (int i = high, path; i >= 0; i--) {
            path = (num >> i) & 1;
            // 与的结果：1 或 0
            if (tree[cur][path] == 0) {
                tree[cur][path] = ++cnt;
            }
            cur = tree[cur][path];
        }
    }

    public static int maxXor(int num) {
        // 该数的最大异或结果
        int ans = 0;
        // 当前来到了多少位，从高位往低位考虑
        int cur = 1;
        for (int i = high, status, want; i >= 0; i--) {
            // num第i位的状态
            status = (num >> i) & 1;
            // num第i位希望的状态，与1异或，若源位1，则期望0；若源位0，则期望1（因为我们最终需要进行异或）
            want = status ^ 1;
            if (tree[cur][want] == 0) {
                // 不能达成
                want ^= 1;
            }
            // 真实的选择
            // 源与真实选择取异或，相同取0，不同取1
            ans |= (status ^ want) << i;
            cur = tree[cur][want];
        }
        return ans;
    }

    public static void clear() {
        for (int i = 1; i <= cnt; i++) {
            tree[i][0] = tree[i][1] = 0;
        }
    }

    // 哈希表
    public static int findMaximumXOR(int[] nums) {
        // 首先找到数组中最大值
        // 确定最大值的二进制状态，有多少个前缀0
        int max = Integer.MIN_VALUE;
        // max：31......i+1位都是0
        for (int num : nums) {
            max = Math.max(max, num);
        }
        // 从高位往低位考虑，每次考虑1位
        int ans = 0;

        HashSet<Integer> set = new HashSet<>();
        for (int i = 31 - Integer.numberOfTrailingZeros(max); i >= 0; i--) {
            // ans：31......i+1位已经完成了探索能否达成1（后续的位全为0）
            // 若源位是0，则寻找1；若源位是1，则寻找0
            // 探索第 i 位是否能达成1
            int better = ans | (1 << i);
            set.clear();
            for (int num : nums) {
                // 只保留num：31......i位
                num = (num >> i) << i;
                // 添加到集合中
                set.add(num);
                // 异或的性质：a ^ b = c，则 a ^ c = b，c ^ b = a
                // 我们期望的结果是better，也就是数组中存在一个数n，使得n ^ num = better
                // 因为n ^ num = better，所以better ^ num = n
                // 若集合中存在n，则我们期望的better可以实现
                if (set.contains(better ^ num)) {
                    ans = better;
                    break;
                }
            }
        }
        return ans;
    }
}
```



## [Leetcode【难】212.单词搜索 II](https://leetcode.cn/problems/word-search-ii/description/)



```java
import java.util.*;

public class Solution {
    // 给定一个二维m×n的字符数组，搜索一个单词字符串数组中的单词

    public static List<String> findWords(char[][] board, String[] words) {
        build(words);
        List<String> ans = new ArrayList<>();
        for (int i = 0; i < board.length; i++) {
            for (int j = 0; j < board[0].length; j++) {
                DFS(board, i, j, 1, ans);
            }
        }
        clear();
        return ans;
    }

    // board : 二维网格
    // i,j : 此时来到的格子位置，i行、j列
    // t : 静态前缀树的编号
    // ans : 收集到了哪些字符串，都放入ans
    // 返回值 : 收集到了几个字符串
    public static int DFS(char[][] board, int i, int j, int t, List<String> ans) {
        // 越界，走了回头路（访问过的标记为0）
        if (i < 0 || i == board.length || j < 0 || j == board[0].length || board[i][j] == 0) {
            return 0;
        }
        // 存储当前位置的字符
        char temp = board[i][j];
        // 静态前缀树数组的路号
        int road = temp - 'a';
        // 下一个节点的编号
        t = tree[t][road];
        // 如果下一个节点不存在，直接返回0
        if (pass[t] == 0) {
            return 0;
        }
        // 收集匹配到了几个字符串
        int fix = 0;
        // 如果当前节点是一个单词的结束节点，收集该单词，并将该单词的结束节点设为null
        if (end[t] != null) {
            fix++;
            ans.add(end[t]);
            end[t] = null;
        }
        // 标记当前位置已经访问过
        board[i][j] = 0;
        // 递归搜索上下左右四个方向
        fix += DFS(board, i - 1, j, t, ans);
        fix += DFS(board, i + 1, j, t, ans);
        fix += DFS(board, i, j - 1, t, ans);
        fix += DFS(board, i, j + 1, t, ans);
        // 回溯：该路上的结果已经搜索好了
        pass[t] -= fix;
        // 回溯：将二维字符数组恢复到未访问的状态（由0恢复为原始字符）
        board[i][j] = temp;
        return fix;
    }

    public static int MAXN = 10001;
    public static int[][] tree = new int[MAXN][26];
    public static int[] pass = new int[MAXN];
    public static String[] end = new String[MAXN];
    public static int cnt;

    public static void build(String[] words) {
        cnt = 1;
        for (String word : words) {
            int cur = 1;
            pass[cur]++;
            for (int i = 0, path; i < word.length(); i++) {
                path = word.charAt(i) - 'a';
                if (tree[cur][path] == 0) {
                    tree[cur][path] = ++cnt;
                }
                cur = tree[cur][path];
                pass[cur]++;
            }
            end[cur] = word;
        }
    }

    public static void clear() {
        for (int i = 1; i <= cnt; i++) {
            Arrays.fill(tree[i], 0);
            pass[i] = 0;
            end[i] = null;
        }
    }

}
```



***



# ✅046【必备】构建前缀信息的技巧



## [Leetcode【易】303.区域和探索——数组不可变](https://leetcode.cn/problems/range-sum-query-immutable/description/)



```java
public class Solution {

    // 数组区域累加和
    class NumArray {

        public int[] sum;

        public NumArray(int[] nums) {
            // 求和数组的长度为原数组长度+1
            // 为了防止原数组开头处的数组越界
            sum = new int[nums.length + 1];
            for (int i = 1; i <= nums.length; i++) {
                sum[i] = sum[i - 1] + nums[i - 1];
            }
        }

        public int sumRange(int l, int r) {
            return sum[r + 1] - sum[l];
        }
    }
}
```



## [牛客【】未排序数组中累加和为给定值的最长子数组长度](https://www.nowcoder.com/practice/36fb0fd3c656480c92b569258a1223d5)



```java
import java.io.*;
import java.util.*;

public class Solution {
    // 给定一个无序数组
    // 返回累加和为指定大小的最长子数组的长度
    // 无序数组元素可正可负可为零

    public static int MAXN = 100001;
    public static int[] arr = new int[MAXN];
    public static int n, aim;
    public static HashMap<Integer, Integer> map = new HashMap<>();

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            aim = (int) in.nval;
            for (int i = 0; i < n; i++) {
                in.nextToken();
                arr[i] = (int) in.nval;
            }
            out.println(compute());
        }
        out.flush();
        out.close();
        br.close();
    }

    public static int compute() {
        map.clear();
        // 一个数字都没有的时候，0这个数字和就已经存在了
        map.put(0, -1);
        // 最大长度
        int ans = 0;
        for (int i = 0, sum = 0; i < n; i++) {
            // sum：0~i的累加和
            sum += arr[i];
            // sum：0......i
            // aim： ......i
            // sum-aim最早出现的位置
            if (map.containsKey(sum - aim)) {
                ans = Math.max(ans, i - map.get(sum - aim));
            }
            if (!map.containsKey(sum)) {
                map.put(sum, i);
            }
        }
        return ans;
    }
}
```



## [Leetcode【中】560.和为 K 的子数组](https://leetcode.cn/problems/subarray-sum-equals-k/description/)



```java
import java.util.*;

public class Solution {
    // 给定一无序数组，统计累加和为aim的子数组的个数
    public static int subarraySum(int[] nums, int aim) {
        HashMap<Integer, Integer> map = new HashMap<>();
        // 0这个前缀和，没有任何数字的时候就已经有了一次
        map.put(0, 1);
        int ans = 0;
        for (int i = 0, sum = 0; i < nums.length; i++) {
            sum += nums[i];
            ans += map.getOrDefault(sum - aim, 0);
            map.put(sum, map.getOrDefault(sum, 0) + 1);
        }
        return ans;
    }
}
```



## [牛客【】未排序数组中累加和为给定值的最长子数组系列问题补 1](https://www.nowcoder.com/practice/545544c060804eceaed0bb84fcd992fb)



```java
import java.io.*;
import java.util.*;

public class Solution {
    // 给定一个无序数组，统计正负数数量相等的最长子数组长度
    public static int MAXN = 1000001;
    public static int[] arr = new int[MAXN];
    public static int n;
    public static HashMap<Integer, Integer> map = new HashMap<>();

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            for (int i = 0, num; i < n; i++) {
                in.nextToken();
                num = (int) in.nval;
                arr[i] = num != 0 ? (num > 0 ? 1 : -1) : 0;
            }
            out.println(compute());
        }
        out.flush();
        out.close();
        br.close();
    }

    public static int compute() {
        map.clear();
        map.put(0, -1);
        int ans = 0;
        for (int i = 0, sum = 0; i < n; i++) {
            sum += arr[i];
            if (map.containsKey(sum)) {
                ans = Math.max(ans, i - map.get(sum));
            } else {
                map.put(sum, i);
            }
        }
        return ans;
    }
}
```



## [Leetcode【中】1124.表现良好的最长时间段](https://leetcode.cn/problems/longest-well-performing-interval/description/)



```java
import java.util.*;

public class Solution {

    public static int longestWPI(int[] hours) {
        HashMap<Integer, Integer> map = new HashMap<>();
        map.put(0, -1);
        int ans = 0;
        for (int i = 0, sum = 0; i < hours.length; i++) {
            sum += hours[i] > 8 ? 1 : -1;
            // 若数组整体满足情况，单拉出来讨论
            if (sum > 0) {
                ans = i + 1;
            } else {
                // 根据函数的单调性，
                // sum-1比sum后出现
                // sum-2比sum-1后出现
                // 若sum-1在之前出现过，那么sum-1到sum之间的所有数的和一定是大于0的
                // 并且sum-1到sum的长度是最大的
                if (map.containsKey(sum - 1)) {
                    ans = Math.max(ans, i - map.get(sum - 1));
                }
            }
            if (!map.containsKey(sum)) {
                map.put(sum, i);
            }
        }
        return ans;
    }
}
```



## [Leetcode【中】1590.使数组和能被 P 整除](https://leetcode.cn/problems/make-sum-divisible-by-p/description/)



```java
import java.util.*;

public class Solution {
    // 使数组和能被P整除
    // 返回移除最短子数组的长度
    public static int minSubarray(int[] nums, int p) {
        // 先求整体余数
        int mod = 0;
        for (int num : nums) {
            mod = (mod + num) % p;
        }
        if (mod == 0) {
            return 0;
        }
        HashMap<Integer, Integer> map = new HashMap<>();
        map.put(0, -1);
        int ans = Integer.MAX_VALUE;
        for (int i = 0, cur = 0, find; i < nums.length; i++) {
            cur = (cur + nums[i]) % p;
            find = (cur + p - mod) % p;
            // find=cur>=mod?cur-mod:cur+p-mod;
            if (map.containsKey(find)) {
                ans = Math.min(ans, i - map.get(find));
            }
            map.put(cur, i);
        }
        return ans == nums.length ? -1 : ans;
    }
}
```



## [Leetcode【中】1371.每个元音包含偶数次的最长子字符串](https://leetcode.cn/problems/find-the-longest-substring-containing-vowels-in-even-counts/description/)



```java
import java.util.*;

public class Solution {
    // 给定一个字符串
    // 返回包含每个元音字母都是偶数次的最长子串
    public static int findTheLongestSubstring(String s) {
        int n = s.length();
        int[] map = new int[32];
        Arrays.fill(map, -2);
        map[0] = -1;
        int ans = 0;
        for (int i = 0, status = 0, m; i < n; i++) {
            m = move(s.charAt(i));
            if (m != -1) {
                status ^= (1 << m);
            }
            if (map[status] != -2) {
                ans = Math.max(ans, i - map[status]);
            } else {
                map[status] = i;
            }
        }
        return ans;
    }

    public static int move(char cha) {
        switch (cha) {
            case 'a':
                return 0;
            case 'e':
                return 1;
            case 'i':
                return 2;
            case 'o':
                return 3;
            case 'u':
                return 4;
            default:
                return -1;
        }
    }
}
```



***



# ✅047【必备】一维差分与等差数列差分



## [Leetcode【中】1109.航班预定统计](https://leetcode.cn/problems/corporate-flight-bookings/description/)



```java
public class Solution {
    // 一维数组，一个二维数组
    // 二维数组中:[first,last,add]
    // 表示在一维数组中first到last之间每个元素都加上add
    public static int[] corpFlightBookings(int[][] bookings, int n) {
        int[] cnt = new int[n + 2];
        for (int[] book : bookings) {
            cnt[book[0]] += book[2];
            cnt[book[1] + 1] -= book[2];
        }
        for (int i = 1; i < cnt.length; i++) {
            cnt[i] += cnt[i - 1];
        }
        int[] ans = new int[n];
        for (int i = 0; i < n; i++) {
            ans[i] = cnt[i + 1];
        }
        return ans;
    }
}
```



## [洛谷【普及+/提高】P4231.三步必杀](https://www.luogu.com.cn/problem/P4231)



```java
import java.io.*;

public class Solution {

    // N长数组
    // M次操作
    // 每次在N的[l,r]区间内加上首项为s，尾项为e的等差数列

    public static int MAXN = 10000005;
    public static long[] arr = new long[MAXN];
    public static int n, m;

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            m = (int) in.nval;
            for (int i = 0, l, r, s, e; i < m; i++) {
                in.nextToken();
                l = (int) in.nval;
                in.nextToken();
                r = (int) in.nval;
                in.nextToken();
                s = (int) in.nval;
                in.nextToken();
                e = (int) in.nval;
                set(l, r, s, e, (e - s) / (r - l));
            }
            build();
            long max = 0, xor = 0;
            for (int i = 1; i <= n; i++) {
                max = Math.max(max, arr[i]);
                xor ^= arr[i];
            }
            out.println(xor + " " + max);
        }
        out.flush();
        out.close();
        br.close();
    }

    // l r
    // 0,1,2 ,3 ,4 ,5 ,6 ,7
    // 0,s,d-s,0 ,0 ,0 ,-e-d,e
    // 0,s,d ,d ,d ,d ,-e ,0
    // 0,s,s+d,s+2d,s+3d,s+4d(e),0 ,0
    public static void set(int l, int r, int s, int e, int d) {
        arr[l] += s;
        arr[l + 1] += d - s;
        arr[r + 1] -= d + e;
        arr[r + 2] += e;
    }

    public static void build() {
        for (int i = 1; i <= n; i++) {
            arr[i] += arr[i - 1];
        }
        for (int i = 1; i <= n; i++) {
            arr[i] += arr[i - 1];
        }
    }
}
```



## [洛谷【普及+/提高】P5026.Lycanthropy](https://www.luogu.com.cn/problem/P5026)



```java
// Java8
import java.io.*;

public class Solution {
    // 湖泊的最大宽度
    public static int MAXN = 1000001;
    // 落水的最大体积为10000
    // 左右最大波及范围：x-3*v+1 ~ x+3*v-1
    // 因此整体向右平移
    public static int OFFSET = 30001;
    // 湖泊宽度为MAXN
    // 左右扩展可能波及的最大范围
    public static int[] arr = new int[OFFSET + MAXN + OFFSET];
    // n个人落水，m个位置
    public static int n, m;

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            m = (int) in.nval;
            for (int i = 0, v, x; i < n; i++) {
                in.nextToken();
                v = (int) in.nval;
                in.nextToken();
                x = (int) in.nval;
                // v体积的朋友，在x处落水
                fall(v, x);
            }
            build();
            int start = OFFSET + 1;
            out.print(arr[start++]);
            for (int i = 2; i <= m; i++) {
                out.print(" " + arr[start++]);
            }
            out.println();
        }
        out.flush();
        out.close();
        br.close();
    }

    public static void fall(int v, int x) {
        // 波及范围：x-3*v+1 ~ x+3*v-1
        //   *           *
        //  * *         * *
        // *   *       *   *
        // --------------------------
        //       *   *
        //        * *
        //         *
        set(x - 3 * v + 1, x - 2 * v, 1, v, 1);
        set(x - 2 * v + 1, x, v - 1, -v, -1);
        set(x + 1, x + 2 * v, -v + 1, v, 1);
        set(x + 2 * v + 1, x + 3 * v - 1, v - 1, 1, -1);
    }

    public static void set(int l, int r, int s, int e, int d) {
        arr[l + OFFSET] += s;
        arr[l + 1 + OFFSET] += d - s;
        arr[r + 1 + OFFSET] -= d + e;
        arr[r + 2 + OFFSET] += e;
    }

    public static void build() {
        for (int i = 1; i <= m + OFFSET; i++) {
            arr[i] += arr[i - 1];
        }
        for (int i = 1; i <= m + OFFSET; i++) {
            arr[i] += arr[i - 1];
        }
    }
}
```



***



# ✅048【必备】二维前缀和二维差分离散化技巧



## [Leetcode【中】204.二维区域和检索——矩阵不变](https://leetcode.cn/problems/range-sum-query-2d-immutable/description/)



```java
public class Solution {
    // 二维矩阵左上右下两点定位的矩阵和
    class NumMatrix {
        public int[][] sum;

        public NumMatrix(int[][] matrix) {
            int n = matrix.length;
            int m = matrix[0].length;
            sum = new int[n + 1][m + 1];
            for (int a = 1, c = 0; c < n; a++, c++) {
                for (int b = 1, d = 0; d < m; b++, d++) {
                    sum[a][b] = matrix[c][d];
                }
            }
            for (int i = 1; i <= n; i++) {
                for (int j = 1; j <= m; j++) {
                    sum[i][j] += sum[i][j - 1] + sum[i - 1][j] - sum[i - 1][j - 1];
                }
            }
        }

        public int sumRegion(int a, int b, int c, int d) {
            return sum[c + 1][d + 1] - sum[c + 1][b] - sum[a][d + 1] + sum[a][b];
        }
    }
}
```



## [Leetcode【中】1139.最大的以 1 为边界的正方形](https://leetcode.cn/problems/largest-1-bordered-square/description/)



```java
public class Solution {

    public static int largest1BorderedSquare(int[][] g) {
        int n = g.length;
        int m = g[0].length;
        build(n, m, g);
        if (sum(g, 0, 0, n - 1, m - 1) == 0) {
            return 0;
        }
        int ans = 1;
        for (int a = 0; a < n; a++) {
            for (int b = 0; b < m; b++) {
                // (a,b)从左上角开始，遍历二维矩阵所有点
                // (c,d)是(a,b)对应的所有可能的右下角
                // 因为已知我们二维矩阵中最小正方形为1
                // 那么我们每次就判断当前点是否能构成一个边长为ans+1的正方形（也是一种剪枝操作）
                for (int c = a + ans, d = b + ans, k = ans + 1; c < n && d < m; c++, d++, k++) {
                    if (sum(g, a, b, c, d) - sum(g, a + 1, b + 1, c - 1, d - 1) == (k - 1) << 2) {
                        ans = k;
                    }
                }
            }
        }
        return ans * ans;
    }

    // 将原始二维数组转换为零点与目标坐标构成的矩阵的和填充的数组
    public static void build(int n, int m, int[][] g) {
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                g[i][j] += get(g, i, j - 1) + get(g, i - 1, j) - get(g, i - 1, j - 1);
            }
        }
    }

    // 计算矩阵中(a,b)到(c,d)的和
    // 如果是一个二维矩阵，那么直接返回矩阵内的面积为0
    public static int sum(int[][] g, int a, int b, int c, int d) {
        return a > c ? 0 : (g[c][d] - get(g, c, b - 1) - get(g, a - 1, d) + get(g, a - 1, b - 1));
    }

    // 获取矩阵中(i,j)的元素
    // 如果(i,j)超出矩阵范围，返回0
    public static int get(int[][] g, int i, int j) {
        return (i < 0 || j < 0) ? 0 : g[i][j];
    }
}
```



## [洛谷【普及-】P3397.地毯](https://www.luogu.com.cn/problem/P3397)



```java
import java.io.*;

public class Solution {
    public static int MAXN = 1002;
    public static int[][] diff = new int[MAXN][MAXN];
    public static int n, q;

    public static void add(int a, int b, int c, int d, int k) {
        diff[a][b] += k;
        diff[c + 1][b] -= k;
        diff[a][d + 1] -= k;
        diff[c + 1][d + 1] += k;
    }

    public static void build() {
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= n; j++) {
                diff[i][j] += diff[i - 1][j] + diff[i][j - 1] - diff[i - 1][j - 1];
            }
        }
    }

    public static void clear() {
        for (int i = 1; i <= n + 1; i++) {
            for (int j = 1; j <= n + 1; j++) {
                diff[i][j] = 0;
            }
        }
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            q = (int) in.nval;
            for (int i = 1, a, b, c, d; i <= q; i++) {
                in.nextToken();
                a = (int) in.nval;
                in.nextToken();
                b = (int) in.nval;
                in.nextToken();
                c = (int) in.nval;
                in.nextToken();
                d = (int) in.nval;
                add(a, b, c, d, 1);
            }
            build();
            for (int i = 1; i <= n; i++) {
                out.print(diff[i][1]);
                for (int j = 2; j <= n; j++) {
                    out.print(" " + diff[i][j]);
                }
                out.println();
            }
            clear();
        }
        out.flush();
        out.close();
    }
}
```



## [牛客【】【模板】二维差分](https://www.nowcoder.com/practice/50e1a93989df42efb0b1dec386fb4ccc)



```java
import java.io.*;

public class Solution {
    public static int MAXN = 1005;
    public static int MAXM = 1005;
    public static long[][] diff = new long[MAXN][MAXM];
    public static int n, m, q;

    public static void add(int a, int b, int c, int d, int k) {
        diff[a][b] += k;
        diff[c + 1][b] -= k;
        diff[a][d + 1] -= k;
        diff[c + 1][d + 1] += k;
    }

    public static void build() {
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= m; j++) {
                diff[i][j] += diff[i - 1][j] + diff[i][j - 1] - diff[i - 1][j - 1];
            }
        }
    }

    public static void clear() {
        for (int i = 1; i <= n + 1; i++) {
            for (int j = 1; j <= m + 1; j++) {
                diff[i][j] = 0;
            }
        }
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            m = (int) in.nval;
            in.nextToken();
            q = (int) in.nval;
            for (int i = 1; i <= n; i++) {
                for (int j = 1; j <= m; j++) {
                    in.nextToken();
                    add(i, j, i, j, (int) in.nval);
                }
            }
            for (int i = 1, a, b, c, d, k; i <= q; i++) {
                in.nextToken();
                a = (int) in.nval;
                in.nextToken();
                b = (int) in.nval;
                in.nextToken();
                c = (int) in.nval;
                in.nextToken();
                d = (int) in.nval;
                in.nextToken();
                k = (int) in.nval;
                add(a, b, c, d, k);
            }
            build();
            for (int i = 1; i <= n; i++) {
                out.print(diff[i][1]);
                for (int j = 2; j <= m; j++) {
                    out.print(" " + diff[i][j]);
                }
                out.println();
            }
            clear();
        }
        out.flush();
        out.close();
    }
}
```



## [Leetcode【难】2132.用油票贴满网格图](https://leetcode.cn/problems/stamping-the-grid/)



```java
public class Solution {
    public static boolean possibleToStamp(int[][] grid, int h, int w) {
        int n = grid.length;
        int m = grid[0].length;
        // 前缀和数组
        int[][] sum = new int[n + 1][m + 1];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                sum[i + 1][j + 1] = grid[i][j];
            }
        }
        build(sum);
        // 差分矩阵
        // 原始矩阵负责判断能否贴邮票
        // 差分矩阵则直接更改
        int[][] diff = new int[n + 2][m + 2];
        for (int a = 1, c = a + h - 1; c <= n; a++, c++) {
            for (int b = 1, d = b + w - 1; d <= m; b++, d++) {
                if (sumRegion(sum, a, b, c, d) == 0) {
                    add(diff, a, b, c, d);
                }
            }
        }
        build(diff);
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (grid[i][j] == 0 && diff[i + 1][j + 1] == 0) {
                    return false;
                }
            }
        }
        return true;
    }

    public static void build(int[][] m) {
        for (int i = 1; i < m.length; i++) {
            for (int j = 1; j < m[0].length; j++) {
                m[i][j] += m[i - 1][j] + m[i][j - 1] - m[i - 1][j - 1];
            }
        }
    }

    public static int sumRegion(int[][] sum, int a, int b, int c, int d) {
        return sum[c][d] - sum[c][b - 1] - sum[a - 1][d] + sum[a - 1][b - 1];
    }

    public static void add(int[][] diff, int a, int b, int c, int d) {
        diff[a][b] += 1;
        diff[c + 1][d + 1] += 1;
        diff[c + 1][b] -= 1;
        diff[a][d + 1] -= 1;
    }
}
```



## [Leetcode【中】LCP74.最强祝福力场](https://leetcode.cn/problems/xepqZ5/description/)



```java
import java.util.*;

public class Solution {
    public static int fieldOfGreatestBlessing(int[][] fields) {
        // n个力场
        int n = fields.length;
        // 2*n个坐标
        long[] xs = new long[n << 1];
        long[] ys = new long[n << 1];
        // 坐标系扩大两倍
        for (int i = 0, k = 0, p = 0; i < n; i++) {
            long x = fields[i][0];
            long y = fields[i][1];
            long r = fields[i][2];
            xs[k++] = (x << 1) - r;
            xs[k++] = (x << 1) + r;
            ys[p++] = (y << 1) - r;
            ys[p++] = (y << 1) + r;
        }
        int sizex = sort(xs);
        int sizey = sort(ys);

        int[][] diff = new int[sizex + 2][sizey + 2];
        for (int i = 0, a, b, c, d; i < n; i++) {
            long x = fields[i][0];
            long y = fields[i][1];
            long r = fields[i][2];
            a = rank(xs, (x << 1) - r, sizex);
            b = rank(ys, (y << 1) - r, sizey);
            c = rank(xs, (x << 1) + r, sizex);
            d = rank(ys, (y << 1) + r, sizey);
            add(diff, a, b, c, d);
        }
        int ans = 0;
        // O(n^2)
        for (int i = 1; i < diff.length; i++) {
            for (int j = 1; j < diff[0].length; j++) {
                diff[i][j] += diff[i - 1][j] + diff[i][j - 1] - diff[i - 1][j - 1];
                ans = Math.max(ans, diff[i][j]);
            }
        }
        return ans;
    }

    // 排序并去重
    public static int sort(long[] nums) {
        Arrays.sort(nums);
        int size = 1;
        for (int i = 1; i < nums.length; i++) {
            if (nums[i] != nums[size - 1]) {
                nums[size++] = nums[i];
            }
        }
        return size;
    }

    public static int rank(long[] nums, long v, int size) {
        int l = 0;
        int r = size - 1;
        int m, ans = 0;
        while (l <= r) {
            m = (l + r) / 2;
            if (nums[m] >= v) {
                ans = m;
                r = m - 1;
            } else {
                l = m + 1;
            }
        }
        return ans + 1;
    }

    // 矩形区域增加
    public static void add(int[][] diff, int a, int b, int c, int d) {
        diff[a][b]++;
        diff[c + 1][d + 1]++;
        diff[c + 1][b]--;
        diff[a][d + 1]--;
    }
}
```



***



# ✅049【必备】滑动窗口



## [Leetcode【中】209.长度最小的子数组](https://leetcode.cn/problems/minimum-size-subarray-sum/description/)



```java
public class Solution {
    // 给定一个长度为N的都是正整数的数组
    // 返回累加和>=target的最短子数组
    public static int minSubArrayLen(int target, int[] nums) {
        int ans = Integer.MAX_VALUE;
        for (int l = 0, r = 0, sum = 0; r < nums.length; r++) {
            sum += nums[r];
            while (sum - nums[l] >= target) {
                sum -= nums[l++];
            }
            if (sum >= target) {
                ans = Math.min(ans, r - l + 1);
            }
        }
        return ans == Integer.MAX_VALUE ? 0 : ans;
    }

}
```



## [Leetcode【中】3.无重复字符的最长子串](https://leetcode.cn/problems/longest-substring-without-repeating-characters/description/)



```java
import java.util.*;

public class Solution {
    // 给定一字符串
    // 返回最长的无重复字符的长度
    public static int lengthOfLongestSubstring(String str) {
        char[] s = str.toCharArray();
        int n = s.length;
        // char -> int -> 0 ~ 255
        // 每一种字符上次出现的位置
        int[] last = new int[256];
        Arrays.fill(last, -1);
        int ans = 0;
        for (int l = 0, r = 0; r < n; r++) {
            l = Math.max(l, last[s[r]] + 1);
            ans = Math.max(ans, r - l + 1);
            last[s[r]] = r;
        }
        return ans;
    }
}
```



## [Leetcode【难】76.最小覆盖子串](https://leetcode.cn/problems/minimum-window-substring/description/)



```java
public class Solution {
    // 给定一字符串
    // 返回覆盖指定字符串中所有字符的最短子串（空返回“”）
    // 无需考虑字符出现顺序
    public static String minWindow(String str, String tar) {
        char[] s = str.toCharArray();
        char[] t = tar.toCharArray();
        // 用负债模拟每个字符的统计
        int[] cnt = new int[256];
        for (char cha : t) {
            cnt[cha]--;
        }
        // 最短覆盖的长度
        int len = Integer.MAX_VALUE;
        // 最短覆盖的子串的开始位置
        int start = 0;
        // 总负债
        int debt = t.length;
        for (int l = 0, r = 0; r < s.length; r++) {
            // 窗口左边界向右滑动
            if (cnt[s[r]]++ < 0) {
                debt--;
            }
            if (debt == 0) {
                while (cnt[s[l]] > 0) {
                    cnt[s[l++]]--;
                }
                if (r - l + 1 < len) {
                    len = r - l + 1;
                    start = l;
                }
            }
        }
        return len == Integer.MAX_VALUE ? "" : str.substring(start, start + len);
    }
}
```



## [Leetcode【中】134.加油站](https://leetcode.cn/problems/gas-station/description/)



```java
public class Solution {
    // 给定两个数组
    // gas[i]表示第i个加油站的油量
    // cost[i]表示第i个加油站到第i+1个加油站的消耗
    // 返回能环绕一圈的加油站的编号，确保结果唯一
    // 如果不存在这样的加油站，返回-1
    public static int canCompleteCircuit(int[] gas, int[] cost) {
        int n = gas.length;
        for (int l = 0, r = 0, sum; l < n; l = r + 1, r = l) {
            sum = 0;
            while (sum + gas[r % n] - cost[r % n] >= 0) {
                if (r - l + 1 == n) {
                    return l;
                }
                sum += gas[r % n] - cost[r % n];
                r++;
            }
        }
        return -1;
    }
}
```



## [Leetcode【中】1234.替换子串得到平衡字符串](https://leetcode.cn/problems/replace-the-substring-for-balanced-string/description/)



```java
public class Solution {
    // 平衡字符串：只含有“Q/W/E/R”，且四种字符出现次数相等
    // 返回需要替换的子串的最短长度
    public static int balancedString(String str) {
        int n = str.length();
        int[] s = new int[n];
        int[] cnt = new int[4];
        for (int i = 0; i < n; i++) {
            char c = str.charAt(i);
            s[i] = c == 'W' ? 1 : (c == 'E' ? 2 : (c == 'R' ? 3 : 0));
            cnt[s[i]]++;
        }
        int debt = 0;
        for (int i = 0; i < 4; i++) {
            if (cnt[i] < n / 4) {
                cnt[i] = 0;
            } else {
                cnt[i] = n / 4 - cnt[i];
                debt -= cnt[i];
            }
        }
        if (debt == 0) {
            return 0;
        }
        int ans = Integer.MAX_VALUE;
        for (int l = 0, r = 0; r < n; r++) {
            if (cnt[s[r]]++ < 0) {
                debt--;
            }
            if (debt == 0) {
                while (cnt[s[l]] > 0) {
                    cnt[s[l++]]--;
                }
                ans = Math.min(ans, r - l + 1);
            }
        }
        return ans;
    }
}
```



## [Leetcode【难】992.K 个不同整数的子数组](https://leetcode.cn/problems/subarrays-with-k-different-integers/description/)



```java
import java.util.*;

public class Solution {
    // 给定一个正整数数组nums，和一个整数k
    // 返回数组中由k个不同整数组成的连续的可以重复（位置不同）的子数组个数

    public static int subarraysWithKDistinct(int[] arr, int k) {
        return numsOfMostKinds(arr, k) - numsOfMostKinds(arr, k - 1);
    }

    public static int MAXN = 20001;
    public static int[] cnts = new int[MAXN];

    // 返回一个数组中数字种类不超过k种的子数组的个数
    public static int numsOfMostKinds(int[] arr, int k) {
        Arrays.fill(cnts, 1, arr.length + 1, 0);
        int ans = 0;
        for (int l = 0, r = 0, collect = 0; r < arr.length; r++) {
            if (++cnts[arr[r]] == 1) {
                collect++;
            }
            while (collect > k) {
                if (--cnts[arr[l++]] == 0) {
                    collect--;
                }
            }
            ans += r - l + 1;
        }
        return ans;
    }
}
```



## [Leetcode【中】395.至少有 K 个重复字符的最长字串](https://leetcode.cn/problems/longest-substring-with-at-least-k-repeating-characters/description/)



```java
import java.util.Arrays;

public class Solution {
    // 给定一个字符串
    // 返回一个字符串
    // 要求：其中的每个字符均大于K次，并且长度最长
    public static int longestSubstring(String str, int k) {
        char[] s = str.toCharArray();
        int n = s.length;
        int[] cnts = new int[256];
        int ans = 0;
        for (int require = 1; require <= 26; require++) {
            Arrays.fill(cnts, 0);
            for (int l = 0, r = 0, collect = 0, satisfy = 0; r < n; r++) {
                cnts[s[r]]++;
                if (cnts[s[r]] == 1) {
                    collect++;
                }
                if (cnts[s[r]] == k) {
                    satisfy++;
                }
                while (collect > require) {
                    if (cnts[s[l]] == 1) {
                        collect--;
                    }
                    if (cnts[s[l]] == k) {
                        satisfy--;
                    }
                    cnts[s[l++]]--;
                }
                if (satisfy == require) {
                    ans = Math.max(ans, r - l + 1);
                }
            }
        }
        return ans;
    }
}
```



***



# ✅050【必备】双指针



## [Leetcode【易】922.按奇偶排序数组 II](https://leetcode.cn/problems/sort-array-by-parity-ii/description/)



```java
public class Solution {
    // 给定一个非负数组，一半奇数，一半偶数
    // 对数组进行排序，要求奇数在下标奇数位置上，偶数在下标偶数位置上
    public static int[] sortArrayByParityII(int[] nums) {
        int n = nums.length;
        for (int odd = 1, even = 0; odd < n && even < n;) {
            if ((nums[n - 1] & 1) == 1) {
                swap(nums, odd, n - 1);
                odd += 2;
            } else {
                swap(nums, even, n - 1);
                even += 2;
            }
        }
        return nums;
    }

    public static void swap(int[] nums, int i, int j) {
        int tmp = nums[i];
        nums[i] = nums[j];
        nums[j] = tmp;
    }
}
```



## [Leetcode【中】287.寻找重复数](https://leetcode.cn/problems/find-the-duplicate-number/description/)



```java
public class Solution {
    // 长度为n+1的数组
    // 数组中元素范围为[1,n]
    // 返回其中出现两次的数字
    public static int findDuplicate(int[] nums) {
        if (nums == null || nums.length < 2) {
            return -1;
        }
        // 慢指针：一次跳一步
        int slow = nums[0];
        // 快指针：一次跳两步
        int fast = nums[nums[0]];
        while (slow != fast) {
            slow = nums[slow];
            fast = nums[nums[fast]];
        }
        // 二者相遇后
        // 快指针回到起点
        // 慢指针和快指针都一次跳一步
        // 二者相遇的点就是环的入口
        fast = 0;
        while (slow != fast) {
            slow = nums[slow];
            fast = nums[fast];
        }
        return slow;
    }
}
```



## [Leetcode【难】42.接雨水](https://leetcode.cn/problems/trapping-rain-water/description/)



```java
public class Solution {
    // 给定n个元素的数组，表示柱子的高度
    // 返回可以接雨水的总量
    public static int trap1(int[] nums) {
        // 逐个位置求水量
        int n = nums.length;
        // 每个位置的左边最大值
        int[] lmax = new int[n];
        lmax[0] = nums[0];
        for (int i = 1; i < n; i++) {
            lmax[i] = Math.max(lmax[i - 1], nums[i]);
        }
        // 每个位置的右边最大值
        int[] rmax = new int[n];
        rmax[n - 1] = nums[n - 1];
        for (int i = n - 2; i >= 0; i--) {
            rmax[i] = Math.max(rmax[i + 1], nums[i]);
        }
        // 每个位置的水量
        int ans = 0;
        for (int i = 1; i < n - 1; i++) {
            ans += Math.max(0, Math.min(lmax[i - 1], rmax[i + 1]) - nums[i]);
        }
        return ans;
    }

    public static int trap2(int[] nums) {
        int l = 1, r = nums.length - 2, lmax = nums[0], rmax = nums[nums.length - 1];
        int ans = 0;
        while (l <= r) {
            // 如果l左侧最大值lmax小于r右侧最大值rmax
            // 那么l右侧最大值最少也是rmax
            // 所以l左侧的最大值一定小于l右侧的最大值
            // 所以l位置的水量就是l左侧的最大值减去l位置的高度
            if (lmax <= rmax) {
                ans += Math.max(0, lmax - nums[l]);
                lmax = Math.max(lmax, nums[l++]);
            }
            // 如果l左侧最大值lmax大于r右侧最大值rmax
            // 那么r左侧最大值最少也是lmax
            // 所以r右侧的最大值一定小于r左侧的最大值
            // 所以r位置的水量就是r右侧的最大值减去r位置的高度
            else {
                ans += Math.max(0, rmax - nums[r]);
                rmax = Math.max(rmax, nums[r--]);
            }
        }
        return ans;
    }
}
```



## [Leetcode【中】881.救生艇](https://leetcode.cn/problems/boats-to-save-people/description/)



```java
import java.util.*;

public class Solution {

    // n个人
    // 每个船最多两人
    // 体重和不超过limit
    // 返回需要的最少船数
    public static int numRescueBoats(int[] people, int limit) {
        Arrays.sort(people);
        int ans = 0, l = 0, r = people.length - 1, sum = 0;
        while (l <= r) {
            sum = l == r ? people[l] : people[l] + people[r];
            if (sum > limit) {
                r--;
            } else {
                l++;
                r--;
            }
            ans++;
        }
        return ans;
    }
}
```



## [Leetcode【中】11.盛水最多的容器](https://leetcode.cn/problems/container-with-most-water/description/)



```java
public class Solution {

    // 长度为n的数组，表示柱子的高度
    // 挑选两根柱子，使其与x轴组成的容器可以容纳最多的水
    // 返回最大储水量
    public static int maxArea(int[] height) {
        int ans = 0;
        for (int l = 0, r = height.length - 1; l < r;) {
            ans = Math.max(ans, Math.min(height[l], height[r]) * (r - l));
            if (height[l] <= height[r]) {
                l++;
            } else {
                r--;
            }
        }
        return ans;
    }
}
```



## [Leetcode【中】475.供暖器](https://leetcode.cn/problems/heaters/description/)



```java
import java.util.*;

public class Solution {
    // x轴正半轴，若干坐标房屋，若干坐标供暖期
    // 返回最小辐射半径，使得每个房屋都被供暖
    public static int findRadius(int[] houses, int[] heaters) {
        Arrays.sort(houses);
        Arrays.sort(heaters);
        int ans = 0;
        for (int i = 0, j = 0; i < houses.length; i++) {
            // i号房屋
            // j号供暖器
            while (!best(houses, heaters, i, j)) {
                j++;
            }
            ans = Math.max(ans, Math.abs(heaters[j] - houses[i]));
        }
        return ans;
    }

    // 1、当供暖器来到最后一个时，它只能是最优选择
    // 2、如果当前供暖器到覆盖房屋的距离小于下一个供暖器到覆盖房屋的距离，
    // 那么当前供暖器就是最优选择
    // 3、如果当前供暖器到覆盖房屋的距离大于等于下一个供暖器到覆盖房屋的距离，
    // 那么下一个供暖器就是最优选择（特别注意：相等时，也需要向后移动）
    public static boolean best(int[] houses, int[] heaters, int i, int j) {
        return j == heaters.length - 1
                ||
                Math.abs(heaters[j] - houses[i]) < Math.abs(heaters[j + 1] - houses[i]);
    }
}
```



## [Leetcode【难】41.缺失的第一个正数](https://leetcode.cn/problems/first-missing-positive/description/)



```java
public class Solution {
    // 给定一个无序数组
    // 返回缺失的最小正整数
    public static int firstMissingPositive(int[] nums) {
        // l的左侧，都是对应i位置放着i+1数字的区域
        int l = 0;
        // r右侧：垃圾区
        // 数组长度n，也就是最多收集1~n这些数字
        // 若有垃圾则r--，放至r右侧
        int r = nums.length;
        while (l < r) {
            // 1、nums[l]==l+1
            // i位置放着i+1数字
            if (nums[l] == l + 1) {
                l++;
            }
            // 2、nums[l]<=l
            // 小于l的位置已经存在了收集到的数字，对于重复的判定为垃圾处理
            // 3、nums[l]>r
            // 大于r的数字，已经超过了最大收集的数字，判定为来及
            // 4、nums[nums[l]-1]==nums[l]
            // i位置上已经存在了i+1这个数
            else if (nums[l] <= l || nums[l] > r || nums[nums[l] - 1] == nums[l]) {
                swap(nums, l, --r);
            }
            // 5、nums[l]在l+1~r-1范围上，且其对应nums[l]+1位置上不是nums[l]
            else {
                swap(nums, l, nums[l] - 1);
            }
        }
        return l + 1;
    }

    public static void swap(int[] arr, int i, int j) {
        int tmp = arr[i];
        arr[i] = arr[j];
        arr[j] = tmp;
    }
}
```



***



# ✅051【必备】二分答案法



## [Leetcode【中】875.爱吃香蕉的珂珂](https://leetcode.cn/problems/koko-eating-bananas/description/)



```java
public class Solution {
    // n堆香蕉
    // 吃香蕉的速度为k，一小时内只能吃一堆
    // 最多h小时
    // 返回最小速度
    public static int minEatingSpeed(int[] piles, int h) {
        int l = 1;
        int r = 0;
        // 最大的一堆香蕉中香蕉数量
        for (int pile : piles) {
            r = Math.max(r, pile);
        }
        // 速度与耗时反比，速度越小，耗时越多
        int ans = 0;
        // 最小且达标的速度，范围[l,r]
        int mid = 0;
        while (l <= r) {
            // mid=(l+r)/2
            mid = l + ((r - l) >> 1);
            // 耗时<=h，达标,继续试探更小速度
            if (f(piles, mid) <= h) {
                ans = mid;
                r = mid - 1;
            }
            // 耗时>h，不达标,继续试探更大速度
            else {
                l = mid + 1;
            }
        }
        return ans;
    }

    // 返回speed速度吃香蕉的耗时
    public static long f(int[] piles, int speed) {
        long ans = 0;
        for (int pile : piles) {
            ans += (pile + speed - 1) / speed;
        }
        return ans;
    }
}
```



## [Leetcode【难】410.分割数组的最大值](https://leetcode.cn/problems/split-array-largest-sum/description/)



```java
public class Solution {
    // 一个非负数组nums
    // 将其拆分为m个非空连续数组
    // 使得这些子数组各自和的最大值最小
    public static int splitArray(int[] nums, int k) {
        // 数组总和
        long sum = 0;
        for (int num : nums) {
            sum += num;
        }
        long ans = 0;
        // [0,sum]二分
        for (long l = 0, r = sum, mid, need; l <= r;) {
            // 每组累加和不超过mid
            mid = l + ((r - l) >> 1);
            // 每组累加和<=mid，需要划分几组
            need = f(nums, mid);
            // 如果需要的组数量<=k，说明mid是一个可能的答案
            if (need <= k) {
                // 记录可能答案
                ans = mid;
                // 尝试更小的mid，试探更大的need
                r = mid - 1;
            } else {
                // 如果需要的组数量>k，说明mid不是一个可能的答案
                // 尝试更大的mid，试探更小的need
                l = mid + 1;
            }
        }
        return (int) ans;
    }

    // 让数组的每一部分累加和<=limit，需要划分为几个部分
    public static int f(int[] arr, long limit) {
        int parts = 1;
        int sum = 0;
        for (int num : arr) {
            if (num > limit) {
                return Integer.MAX_VALUE;
            }
            if (sum + num > limit) {
                parts++;
                sum = num;
            } else {
                sum += num;
            }
        }
        return parts;
    }
}
```



## [牛客【】机器人跳跃问题](https://www.nowcoder.com/practice/7037a3d57bbd4336856b8e16a9cafd71)



```java
import java.io.*;

public class Solution {
    // N+1座建筑
    // 0建筑高度为0，初始能量s，i建筑高度为H(i)
    // 连续向右跳
    // 若位于k建筑，自身能量E
    // 下一建筑高度H(k+1)
    // 若H(k+1) <= E，下一建筑处的能量E+E-H(k+1)
    // 若H(k+1) > E，下一建筑处的能量E+E-H(k+1)
    // 若想通关，返回起始最小需要能量

    public static int MAXN = 100001;
    public static int[] arr = new int[MAXN];
    public static int n;

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            int l = 0;
            int r = 0;
            for (int i = 1; i <= n; i++) {
                in.nextToken();
                arr[i] = (int) in.nval;
                r = Math.max(r, arr[i]);
            }
            // 最大值必然通过
            out.println(compute(l, r, r));
        }
        out.flush();
        out.close();
    }

    // [l,r]通关所需要的最小能量的范围
    // max是所有建筑的最大高度
    public static int compute(int l, int r, int max) {
        int mid, ans = -1;
        while (l <= r) {
            mid = l + ((r - l) >> 1);
            if (f(mid, max)) {
                ans = mid;
                r = mid - 1;
            } else {
                l = mid + 1;
            }
        }
        return ans;
    }

    // max：如果过程中，能量超过了max（所有建筑中的最高建筑），
    // 那么该能量一定可以通关
    public static boolean f(int energy, int max) {
        for (int i = 1; i <= n; i++) {
            // if (energy <= arr[i]) {
            // energy -= arr[i] - energy;
            // } else {
            // energy += energy - arr[i];
            // }
            energy += energy - arr[i];
            if (energy >= max) {
                return true;
            }
            if (energy < 0) {
                return false;
            }
        }
        return true;
    }
}
```



## [Leetcode【难】719.找出第 K 小的数对距离](https://leetcode.cn/problems/find-k-th-smallest-pair-distance/description/)



```java
import java.util.*;

public class Solution {
    // 给定一个整数数组nums与一个整数k
    // 返回第K小的数对距离（两个整数的绝对值查）
    public static int smallestDistancePair(int[] nums, int k) {
        int n = nums.length;
        Arrays.sort(nums);
        int ans = 0;
        // [0,最大-最小]：右边界是最大的数对距离
        for (int l = 0, r = nums[n - 1] - nums[0], mid, count; l <= r;) {
            // 数对距离的中值
            mid = l + ((r - l) >> 1);
            // 返回数对距离小于等于mid的数量
            count = f(nums, mid);
            if (count >= k) {
                // 数对距离的第mid小中mid大于k，说明mid偏大
                ans = mid;
                r = mid - 1;
            } else {
                // 数对距离的第mid小中mid小于k，说明mid偏小
                l = mid + 1;
            }
        }
        return ans;
    }

    // 返回数组中数对距离小于等于limit的数量
    public static int f(int[] arr, int limit) {
        int ans = 0;
        // 滑动窗口（双指针），左边界固定
        for (int l = 0, r = 0; l < arr.length; l++) {
            // 右边界向右移动
            // 1、右边界不越界
            // 2、移动的右边界-固定的左边界<=limit
            while (r + 1 < arr.length && arr[r + 1] - arr[l] <= limit) {
                r++;
            }
            // 左边界每次固定，右边界向右移动，计算数对距离小于等于limit的数量
            ans += r - l;
        }
        return ans;
    }
}
```



## [Leetcode【难】2141.同时运行 N 台电脑的最长时间](https://leetcode.cn/problems/maximum-running-time-of-n-computers/description/)



```java
public class Solution {
    // num台电脑，一数组batteries表示若干电池
    // 每个电池可支持一台电脑运行batteries[i]时间
    // 所有电脑需要同时都在运行，也就是同时都有电池支持
    // 每个电池只能支持一台电脑
    // 但每个电池可以在任意整数时刻切换支持电脑
    // 返回所有电脑同时运行的最大时间

    public static long maxRunTime1(int num, int[] arr) {
        // 所有电池总量
        long sum = 0;
        for (int x : arr) {
            sum += x;
        }
        // 所有电脑共同运行的时间
        long ans = 0;
        for (long l = 0, r = sum, mid; l <= r;) {
            // 让所有电脑运行mid时间，是否可行
            mid = l + ((r - l) >> 1);
            if (f(arr, num, mid)) {
                // 可行，则尝试更大的时间
                ans = mid;
                l = mid + 1;
            } else {
                // 不可行，则尝试更小的时间
                r = mid - 1;
            }
        }
        return ans;
    }

    // 让num台电脑共同运行time时间，是否可行
    public static boolean f(int[] arr, int num, long time) {
        long sum = 0;
        // 单个电池支持时间
        for (int x : arr) {
            if (x > time) {
                // 单个电池足矣支持一台电脑
                num--;
            } else {
                // 碎片电池：一个电池支持不了一台电脑time时间
                sum += x;
            }
            if (sum >= (long) num * time) {
                // 碎片电池总量>电脑台数*time
                // 单个电池可以支持一台电脑的电池和电脑均不计入
                return true;
            }
        }
        return false;
    }

    public static long maxRunTime2(int num, int[] arr) {
        int max = 0;
        // 所有电池总量
        long sum = 0;
        for (int x : arr) {
            max = Math.max(max, x);
            sum += x;
        }
        // 当所有电池总量>最大电池总量*电脑台数
        // 则同时运行时间必定大于max
        // 此时，所有电脑最多同时运行sum/num时间
        if (sum > (long) max * num) {
            return sum / num;
        }
        // 当所有电池总量<最大电池总量*电脑台数
        // 则同时运行时间必定小于等于max
        // [0,max]较原来的[0,sum]范围更小

        // 相当于把一个电池支持一台电脑的情况但拉出来考虑
        // 至于所有电脑都是碎片，则必然可以使用所有碎片时间

        long ans = 0;
        for (int l = 0, r = max, mid; l <= r;) {
            mid = l + ((r - l) >> 1);
            if (f(arr, num, mid)) {
                ans = mid;
                l = mid + 1;
            } else {
                r = mid - 1;
            }
        }
        return ans;
    }
}
```



## 谷歌笔试【】计算等位时间



```java
// Google 笔试
// 计算等位时间
// 给定一个长度n数组arr，表示n个服务员，每服务一个人对应的时间
// 给定一个正数m，表示有m个人等
// 假设m远大于n
// 如果你是刚来的，遵循“有空就上，多个空随意挑选”，请问你需要等多长时间

import java.util.*;

public class Solution {

    // 堆模拟
    public static int waitingTime1(int[] arr, int m) {
        // 小根堆
        // 一个一个出来，累加时间，再放回去
        // 其中元素按照完成服务时间排序
        PriorityQueue<int[]> heap = new PriorityQueue<>((a, b) -> a[0] - b[0]);
        for (int i = 0; i < arr.length; i++) {
            heap.add(new int[] { 0, arr[i] });
        }
        for (int i = 0; i < m; i++) {
            int[] cur = heap.poll();
            cur[0] += cur[1];
            heap.add(cur);
        }
        return heap.peek()[0];
    }

    // 二分最优解
    public static int waitingTime2(int[] arr, int m) {
        // 服务时间最短的人，也就是相同时间可以服务最多人的服务员
        int min = Integer.MAX_VALUE;
        for (int x : arr) {
            min = Math.min(x, min);
        }
        int ans = 0;
        // 最差情况：只使用服务时间最短的人
        // [0,min*m]也可以为第m个人服务完成，即一共m+1人受到了服务
        for (int l = 0, r = min * m, mid; l <= r;) {
            mid = l + ((r - l) >> 1);
            // [0,mid]，可以为多少人提供服务（包括服务好的、正在服务的）
            if (f(arr, mid) >= m + 1) {
                // [0,mid]，可以为>=m+1个人提供服务（包括服务好的、正在服务的）
                // 说明[0,mid]这个时间段内，是可以为第m个人服务完成的
                // 但是我们要找的是最早的时间点，所以继续在[0,mid-1]范围找
                ans = mid;
                r = mid - 1;
            } else {
                l = mid + 1;
            }
        }
        return ans;
    }

    // 每个服务员都服务[0,time]，一共可以接待多少人（包括服务好的、正在服务的）
    public static int f(int[] arr, int time) {
        int ans = 0;
        for (int num : arr) {
            // [0,8]（2个小时）:0、2、4、6、8
            // [0,8]（3个小时）:0、3、6、
            ans += (time / num) + 1;
        }
        return ans;
    }

    public static int[] randomArray(int n, int v) {
        int[] arr = new int[n];
        for (int i = 0; i < n; i++) {
            arr[i] = (int) (Math.random() * v) + 1;
        }
        return arr;
    }

    public static void main(String[] args) {
        int N = 10;
        int V = 10;
        int M = 100;
        int testTime = 100;
        for (int i = 0; i < testTime; i++) {
            int n = (int) (Math.random() * N) + 1;
            int[] arr = randomArray(n, V);
            int m = (int) (Math.random() * M) + 1;
            int ans1 = waitingTime1(arr, m);
            int ans2 = waitingTime2(arr, m);
            if (ans1 != ans2) {
                System.out.println("Oops!");
            }
        }
        System.out.println("Test passed!");
    }
}
```



## [Leetcode【中】2187.完成旅途的最少时间](https://leetcode.cn/problems/minimum-time-to-complete-trips/description/)



```java
public class Solution {
    // time[]辆公交车，i辆公交车完成一趟的时间为time[i]
    // 给定一个整数n
    // 返回这么多辆公交车总共完成n趟所需要的最少时间
    public static long minimumTime(int[] arr, int w) {
        int min = Integer.MAX_VALUE;
        for (int x : arr) {
            min = Math.min(min, x);
        }
        long ans = 0;
        for (long l = 0, r = (long) min * w, mid; l <= r;) {
            mid = l + ((r - l) >> 1);
            if (f(arr, mid) >= w) {
                ans = mid;
                r = mid - 1;
            } else {
                l = mid + 1;
            }
        }
        return ans;
    }

    // time时间内，arr[]辆公交车，最多能完成多少趟旅行
    // 这里指的是完成，正在进行的不能计算在内
    public static long f(int[] arr, long time) {
        long ans = 0;
        for (int num : arr) {
            ans += (time / num);
        }
        return ans;
    }
}
```



## 大厂笔试【】刀砍毒杀怪兽



```java
// 大厂笔试
// 刀砍毒杀怪兽
// 怪兽初始血量整数hp
// 给定两个长度n的整数数组，分别代表刀砍、毒杀的伤害值
// 第i回合选择刀砍，则当前回合怪兽直接损失cuts[i]的血量
// 第i回合选择毒杀，则从下一回合开始每回合都会损失poisons[i]的血量
// 每回合只能对操作进行二选一
// - 如果你在n回合内没有直接杀死怪兽，后续你不能再有任何操作
// - 但是如果怪兽有中毒效果，那么怪兽在n回合后即使没有任何操作也会逐渐掉血
// - 1<=n<=10^5
// - 1<=hp<=10^9
// - 1<=cuts[i],poisons[i]<=10^9
// 返回最少需要多少回合，怪兽被杀死

public class Solution {

    // 二分最优解
    // 因为无论是刀砍还是毒杀最低伤害都是1，那么最多最多hp+1回合就可以结束游戏
    // 因此二分范围确定[1,hp+1]
    public static int fast(int[] cuts, int[] poisons, int hp) {
        int ans = Integer.MAX_VALUE;
        for (int l = 1, r = hp + 1, mid; l <= r;) {
            // 假设必须在mid回合内游戏结束
            mid = l + ((r - l) >> 1);
            if (f(cuts, poisons, hp, mid)) {
                // 如果在mid回合内游戏结束，探索更少回合数
                ans = mid;
                r = mid - 1;
            } else {
                // 如果在mid回合内游戏结束，探索更多回合数
                l = mid + 1;
            }
        }
        return ans;
    }

    // 验证在limit回合内是否可以游戏结束
    public static boolean f(int[] cuts, int[] poisons, long hp, int limit) {
        int n = Math.min(cuts.length, limit);
        for (int i = 0; i < n; i++) {
            hp -= Math.max((long) cuts[i], (long) (limit - i - 1) * (long) poisons[i]);
            if (hp <= 0) {
                return true;
            }
        }
        return false;
    }

    // 动态规划方法(只是为了验证)
    public static int fast1(int[] cuts, int[] poisons, int hp) {
        int sum = 0;
        for (int num : poisons) {
            sum += num;
        }
        int[][][] dp = new int[cuts.length][hp + 1][sum + 1];
        return f1(cuts, poisons, 0, hp, 0, dp);
    }

    // 不做要求
    public static int f1(int[] cuts, int[] poisons, int i, int r, int p, int[][][] dp) {
        r -= p;
        if (r <= 0) {
            return i + 1;
        }
        if (i == cuts.length) {
            if (p == 0) {
                return Integer.MAX_VALUE;
            } else {
                return cuts.length + 1 + (r + p - 1) / p;
            }
        }
        if (dp[i][r][p] != 0) {
            return dp[i][r][p];
        }
        int p1 = r <= cuts[i] ? (i + 1) : f1(cuts, poisons, i + 1, r - cuts[i], p, dp);
        int p2 = f1(cuts, poisons, i + 1, r, p + poisons[i], dp);
        int ans = Math.min(p1, p2);
        dp[i][r][p] = ans;
        return ans;
    }

    public static int[] randomArray(int n, int v) {
        int[] ans = new int[n];
        for (int i = 0; i < n; i++) {
            ans[i] = (int) (Math.random() * v) + 1;
        }
        return ans;
    }

    public static void main(String[] args) {
        int N = 50;
        int V = 50;
        int H = 100;
        int testTimes = 100;
        for (int i = 0; i < testTimes; i++) {
            int n = (int) (Math.random() * N) + 1;
            int[] cuts = randomArray(n, V);
            int[] poisons = randomArray(n, V);
            int hp = (int) (Math.random() * H) + 1;
            int ans1 = fast(cuts, poisons, hp);
            int ans2 = fast1(cuts, poisons, hp);
            if (ans1 != ans2) {
                System.out.println("Oops!");
            }
            System.out.println("test " + i + " passed");
        }
    }
}
```



***



# ✅052【必备】单调栈-上



## [牛客【】单调栈结构（进阶）](https://www.nowcoder.com/practice/2a2c00e7a88a498693568cef63a4b7bb)



```java
import java.io.*;

public class Solution {

    // 单调栈结构（栈自底到顶是递增的）
    // 含重复元素的情况也能够解决不含重复元素的情况

    // 给定一arr数组
    // 返回每一个位置左边和右边离自己最近且比自己小的位置
    // 数组元素可重复也可不重复

    public static int MAXN = 1000001;
    // arr数组
    public static int[] arr = new int[MAXN];
    // 单调栈
    public static int[] stack = new int[MAXN];
    // ans[i][0]表示i位置左边离自己最近且比自己小的位置
    // ans[i][1]表示i位置右边离自己最近且比自己小的位置
    public static int[][] ans = new int[MAXN][2];
    // 数组长度、单调栈中元素数量
    public static int n, r;

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            for (int i = 0; i < n; i++) {
                in.nextToken();
                arr[i] = (int) in.nval;
            }
            compute();
            for (int i = 0; i < n; i++) {
                out.println(ans[i][0] + " " + ans[i][1]);
            }
        }
        out.flush();
        out.close();
    }

    // 栈中元素从底到顶是递增的
    public static void compute() {
        // 单调栈中元素数量
        r = 0;
        // 标记栈顶
        int cur;
        // 遍历数组
        for (int i = 0; i < n; i++) {
            // 当前栈中的栈顶元素arr[stack[r - 1]]大于我们此时遍历到的arr[i]
            // 说明栈顶元素的右边离自己最近且比自己小的位置就是i
            // ！！！注意：这里的大于等于
            // 相等时原栈顶位置元素也需要弹出，替换为新的位置元素（二者在arr数组中对应的值相等）
            while (r > 0 && arr[stack[r - 1]] >= arr[i]) {
                // 将栈顶元素（位置）弹出给cur，栈中元素数量-1
                cur = stack[--r];
                // 如果此时栈中还有元素，那么此时栈顶的元素就是cur的左边最近且比自己小的位置
                ans[cur][0] = r > 0 ? stack[r - 1] : -1;
                // 栈顶元素的右边离自己最近且比自己小的位置就是当前遍历到的数组i位置
                ans[cur][1] = i;
            }
            // 将当前遍历到的数组位置i入栈
            stack[r++] = i;
        }
        // 清算栈中剩余元素
        while (r > 0) {
            // 当前的栈顶元素并弹出
            cur = stack[--r];
            // 如果此时栈中还有元素，那么此时栈顶的元素就是cur的左边最近且比自己小的位置
            ans[cur][0] = r > 0 ? stack[r - 1] : -1;
            // 栈顶元素的右边离自己最近且比自己小的位置就是-1
            ans[cur][1] = -1;
        }
        // 若无重复元素，则本步骤的if阶段不会执行（碰不到满足的情况）
        // 若有重复的元素，我们需要从后往前遍历
        for (int i = n - 2; i >= 0; i--) {
            // 若i位置的右边离自己最近且小于等于自己的位置j，arr[i]==arr[j]
            // i ans[i][1]:arr[i]=arr[ans[i][1]]
            // 但j位置的右边离自己最近且小于等于自己的位置k，arr[j]!=arr[k]
            // ans[i][1] ans[ans[i][1]][1]:arr[ans[i][1]]!=arr[ans[ans[i][1]][1]]
            // 那么我们急需要把i位置的右边离自己最近且小于等于自己的位置j更新为k
            // 即ans[i][1]=ans[ans[i][1]][1]
            if (ans[i][1] != -1 && arr[ans[i][1]] == arr[i]) {
                ans[i][1] = ans[ans[i][1]][1];
            }
        }
    }
}
```



## [Leetcode【中】739.每日温度](https://leetcode.cn/problems/daily-temperatures/description/)



```java
public class Solution {
    // 给定一个整数温度数组
    // 返回一个数组
    // 其中 answer[i] 是指对于第 i 天，下一个更高温度出现在几天后
    // 如果气温在这之后都不会升高，请在该位置用 0 来代替.
    public static int MAXN = 100001;
    public static int[] stack = new int[MAXN];
    public static int r;

    public static int[] dailyTemperatures(int[] nums) {
        int n = nums.length;
        int[] ans = new int[n];
        r = 0;
        // 本单调栈，从第到顶递减
        // 当栈中元素数量不为0
        // 且当前遍历的元素大于栈顶元素
        // 弹出栈顶元素
        // 记录弹出的栈顶元素的位置
        // 记录当前弹出栈顶元素的位置与遍历位置的差值，即是几天后
        for (int i = 0, cur; i < n; i++) {
            while (r > 0 && nums[stack[r - 1]] < nums[i]) {
                cur = stack[--r];
                ans[cur] = i - cur;
            }
            // 相等时候的处理，相等也加入单调栈
            stack[r++] = i;
        }
        return ans;
    }
}
```



## [Leetcode【中】907.子数组的最小值之和](https://leetcode.cn/problems/sum-of-subarray-minimums/submissions/667385193/)



```java
public class Solution {
    // 给定一个整数数组arr
    // 返回其所有子数组中最小值的和
    // 结果可能很大，对1000000007取模
    public static int MOD = 1000000007;
    public static int MAXN = 30001;
    public static int[] stack = new int[MAXN];
    public static int r;

    // ……2……5……4……
    // ……1……3……7……
    // 我们需要求每个子数组的最小和，那么根据单调栈
    // 若位置3左右两侧相邻的比位置3指向的数小的分别是位置1和位置7
    // 那么数组片段2~6中包含位置3的子数组最小值都是位置3的5
    // 也就是：
    // 2~3、2~4、2~5、2~6
    // 3~3、3~4、3~5、3~6
    // 也就是（3-1）*（7-3）=2*4=8个子数组的最小值都是5

    public static int sumSubarrayMins(int[] arr) {
        long ans = 0;
        r = 0;
        for (int i = 0; i < arr.length; i++) {
            while (r > 0 && arr[stack[r - 1]] >= arr[i]) {
                int cur = stack[--r];
                int left = r == 0 ? -1 : stack[r - 1];
                ans = (ans + (long) (cur - left) * (i - cur) * arr[cur]) % MOD;
            }
            stack[r++] = i;
        }
        while (r > 0) {
            int cur = stack[--r];
            int left = r == 0 ? -1 : stack[r - 1];
            ans = (ans + (long) (cur - left) * (arr.length - cur) * arr[cur]) % MOD;
        }
        return (int) ans;
    }
}
```



## [Leetcode【难】84.柱状图中最大的矩形](https://leetcode.cn/problems/largest-rectangle-in-histogram/description/)



```java
public class Solution {
    // 给定一arr数组，表示柱子高度
    // 返回其中最大矩形面积

    public static int MAXN = 100001;
    public static int[] stack = new int[MAXN];
    public static int r;

    public static int largestRectangleArea(int[] height) {
        int n = height.length;
        r = 0;
        int ans = 0, cur, left;
        // 遍历数组元素
        // 这里的单调栈递增
        for (int i = 0; i < n; i++) {
            // 当栈中有元素，且当前i位置柱子高度小于等于栈顶柱子高度时
            // 也就是相等时，也需要弹出栈顶
            while (r > 0 && height[stack[r - 1]] >= height[i]) {
                // 栈顶弹出，更新为次一位置的栈顶
                cur = stack[--r];
                // 左侧如果栈中还有元素，则是返回栈顶位置的柱子高度
                // 否则是-1
                left = r == 0 ? -1 : stack[r - 1];
                // 计算当前栈顶位置的最大矩形面积
                // 高度是当前栈顶位置的柱子高度
                // 宽度是当前i位置减去左侧位置再减1
                // 也就是栈顶存的位置cur做高，左右两侧第一个比它低的位置作为边界
                ans = Math.max(ans, height[cur] * (i - left - 1));
            }
            // 将当前柱子高度入栈
            stack[r++] = i;
        }
        // 遍历完成后，栈中可能还有元素
        // 这些元素的右侧没有比它们低的柱子
        // 因此它们的右侧边界是数组的最后一个位置n
        while (r > 0) {
            cur = stack[--r];
            left = r == 0 ? -1 : stack[r - 1];
            ans = Math.max(ans, height[cur] * (n - left - 1));
        }
        return ans;
    }
}
```



## [Leetcode【难】85.最大矩形](https://leetcode.cn/problems/maximal-rectangle/description/)



```java
import java.util.*;

public class Solution {
    // 二维矩阵只包含0和1
    // 返回只包含1的最大矩形面积
    public static int MAXN = 201;
    public static int[] height = new int[MAXN];
    public static int[] stack = new int[MAXN];
    public static int r;

    public static int maximalRectangle(char[][] grid) {
        int n = grid.length;
        int m = grid[0].length;
        Arrays.fill(height, 0, m, 0);
        int ans = 0;
        // 二维矩阵n行m列
        // 从第0行开始，压缩数组
        // 从第i行开始，若对应位置为0，则本行该列的值为0
        // 每压缩一次，就计算一次最大矩形面积
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                height[j] = grid[i][j] == '0' ? 0 : height[j] + 1;
            }
            ans = Math.max(ans, largestRectangleArea(m));
        }
        return ans;
    }

    public static int largestRectangleArea(int m) {
        r = 0;
        int ans = 0, cur, left;
        for (int i = 0; i < m; i++) {
            while (r > 0 && height[stack[r - 1]] >= height[i]) {
                cur = stack[--r];
                left = r == 0 ? -1 : stack[r - 1];
                ans = Math.max(ans, height[cur] * (i - left - 1));
            }
            stack[r++] = i;
        }
        while (r > 0) {
            cur = stack[--r];
            left = r == 0 ? -1 : stack[r - 1];
            ans = Math.max(ans, height[cur] * (m - left - 1));
        }
        return ans;
    }
}
```



## [洛谷【普及/提高-】P5788.【模板】单调栈](https://www.luogu.com.cn/problem/P5788)



```java
// 课上没讲的代码，单调栈在洛谷上的测试，原理是一样的
// 洛谷上这道题对java特别不友好，不这么写通过不了，注意看注释，非常极限
// 建议看看就好，现在的笔试和比赛时，不会这么极限的
// 给定一个长度为n的数组，打印每个位置的右侧，大于该位置数字的最近位置

import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;

public class Main {

        public static void main(String[] args) throws IOException {
                int n = nextInt();
                int[] arr = new int[n + 1];
                for (int i = 1; i <= n; i++) {
                        arr[i] = nextInt();
                }
                // 单调栈中保证 : 左 >= 右
                int[] stack = new int[n + 1];
                int r = 0;
                // 注意，这里为了省空间，直接复用了arr
                // 比如一个位置x，如果从stack中弹出，并且是当前的i位置让其弹出的
                // 那么令arr[x] = i，也就是代码36行
                // 此时arr[x]不再表示原始数组x位置的值
                // 而去表示，原始数组中，x的右边，大于arr[x]，最近的位置
                // 也就是说，重新复用arr，让其变成答案数组
                // 为啥这么节省？为啥不单独弄一个答案数组
                // 没办法，不这么节省通过不了测试，空间卡的非常极限
                for (int i = 1; i <= n; i++) {
                        while (r > 0 && arr[stack[r - 1]] < arr[i]) {
                                arr[stack[--r]] = i;
                        }
                        stack[r++] = i;
                }
                while (r > 0) {
                        arr[stack[--r]] = 0;
                }
                out.print(arr[1]);
                for (int i = 2; i <= n; i++) {
                        out.print(" " + arr[i]);
                }
                out.println();
                out.flush();
        }

        // 用如下的方式读数据其实并不推荐
        // 但是这道题特别卡空间
        // 需要这么读数据让内存开销最小
        // 一般笔试、比赛时不需要这么写
        public static InputStream in = new BufferedInputStream(System.in);

        public static PrintWriter out = new PrintWriter(System.out);

        public static int nextInt() throws IOException {
                int ch, sign = 1, ans = 0;
                while (!Character.isDigit(ch = in.read())) {
                        if (ch == '-')
                                sign = -1;
                }
                do {
                        ans = ans * 10 + ch - '0';
                } while (Character.isDigit(ch = in.read()));
                return (ans * sign);
        }
}
```



***



# ✅053【必备】单调栈-下



## [Leetcode【中】962.最大宽度坡](https://leetcode.cn/problems/maximum-width-ramp/description/)



```java
public class Solution {
    // 给定一个数组，任意两个不同的数组下标可以构成一个元组
    // (i,j):i<j且A[i]<=A[j]
    // 返回j-i最大值
    public static int MAXN = 50001;
    public static int[] stack = new int[MAXN];
    public static int r;

    public static int maxWidthRamp(int[] arr) {
        // 单调栈是自低到顶递减
        // 但0位置必须进站，因为0位置是坡的左边界
        r = 1;
        // 然后，依次只进栈比栈顶元素小的位置
        int n = arr.length;
        for (int i = 1; i < n; i++) {
            if (arr[stack[r - 1]] > arr[i]) {
                stack[r++] = i;
            }
        }
        int ans = 0;
        // 从右往左遍历，对于每一个遍历的位置
        // 都需要弹出栈顶元素，直到栈顶元素小于等于当前遍历位置元素
        for (int j = n - 1; j >= 0; j--) {
            while (r > 0 && arr[stack[r - 1]] <= arr[j]) {
                ans = Math.max(ans, j - stack[--r]);
            }
        }
        return ans;
    }
}
```



## [Leetcode【中】316.去除重复字母](https://leetcode.cn/problems/remove-duplicate-letters/description/)



```java
import java.util.*;

public class Solution {
    // 给定一字符
    // 去除其中重复的字符，使每个字符只出现依次
    // 并保证字典序最小，不同字符相对位置保持不变

    public static int MAXN = 26;
    // 每种字符的词频
    public static int[] cnts = new int[MAXN];
    // 每种字符目前有没有进栈
    public static boolean[] enter = new boolean[MAXN];
    public static char[] stack = new char[MAXN];
    public static int r;

    public static String removeDuplicateLetters(String str) {
        // 统计每种字符的词频
        Arrays.fill(cnts, 0);
        char[] s = str.toCharArray();
        for (char cha : s) {
            cnts[cha - 'a']++;
        }
        // 栈的大小
        r = 0;
        // 每个字符是否进栈
        Arrays.fill(enter, false);
        for (char cur : s) {
            // 如果该字符尚未进栈
            if (!enter[cur - 'a']) {
                // 如果栈中不为空，栈顶字符比当前字符大（ASCLL），并且栈顶字符后续仍然会出现
                while (r > 0 && stack[r - 1] > cur && cnts[stack[r - 1] - 'a'] > 0) {
                    // 弹出当前栈顶字符
                    enter[stack[r - 1] - 'a'] = false;
                    r--;
                }
                // 当前字符进栈
                stack[r++] = cur;
                enter[cur - 'a'] = true;
            }
            // 当前字符已经遍历过，词频-1
            cnts[cur - 'a']--;
        }
        return String.valueOf(stack, 0, r);
    }
}
```



## [Leetcode【中】1081.不同字符的最小子序列](https://leetcode.cn/problems/smallest-subsequence-of-distinct-characters/submissions/667415705/)



```java
import java.util.*;

public class Solution {
    // 给定一字符
    // 去除其中重复的字符，使每个字符只出现依次
    // 并保证字典序最小，不同字符相对位置保持不变

    public static int MAXN = 26;
    // 每种字符的词频
    public static int[] cnts = new int[MAXN];
    // 每种字符目前有没有进栈
    public static boolean[] enter = new boolean[MAXN];
    public static char[] stack = new char[MAXN];
    public static int r;

    public String smallestSubsequence(String str) {
        // 统计每种字符的词频
        Arrays.fill(cnts, 0);
        char[] s = str.toCharArray();
        for (char cha : s) {
            cnts[cha - 'a']++;
        }
        // 栈的大小
        r = 0;
        // 每个字符是否进栈
        Arrays.fill(enter, false);
        for (char cur : s) {
            // 如果该字符尚未进栈
            if (!enter[cur - 'a']) {
                // 如果栈中不为空，栈顶字符比当前字符大（ASCLL），并且栈顶字符后续仍然会出现
                while (r > 0 && stack[r - 1] > cur && cnts[stack[r - 1] - 'a'] > 0) {
                    // 弹出当前栈顶字符
                    enter[stack[r - 1] - 'a'] = false;
                    r--;
                }
                // 当前字符进栈
                stack[r++] = cur;
                enter[cur - 'a'] = true;
            }
            // 当前字符已经遍历过，词频-1
            cnts[cur - 'a']--;
        }
        return String.valueOf(stack, 0, r);
    }
}
```



## [Leetcode【中】2289.使数组按非递减顺序排序](https://leetcode.cn/problems/steps-to-make-array-non-decreasing/description/)



```java
import java.io.*;

public class Solution {
    // 大鱼吃小鱼
    // 给定一个数组arr
    // 每轮每个鱼都会向右吃掉离自己最近且比自己小的鱼
    // 吃鱼可以同时发生：大鱼吃小鱼，小鱼吃小小鱼
    // 还可以多个鱼同时吃一条鱼
    // 返回多少轮后，鱼的数量固定
    // 8、3、1、5、6、7、2、4
    // 一：8吃3；3吃1；5、6、7吃2；
    // 8、5、6、7、4
    // 二：8吃5；5、6、7吃4；
    // 8、6、7
    // 三：8吃6
    // 8、7
    // 四：8吃7
    // 8
    // 返回4

    public static int MAXN = 100001;
    public static int[] arr = new int[MAXN];
    public static int n;
    public static int[][] stack = new int[MAXN][2];
    public static int r;

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            for (int i = 0; i < n; i++) {
                in.nextToken();
                arr[i] = (int) in.nval;
            }
            out.println(turns());
        }
        out.flush();
        out.close();
    }

    public static int turns() {
        // 单调栈自底到顶递减，因为不能互吃
        r = 0;
        int ans = 0;
        // 从后往前遍历
        for (int i = n - 1, curTurn; i >= 0; i--) {
            // i号鱼的体重为arr[i]
            // 都是从0开始，所以初始时curTurn为0
            curTurn = 0;
            // 当栈不为空时，且栈顶鱼的体重小于当前鱼的体重
            while (r > 0 && stack[r - 1][0] < arr[i]) {
                // 当前鱼吃的轮数为：当前鱼对应轮数+1和栈顶鱼的吃轮数的较大值
                // 并将栈顶鱼弹出
                curTurn = Math.max(curTurn + 1, stack[--r][1]);
            }
            // 将当前鱼体重入栈
            stack[r][0] = arr[i];
            // 将当前鱼的吃轮数入栈
            stack[r++][1] = curTurn;
            ans = Math.max(ans, curTurn);
        }
        return ans;
    }

    public static int MAXM = 100001;
    public static int[][] s = new int[MAXM][2];
    public static int size;

    public static int totalSteps(int[] arr) {
        size = 0;
        int ans = 0;
        for (int i = arr.length - 1, curTurn; i >= 0; i--) {
            curTurn = 0;
            while (size > 0 && s[size - 1][0] < arr[i]) {
                curTurn = Math.max(curTurn + 1, s[--size][1]);
            }
            s[size][0] = arr[i];
            s[size++][1] = curTurn;
            ans = Math.max(ans, curTurn);
        }
        return ans;
    }
}
```



## [牛客【】大鱼吃小鱼（B 站笔试）](https://www.nowcoder.com/practice/77199defc4b74b24b8ebf6244e1793de)



```java
import java.io.*;

public class Solution {
    // 大鱼吃小鱼
    // 给定一个数组arr
    // 每轮每个鱼都会向右吃掉离自己最近且比自己小的鱼
    // 吃鱼可以同时发生：大鱼吃小鱼，小鱼吃小小鱼
    // 还可以多个鱼同时吃一条鱼
    // 返回多少轮后，鱼的数量固定
    // 8、3、1、5、6、7、2、4
    // 一：8吃3；3吃1；5、6、7吃2；
    // 8、5、6、7、4
    // 二：8吃5；5、6、7吃4；
    // 8、6、7
    // 三：8吃6
    // 8、7
    // 四：8吃7
    // 8
    // 返回4

    public static int MAXN = 100001;
    public static int[] arr = new int[MAXN];
    public static int n;
    public static int[][] stack = new int[MAXN][2];
    public static int r;

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            for (int i = 0; i < n; i++) {
                in.nextToken();
                arr[i] = (int) in.nval;
            }
            out.println(turns());
        }
        out.flush();
        out.close();
    }

    public static int turns() {
        // 单调栈自底到顶递减，因为不能互吃
        r = 0;
        int ans = 0;
        // 从后往前遍历
        for (int i = n - 1, curTurn; i >= 0; i--) {
            // i号鱼的体重为arr[i]
            // 都是从0开始，所以初始时curTurn为0
            curTurn = 0;
            // 当栈不为空时，且栈顶鱼的体重小于当前鱼的体重
            while (r > 0 && stack[r - 1][0] < arr[i]) {
                // 当前鱼吃的轮数为：当前鱼对应轮数+1和栈顶鱼的吃轮数的较大值
                // 并将栈顶鱼弹出
                curTurn = Math.max(curTurn + 1, stack[--r][1]);
            }
            // 将当前鱼体重入栈
            stack[r][0] = arr[i];
            // 将当前鱼的吃轮数入栈
            stack[r++][1] = curTurn;
            ans = Math.max(ans, curTurn);
        }
        return ans;
    }
}
```



## [Leetcode【中】1504.统计全 1 子矩形](https://leetcode.cn/problems/count-submatrices-with-all-ones/description/)



```java
import java.util.*;

public class Solution {
    // 给定一个二维矩阵
    // 只由0或1组成
    // 返回全部由1组成的矩形的数量

    // 矩阵的列数
    public static int MANM = 151;
    public static int[] height = new int[MANM];
    public static int[] stack = new int[MANM];
    public static int r;

    public static int numSubmat(int[][] mat) {
        // 矩阵的行数
        int n = mat.length;
        // 矩阵的列数
        int m = mat[0].length;
        // 结果
        int ans = 0;
        // 初始化高度数组
        Arrays.fill(height, 0, m, 0);
        // 遍历每一行
        for (int i = 0; i < n; i++) {
            // 处理每一行作为底的情况
            for (int j = 0; j < m; j++) {
                // 计算当前位置的高度
                // 因为以本行作底，因此如果当前位置是0，高度就是0
                // 如果当前位置是1，高度就是上一行的高度+1
                height[j] = mat[i][j] == 0 ? 0 : height[j] + 1;
            }
            ans += submat(m);
        }
        return ans;
    }

    // 1 1
    // 1 1
    // 1 1
    // 1 1
    // 1 1
    // 1 1 1
    // 1 1 1
    // 1 1 1 1
    // 1 1 1 1
    // 4 9 9 2
    // 0 1 2 3
    // 若如上是某一行做底高度数组的具体值
    // 0-4：左侧：-1(0)；右侧：3(2)
    // 高度为3或4的矩形：2*6=(4-2)*(3*(3+1)/2)=12
    // 高度3:0~0、0~1、0~2、1~1、1~2、2~2
    // 高度4:0~0、0~1、0~2、1~1、1~2、2~2
    // 1-9:不算
    // 2-9：左侧：0(4)；右侧3(2)
    // 高度为5、6、7、8、9的矩形：5*3=15
    // 高度为5:1~1、1~2、2~2
    // 高度为6:1~1、1~2、2~2
    // 高度为7:1~1、1~2、2~2
    // 高度为8:1~1、1~2、2~2
    // 高度为9:1~1、1~2、2~2
    // 3-2：左侧：-1(0)；右侧：4(0)
    // 高度为1或2的矩形：2*10=20
    // 高度为1:0~0、0~1、0~2、0~3、1~1、1~2、1~3、2~2、2~3、3~3
    // 高度为2:0~0、0~1、0~2、0~3、1~1、1~2、1~3、2~2、2~3、3~3
    public static int submat(int m) {
        int ans = 0;
        r = 0;
        // 遍历高度数组、计算每个高度左右两侧最近的小于它的位置
        for (int i = 0, left, len, bottom; i < m; i++) {
            // 对于栈顶元素大于或等于当前高度，都需要弹出
            while (r > 0 && height[stack[r - 1]] >= height[i]) {
                // 栈顶元素弹出并赋给cur
                int cur = stack[--r];
                // 如果栈顶元素大于当前高度，才需要计算（相等则不需要计算）
                if (height[cur] > height[i]) {
                    // 如果栈顶元素是当前栈中唯一元素
                    // 那么它左侧最近的小于它的位置就是-1
                    // 否则，栈顶元素的左侧最近的小于它的位置就是新的栈顶元素
                    left = r == 0 ? -1 : stack[r - 1];
                    // 计算从右侧最近且小于当前高度的位置到左侧最近且小于当前高度的位置的距离
                    len = i - left - 1;
                    // 计算左右两侧哪个较小值更大
                    bottom = Math.max(left == -1 ? 0 : height[left], height[i]);
                    // 那么可能的矩形就是：
                    // 每种可能的高度height[cur]-bottom
                    // 每种高度可能长度的最大值：len
                    ans += (height[cur] - bottom) * len * (len + 1) / 2;
                }
            }
            // 当前高度入栈
            stack[r++] = i;
        }
        // 遍历完高度数组，栈中可能有剩余
        while (r > 0) {
            // 此时的栈顶元素，弹出
            int cur = stack[--r];
            // 如果栈顶元素不是当前栈中唯一元素
            // 那么它左侧最近的小于它的位置就是新的栈顶元素
            int left = r == 0 ? -1 : stack[r - 1];
            // 对于此时弹出的栈顶元素
            // 其右侧最近且小于它的位置都是数组的越界位置m（数组从0开始，长为m）
            int len = m - left - 1;
            // 计算左右两侧两个较小值哪个更大
            // 因为右侧的恒为0，左侧如果还有元素，那么就是左侧的高度
            // 否则，左侧没有元素，那么也是0
            int bottom = left == -1 ? 0 : height[left];
            // 加上这批次可能构成的矩形
            ans += (height[cur] - bottom) * len * (len + 1) / 2;
        }
        return ans;
    }
}
```



***



# ✅054【必备】单调队列-上



## [Leetcode【难】239.滑动窗口](https://leetcode.cn/problems/sliding-window-maximum/description/)



```java
public class Solution {
    // 给定一整数数组nums，有一个大小为k的滑动窗口从数组的最左侧移动到数组的最右侧
    // 滑动窗口每次只移动以为
    // 返回滑动窗口中的最大值

    public static int MAXN = 100001;
    public static int[] deque = new int[MAXN];
    public static int head, tail;

    public static int[] maxSlidingWindow(int[] arr, int k) {
        int n = arr.length;
        head = tail = 0;
        // 先形成k-1长度的窗口
        for (int i = 0; i < k - 1; i++) {
            // 单调队列：头->尾，大->小
            // 当队列中不为空
            // 队尾元素小于等于当前元素时，队尾元素出队
            // 对于碰到相等的情况，也出队，确保队列中元素唯一，且有效位置更为靠右
            while (head < tail && arr[deque[tail - 1]] <= arr[i]) {
                tail--;
            }
            // 若队尾元素大于当前元素时，当前元素入队
            deque[tail++] = i;
        }
        // 返回队列长度
        int m = n - k + 1;
        int[] ans = new int[m];
        // 也就是数组会有m个滑动窗口
        for (int l = 0, r = k - 1; l < m; l++, r++) {
            // 若队尾元素小于等于当前元素时，队尾元素出队
            // 对于碰到相等的情况，也出队，确保队列中元素唯一，且有效位置更为靠右
            while (head < tail && arr[deque[tail - 1]] <= arr[r]) {
                tail--;
            }
            // 直到队尾元素大于当前元素时，当前元素入队
            deque[tail++] = r;
            // 收集答案
            ans[l] = arr[deque[head]];
            // 滑动窗口右移，如果移除的位置恰好在队头，队头出队
            if (deque[head] == l) {
                head++;
            }
        }
        return ans;
    }
}
```



## [Leetcode【中】1438.绝对差不超过限制的最长连续子数组](https://leetcode.cn/problems/longest-continuous-subarray-with-absolute-diff-less-than-or-equal-to-limit/description/)



```java
public class Solution {
    // 给定一个整数数组nums，和一个表示限制的整数limit
    // 返回最长连续子数组的长度
    // 该子数组中任意两个元素之间的绝对差必须小于等于limit
    // 如果不存在则返回0

    public static int MAXN = 100001;
    // 窗口内最大值的更新结构（单调队列）
    public static int[] maxDeque = new int[MAXN];
    // 窗口内最小值的更新结构（单调队列）
    public static int[] minDeque = new int[MAXN];
    public static int maxHead, maxTail, minHead, minTail;
    // 全局数组，存入nums数组，方便函数访问
    public static int[] arr;

    public static int longestSubarray(int[] nums, int limit) {
        // 初始化窗口内最大值的更新结构、窗口内最小值的更新结构
        maxHead = maxTail = minHead = minTail = 0;
        // 初始化全局数组
        arr = nums;
        // 数组长度
        int n = arr.length;
        // 结果
        int ans = 0;
        // 窗口右边界，从0开始最远扩展到n-1（数组右边界）
        for (int l = 0, r = 0; l < n; l++) {

            // 如果当前窗口满足要求，那么窗口向右扩展
            // 只能窗口的最大值更大、最小值更小，更加满足要求

            // 如果当前窗口不满足要求，那么窗口如果还要向右扩展
            // 那么窗口的最大值只会更小，最小值只会更大，更加不满足要求

            // 窗口左边界保持不动，右边界向右移动
            // - 窗口右边界未到数组右边界
            // - 当前数组元素若加入窗口满足要求
            while (r < n && ifOK(limit, nums[r])) {
                // 更新窗口内最大值的更新结构、窗口内最小值的更新结构
                push(r++);
            }
            // 此时，[l,r]是以l开头的子数组能向右延伸的最大范围
            ans = Math.max(ans, r - l);
            // 窗口左边界向右移动一位
            pop(l);
        }
        return ans;
    }

    // 如果当前数组元素加入两个单调队列，滑动窗口满足要求
    public static boolean ifOK(int limit, int number) {
        // 若当前队列为空，则当前数组元素直接加入队列，并返回
        // 若当前对列不为空，比较两个队列的队头元素与number的大小
        int max = maxHead < maxTail ? Math.max(arr[maxDeque[maxHead]], number) : number;
        int min = minHead < minTail ? Math.min(arr[minDeque[minHead]], number) : number;
        return max - min <= limit;
    }

    // 窗口右边界向右移动一位，更新窗口内最大值的更新结构、窗口内最小值的更新结构
    public static void push(int r) {
        // 窗口内最大值的更新结构（单调队列）
        // 若当前队列为空，则当前数组元素直接加入队列
        // 若当前对列不为空，比较当前队列的队尾元素与number的大小
        // 若当前队列的队尾元素小于等于number，则弹出队尾元素，直到队列为空或队尾元素大于number
        while (maxHead < maxTail && arr[maxDeque[maxTail - 1]] <= arr[r]) {
            maxTail--;
        }
        maxDeque[maxTail++] = r;
        // 窗口内最小值的更新结构（单调队列）
        // 若当前队列为空，则当前数组元素直接加入队列
        // 若当前对列不为空，比较当前队列的队尾元素与number的大小
        // 若当前队列的队尾元素大于等于number，则弹出队尾元素，直到队列为空或队尾元素小于number
        while (minHead < minTail && arr[minDeque[minTail - 1]] >= arr[r]) {
            minTail--;
        }
        minDeque[minTail++] = r;
    }

    // 窗口左边界向右移动一位，更新窗口内最大值的更新结构、窗口内最小值的更新结构
    public static void pop(int l) {
        // 窗口内最大值的更新结构（单调队列）
        // 若当前队列的队头元素等于l，则弹出队头元素
        if (maxHead < maxTail && maxDeque[maxHead] == l) {
            maxHead++;
        }
        // 窗口内最小值的更新结构（单调队列）
        // 若当前队列的队头元素等于l，则弹出队头元素
        if (minHead < minTail && minDeque[minHead] == l) {
            minHead++;
        }
    }
}
```



## [洛谷【普及+/提高】P2698.\[USACO12MAR\] Flowerpot S](https://www.luogu.com.cn/problem/P2698)



```java
import java.io.*;
import java.util.*;

public class Solution {
    // 给定N滴水的坐标（x,y），y表示水滴的高度，x表示它下落到x轴的位置
    // 每滴水下落的速度为1单位长度每秒
    // 有一个花盘，负责收集水滴，位置固定
    // 要求花盘收到的第一滴水和最后一滴水之间的时间差（高度差）至少为D
    // 返回花盘的最小宽度，否则返回-1

    public static int MAXN = 100005;
    // 水滴坐标
    public static int[][] arr = new int[MAXN][2];
    // 水滴数量、最小时间差
    public static int n, d;
    // 最大高度、最小高度队列
    public static int[] maxDeque = new int[MAXN];
    public static int[] minDeque = new int[MAXN];
    public static int maxHead, maxTail, minHead, minTail;

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            d = (int) in.nval;
            for (int i = 0; i < n; i++) {
                in.nextToken();
                arr[i][0] = (int) in.nval;
                in.nextToken();
                arr[i][1] = (int) in.nval;
            }
            int ans = compute();
            out.println(ans == Integer.MAX_VALUE ? -1 : ans);
        }
        out.flush();
        out.close();
    }

    public static int compute() {
        // 为数组排序，x坐标升序
        Arrays.sort(arr, 0, n, (a, b) -> a[0] - b[0]);
        maxHead = maxTail = minHead = minTail = 0;
        int ans = Integer.MAX_VALUE;
        // 滑动窗口：移动左侧边界
        for (int l = 0, r = 0; l < n; l++) {

            // 固定左侧边界，移动右侧边界

            // 当l固定，当前r满足条件时
            // 如果继续移动r，只会使时间差增加，宽度也增加

            // 因此，l固定时，首个满足条件的r，就是最小宽度的右边界
            // 注意哦，这里是[l,r)
            // 为什么右开呢，我觉得这里r可以借助窗口中元素的数量（暂定l=0）来理解
            // 开始0个元素，不成立
            // 入队、r右移、队中元素+1、不成立
            // 入队、r右移、队中元素+1、成立
            // 此时r=2，但窗口中位置元素为[0,1]，因此需要-1

            // 因为while循环最后一轮结束时，r会向右移动一步
            // 所以，r-1就是最小宽度的右边界
            while (!ifOK() && r < n) {
                push(r++);
            }
            // 因为while循环结束的条件是：l固定，r满足条件或者r到达数组末尾
            if (ifOK()) {
                ans = Math.min(ans, arr[r - 1][0] - arr[l][0]);
            }
            // 当前l固定时，最小宽度已经更新
            // l右移
            pop(l);
        }
        return ans;
    }

    // 检查当前窗口是否满足条件
    public static boolean ifOK() {
        // 窗口非空，则直接返回队头
        // 窗口为空，则返回0
        int max = maxHead < maxTail ? arr[maxDeque[maxHead]][1] : 0;
        int min = minHead < minTail ? arr[minDeque[minHead]][1] : 0;
        return max - min >= d;
    }

    // 窗口右移，加入新元素
    public static void push(int r) {
        // 维护最大高度队列
        // 队尾元素小于等于当前元素，弹出
        while (maxHead < maxTail && arr[maxDeque[maxTail - 1]][1] <= arr[r][1]) {
            maxTail--;
        }
        maxDeque[maxTail++] = r;
        // 维护最小高度队列
        // 队尾元素大于等于当前元素，弹出
        while (minHead < minTail && arr[minDeque[minTail - 1]][1] >= arr[r][1]) {
            minTail--;
        }
        minDeque[minTail++] = r;
    }

    // 窗口左移，移除旧元素
    public static void pop(int l) {
        // 移除旧元素时，需要检查队头是否过期
        if (maxHead < maxTail && maxDeque[maxHead] == l) {
            maxHead++;
        }
        if (minHead < minTail && minDeque[minHead] == l) {
            minHead++;
        }
    }
}
```



***



# ✅055【必备】单调队列-下



## [Leetcode【难】862.和至少为 K 的最短子数组](https://leetcode.cn/problems/shortest-subarray-with-sum-at-least-k/description/)



```java
public class Solution {
    // 给定一个数组arr，可正可负可为零
    // 给定一个正数k
    // 返回最短的累加和>=k的子数组的长度

    public static int MAXN = 100001;
    // 前缀和数组
    public static long[] sum = new long[MAXN];
    // 单调队列
    public static int[] deque = new int[MAXN];
    // 队列头
    public static int head;
    // 队列尾
    public static int tail;

    public static int shortestSubarray(int[] arr, int k) {
        int n = arr.length;
        // 前缀和数组，长度为n+1，sum[0]=0
        for (int i = 0; i < n; i++) {
            sum[i + 1] = sum[i] + arr[i];
        }
        head = tail = 0;
        int ans = Integer.MAX_VALUE;
        // 遍历n+1的前缀和数组
        for (int i = 0; i <= n; i++) {
            // 如果队列不为空，且当前的前缀和-单调队列对头的前缀和>=k
            // 那么更新候选答案，并弹出队头
            while (head != tail && sum[i] - sum[deque[head]] >= k) {
                ans = Math.min(ans, i - deque[head++]);
            }
            // 单调队列：头->尾、小->大
            // 如果队列不为空，且当前的前缀和小于等于队尾的前缀和
            // 对于<：如果后续的前缀和-当前的较小的前缀和尚且不满足条件，
            // 那么比当前位置更靠前（长度更长）且更大（片段和更小）的前缀和更不会成立
            // 对于=：两个位置的前缀和相等，那么后续前缀和减去的一定是离它更近更靠后的前缀和
            // 因此两种情况都需要出队
            while (head != tail && sum[deque[tail - 1]] >= sum[i]) {
                tail--;
            }
            // 当前位置的前缀和入队
            deque[tail++] = i;
        }
        return ans != Integer.MAX_VALUE ? ans : -1;
    }
}
```



## [Leetcode【难】1499.满足不等式的最大值](https://leetcode.cn/problems/max-value-of-equation/description/)



```java
public class Solution {
    // 给定一数组points和一个整数k
    // 数组中每个元素都是二维平面上点的坐标(x,y)，并且都按照x升序
    // 也就是 1<=i<j<=points.length，xi<xj恒成立
    // 找出 yi+yj+|xi-xj| 的最大值
    // 并且满足 |xi-xj|<=k , 1<=i<j<=points.length

    public static int MAXN = 100001;
    public static int[][] deque = new int[MAXN][2];
    public static int head, tail;

    public static int findMaxValueOfEquation(int[][] points, int k) {
        head = tail = 0;
        int n = points.length;
        int ans = Integer.MIN_VALUE;
        for (int i = 0, x, y; i < n; i++) {
            x = points[i][0];
            y = points[i][1];
            // 此时要求有三：
            // - 原式可转化为：yj+xj+yi-xi即靠后坐标和尽可能大
            // - 靠前坐标差尽可能小
            // - 二坐标横坐标差不超过k

            // 单调队列：头->尾、大->小：坐标y-x的差值

            // 若队列不为空，队头元素的x与当前点x的距离超过了k，弹出队头
            while (head < tail && deque[head][0] + k < x) {
                head++;
            }

            // 计算此时队头坐标和当前点的指标
            if (head < tail) {
                ans = Math.max(ans, x + y + deque[head][1] - deque[head][0]);
            }

            // 如果当前点的y-x值大于队尾点的y-x值
            // 那么当前点使指标更大，且位置靠后，更容易满足|xi-xj|<=k
            // 所以弹出队尾元素
            while (head < tail && deque[tail - 1][1] - deque[tail - 1][0] <= y - x) {
                tail--;
            }

            // 当前点的x和y，该从尾部进入单调队列
            deque[tail][0] = x;
            deque[tail++][1] = y;
        }
        return ans;
    }
}
```



## [Leetcode【难】2071.你可以安排的最多任务数目](https://leetcode.cn/problems/maximum-number-of-tasks-you-can-assign/description/)



```java
import java.util.*;

public class Solution {
    // n个任务tasks，存储重量
    // m个工人workers，存储能力
    // pills个大力丸，每个增加strength的能力
    // 每个工人只能完成一个任务
    // 每个工人只能使用一个大力丸
    // 每个工人的能力需要大于等于任务的重量
    // 返回最大任务数量可以完成

    public static int[] tasks;
    public static int[] workers;
    public static int MAXN = 50001;
    public static int[] deque = new int[MAXN];
    public static int head, tail;

    public static int maxTaskAssign(int[] ts, int[] ws, int pills, int strength) {
        tasks = ts;
        workers = ws;
        // 任务和工人都排序,都升序
        Arrays.sort(tasks);
        Arrays.sort(workers);

        int tsize = tasks.length;
        int wsize = workers.length;

        int ans = 0;
        // 任务完成数量最少0个，最多（任务数量和工人数量的较小值）
        for (int l = 0, r = Math.min(tsize, wsize), mid; l <= r;) {
            // mid = (l + r) / 2;
            mid = l + ((r - l) >> 1);
            // 根据贪心，我们只看重任务数量
            // 因此，因为两个数组我们都已升序排序
            // 选任务，选要求最低的任务，前mid个任务
            // 选工人，选能力最大的工人，后mid个工人
            if (ifCan(0, mid - 1, wsize - mid, wsize - 1, strength, pills)) {
                ans = mid;
                l = mid + 1;
            } else {
                r = mid - 1;
            }
        }
        return ans;
    }

    // 最轻的几个任务:tasks[tl...tr]
    // 在药丸strength*pills的加持下
    // 由能力最大的几个人完成:workers[wl...wr]
    // 返回是否能完成
    public static boolean ifCan(int tl, int tr, int wl, int wr, int s, int p) {
        // 单调队列，从头到尾：从小到大
        head = tail = 0;
        // 药丸数量
        int count = 0;
        for (int i = wl, j = tl; i <= wr; i++) {
            // i是工人编号
            // j是任务编号

            // 工人i能完成的任务，全部从小到大进队列
            for (; j <= tr && tasks[j] <= workers[i]; j++) {
                deque[tail++] = j;
            }
            // 工人i选择队列头的任务（也就是他能完成的任务中，重量最小的，这里确保能完成即可）
            if (head < tail && tasks[deque[head]] <= workers[i]) {
                head++;
            } else {
                // 工人i没有任务可做，需要吃药
                // 吃药后，工人i能完成的任务，全部从小到大进队列
                for (; j <= tr && tasks[j] <= workers[i] + s; j++) {
                    deque[tail++] = j;
                }
                // 因为我们这里只确保n个任务有n人完成，因此每个人都需要完成一次任务
                // 如果完不成，那么当前的情况就行不通
                // 如果当前工人i在药丸加持下有任务可做，他需要完成能够完成的最大的任务
                // 因为后续的工人不一定也有药丸加持，他需要做到不浪费任务
                if (head < tail) {
                    count++;
                    tail--;
                } else {
                    return false;
                }
            }
        }
        return count <= p;
    }
}
```



***



# ✅056【必备】并查集-上



## [牛客【】并查集的实现](https://www.nowcoder.com/practice/e7ed657974934a30b2010046536a5372)



```java
import java.io.*;

public class Solution {
    // 并查集：栈实现路径压缩+小挂大

    // 元素个数
    public static int MAXN = 1000001;
    // 当前位置往上指向的最近代表节点
    public static int[] father = new int[MAXN];
    // 集合的大小
    public static int[] size = new int[MAXN];
    // 栈：收集沿途节点，压缩路径
    public static int[] stack = new int[MAXN];
    public static int n;

    // 初始化并查集
    // - 指向数组都初始化为自己
    // - 每个元素都有自己的集合，集合的大小都初始化为1
    public static void build() {
        for (int i = 0; i < n; i++) {
            father[i] = i;
            size[i] = 1;
        }
    }

    // i号节点，往上一直找，找到代表节点（其代表节点指向自己）返回
    // - 沿途收集了几个点，就压入栈里
    // - 最后再弹出栈里的所有点，都指向代表节点
    // 将路径所有节点直接指向代表节点
    // 压缩路径
    public static int find(int i) {
        int size = 0;
        while (i != father[i]) {
            // 路径节点入栈
            stack[size++] = i;
            i = father[i];
        }
        while (size > 0) {
            // 路径节点出栈，指向代表节点
            father[stack[--size]] = i;
        }
        return i;
    }

    // 判断x和y是否在同一个集合：判断二者的代表节点是否相同
    public static boolean isSameSet(int x, int y) {
        return find(x) == find(y);
    }

    // x和y所在的集合合并：小挂大
    public static void union(int x, int y) {
        int fx = find(x);
        int fy = find(y);
        // 二者的代表节点不同，不在一个集合中
        if (fx != fy) {
            if (size[fx] >= size[fy]) {
                // fx集合的大小大于等于fy集合的大小
                // 所以fy集合挂在fx集合下
                // fx的集合大小增加fy的集合大小
                size[fx] += size[fy];
                father[fy] = fx;
            } else {
                // fy集合的大小大于fx集合的大小
                // 所以fx集合挂在fy集合下
                // fy的集合大小增加fx的集合大小
                size[fy] += size[fx];
                father[fx] = fy;
            }
        }
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            build();
            in.nextToken();
            int m = (int) in.nval;
            for (int i = 0; i < m; i++) {
                in.nextToken();
                int op = (int) in.nval;
                in.nextToken();
                int x = (int) in.nval;
                in.nextToken();
                int y = (int) in.nval;
                if (op == 1) {
                    out.println(isSameSet(x, y) ? "Yes" : "No");
                } else {
                    union(x, y);
                }
            }
        }
        out.flush();
        out.close();
    }
}
```



## [洛谷【】P3367.【模板】并查集](https://www.luogu.com.cn/problem/P3367)



```java
import java.io.*;

public class Solution {
    // 并查集：递归实现路径压缩

    // 元素个数
    public static int MAXN = 200001;
    // 当前位置往上指向的最近代表节点
    public static int[] father = new int[MAXN];
    // 节点个数
    public static int n;

    // 初始化并查集
    // - 指向数组都初始化为自己
    public static void build() {
        for (int i = 0; i <= n; i++) {
            father[i] = i;
        }
    }

    // 递归实现路径压缩：查找当前节点的代表节点
    // 3->4->5->8->1
    // f(3)开始执行
    // 3!=father(3)=4:  father(3)=f(4)
    //   4!=father(4)=5:  father(4)=f(5)
    //     5!=father(5)=8:  father(5)=f(8)
    //       8!=father(8)=1:  father(8)=f(1)
    //         1==father(1)=1:  return 1
    //       8的代表节点设置为1，返回此时8的代表节点1
    //     5的代表节点设置为1，返回此时5的代表节点1
    //   4的代表节点设置为1，返回此时4的代表节点1
    // 3的代表节点设置为1，返回此时3的代表节点1
    // 3->4->5->8->1
    public static int find(int i) {
        if (i != father[i]) {
            // 如果当前节点不是代表节点，通过递归找到代表节点，并将当前节点的代表节点设置为代表节点
            father[i] = find(father[i]);
        }
        return father[i];
    }

    // 判断x和y是否在同一个集合：判断二者的代表节点是否相同
    public static boolean isSameSet(int x, int y) {
        return find(x) == find(y);
    }

    // x和y所在的集合合并
    public static void union(int x, int y) {
        // 找到x的代表节点直接改为y的代表节点
        father[find(x)] = find(y);
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            build();
            in.nextToken();
            int m = (int) in.nval;
            for (int i = 0; i < m; i++) {
                in.nextToken();
                int op = (int) in.nval;
                in.nextToken();
                int x = (int) in.nval;
                in.nextToken();
                int y = (int) in.nval;
                if (op == 1) {
                    union(x, y);
                } else {
                    out.println(isSameSet(x, y) ? "Y" : "N");
                }
            }
        }
        out.flush();
        out.close();
    }
}
```



## [Leetcode【难】765.情侣牵手](https://leetcode.cn/problems/couples-holding-hands/description/)



```java
public class Solution {
    // n对情侣坐2n个位置
    // 给定一个数组nums，nums[i]表示第i位置坐的人的ID
    // 情侣按顺序编号，第一对（0,1）、第二对（2,3）、……
    // 每次交换位置任意
    // 返回至少交换位置的次数，每对情侣都坐一块

    public static int minSwapsCouples(int[] nums) {
        // 总体人数
        int n = nums.length;
        // 初始化并查集n/2个
        build(n / 2);
        // 将所有情侣【（0,1）、（2,3）、……】合并到一个集合中
        for (int i = 0; i < n; i += 2) {
            union(nums[i] / 2, nums[i + 1] / 2);
        }
        // 情侣数减去集合数就是最少交换次数
        // 6、0、1、5、2、3、8、4、7、9
        // 3、0、0、2、1、1、4、2、3、4
        // 1:(0,3)
        // 2:(0,2,3)
        // 3:(0,2,3)、(1)
        // 4:(0,2,3,4)、(1)
        // 5:(0,2,3,4)、(1)
        // 正常情况，完美坐法应该刚好n/2个集合，即每对情侣坐在一起
        // 但是有的可能不是一对情侣做到了一起，将两个集合合并了起来
        // 有多对情侣的集合，该集合需要情侣对数-1次交换
        // 那么多个集合求和：也就是所有情侣数-集合数
        return n / 2 - sets;
    }

    public static int MAXN = 31;
    public static int[] father = new int[MAXN];
    public static int sets;

    // 初始化并查集
    // - 指向数组都初始化为自己
    public static void build(int n) {
        for (int i = 0; i < n; i++) {
            father[i] = i;
        }
        // 初始化集合个数为n
        sets = n;
    }

    // 查找当前节点的代表节点
    public static int find(int i) {
        if (i != father[i]) {
            father[i] = find(father[i]);
        }
        return father[i];
    }

    // x和y所在的集合合并
    public static void union(int x, int y) {
        int fx = find(x);
        int fy = find(y);
        if (fx != fy) {
            father[fx] = fy;
            // 集合个数减1
            sets--;
        }
    }
}
```



## [Leetcode【难】839.相似字符串组](https://leetcode.cn/problems/similar-string-groups/description/)



```java
public class Solution {
    // 给定一个字符串数组strs
    // 其中每个字符串都是其他字符串的异构词（相同数量的字符，不同的排列顺序）
    // 如果交换字符串X中的两个字符，使其与Y相等（X和Y字符串不一样的位只有0或2个）
    // 或者两个字符串本身就相等
    // 相似可以传递，X和Y相似，Y和Z相似，那么X、Y、Z在同一组
    // 则称X和Y相似
    // 相似的字符串是一组
    // 返回该字符串数组中有多少组

    public static int numSimilarGroups(String[] strs) {
        // 字符串数量
        int n = strs.length;
        // 字符串长度
        int m = strs[0].length();
        // 初始化并查集为n
        build(n);
        // 遍历所有字符串对
        for (int i = 0; i < n; i++) {
            for (int j = i + 1; j < n; j++) {
                // 如果i和j不在同一组
                if (find(i) != find(j)) {
                    // 计算i和j的差异字符数
                    int diff = 0;
                    for (int k = 0; k < m && diff < 3; k++) {
                        if (strs[i].charAt(k) != strs[j].charAt(k)) {
                            diff++;
                        }
                    }
                    // 如果i和j的差异字符数为0或2，就合并i和j
                    if (diff == 0 || diff == 2) {
                        union(i, j);
                    }
                }
            }
        }
        return sets;
    }

    public static int MAXN = 301;
    public static int[] father = new int[MAXN];
    public static int sets;

    public static void build(int n) {
        for (int i = 0; i < n; i++) {
            father[i] = i;
        }
        sets = n;
    }

    public static int find(int i) {
        if (i != father[i]) {
            father[i] = find(father[i]);
        }
        return father[i];
    }

    public static void union(int x, int y) {
        int fx = find(x);
        int fy = find(y);
        if (fx != fy) {
            father[fx] = fy;
            sets--;
        }
    }
}
```



## [Leetcode【中】200.岛屿数量](https://leetcode.cn/problems/number-of-islands/description/)



```java
public class Solution {
    // 给定一个二维矩阵，只由“0”（水域）或“1“（陆地）填充”
    // 由1构成的是岛屿（只能上下左右相连）
    // 返回有多少个岛屿

    public static int numIslands(char[][] grid) {
        int n = grid.length;
        int m = grid[0].length;
        build(n, m, grid);
        // 遍历二维矩阵
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                // 如果当前位置是陆地
                if (grid[i][j] == '1') {
                    // 如果当前位置的左边也是陆地，合并它们的集合
                    if (j > 0 && grid[i][j - 1] == '1') {
                        union(i, j, i, j - 1);
                    }
                    // 如果当前位置的上边也是陆地，合并它们的集合
                    if (i > 0 && grid[i - 1][j] == '1') {
                        union(i, j, i - 1, j);
                    }
                }
            }
        }
        return sets;
    }

    public static int MAXSIZE = 100001;
    public static int[] father = new int[MAXSIZE];
    // 集合数量
    public static int sets;
    // 列数
    public static int cols;

    // 将二位矩阵中所有为1的位置都初始化集合
    public static void build(int n, int m, char[][] grid) {
        cols = m;
        sets = 0;
        for (int a = 0; a < n; a++) {
            for (int b = 0, index; b < m; b++) {
                if (grid[a][b] == '1') {
                    index = index(a, b);
                    father[index] = index;
                    sets++;
                }
            }
        }
    }

    // 将二维矩阵转换为一维索引
    // 1 、 2、 3 、4
    // 5 、 6、 7 、8
    // 9 、10、11、12
    // 13、14、15、16
    public static int index(int a, int b) {
        // 行号 * 列数 + 列号
        return a * cols + b;
    }

    // 查找i位置的集合代表
    public static int find(int i) {
        if (i != father[i]) {
            father[i] = find(father[i]);
        }
        return father[i];
    }

    // 合并a、b位置的集合和c、d位置的集合
    public static void union(int a, int b, int c, int d) {
        int i = find(index(a, b));
        int j = find(index(c, d));
        if (i != j) {
            father[i] = j;
            sets--;
        }
    }

}
```



***



# ✅057【必备】并查集-下



## [Leetcode【中】947.移除最多的同行或同列石头](https://leetcode.cn/problems/most-stones-removed-with-same-row-or-column/description/)



```java
import java.util.*;

public class Solution {
    // n个石头放在二维矩阵中
    // 每个坐标只能有一个石头，每一行每一列也只能有一个石头
    // 若同一行或同一列有多个石头，我们就可以移除该石头
    // 返回可以移除的最大石头数量

    // key : 某行或某列
    // value : 某行或某列第一次遇到的石头编号
    public static HashMap<Integer, Integer> rowFirst = new HashMap<>();
    public static HashMap<Integer, Integer> colFirst = new HashMap<>();

    public static int removeStones(int[][] stones) {
        int n = stones.length;
        build(n);
        for (int i = 0; i < n; i++) {
            // 第i个石头的行号和列号
            int row = stones[i][0];
            int col = stones[i][1];
            // 若当前行第一次遇到石头，就记录下来
            if (!rowFirst.containsKey(row)) {
                rowFirst.put(row, i);
            } else {
                // 若当前行之前遇到过石头，就合并当前石头和之前遇到的石头
                union(i, rowFirst.get(row));
            }
            // 若当前列第一次遇到石头，就记录下来
            if (!colFirst.containsKey(col)) {
                colFirst.put(col, i);
            } else {
                // 若当前列之前遇到过石头，就合并当前石头和之前遇到的石头
                union(i, colFirst.get(col));
            }
        }
        // 每个集合中都可以减少到只保留一个石头
        // 所以最多可以移除的石头数量就是总石头数量减去集合数量
        return n - sets;
    }

    public static int MAXN = 1001;
    public static int[] father = new int[MAXN];
    public static int sets;

    public static void build(int n) {
        rowFirst.clear();
        colFirst.clear();
        for (int i = 0; i < n; i++) {
            father[i] = i;
        }
        sets = n;
    }

    public static int find(int i) {
        if (i != father[i]) {
            father[i] = find(father[i]);
        }
        return father[i];
    }

    public static void union(int x, int y) {
        int fx = find(x);
        int fy = find(y);
        if (fx != fy) {
            father[fx] = fy;
            sets--;
        }
    }
}
```



## [Leetcode【难】2092.找出知晓密码的所有专家](https://leetcode.cn/problems/find-all-people-with-secret/description/)



```java
import java.util.*;

public class Solution {
    // 给定一个整数n，表示n专家的表示
    // 给定一个二维整数数组meetings
    // meetings[i]=[xi,yi,timei]
    // 表示专家xi和专家yi在时间timei要开一场会
    // 一个专家可以同时参加多场会议
    // 再给定一个整数firstPerson
    // 表示专家0在时间0将和专家firstPerson开一场会，分享了密码
    // 知晓秘密的专家会在开会时与其他专家分享
    // 返回知晓秘密的专家列表

    public static int MAXN = 100001;
    public static int[] father = new int[MAXN];

    // 是否知晓秘密
    public static boolean[] serect = new boolean[MAXN];

    public static List<Integer> findAllPeople(int n, int[][] meetings, int firstPerson) {
        // 初始化0时刻
        build(n, firstPerson);
        // {0:专家、1:专家、2:时间}
        Arrays.sort(meetings, (a, b) -> a[2] - b[2]);
        // 会议次数，
        int m = meetings.length;
        // 滑动窗口遍历所有会议，时刻相同的会议为一组
        for (int l = 0, r; l < m;) {
            // 找到当前时刻的所有会议
            r = l;
            while (r + 1 < m && meetings[l][2] == meetings[r + 1][2]) {
                r++;
            }
            // 将开会的每组两个专家合并到一个集合
            for (int i = l; i <= r; i++) {
                union(meetings[i][0], meetings[i][1]);
            }
            // 开完会后，将集合中不知晓秘密的专家分离出来
            for (int i = l; i <= r; i++) {
                if (!serect[find(meetings[i][0])] && !serect[find(meetings[i][1])]) {
                    father[meetings[i][0]] = meetings[i][0];
                    father[meetings[i][1]] = meetings[i][1];
                }
            }
            l = r + 1;
        }
        // 收集所有知晓秘密的专家
        List<Integer> ans = new ArrayList<>();
        for (int i = 0; i < n; i++) {
            if (serect[find(i)]) {
                ans.add(i);
            }
        }
        return ans;
    }

    // 初始化并查集
    public static void build(int n, int first) {
        for (int i = 0; i < n; i++) {
            father[i] = i;
            serect[i] = false;
        }
        // 专家0和firstPerson在时间0开一场会，分享了密码
        father[first] = 0;
        serect[0] = true;
    }

    // 查找i的代表元素
    public static int find(int i) {
        if (i != father[i]) {
            father[i] = find(father[i]);
        }
        return father[i];
    }

    // 合并x和y所在的集合
    public static void union(int x, int y) {
        int fx = find(x);
        int fy = find(y);
        if (fx != fy) {
            father[fx] = fy;
            // 如果fy知晓秘密，那么fx也知晓秘密
            serect[fy] |= serect[fx];
        }
    }
}
```



## [Leetcode【难】2421.好路径的数目](https://leetcode.cn/problems/number-of-good-paths/)



```java
import java.util.*;

public class Solution {
    // 给定一个一维数组vals
    // - 数组长度是节点个数
    // - 数组元素是节点的值
    // - 元素下标是节点编号
    // 给定一个二维数组edges
    // - edges[i]=[ai,bi]是两个节点之间的一条无向边
    // - ai、bi是节点编号
    // 好路径
    // - 开始节点和结束节点的值相同（二者可重合）
    // - 路径上所有的节点值小于等于开始和结尾节点的值
    // 返回好路径的数量

    // 最大节点个数
    public static int MAXN = 30001;
    // 节点的代表节点（同时也是节点集合中节点的最大值）
    public static int[] father = new int[MAXN];
    // 集合中最大值的次数，也就是集合中代表节点的值出现了几次
    public static int[] maxcnt = new int[MAXN];

    // 初始化并查集
    public static void build(int n) {
        for (int i = 0; i < n; i++) {
            // 每个节点的代表节点是自己
            father[i] = i;
            // 每个节点的最大值次数是1
            maxcnt[i] = 1;
        }
    }

    // 扁平化压缩路径
    public static int find(int i) {
        if (i != father[i]) {
            father[i] = find(father[i]);
        }
        return father[i];
    }

    // 合并两个集合可产生的好路径数量
    public static int union(int x, int y, int[] vals) {
        // fx : x所在集合的代表节点，同时也是x所在集合的最大值
        int fx = find(x);
        // fy : y所在集合的代表节点，同时也是y所在集合的最大值
        int fy = find(y);
        // path : 合并两个集合可产生的好路径数量
        int path = 0;
        // x集合最大值大于y集合最大值
        if (vals[fx] > vals[fy]) {
            // fy集合的最大值更新为fx
            father[fy] = fx;
        }
        // x集合的最大值小于y集合的最大值
        else if (vals[fx] < vals[fy]) {
            // fx集合的最大值更新为fy
            father[fx] = fy;
        }
        // x集合的最大值等于y集合的最大值，则两个集合合并可以产生好路径
        else {
            // 两个集合最大值一样！
            // 好路径数量就等于两个集合的最大值的出现次数的乘积
            path = maxcnt[fx] * maxcnt[fy];
            // fy集合的最大值更新为fx
            father[fy] = fx;
            // fx集合的最大值次数加上fy集合的最大值次数
            maxcnt[fx] += maxcnt[fy];
        }
        return path;
    }

    public static int numberOfGoodPaths(int[] vals, int[][] edges) {
        int n = vals.length;
        build(n);
        int ans = n;
        // 将边按照两端节点的较大值升序排列
        Arrays.sort(edges, (e1, e2) -> (Math.max(vals[e1[0]], vals[e1[1]])) - (Math.max(vals[e2[0]], vals[e2[1]])));
        // 依次处理所有边
        for (int[] edge : edges) {
            ans += union(edge[0], edge[1], vals);
        }
        return ans;
    }

    // vals:[2、1、1、2、2、1、1、2]
    //       a、b、c、d、e、f、g、h
    //       0、1、2、3、4、5、6、7
    // edge:[[a,b],[b,d],[a,c],[c,e],[c,f],[f,g],[g,h]]
    //       [0,1],[1,3],[0,2],[2,4],[2,5],[5,6],[6,7]
    //       [2,1],[1,2],[2,1],[1,2],[1,1],[1,1],[1,2]
    //     a2
    //   4/ \7
    //   b1  c1
    //  3/  5/ \1
    // d2  e2  f1
    //        /2
    //       g1
    //      /6
    //     h2
    //
    // 一：
    // c{c}：最大值1，次数1 ； f{f}：最大值1，次数1
    // 最大值相等：ans=1*1=1 ； 合并{c,f}：最大值1，次数2
    // 二：
    // f{c,f}：最大值1，次数2 ； g{g}：最大值1，次数1
    // 最大值相等：ans=1*2=2 ； 合并{g,f,c}：最大值1，次数3
    // 三：
    // b{b}：最大值1，次数1 ； d{d}：最大值2，次数1
    // 最大值不等 ；合并{b,d}：最大值2，次数1
    // 四：
    // a{a}：最大值2，次数1 ； b{b,d}：最大值2，次数1
    // 最大值相等：ans=1*1=1 ； 合并{a,b,d}：最大值2，次数2
    // 五：
    // c{g,f,c}：最大值1，次数3 ； e{e}：最大值2，次数1
    // 最大值不等 ；合并{c,g,f,e}：最大值2，次数1
    // 六：
    // g{c,g,f,e}：最大值2，次数1 ； h{h}：最大值2，次数1
    // 最大值相等：ans=1*1=1 ； 合并{c,g,f,e,h}：最大值2，次数2
    // 七：
    // a{a,b,d}：最大值2，次数2 ； c{c,g,f,e,h}：最大值2，次数2
    // 最大值相等：ans=2*2=4 ； 合并{a,b,d,c,g,c,g,f,e,h}：最大值2，次数4
}
```



## [Leetcode【难】928.尽量减少恶意软件的传播 II](https://leetcode.cn/problems/minimize-malware-spread-ii/description/)



```java
import java.util.*;

public class Solution {
    // 给定一个n个节点，n*n的邻接矩阵，表示无向图
    // graph[i][j]==1 表示i和j之间有边，graph[j][i]==1也成立
    // 给定一数组initial，表示被感染的节点
    // 只要与被感染的节点相连（直接或间接），都会被传播
    // 现在我们需要删除一个节点
    // 使得删除后相比删除前会被感染的节点减少的最多
    // 返回节点编号

    // 最大节点数量
    public static int MAXN = 301;
    // 每个节点是否被感染
    public static boolean[] virus = new boolean[MAXN];
    // 删除每个源头节点，能拯救多少个节点
    public static int[] savecnts = new int[MAXN];
    // 每个集合的标签：感染源头
    // a : 代表点，该个集合源头是 infect[a]
    // - -1：目前这个集合没有发现源头
    // - >=0：目前这个集合源头是 infect[a]
    // - -2：目前这个集合源头不止一个，已经无法拯救了!
    public static int[] infect = new int[MAXN];
    // 每个节点的代表点
    public static int[] father = new int[MAXN];
    // 每个集合的大小是多少
    public static int[] size = new int[MAXN];

    // 集合中只放普通节点

    public static void build(int n, int[] initial) {
        for (int i = 0; i < n; i++) {
            // 初始化，全部为普通节点
            virus[i] = false;
            // 每个节点删除后可以拯救的普通节点数量为0
            savecnts[i] = 0;
            // 该节点尚无源头节点
            infect[i] = -1;
            // 该节点的代表点是它自己
            father[i] = i;
            // 该节点所在集合大小是1
            size[i] = 1;
        }
        for (int i : initial) {
            // 初始化，挑选出源头节点
            virus[i] = true;
        }
    }

    public static int find(int i) {
        if (i != father[i]) {
            father[i] = find(father[i]);
        }
        return father[i];
    }

    public static void union(int i, int j) {
        int fi = find(i);
        int fj = find(j);
        if (fi != fj) {
            father[fi] = fj;
            size[fj] += size[fi];
        }
    }

    public static int minMalwareSpread(int[][] graph, int[] initial) {
        int n = graph.length;
        build(n, initial);
        // 普通节点合并
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                if (graph[i][j] == 1 && !virus[i] && !virus[j]) {
                    union(i, j);
                }
            }
        }
        // 寻找每个集合的感染源头
        // 遍历每个源头节点
        for (int sick : initial) {
            // 遍历所有节点
            for (int neighbor = 0; neighbor < n; neighbor++) {
                // 当前节点不是当前源头节点，不是其余源头节点，且二者相连
                if (sick != neighbor && !virus[neighbor] && graph[sick][neighbor] == 1) {
                    // 寻找当前节点的代表节点
                    int fatherNeighbor = find(neighbor);
                    // 如果当前节点没有源头节点，
                    if (infect[fatherNeighbor] == -1) {
                        // 则当前节点的源头就是当前源头节点
                        infect[fatherNeighbor] = sick;
                    }
                    // 如果当前节点有源头节点，但源头不是当前源头节点
                    // 且当前节点尚未无法拯救
                    else if (infect[fatherNeighbor] != -2 && infect[fatherNeighbor] != sick) {
                        // 则当前节点的源头节点有多个
                        infect[fatherNeighbor] = -2;
                    }
                }
            }
        }
        for (int i = 0; i < n; i++) {
            // 如果当前节点是所在结合的代表点，且有唯一的源头节点
            if (i == find(i) && infect[i] >= 0) {
                // 则当前节点所在的集合可以通过删除当前源头节点来拯救
                // 那么当前源头节点可以拯救的数量可以加上当前节点所在集合的大小
                savecnts[infect[i]] += size[i];
            }
        }
        Arrays.sort(initial);
        int ans = initial[0];
        int max = savecnts[ans];
        for (int i : initial) {
            if (savecnts[i] > max) {
                max = savecnts[i];
                ans = i;
            }
        }
        return ans;
    }
}
```



***



# ✅058【必备】洪水填充



## [Leetcode【中】200.岛屿数量](https://leetcode.cn/problems/number-of-islands/description/)



```java
public class Solution {
    // 给定一个由“1（陆地）”和“0（水）”组成的二维表格
    // 岛屿总是被水包围，岛屿只能与上下左右相邻陆地相连
    // 表格四边均被水包围
    // 返回岛屿数量

    // 洪水填充最优解
    public static int numIslands(char[][] board) {
        int n = board.length;
        int m = board[0].length;
        int islands = 0;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (board[i][j] == '1') {
                    islands++;
                    dfs(board, n, m, i, j);
                }
            }
        }
        return islands;
    }

    public static void dfs(char[][] board, int n, int m, int i, int j) {
        if (i < 0 || i == n || j < 0 || j == m || board[i][j] != '1') {
            return;
        }
        // board[i][j]='1'
        board[i][j] = '2';
        dfs(board, n, m, i - 1, j);
        dfs(board, n, m, i + 1, j);
        dfs(board, n, m, i, j - 1);
        dfs(board, n, m, i, j + 1);
    }
}
```



## [Leetcode【中】130.被围绕的区域](https://leetcode.cn/problems/surrounded-regions/description/)



```java
public class Solution {
    // 给定一个m*n的矩阵，矩阵每个元素都是“X”或“O”
    // 对于所有被“X”围绕的区域
    // 围绕：“X”连接了整个区域，区域中没有任何单元格位于表格边缘
    // 将区域内的“O”填充为“X”
    public static void solve(char[][] board) {
        int n = board.length;
        int m = board[0].length;
        // 将矩阵的上下两条边上出现的“O”以及与之相连的“O”填充为“F”
        // 也就是因为位于矩阵边缘而不算被围绕的地方
        for (int j = 0; j < m; j++) {
            if (board[0][j] == 'O') {
                dfs(board, n, m, 0, j);
            }
            if (board[n - 1][j] == 'O') {
                dfs(board, n, m, n - 1, j);
            }
        }
        // 将矩阵的左右两条边上出现的“O”以及与之相连的“O”填充为“F”
        // 也就是因为位于矩阵边缘而不算被围绕的地方
        for (int i = 0; i < n; i++) {
            if (board[i][0] == 'O') {
                dfs(board, n, m, i, 0);
            }
            if (board[i][m - 1] == 'O') {
                dfs(board, n, m, i, m - 1);
            }
        }
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                // 将矩阵内部被围绕的“O”填充为“X”
                if (board[i][j] == 'O') {
                    board[i][j] = 'X';
                }
                // 将矩阵边缘的“F”改回“O”
                if (board[i][j] == 'F') {
                    board[i][j] = 'O';
                }
            }
        }
    }

    public static void dfs(char[][] board, int n, int m, int i, int j) {
        if (i < 0 || i == n || j < 0 || j == m || board[i][j] != 'O') {
            return;
        }
        board[i][j] = 'F';
        dfs(board, n, m, i + 1, j);
        dfs(board, n, m, i - 1, j);
        dfs(board, n, m, i, j + 1);
        dfs(board, n, m, i, j - 1);
    }
}
```



## [Leetcode【难】827.最大人工岛](https://leetcode.cn/problems/making-a-large-island/description/)



```java
public class Solution {
    // 给定一个n*n的矩阵，只由0或1组成
    // 最多只能将一个0变成1
    // 返回此操作后，最大的岛屿面积
    // 岛屿：上下左右相邻的1组成
    public static int largestIsland(int[][] grid) {
        int n = grid.length;
        int m = grid[0].length;
        // 先将所有岛屿从2开始进行编号
        int id = 2;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (grid[i][j] == 1) {
                    dfs(grid, n, m, i, j, id++);
                }
            }
        }
        // 统计所有岛屿对应的面积
        int[] size = new int[id];
        int ans = 0;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (grid[i][j] > 1) {
                    ans = Math.max(ans, ++size[grid[i][j]]);
                }
            }
        }
        // 遍历0区域
        boolean[] visited = new boolean[id];
        int up, down, left, right, merge;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (grid[i][j] == 0) {
                    up = i > 0 ? grid[i - 1][j] : 0;
                    down = i + 1 < n ? grid[i + 1][j] : 0;
                    left = j > 0 ? grid[i][j - 1] : 0;
                    right = j + 1 < m ? grid[i][j + 1] : 0;
                    merge = 1;
                    if (!visited[up]) {
                        merge += size[up];
                        visited[up] = true;
                    }
                    if (!visited[down]) {
                        merge += size[down];
                        visited[down] = true;
                    }
                    if (!visited[left]) {
                        merge += size[left];
                        visited[left] = true;
                    }
                    if (!visited[right]) {
                        merge += size[right];
                        visited[right] = true;
                    }
                    ans = Math.max(ans, merge);
                    visited[up] = false;
                    visited[down] = false;
                    visited[left] = false;
                    visited[right] = false;
                }
            }
        }
        return ans;
    }

    public static void dfs(int[][] grid, int n, int m, int i, int j, int id) {
        if (i < 0 || i == n || j < 0 || j == m || grid[i][j] != 1) {
            return;
        }
        grid[i][j] = id;
        dfs(grid, n, m, i - 1, j, id);
        dfs(grid, n, m, i + 1, j, id);
        dfs(grid, n, m, i, j - 1, id);
        dfs(grid, n, m, i, j + 1, id);
    }
}
```



## [Leetcode【难】803.打砖块](https://leetcode.cn/problems/bricks-falling-when-hit/description/)



```java
public class Solution {
    // 给定m*n的矩阵，1表示砖块，0表示空白
    // 砖块稳定：
    // - 直接与矩阵顶部连接，也就是第0行一定稳定
    // - 上下左右四个方向相邻的至少有一个稳定
    // 给定一数组，这是需要依次消除砖块的位置
    // 每次消除对应位置砖块时，其余砖块可能因此这一操作也掉落
    // 返回每次操作对应掉落的砖块（也就是说不包括自身）数目

    public static int n, m;
    public static int[][] grid;

    public static int[] hitBricks(int[][] g, int[][] h) {
        grid = g;
        n = g.length;
        m = g[0].length;
        int[] ans = new int[h.length];
        // 当只有1行时，没有多余砖块掉落
        if (n == 1) {
            return ans;
        }
        for (int[] hit : h) {
            grid[hit[0]][hit[1]]--;
        }
        // 天花板洪水填充，将所有与天花板相连的砖块感染成2
        for (int i = 0; i < m; i++) {
            dfs(0, i);
        }
        for (int i = h.length - 1, row, col; i >= 0; i--) {
            row = h[i][0];
            col = h[i][1];
            grid[row][col]++;
            if (ifWorth(row, col)) {
                ans[i] = dfs(row, col) - 1;
            }
        }
        return ans;
    }

    // 从(i,j)格子出发，遇到1就感染成2
    // 统计新增了几个2！
    public static int dfs(int i, int j) {
        if (i < 0 || i == n || j < 0 || j == m || grid[i][j] != 1) {
            return 0;
        }
        grid[i][j] = 2;
        return 1 + dfs(i + 1, j) + dfs(i - 1, j) + dfs(i, j + 1) + dfs(i, j - 1);
    }

    public static boolean ifWorth(int i, int j) {
        return grid[i][j] == 1 &&
                (i == 0
                        || (i > 0 && grid[i - 1][j] == 2)
                        || (i < n - 1 && grid[i + 1][j] == 2)
                        || (j > 0 && grid[i][j - 1] == 2)
                        || (j < m - 1 && grid[i][j + 1] == 2));
    }
}
```



***



# ✅059【必备】建图、链式前向星、拓扑排序



图的三种建立方式



```java
import java.util.*;

public class Solution {
    // 点的最大数量
    public static int MAXN = 100;
    // 边的最大数量
    // 无向图最大边数:n*(n-1)/2
    // 有向图最大边数:n*(n-1)
    // m条边的无向图，链式前向星需要准备m*2条边
    public static int MAXM = 200;

    // 邻接矩阵（同时支持无向或有向）
    // 不带图，0或1填充
    // 带权图，权重或∞填充
    public static int[][] matrix = new int[MAXN][MAXN];

    // 邻接表（同时支持无向或有向）
    // 不带图
    public static ArrayList<ArrayList<Integer>> table1 = new ArrayList<>();
    // 带权图
    public static ArrayList<ArrayList<int[]>> table2 = new ArrayList<>();

    // 链式前向星
    public static int[] head = new int[MAXN];
    public static int[] next = new int[MAXM];
    public static int[] to = new int[MAXM];
    public static int[] weight = new int[MAXM];
    public static int cnt = 1;

    public static void build(int n) {
        // 邻接矩阵清空
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= n; j++) {
                matrix[i][j] = 0;
            }
        }
        // 邻接表清空
        table2.clear();
        // 邻接表虽然准备了n+1个列表，但实际上第0个用不到
        for (int i = 0; i <= n; i++) {
            table2.add(new ArrayList<>());
        }
        // 链式前向星清空
        // 边清空
        cnt = 1;
        Arrays.fill(head, 1, n + 1, 0);
    }

    // 链式前向星加边
    // 4个节点、5条边
    // [1,3]:1
    // [4,3]:2
    // [2,4]:3
    // [1,2]:4
    // [1,4]:5
    // head :[ ,5,3,0,2]
    // 0 1 2 3 4
    // next :[ ,0,0,0,1,4]
    // 0 1 2 3 4 5
    // to :[ ,3,3,4,2,4]
    // 0 1 2 3 4 5
    // weight:[ ,1,1,1,1,1]
    public static void addEdge(int u, int v, int w) {
        // u -> v , w
        // 当前边的下一条边（同样以该节点为起点，但是编号比当前边小的边）
        next[cnt] = head[u];
        // 当前边的终点
        to[cnt] = v;
        // 当前边的权重
        weight[cnt] = w;
        // 当前边成为当前起点新的第一条边，编号为cnt，然后cnt更新
        head[u] = cnt++;
    }

    // 有向带权图
    public static void directGraph(int[][] edges) {
        for (int[] edge : edges) {
            // 邻接矩阵
            matrix[edge[0]][edge[1]] = edge[2];
            // 邻接表
            table2.get(edge[0]).add(new int[] { edge[1], edge[2] });
            // 链式前向星
            addEdge(edge[0], edge[1], edge[2]);
        }
    }

    // 无向带权图
    public static void undirectGraph(int[][] edges) {
        for (int[] edge : edges) {
            // 邻接矩阵
            matrix[edge[0]][edge[1]] = edge[2];
            matrix[edge[1]][edge[0]] = edge[2];
            // 邻接表
            table2.get(edge[0]).add(new int[] { edge[1], edge[2] });
            table2.get(edge[1]).add(new int[] { edge[0], edge[2] });
            // 链式前向星
            addEdge(edge[0], edge[1], edge[2]);
            addEdge(edge[1], edge[0], edge[2]);
        }
    }

    // 遍历图
    public static void traversal(int n) {
        System.out.println("邻接矩阵遍历");
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= n; j++) {
                System.out.print(matrix[i][j] + " ");
            }
            System.out.println();
        }
        System.out.println("邻接表遍历");
        for (int i = 1; i <= n; i++) {
            System.out.print(i + "(邻居、边权):");
            for (int[] edge : table2.get(i)) {
                System.out.print("(" + edge[0] + "," + edge[1] + ") ");
            }
            System.out.println();
        }
        System.out.println("链式前向星");
        for (int i = 1; i <= n; i++) {
            System.out.print(i + "(邻居、终点):");
            for (int ei = head[i]; ei != 0; ei = next[ei]) {
                System.out.print("(" + to[ei] + "," + weight[ei] + ") ");
            }
            System.out.println();
        }
    }

    public static void main(String[] args) {
        int n = 4;
        int[][] edges = { { 1, 3, 1 }, { 4, 3, 2 }, { 2, 4, 3 }, { 1, 2, 4 }, { 1, 4, 5 } };
        build(n);
        directGraph(edges);
        traversal(n);
    }
}
```



## [Leetcode【中】210.课程表 II](https://leetcode.cn/problems/course-schedule-ii/description/)



```java
import java.util.*;

public class Solution {
    // numCourses门课，编号0~numCourses-1
    // prerequisites[i]=[ai,bi]表示要学习课程ai，必须先完成课程bi
    // 返回任意一种可行的顺序，反之则返回空数组

    public static int[] findOrder(int numCourses, int[][] prerequisites) {
        // 建立一个有向图存储课程依赖关系
        ArrayList<ArrayList<Integer>> graph = new ArrayList<>();
        // 初始化num个节点
        for (int i = 0; i < numCourses; i++) {
            graph.add(new ArrayList<>());
        }
        // 统计每个节点的入度
        int[] inDegree = new int[numCourses];
        for (int[] edge : prerequisites) {
            // [ai,bi]:bi->ai
            graph.get(edge[1]).add(edge[0]);
            inDegree[edge[0]]++;
        }
        // 结果队列
        int[] queue = new int[numCourses];
        int l = 0, r = 0;
        // 统计入度为0的课程，依次入队
        for (int i = 0; i < numCourses; i++) {
            if (inDegree[i] == 0) {
                queue[r++] = i;
            }
        }
        // 统计入队数量
        int count = 0;
        while (l < r) {
            // 滑动窗口右移
            int cur = queue[l++];
            // 上一课程已处理完毕
            count++;
            // 遍历以当前课程为先修课程的课程编号数组
            for (int next : graph.get(cur)) {
                // 如果某一课程此时入度-1=0，则该课程入队
                if (--inDegree[next] == 0) {
                    queue[r++] = next;
                }
            }
        }
        return count == numCourses ? queue : new int[0];
    }
}
```



## [牛客【】【模板】拓扑排序](https://www.nowcoder.com/practice/88f7e156ca7d43a1a535f619cd3f495c)



```java
import java.io.*;
import java.util.*;

public class Solution {
    // 拓扑排序（链表动态建图）
    // 返回任意可行解

    public static int MAXN = 200001;
    public static int[] queue = new int[MAXN];
    public static int l, r;
    public static int[] inDegree = new int[MAXN];
    public static int[] ans = new int[MAXN];
    public static int n, m;

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            m = (int) in.nval;
            ArrayList<ArrayList<Integer>> graph = new ArrayList<>();
            for (int i = 0; i <= n; i++) {
                graph.add(new ArrayList<>());
            }
            Arrays.fill(inDegree, 0, n + 1, 0);
            for (int i = 0, from, to; i < m; i++) {
                in.nextToken();
                from = (int) in.nval;
                in.nextToken();
                to = (int) in.nval;
                graph.get(from).add(to);
                inDegree[to]++;
            }
            if (!topoSort(graph)) {
                out.println(-1);
            } else {
                for (int i = 0; i < n - 1; i++) {
                    out.print(ans[i] + " ");
                }
                out.println(ans[n - 1]);
            }
        }
        out.flush();
        out.close();
    }

    public static boolean topoSort(ArrayList<ArrayList<Integer>> graph) {
        l = r = 0;
        for (int i = 1; i <= n; i++) {
            if (inDegree[i] == 0) {
                queue[r++] = i;
            }
        }
        int fill = 0;
        while (l < r) {
            int cur = queue[l++];
            ans[fill++] = cur;
            for (int next : graph.get(cur)) {
                if (--inDegree[next] == 0) {
                    queue[r++] = next;
                }
            }
        }
        return fill == n;
    }
}
```



```java
import java.io.*;
import java.util.*;

public class Solution {
    // 拓扑排序（静态链式前向星建图）
    // 返回任意可行解

    public static int MAXN = 200001;
    public static int MAXM = 200001;
    public static int[] head = new int[MAXN];
    public static int[] next = new int[MAXM];
    public static int[] to = new int[MAXM];
    public static int cnt;
    public static int[] queue = new int[MAXN];
    public static int l, r;
    public static int[] inDegree = new int[MAXN];
    public static int[] ans = new int[MAXN];
    public static int n, m;

    public static void build(int n) {
        cnt = 1;
        Arrays.fill(head, 0, n + 1, 0);
        Arrays.fill(inDegree, 0, n + 1, 0);
    }

    public static void addEdge(int f, int t) {
        next[cnt] = head[f];
        to[cnt] = t;
        head[f] = cnt++;
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            m = (int) in.nval;
            build(n);
            for (int i = 0, from, to; i < m; i++) {
                in.nextToken();
                from = (int) in.nval;
                in.nextToken();
                to = (int) in.nval;
                addEdge(from, to);
                inDegree[to]++;
            }
            if (!topoSort()) {
                out.println(-1);
            } else {
                for (int i = 0; i < n - 1; i++) {
                    out.print(ans[i] + " ");
                }
                out.println(ans[n - 1]);
            }
        }
        out.flush();
        out.close();
    }

    public static boolean topoSort() {
        l = r = 0;
        for (int i = 1; i <= n; i++) {
            if (inDegree[i] == 0) {
                queue[r++] = i;
            }
        }
        int fill = 0;
        while (l < r) {
            int cur = queue[l++];
            ans[fill++] = cur;
            for (int ei = head[cur]; ei != 0; ei = next[ei]) {
                if (--inDegree[to[ei]] == 0) {
                    queue[r++] = to[ei];
                }
            }
        }
        return fill == n;
    }
}
```



## [洛谷【】U107394 拓扑排序模板](https://www.luogu.com.cn/problem/U107394)



```java
import java.io.*;
import java.util.*;

public class Solution {
    // 拓扑排序
    // 返回的结果字典序尽可能小

    public static int MAXN = 100001;
    public static int MAXM = 100001;
    // 链式前向星
    public static int[] head = new int[MAXN];
    public static int[] next = new int[MAXM];
    public static int[] to = new int[MAXM];
    public static int cnt;

    // 拓扑排序：使用小根堆而不是队列
    public static int[] heap = new int[MAXN];
    public static int heapSize;

    public static int[] indegree = new int[MAXN];

    // 结果
    public static int[] ans = new int[MAXN];
    public static int n, m;

    // 初始化
    public static void build(int n) {
        cnt = 1;
        heapSize = 0;
        Arrays.fill(head, 0, n + 1, 0);
        Arrays.fill(indegree, 0, n + 1, 0);
    }

    // 添加边
    public static void addEdge(int u, int v) {
        next[cnt] = head[u];
        to[cnt] = v;
        head[u] = cnt++;
    }

    // 小根堆入堆
    public static void push(int num) {
        int i = heapSize++;
        heap[i] = num;
        while (heap[i] < heap[(i - 1) / 2]) {
            swap(i, (i - 1) / 2);
            i = (i - 1) / 2;
        }
    }

    // 小根堆弹出最小值
    public static int pop() {
        int ans = heap[0];
        heap[0] = heap[--heapSize];
        int i = 0, l = 1;
        while (l < heapSize) {
            int best = l + 1 < heapSize && heap[l + 1] < heap[l] ? l + 1 : l;
            best = heap[best] < heap[i] ? best : i;
            if (best == i) {
                break;
            }
            swap(best, i);
            i = best;
            l = i * 2 + 1;
        }
        return ans;
    }

    // 小根堆是否为空
    public static boolean isEmpty() {
        return heapSize == 0;
    }

    public static void swap(int i, int j) {
        int tmp = heap[i];
        heap[i] = heap[j];
        heap[j] = tmp;
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            m = (int) in.nval;
            build(n);
            for (int i = 0, from, t; i < m; i++) {
                in.nextToken();
                from = (int) in.nval;
                in.nextToken();
                t = (int) in.nval;
                addEdge(from, t);
                indegree[t]++;
            }
            topoSort();
            for (int i = 0; i < n - 1; i++) {
                out.print(ans[i] + " ");
            }
            out.println(ans[n - 1]);
        }
        out.flush();
        out.close();
    }

    public static void topoSort() {
        for (int i = 1; i <= n; i++) {
            if (indegree[i] == 0) {
                push(i);
            }
        }
        int fill = 0;
        while (!isEmpty()) {
            int cur = pop();
            ans[fill++] = cur;
            for (int ei = head[cur]; ei != 0; ei = next[ei]) {
                if (--indegree[to[ei]] == 0) {
                    push(to[ei]);
                }
            }
        }
    }
}
```



## [Leetcode【难】LCR114.火星词典](https://leetcode.cn/problems/Jf1JuT/description/)



```java
import java.util.*;

public class Solution {
    // 给定一字符串数组，其中的字符串都已经升序排好，不同字符串之间也已经排好序
    // 但是排序规则不是常规的字典序，而是一种自定义的字典序
    // 每个字符串只由26个英文小写字母组成
    // 现在我们需要返回这个自定义的字典序
    // 若有多个解决方案，则任意返回一个

    public static String alienOrder(String[] words) {
        // 26个字符入度表
        int[] inDegree = new int[26];
        Arrays.fill(inDegree, -1);
        // 标记出现的字符
        for (String w : words) {
            for (int i = 0; i < w.length(); i++) {
                inDegree[w.charAt(i) - 'a'] = 0;
            }
        }
        // 初始化有向图
        ArrayList<ArrayList<Integer>> graph = new ArrayList<>();
        for (int i = 0; i < 26; i++) {
            graph.add(new ArrayList<>());
        }
        // 对于两个字符串
        // abe
        // abcd
        // 说明e->c
        for (int i = 0, j, len; i < words.length - 1; i++) {
            String cur = words[i];
            String next = words[i + 1];
            len = Math.min(cur.length(), next.length());
            // 遍历两个字符串，找到第一个不同的字符
            for (j = 0; j < len; j++) {
                if (cur.charAt(j) != next.charAt(j)) {
                    // 添加路径：cur.charAt(j) -> next.charAt(j)
                    graph.get(cur.charAt(j) - 'a').add(next.charAt(j) - 'a');
                    // next.charAt(j)的入度增加
                    inDegree[next.charAt(j) - 'a']++;
                    break;
                }
            }
            // 如果两个字符串的顺序：
            // abcd
            // abc
            // 没有可行的排序
            if (j < cur.length() && j == next.length()) {
                return "";
            }
        }
        // 初始化
        int[] queue = new int[26];
        int l = 0, r = 0;
        int count = 0;
        // 统计出现的字符种类，并将入度为0的字符入队
        for (int i = 0; i < 26; i++) {
            if (inDegree[i] != -1) {
                count++;
            }
            if (inDegree[i] == 0) {
                queue[r++] = i;
            }
        }
        StringBuilder sb = new StringBuilder();
        // 拓扑排序
        while (l < r) {
            int cur = queue[l++];
            sb.append((char) (cur + 'a'));
            for (int next : graph.get(cur)) {
                if (--inDegree[next] == 0) {
                    queue[r++] = next;
                }
            }
        }
        return sb.length() == count ? sb.toString() : "";
    }
}
```



## [Leetcode【难】936.戮印序列](https://leetcode.cn/problems/stamping-the-sequence/description/)



```java
import java.util.*;

public class Solution {
    // 给定一个印章字符串stamp，一个目标字符串target
    // 那么现在有target长度的?
    // 我们需要挑选位置盖印章，使得原始的?变为target
    // 返回每次印章的起始位置（任意一种可行解）
    // stamp :abc
    // target:ababc
    // 初始 :?????
    // 1 :??abc
    // 2 :abcbc
    // 返回数组[2,0]
    public static int[] movesToStamp(String stamp, String target) {
        // 两个字符串数组化
        char[] s = stamp.toCharArray();
        char[] t = target.toCharArray();
        int sLen = s.length;
        int tLen = t.length;
        // 入度数组 : 目标字符串合适位置作为开头，所有的可能
        int[] inDegree = new int[tLen - sLen + 1];
        Arrays.fill(inDegree, sLen);
        // 初始化图，目标字符串所有位置
        ArrayList<ArrayList<Integer>> graph = new ArrayList<>();
        for (int i = 0; i < tLen; i++) {
            graph.add(new ArrayList<>());
        }
        // 寻找入度为0，匹配错误点为0的位置，入队
        int[] queue = new int[tLen - sLen + 1];
        int l = 0, r = 0;
        // 遍历目标字符串所有起始位置
        for (int i = 0; i < tLen - sLen + 1; i++) {
            // 遍历印章字符串
            for (int j = 0; j < sLen; j++) {
                // 如果目标字符串和印章字符串匹配，入度减一
                if (t[i + j] == s[j]) {
                    // 如果某一位置的入度减为0，那么可以入队
                    if (--inDegree[i] == 0) {
                        queue[r++] = i;
                    }
                } else {
                    // 错误的位置->该匹配情况下的印章字符串的起始位置
                    graph.get(i + j).add(i);
                }
            }
        }
        // 同一个位置不需要重复取消错误
        boolean[] visited = new boolean[tLen];
        // 倒序记录路径
        int[] path = new int[tLen - sLen + 1];
        // 路径大小
        int size = 0;
        // 拓扑排序
        while (l < r) {
            // 出队
            // 能够完美匹配的起始位置
            int cur = queue[l++];
            // 记录路径
            path[size++] = cur;
            // 遍历印章字符串
            for (int i = 0; i < sLen; i++) {
                // 如果当前的错误点还没有被覆盖过
                if (!visited[cur + i]) {
                    visited[cur + i] = true;
                    // 遍历当前错误位置所有可能的起始位置
                    for (int next : graph.get(cur + i)) {
                        // 如果某个起始位置的入度减为0，那么可以入队
                        if (--inDegree[next] == 0) {
                            queue[r++] = next;
                        }
                    }
                }
            }
        }
        // 如果路径大小不等于我们所有的可能位置数量不匹配，说明拓扑排序失败
        if (size != tLen - sLen + 1) {
            return new int[0];
        }
        // 倒序记录路径
        for (int i = 0, j = size - 1; i < j; i++, j--) {
            int temp = path[i];
            path[i] = path[j];
            path[j] = temp;
        }
        return path;
    }
    // stramp:a b c
    // target:a a b c b c
    //        0 1 2 3 4 5
    // 0开头  :✓ ✕ ✕2->0
    //        0 1 2
    // 1开头  :✓ ✓ ✓0
    //        1 2 3
    // 2开头  :✕ ✕ ✕3->1->0
    //        2 3 4
    // 3开头  :✕ ✓ ✓1->0
    //        3 4 5
    // 因为错误点可以被后续盖的印章所取消
    // 那么没有错误点的1开头的必然是最后一次盖的
    // 那么1开头覆盖的位置为1 2 3
    // 那么往前到退一步没有错误点的是0开头的和3开头的
    // 我们选0开头的，覆盖位置为0（1 2两个位置已被1开头的覆盖）
    // 再选3开头的，覆盖位置为4 5（3位置的已被1开头的覆盖）
    // 最后2开头的，错误都已被覆盖
}
```



***



# ✅060【必备】拓扑排序



## [洛谷【普及/提高-】P4017.最大食物链计数](https://www.luogu.com.cn/problem/P4017)



```java
import java.io.*;
import java.util.*;

public class Solution {
    // 食物链：a->b（一有向无环图）
    // 返回这个图中从最初级动物到最顶级动物的食物链有几条

    public static int MAXN = 5001;
    public static int MAXM = 500001;
    public static int MOD = 80112002;

    // 链式前向星图
    public static int[] head = new int[MAXN];
    public static int[] next = new int[MAXM];
    public static int[] to = new int[MAXM];
    public static int cnt;

    // 拓扑排序
    public static int[] queue = new int[MAXN];
    public static int[] inDegree = new int[MAXN];
    public static int n, m;

    public static int[] lines = new int[MAXN];

    public static void build(int n) {
        cnt = 1;
        Arrays.fill(head, 0, n + 1, 0);
        Arrays.fill(inDegree, 0, n + 1, 0);
        Arrays.fill(lines, 0, n + 1, 0);
    }

    public static void addEdge(int u, int v) {
        next[cnt] = head[u];
        to[cnt] = v;
        head[u] = cnt++;
    }

    public static int topoSort() {
        // 遍历入度数组，入度为0的即为最初级动物，入队
        int l = 0, r = 0;
        for (int i = 1; i <= n; i++) {
            if (inDegree[i] == 0) {
                queue[r++] = i;
                lines[i] = 1;
            }
        }
        // 答案
        int ans = 0;
        // 滑动窗口，拓扑排序
        while (l < r) {
            // 依次遍历当前入度为0的节点
            int u = queue[l++];
            // 如果当前节点没有出度，说明是最顶级动物，需要统计答案
            if (head[u] == 0) {
                ans = (ans + lines[u]) % MOD;
            } else {
                // 如果当前节点有出度，遍历他的所有出度节点
                for (int ei = head[u], v; ei > 0; ei = next[ei]) {
                    // 当前节点一有向边的指向节点
                    v = to[ei];
                    // 该指向指点的条数需要加上当前节点的条数
                    lines[v] = (lines[v] + lines[u]) % MOD;
                    // 该指向节点的入度减一，如果入度变为0，则入队
                    if (--inDegree[v] == 0) {
                        queue[r++] = v;
                    }
                }
            }
        }
        return ans;
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            // n个节点，m条单向边
            n = (int) in.nval;
            in.nextToken();
            m = (int) in.nval;
            build(n);
            build(n);
            for (int i = 0, u, v; i < m; i++) {
                in.nextToken();
                u = (int) in.nval;
                in.nextToken();
                v = (int) in.nval;
                addEdge(u, v);
                inDegree[v]++;
            }
            out.println(topoSort());
        }
        out.flush();
        out.close();
    }
}
```



## [Leetcode【中】851.喧闹和富有](https://leetcode.cn/problems/loud-and-rich/description/)



```java
import java.util.*;

public class Solution {
    // 给定一个整数n，表示0~n-1个人
    // 一个二维数组richer[i]=[ai,bi]:表示ai比bi有钱
    // 一个数组quiet[i]是person i的安静值
    // 返回一个数组ans
    // ans[x]=y的前提是
    // 所有比x有钱的人中，y是最安静的人

    public static int[] loudAndRich(int[][] richer, int[] quiet) {
        int n = quiet.length;
        // 建图：邻接表
        ArrayList<ArrayList<Integer>> graph = new ArrayList<>();
        for (int i = 0; i < n; i++) {
            graph.add(new ArrayList<>());
        }
        // 统计每个节点的入度
        int[] inDegree = new int[n];
        for (int[] r : richer) {
            graph.get(r[0]).add(r[1]);
            inDegree[r[1]]++;
        }
        // 拓扑排序
        // 初始化队列，入度为0的入队
        int[] queue = new int[n];
        int l = 0, r = 0;
        for (int i = 0; i < n; i++) {
            if (inDegree[i] == 0) {
                queue[r++] = i;
            }
        }
        // 初始答案数组
        // 默认每个人的答案当前都是自己
        int[] ans = new int[n];
        for (int i = 0; i < n; i++) {
            ans[i] = i;
        }
        while (l < r) {
            // 遍历入度为0的节点
            int cur = queue[l++];
            // 遍历当前节点的所有指向节点
            for (int next : graph.get(cur)) {
                // 如果当前节点的答案更安静，更新指向节点的答案
                if (quiet[ans[cur]] < quiet[ans[next]]) {
                    ans[next] = ans[cur];
                }
                // 更新指向节点的入度，
                // 如果入度为0，入队
                if (--inDegree[next] == 0) {
                    queue[r++] = next;
                }
            }
        }
        return ans;
    }
}
```



## [Leetcode【难】2050.并行课程 II](https://leetcode.cn/problems/parallel-courses-iii/description/)



```java
import java.util.*;

public class Solution {
    // 给定整数n，表示1~n门课
    // 给定一个二维整数数组relations
    // relations[i]=[prev,next]表示prev必须在next之前完成
    // 给定一个长度为n的整数数组time
    // time[i]表示完成第(i+1)门课程需要花费的月份数
    // 返回完成所有课程需要的最少月份
    // - 如果一门课的先修课程已全部完成，则可以在任意时间可是
    // - 可以同时上任意数量的课程

    public static int minimumTime(int n, int[][] relations, int[] time) {
        // 初始化图（邻接表）
        ArrayList<ArrayList<Integer>> graph = new ArrayList<>();
        for (int i = 0; i <= n; i++) {
            graph.add(new ArrayList<>());
        }
        // 入度数组，建图
        int[] inDegree = new int[n + 1];
        for (int[] edge : relations) {
            graph.get(edge[0]).add(edge[1]);
            inDegree[edge[1]]++;
        }
        // 拓扑排序
        // 初始化队列：没有先修课程的入队
        int[] queue = new int[n];
        int l = 0, r = 0;
        for (int i = 1; i <= n; i++) {
            if (inDegree[i] == 0) {
                queue[r++] = i;
            }
        }
        // 完成每个课程所需有的时间（包含前置课程）
        int[] cost = new int[n + 1];
        // 最终结果
        int ans = 0;
        // 滑动窗口，遍历队列
        while (l < r) {
            // 遍历，当前没有需要完成先修课程的课程
            int cur = queue[l++];
            // 完成当前课程的总时间
            // 当前课程的完成时间+不同先修课程路线的最大完成时间
            cost[cur] += time[cur - 1];
            // 更新最终结果
            ans = Math.max(ans, cost[cur]);
            // 遍历，当前课程的后置课程
            for (int next : graph.get(cur)) {
                // 更新后置课程完成选修课程的时间
                // 可能有多条前置课程路线需要我们去完成，我们需要选择其中最大的
                cost[next] = Math.max(cost[next], cost[cur]);
                // 如果后置课程的入度减为0，入队
                if (--inDegree[next] == 0) {
                    queue[r++] = next;
                }
            }
        }
        return ans;
    }
}
```



## [Leetcode【难】2127.参加会议的最多员工数](https://leetcode.cn/problems/maximum-employees-to-be-invited-to-a-meeting/description/)



```java
public class Solution {
    // 有n个员工需要开会，编号0~n-1
    // - 每个员工都会喜欢一位自己以外的员工
    // - 每位员工只有在他喜欢的员工的旁边，才会参加会议
    // 返回参加会议的最多员工数目
    public static int maximumInvitations(int[] favorite) {
        // 员工数量
        int n = favorite.length;
        // 统计入度数组
        int[] inDegree = new int[n];
        for (int i = 0; i < n; i++) {
            inDegree[favorite[i]]++;
        }
        // 初始化队列
        int[] queue = new int[n];
        int l = 0, r = 0;
        // 没有入度的员工入队
        for (int i = 0; i < n; i++) {
            if (inDegree[i] == 0) {
                queue[r++] = i;
            }
        }
        // 每个员工之前的最长链
        // 也就是以每个员工为终点的最长链，不包括当前员工
        int[] deep = new int[n];
        while (l < r) {
            int cur = queue[l++];
            int next = favorite[cur];
            // 可能有多个员工喜欢同一个员工
            // 那么该员工的最长链应该是所有喜欢他的员工的链的最大值
            deep[next] = Math.max(deep[next], deep[cur] + 1);
            if (--inDegree[next] == 0) {
                queue[r++] = next;
            }
        }
        // 目前图中的点只剩下环上的
        // - 不在环上的入度都已经变为0
        // - 环上的员工入度都还大于0

        // - 所有小环（中心节点==2）：中心点+延伸点：总个数
        int smallRings = 0;
        // - 所有大环（中心节点>=3）：中心点：最大环的中心点个数
        // 对于大环，最终答案只能是最大环的中心点个数，因为他们必须围成一个圈，不能像小环一样拼成一个圆圈
        int bigRings = 0;
        for (int i = 0; i < n; i++) {
            // 遍历每一个环
            if (inDegree[i] > 0) {
                // 初始化当前环的大小为1
                int ringSize = 1;
                // 从当前节点开始遍历环，并将当前节点入度改为0
                inDegree[i] = 0;
                // 遍历当前的环，并对遍历的每个节点入度该为0
                for (int j = favorite[i]; j != i; j = favorite[j]) {
                    ringSize++;
                    inDegree[j] = 0;
                }
                // 统计当前环的大小
                if (ringSize == 2) {
                    // 如果当前环是小环，那么就是加上两个节点以及各自的最长链
                    smallRings += 2 + deep[i] + deep[favorite[i]];
                } else {
                    // 如果当前环是大环，那么更新最大环的中心点个数
                    bigRings = Math.max(bigRings, ringSize);
                }
            }
        }
        return Math.max(smallRings, bigRings);
    }
}
```



***



# ✅061【必备】最小生成树



## [洛谷【普及/提高-】P3366 【模板】最小生成树](https://www.luogu.com.cn/problem/P3366)



```java
// Kruskal
// - 时间复杂度：O(m * log m) + O(n + m)
// - 空间复杂度：O(n + m)

import java.io.*;
import java.util.*;

public class Solution {
    // 最大节点数目
    public static int MAXN = 5001;
    // 最大边数目
    public static int MAXM = 200001;
    // 并查集
    public static int[] father = new int[MAXN];
    // 存储边
    public static int[][] edges = new int[MAXM][3];
    // 节点、边
    public static int n, m;

    // 初始化并查集
    public static void build() {
        for (int i = 1; i <= n; i++) {
            father[i] = i;
        }
    }

    // 查找当前节点的代表节点
    public static int find(int i) {
        if (i != father[i]) {
            father[i] = find(father[i]);
        }
        return father[i];
    }

    // 如果需要合并的两个集合元素位于同一个集合
    // 那么合并这两个元素会产生环，不符合题意
    public static boolean union(int x, int y) {
        int fx = find(x);
        int fy = find(y);
        if (fx != fy) {
            father[fx] = fy;
            return true;
        } else {
            return false;
        }
    }

    // 有权无向图
    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            m = (int) in.nval;
            build();
            // 存储边数组
            for (int i = 0; i < m; i++) {
                in.nextToken();
                edges[i][0] = (int) in.nval;
                in.nextToken();
                edges[i][1] = (int) in.nval;
                in.nextToken();
                edges[i][2] = (int) in.nval;
            }
            // 按照边的大小升序排序
            Arrays.sort(edges, 0, m, (a, b) -> a[2] - b[2]);
            // 最小生成树的最短路径和
            int ans = 0;
            // n个节点需要n-1条边
            int edgeCount = 0;
            // 从最短边开始遍历所有的边
            for (int[] edge : edges) {
                // 合并一条边两端的节点的条件
                // 两个端点各自所在的集合不同
                if (union(edge[0], edge[1])) {
                    edgeCount++;
                    ans += edge[2];
                }
            }
            out.println(edgeCount == n - 1 ? ans : "orz");
        }
        out.flush();
        out.close();
    }
}
```



```java
// Prim
// - 时间复杂度：O(m * log m) + O(n + m)
// - 空间复杂度：O(n + m)

import java.io.*;
import java.util.*;

public class Solution {

    public static int n, m;

    // 双向有权有向图
    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            // 邻接表（0位置的用不到、使用1~n位置）
            ArrayList<ArrayList<int[]>> graph = new ArrayList<>();
            n = (int) in.nval;
            // 初始化邻接表
            for (int i = 0; i <= n; i++) {
                graph.add(new ArrayList<>());
            }
            in.nextToken();
            m = (int) in.nval;
            for (int i = 0, u, v, w; i < m; i++) {
                in.nextToken();
                u = (int) in.nval;
                in.nextToken();
                v = (int) in.nval;
                in.nextToken();
                w = (int) in.nval;
                // 存储同一位置的双向边
                graph.get(u).add(new int[] { v, w });
                graph.get(v).add(new int[] { u, w });
            }
            // 小根堆
            PriorityQueue<int[]> sHeap = new PriorityQueue<>((a, b) -> a[1] - b[1]);
            // 初始化：任选一个节点开始，将当前节点指出的所有边及权都添加进小根堆
            for (int[] edge : graph.get(1)) {
                sHeap.add(edge);
            }
            // 每个节点是否访问
            // 功能类似并查集：最小生成树上是否有该节点
            boolean[] set = new boolean[n + 1];
            // 最小生成树上节点的数量，初始化为1
            int nodeCount = 1;
            // 位置1的节点初始化为已访问
            set[1] = true;
            // 最小生成树的最短路径和
            int ans = 0;
            // 小根堆是否空
            while (!sHeap.isEmpty()) {
                // 将小根堆中最短的边弹出
                int[] edge = sHeap.poll();
                int next = edge[0];
                int cost = edge[1];
                // 如果指向节点未访问，就入最小生成树
                if (!set[next]) {
                    nodeCount++;
                    set[next] = true;
                    ans += cost;
                    // 将该指向节点的所有指向边及权都入小根堆
                    for (int[] e : graph.get(next)) {
                        sHeap.add(e);
                    }
                }
            }
            out.println(nodeCount == n ? ans : "orz");
        }
        out.flush();
        out.close();
    }
}
```



```java
// Prim优化
// - 时间复杂度：O((n + m) * log n) + O(n + m)
// - 空间复杂度：O
// 核心思路：
// 将最小生成树中的节点看成一个整体一个节点
// 使用从这个整体出发到其余节点的距离
// 每个节点都只进出堆一次

import java.io.*;
import java.util.*;

public class Solution {

    // 最大节点数
    public static int MAXN = 5001;
    // 最大边数
    public static int MAXM = 400001;
    // 节点数
    public static int n;
    // 边数
    public static int m;

    // 链式前向星建图
    public static int[] head = new int[MAXN];
    public static int[] next = new int[MAXM];
    public static int[] to = new int[MAXM];
    public static int[] weight = new int[MAXM];
    public static int cnt;

    // 手写堆数组
    public static int[][] heap = new int[MAXN][2];
    public static int heapSize;

    // 堆位置索引数组
    // where[x]=-1:x尚未进入过堆
    // where[x]=-2:x已经弹出了堆
    // where[x]=i(>=0):x在堆上的i位置
    public static int[] where = new int[MAXN];

    // 节点数
    public static int nodeCount;

    public static void build() {
        cnt = 1;
        heapSize = 0;
        nodeCount = 0;
        Arrays.fill(head, 1, n + 1, 0);
        Arrays.fill(where, 1, n + 1, -1);
    }

    public static void addEdge(int u, int v, int w) {
        next[cnt] = head[u];
        to[cnt] = v;
        weight[cnt] = w;
        head[u] = cnt++;
    }

    // 处理编号ei的边
    public static void addOrUpdateOrIgnore(int ei) {
        int v = to[ei];
        int w = weight[ei];
        if (where[v] == -1) {
            // v这个点从未进入过堆
            heap[heapSize][0] = v;
            heap[heapSize][1] = w;
            where[v] = heapSize++;
            heapInsert(where[v]);
        } else if (where[v] >= 0 && heap[where[v]][1] > w) {
            heap[where[v]][1] = w;
            heapInsert(where[v]);
        }
    }

    public static void heapInsert(int i) {
        while (heap[i][1] < heap[(i - 1) / 2][1]) {
            swap(i, (i - 1) / 2);
            i = (i - 1) / 2;
        }
    }

    // - 堆中元素
    // - 目标节点编号
    // - 到目标节点的花费
    public static int u, w;

    public static void pop() {
        u = heap[0][0];
        w = heap[0][1];
        swap(0, --heapSize);
        heapify(0);
        where[u] = -2;
        nodeCount++;
    }

    public static void heapify(int i) {
        int l = i * 2 + 1;
        while (l < heapSize) {
            int best = l + 1 < heapSize && heap[l + 1][1] < heap[l][1] ? l + 1 : l;
            best = heap[best][1] < heap[i][1] ? best : i;
            if (best == i) {
                break;
            }
            swap(i, best);
            i = best;
            l = i * 2 + 1;
        }
    }

    public static boolean isEmpty() {
        return heapSize == 0;
    }

    // 交换堆中i位置和j位置
    public static void swap(int i, int j) {
        // 交换索引位置
        int a = heap[i][0];
        int b = heap[j][0];
        where[a] = j;
        where[b] = i;
        // 交换堆中元素
        int[] tmp = heap[i];
        heap[i] = heap[j];
        heap[j] = tmp;
    }

    // 双向有权有向图
    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            m = (int) in.nval;
            build();
            for (int i = 0, u, v, w; i < m; i++) {
                in.nextToken();
                u = (int) in.nval;
                in.nextToken();
                v = (int) in.nval;
                in.nextToken();
                w = (int) in.nval;
                addEdge(u, v, w);
                addEdge(v, u, w);
            }
            int ans = prim();
            out.println(nodeCount == n ? ans : "orz");
        }
        out.flush();
        out.close();
    }

    public static int prim() {
        // 从1号节点开始
        nodeCount = 1;
        where[1] = -2;
        // 将所有从1号节点出发的边加入堆
        for (int ei = head[1]; ei > 0; ei = next[ei]) {
            addOrUpdateOrIgnore(ei);
        }
        int ans = 0;
        while (!isEmpty()) {
            pop();
            ans += w;
            for (int ei = head[u]; ei > 0; ei = next[ei]) {
                addOrUpdateOrIgnore(ei);
            }
        }
        return ans;
    }
}
```



## [Leetcode【难】1697.检查边长度限制的路径是否存在](https://leetcode.cn/problems/checking-existence-of-edge-length-limited-paths/description/)



```java
import java.util.*;

public class Solution {
    // 给定一个n个节点组成的无向图
    // edgeList[i]=[ui,vi,disi]表示点ui和点vi之间有一条disi的边
    // 注意：两点之间不一定只有一条路径
    // 给定一个查询数组queries[j]=[pj,qj,limit]
    // 检查从pj到qj是否存在一条每条边都严格小于limit的路径
    // 返回一个布尔数组

    // 将所有边升序排序
    // 将严格小于limit的边生成最小生成树
    // 检查路径两端是否在同一个集合中

    public static int MAXN = 100001;
    public static int[][] questions = new int[MAXN][4];
    public static int[] father = new int[MAXN];

    public static void build(int n) {
        for (int i = 0; i < n; i++) {
            father[i] = i;
        }
    }

    public static int find(int i) {
        if (i != father[i]) {
            father[i] = find(father[i]);
        }
        return father[i];
    }

    public static boolean isSameSet(int x, int y) {
        return find(x) == find(y);
    }

    public static void union(int x, int y) {
        father[find(x)] = find(y);
    }

    public static boolean[] distanceLimitedPathsExist(int n, int[][] edges, int[][] queries) {
        // 对所有边按照权升序排序
        Arrays.sort(edges, (a, b) -> a[2] - b[2]);
        int m = edges.length;
        int k = queries.length;
        for (int i = 0; i < k; i++) {
            questions[i][0] = queries[i][0];
            questions[i][1] = queries[i][1];
            questions[i][2] = queries[i][2];
            questions[i][3] = i;
        }
        // 对所有查询按照limit升序排序
        Arrays.sort(questions, 0, k, (a, b) -> a[2] - b[2]);
        build(n);
        // 对于每组limit，筛选出所有边权小于limit的边，合并并查集，
        // 只要查询的两个点在同一个集合中，就一定可以通过最小生成树到达
        boolean[] ans = new boolean[k];
        for (int i = 0, j = 0; i < k; i++) {
            for (; j < m && edges[j][2] < questions[i][2]; j++) {
                union(edges[j][0], edges[j][1]);
            }
            ans[questions[i][3]] = isSameSet(questions[i][0], questions[i][1]);
        }
        return ans;
    }
}
```



## [洛谷【普及/提高-】P2330 \[SCOI2005\] 繁忙的都市](https://www.luogu.com.cn/problem/P2330)



```java
// 最小生成树一定是最小瓶颈树
// 最小瓶颈树是指在一个加权连通图中，
// 找到一个子图（原图的所有点连通），使得子图中任意两点之间的路径中
// 权值最大的边的权值最小

import java.util.*;
import java.io.*;

public class Solution {

    // n个节点，不同节点之间最多一条双向路相邻
    // 现在要求选择其中几条路
    // - 在所有节点相连的前提下，路最少
    // - 选择的路的路权的最大值尽可能小
    // 返回选了几条路，以及其中最大值是多少

    public static int MAXN = 301;
    public static int MAXM = 8001;
    public static int[] father = new int[MAXN];
    public static int[][] edges = new int[MAXM][3];
    public static int n, m;

    public static void build() {
        for (int i = 1; i <= n; i++) {
            father[i] = i;
        }
    }

    public static int find(int i) {
        if (i != father[i]) {
            father[i] = find(father[i]);
        }
        return father[i];
    }

    public static boolean union(int x, int y) {
        int fx = find(x);
        int fy = find(y);
        if (fx != fy) {
            father[fx] = fy;
            return true;
        } else {
            return false;
        }
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            m = (int) in.nval;
            build();
            for (int i = 0; i < m; i++) {
                in.nextToken();
                edges[i][0] = (int) in.nval;
                in.nextToken();
                edges[i][1] = (int) in.nval;
                in.nextToken();
                edges[i][2] = (int) in.nval;
            }
            Arrays.sort(edges, 0, m, (a, b) -> a[2] - b[2]);
            int ans = 0;
            int edgeCount = 0;
            for (int[] edge : edges) {
                if (union(edge[0], edge[1])) {
                    edgeCount++;
                    ans = Math.max(ans, edge[2]);
                }
                if (edgeCount == n - 1) {
                    break;
                }
            }
            out.println((n - 1) + " " + ans);
        }
        out.flush();
        out.close();
    }
}
```



***



# ✅062【必备】BFS 及其扩展



## [Leetcode【中】1162.地图分析](https://leetcode.cn/problems/as-far-from-land-as-possible/description/)



```java
public class Solution {
    // 给定一个二维n*n的矩阵grid
    // 由1（陆地）和0（海洋）填充
    // 返回矩阵中海洋的一个点
    // - 该点距离离它最近的陆地单元格的距离最大
    // - 曼哈顿距离=|x1-x2|+|y1-y2|

    // 宽度优先队列搜索（逐层遍历）

    public static int MAXN = 101;
    public static int MAXM = 101;
    public static int[][] queue = new int[MAXN * MAXM][2];
    public static int l, r;

    // 每个位置是否已经访问
    public static boolean[][] visited = new boolean[MAXN][MAXM];

    // 地图遍历一节点的四个方向移动
    // 0:上，1:右，2:下，3:左
    // (x,y):0:x+move[i],1:y+move[i+1]=x-1,y
    // (x,y):1:x+move[i],1:y+move[i+1]=x,y+1
    // (x,y):2:x+move[i],1:y+move[i+1]=x+1,y
    // (x,y):3:x+move[i],1:y+move[i+1]=x,y-1
    public static int[] move = new int[] { -1, 0, 1, 0, -1 };

    public static int maxDistance(int[][] grid) {
        // 二维矩阵的行和列
        int n = grid.length;
        int m = grid[0].length;
        // 矩阵中海洋单元格的数量
        int seas = 0;
        l = r = 0;
        // 初始化
        // - 将原始图中陆地标记为已访问
        // - 将原始图中陆地作为搜索第一层入队
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                if (grid[i][j] == 1) {
                    visited[i][j] = true;
                    queue[r][0] = i;
                    queue[r++][1] = j;
                } else {
                    visited[i][j] = false;
                    seas++;
                }
            }
        }
        // 排除特殊情况
        if (seas == 0 || seas == n * m) {
            return -1;
        }
        // 搜索层数
        int level = 0;
        while (l < r) {
            level++;
            // 遍历当前层的所有节点（队列）
            int size = r - l;
            for (int k = 0, x, y, nx, ny; k < size; k++) {
                x = queue[l][0];
                y = queue[l++][1];
                // 遍历当前节点的四个方向
                for (int i = 0; i < 4; i++) {
                    nx = x + move[i];
                    ny = y + move[i + 1];
                    // 新位置是否可以作为下一层探索的节点入队
                    if (nx >= 0 && nx < n && ny >= 0 && ny < m && !visited[nx][ny]) {
                        visited[nx][ny] = true;
                        queue[r][0] = nx;
                        queue[r++][1] = ny;
                    }
                }
            }
        }
        // 陆地算作了第一层
        return level - 1;
    }
}
```



## [Leetcode【难】691.贴纸拼词](https://leetcode.cn/problems/stickers-to-spell-word/description/)



```java
import java.util.*;

public class Solution {
    // 给定一个目标字符串target
    // 给定n种不同的小字符串，每种字符串数量不限
    // - 字符都是小写的英文字母
    // 现在我们需要用这些小字符串拼凑出target
    // 小字符串可以切割到单个字符级别进行拼凑
    // 返回我们最少需要的小字符串数量，反之则返回-1

    // 宽度有限遍历
    // 暴力思路：
    // 对于目标字符串，
    // 第一轮：该字符串减去所有可以的字符串，产生各自的结果（n个）
    // 第二轮：上一轮的结果各自继续减去所有可以的字符串，产生各自所有可能的结果（n*n个）
    // 持续，直到出现空字符，当前轮数即为结果

    // 剪枝思路：
    // 对于已处理的目标字符串（所有字符排序）
    // 每一轮中，只选择包含目标字符串首个字符的小字符串

    public static int MAXN = 501;
    public static String[] queue = new String[MAXN];
    public static int l, r;

    // 调整一个字符串，使其的字符升序排序
    public static String sort(String str) {
        char[] s = str.toCharArray();
        Arrays.sort(s);
        return String.valueOf(s);
    }

    public static String next(String t, String s) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0, j = 0; i < t.length();) {
            // 如果小字符串遍历完了，直接将目标字符串剩余字符加入结果
            if (j == s.length()) {
                sb.append(t.charAt(i++));
            } else {
                // 如果目标子字符串当前字符更小，直接加入结果
                if (t.charAt(i) < s.charAt(j)) {
                    sb.append(t.charAt(i++));
                } else if (t.charAt(i) > s.charAt(j)) {
                    // 如果目标子字符串的当前字符更大，移动小字符串指针
                    j++;
                } else {
                    // 如果二者一致，都移动指针
                    i++;
                    j++;
                }
            }
        }
        return sb.toString();
    }

    public static int minStickers(String[] stickers, String target) {
        // 邻接表
        // 存储含有对应字符的小字符串
        ArrayList<ArrayList<String>> graph = new ArrayList<>();
        for (int i = 0; i < 26; i++) {
            graph.add(new ArrayList<>());
        }
        for (String str : stickers) {
            // 整理每个小字符串
            str = sort(str);
            for (int i = 0; i < str.length(); i++) {
                // 不需要重复存储
                if (i == 0 || str.charAt(i) != str.charAt(i - 1)) {
                    graph.get(str.charAt(i) - 'a').add(str);
                }
            }
        }
        // 记录已处理过的目标字符串
        HashSet<String> visited = new HashSet<>();
        // 整理目标字符串
        target = sort(target);
        visited.add(target);
        // 初始化队列，将最原始目标字符串入对
        l = r = 0;
        queue[r++] = target;
        // 整层宽度优先遍历
        int level = 1;
        while (l < r) {
            int size = r - l;
            // 遍历本层所有可能目标子字符串
            for (int i = 0; i < size; i++) {
                // 获取当前目标字符串
                String cur = queue[l++];
                // 遍历所有含有当前目标字符串首字符的小字符串
                for (String s : graph.get(cur.charAt(0) - 'a')) {
                    // 当前目标字符串-小字符串
                    String next = next(cur, s);
                    // 如果结果为空，即获得了最终空字符串，返回当前层数
                    if (next.equals("")) {
                        return level;
                    } else if (!visited.contains(next)) {
                        // 如果结果不为空，且之前未处理过，记录已处理
                        // 如果记录过，直接跳过，因为如果记录过的话，
                        // 说明之前的路径更短，当前路径一定不是最优解
                        visited.add(next);
                        // 如果还没有结束，新字符串入队
                        queue[r++] = next;
                    }
                }
            }
            // 进入下一层
            level++;
        }
        return -1;
    }
}
```



## [Leetcode【难】2290.到达角落需要移除障碍物的最小数目](https://leetcode.cn/problems/minimum-obstacle-removal-to-reach-corner/description/)



```java
// 01BFS
// - distance[i]表示从源点到i点的最短距离，初始时都设置为无穷大
// - 源点进入双端队列，distance[源点]=0
// - 双端队列弹出头部节点
//   - 如果当前节点是目标节点，返回distance[目标节点]
//   - 否则：从x点出发，去y点，权为w
//     - 如果distance[y]>distance[x]+w
//       - 更新distance[y]=distance[x]+w
//       - 如果w=0，y点从头部进入双端队列
//       - 如果w=1，y点从尾部进入双端队列
//     - 否则，直接跳过
// - 双端队列为空，停止搜索，返回-1

import java.util.*;

public class Solution {
    // 给定一个m*n的二维矩阵grid
    // 由0（空地）和1（障碍）组成
    // 现在从左上角(0,0)移动到右下角(m-1,n-1)
    // 返回最小需要移除的障碍物数量

    public static int minimumObstacles(int[][] grid) {
        int[] move = { -1, 0, 1, 0, -1 };
        int m = grid.length;
        int n = grid[0].length;
        // 每个点到(0,0)的最小移除障碍物数量
        int[][] distance = new int[m][n];
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                distance[i][j] = Integer.MAX_VALUE;
            }
        }
        // 初始化双端队列
        ArrayDeque<int[]> deque = new ArrayDeque<>();
        // 源点进入队列，更新distance数组
        deque.addFirst(new int[] { 0, 0 });
        distance[0][0] = 0;
        // 双端队列不空不停
        while (!deque.isEmpty()) {
            // 弹出头部节点
            int[] record = deque.pollFirst();
            int x = record[0];
            int y = record[1];
            // 到达目标节点
            if (x == m - 1 && y == n - 1) {
                return distance[x][y];
            }
            // 往上下左右四个方向走
            for (int i = 0; i < 4; i++) {
                int nx = x + move[i];
                int ny = y + move[i + 1];
                // 如果x,y都未越界，且distance[nx][ny]>distance[x][y]+w
                if (nx >= 0 && nx < m && ny >= 0 && ny < n && distance[x][y] + grid[nx][ny] < distance[nx][ny]) {
                    distance[nx][ny] = distance[x][y] + grid[nx][ny];
                    if (grid[nx][ny] == 0) {
                        // 如果边权为0，从头部进入队列
                        deque.addFirst(new int[] { nx, ny });
                    } else {
                        // 如果边权为1，从尾部进入队列
                        deque.addLast(new int[] { nx, ny });
                    }
                }
            }
        }
        return -1;
    }
}
```



## [Leetcode【难】1368.使网格图至少有一条有效路径的最小代价](https://leetcode.cn/problems/minimum-cost-to-make-at-least-one-valid-path-in-a-grid/description/)



```java
import java.util.*;

public class Solution {
    // 给定一个m*n的grid二维矩阵，每个格子可能有一个数字
    // 1：下一步必须往右走
    // 2：下一步必须往左走
    // 3：下一步必须往下走
    // 4：下一步必须往上走
    // 现在我们需要从左上角(0,0)走到右下角(m-1,n-1)
    // 每个格子我们可以花费1的代价修改其提供的方向
    // 返回最小代价
    // 如果无法到达右下角，返回-1

    public static int minCost(int[][] grid) {
        // 配置移动数组
        int[][] move = { {}, { 0, 1 }, { 0, -1 }, { 1, 0 }, { -1, 0 } };
        // 初始化BFS
        int m = grid.length;
        int n = grid[0].length;
        int[][] distance = new int[m][n];
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < n; j++) {
                distance[i][j] = Integer.MAX_VALUE;
            }
        }
        // 初始化双端队列
        ArrayDeque<int[]> q = new ArrayDeque<>();
        // 源点入队
        q.addFirst(new int[] { 0, 0 });
        distance[0][0] = 0;
        // 队列不空不停
        while (!q.isEmpty()) {
            int[] record = q.pollFirst();
            int x = record[0];
            int y = record[1];
            if (x == m - 1 && y == n - 1) {
                return distance[x][y];
            }
            // 遍历四个方向
            for (int i = 1; i <= 4; i++) {
                int nx = x + move[i][0];
                int ny = y + move[i][1];
                // 使用01BFS的核心原因：
                // - 如果移动方向与格子提供的方向一致，代价为0
                // - 如果移动方向与格子提供的方向不一致，代价为1
                int cost = grid[x][y] != i ? 1 : 0;
                // 更新距离
                if (nx >= 0 && nx < m && ny >= 0 && ny < n && distance[nx][ny] > distance[x][y] + cost) {
                    distance[nx][ny] = distance[x][y] + cost;
                    if (cost == 0) {
                        q.addFirst(new int[] { nx, ny });
                    } else {
                        q.addLast(new int[] { nx, ny });
                    }
                }
            }
        }
        return -1;
    }
}
```



## [Leetcode【难】407.接雨水 II](https://leetcode.cn/problems/trapping-rain-water-ii/description/)



```java
import java.util.*;

public class Solution {
    // 二维接雨水
    // 给定一m*n的二维矩阵，值均非负，代表单元柱高度
    // 返回图围成的总接水量

    public static int trapRainWater(int[][] height) {
        int[] move = new int[] { -1, 0, 1, 0, -1 };
        int n = height.length;
        int m = height[0].length;
        // 小根堆
        // 0 : 行
        // 1 : 列
        // 2 : 水位线
        PriorityQueue<int[]> heap = new PriorityQueue<>((a, b) -> a[2] - b[2]);
        boolean[][] visited = new boolean[n][m];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                // 边界入堆
                if (i == 0 || i == n - 1 || j == 0 || j == m - 1) {
                    heap.add(new int[] { i, j, height[i][j] });
                    visited[i][j] = true;
                } else {
                    visited[i][j] = false;
                }
            }
        }
        int ans = 0;
        while (!heap.isEmpty()) {
            // 弹出水位线最小的单元
            int[] record = heap.poll();
            int x = record[0];
            int y = record[1];
            int w = record[2];
            // 计算当前单元接水量
            ans += w - height[x][y];
            // 向4个方向扩展
            for (int i = 0, nx, ny; i < 4; i++) {
                nx = x + move[i];
                ny = y + move[i + 1];
                // 扩展单元在矩阵内且未访问过
                if (nx >= 0 && nx < n && ny >= 0 && ny < m && !visited[nx][ny]) {
                    // 扩展单元水位线为当前单元水位线与扩展单元高度的较大值
                    heap.add(new int[] { nx, ny, Math.max(height[nx][ny], w) });
                    visited[nx][ny] = true;
                }
            }
        }
        return ans;
    }
}
```



## [Leetcode【难】126.单词接龙 II](https://leetcode.cn/problems/word-ladder-ii/description/)



```java
import java.util.*;

public class Solution {
    // 给定初始字符串begin和目标字符串end
    // 给定一个中间字符串数组s
    // 字符串均小写
    // 每次begin只能改变一个字符，直到变为end
    // begin -> s[1] -> s[2] ->...-> end
    // 返回所有最短路径转换路径.反之返回空列表

    // 存储中间字符串的集合（哈希表）：更方便操作
    public static HashSet<String> dict;
    // 当前层字符串的集合
    public static HashSet<String> curLevel = new HashSet<>();
    // 下一层字符串（当前层可以通过一个字符的改变变成的）的集合
    public static HashSet<String> nextLevel = new HashSet<>();
    // 反向图：为了生成路径
    public static HashMap<String, ArrayList<String>> graph = new HashMap<>();
    // 有效路径
    public static LinkedList<String> path = new LinkedList<>();
    // 有效路径的集合
    public static List<List<String>> ans = new ArrayList<>();

    // 初始化
    public static void build(List<String> wordList) {
        dict = new HashSet<>(wordList);
        graph.clear();
        ans.clear();
        curLevel.clear();
        nextLevel.clear();
    }

    // 正向宽搜
    public static boolean BFS(String begin, String end) {
        // 正向宽搜，是否找到了end
        boolean find = false;
        // 从begin开始第一层
        curLevel.add(begin);
        while (!curLevel.isEmpty()) {
            // 从哈希表中移除当前层的所有字符串
            // 此处移除是累加的，是为了当前层操作产出的字符串不会是之前处理过的，否则就不符合最短路径了
            dict.removeAll(curLevel);
            // 遍历当前层的所有字符串
            for (String word : curLevel) {
                // 对于当前字符串，遍历每个位置，每个位置都完成一轮从a变到z
                char[] w = word.toCharArray();
                for (int i = 0; i < w.length; i++) {
                    char old = w[i];
                    for (char ch = 'a'; ch <= 'z'; ch++) {
                        w[i] = ch;
                        String str = String.valueOf(w);
                        // 如果下一个字符串在去重后的字符串哈希表中，且不是当前字符串
                        if (dict.contains(str) && !str.equals(word)) {
                            if (str.equals(end)) {
                                find = true;
                            }
                            // 下一个字符串不在反向图中，就加入
                            graph.putIfAbsent(str, new ArrayList<>());
                            // 原始字符串word->下一个字符串str
                            // 反向存储
                            graph.get(str).add(word);
                            // 将当前的下一个字符串加入下一层
                            nextLevel.add(str);
                        }
                    }
                    // 恢复当前字符串
                    w[i] = old;
                }
            }
            // 如果找到了，直接返回
            if (find) {
                return true;
            } else {
                // 如果没有找到
                // 下一层成为当前层
                // 下一层清空
                HashSet<String> temp = curLevel;
                curLevel = nextLevel;
                nextLevel = temp;
                nextLevel.clear();
            }
        }
        return false;
    }

    // 反向深搜
    // 从end开始，反向递归寻找begin
    // 关键是graph: key->value: 下一个字符串->原始字符串
    public static void DFS(String end, String begin) {
        // 当前节点加入路径
        path.addFirst(end);
        if (end.equals(begin)) {
            // 找到begin，加入路径集合
            ans.add(new ArrayList<>(path));
        } else if (graph.containsKey(end)) {
            // 反向图中含有end，说明end有前驱节点
            // 遍历end的所有前驱节点
            for (String next : graph.get(end)) {
                // 继续向前深搜
                DFS(next, begin);
            }
        }
        // 回溯，当前节点移出路径
        path.removeFirst();
    }

    // 主函数
    public static List<List<String>> findLadders(String beginWord, String endWord, List<String> wordList) {
        // 初始化，处理中间字符串链表->哈希表
        build(wordList);
        // 目标字符串不在词表中，直接返回空列表
        if (!dict.contains(endWord)) {
            return ans;
        }
        if (BFS(beginWord, endWord)) {
            DFS(endWord, beginWord);
        }
        return ans;
    }
}
```



***



# ✅063【必备】双向广搜



## [Leetcode【难】127.单词接龙](https://leetcode.cn/problems/word-ladder/description/)



```java
import java.util.*;

public class Solution {
    // 给定两字符串：beginWord和endWord
    // 在给定一个中间字符串数组wordList
    // begin->wordList[i]->...->wordList[j]->end
    // 每次只能更改一个位置的字符
    // 返回最短长度，反之返回0

    public static int ladderLength(String begin, String end, List<String> wordList) {
        // 中间字符串数组->哈希表
        HashSet<String> dict = new HashSet<>(wordList);
        if (!dict.contains(end)) {
            return 0;
        }
        // 起始和终止两端同时往中间搜索
        // 一个作为小端
        // 一个作为大端
        // 剪枝:我们始终使用小端进行搜索
        // 数量少的一侧
        HashSet<String> sLevel = new HashSet<>();
        // 数量多的一侧
        HashSet<String> bLevel = new HashSet<>();
        // 由数量少的一侧扩展出的下一层
        HashSet<String> nLevel = new HashSet<>();
        // 初始化
        // 起始为小端
        sLevel.add(begin);
        // 终止为大端
        bLevel.add(end);
        // 初始的路径长度就为2
        for (int len = 2; !sLevel.isEmpty(); len++) {
            // 遍历小端的字符串
            for (String w : sLevel) {
                // 当前字符串转为字符数组,对每个位置尝试'a'->'z'的变换
                char[] word = w.toCharArray();
                for (int j = 0; j < word.length; j++) {
                    // 存储当前字符串当前位置的初始字符
                    char old = word[j];
                    for (char change = 'a'; change <= 'z'; change++) {
                        if (change != old) {
                            word[j] = change;
                            // 获得变化后的字符串
                            String next = String.valueOf(word);
                            // 如果小端变换后的下一层字符串包含在当前大端中,即搜索到了最短路径
                            if (bLevel.contains(next)) {
                                return len;
                            }
                            // 只有中间字符串数组含有的字符才可以被我们添加到下一层中
                            // 并且每个中间字符串只能添加一次,确保是最短路径
                            if (dict.contains(next)) {
                                dict.remove(next);
                                nLevel.add(next);
                            }
                        }
                    }
                    // 恢复
                    word[j] = old;
                }
            }
            if (nLevel.size() <= bLevel.size()) {
                // 如果小端的下一层仍然偏少
                // 那么小端的下一层继续是小端
                HashSet<String> temp = sLevel;
                sLevel = nLevel;
                nLevel = temp;
            } else {
                // 如果小端的下一层偏多
                // 那么大端变为小端
                // 原始小端的下一层赋给大端
                HashSet<String> temp = sLevel;
                sLevel = bLevel;
                bLevel = nLevel;
                nLevel = temp;
            }
            nLevel.clear();
        }
        return 0;
    }
}
```



## [洛谷【普及+/提高】P4799 \[CEOI 2015\] 世界冰球锦标赛 （Day2）](https://www.luogu.com.cn/problem/P4799)



## [牛客【中】WY52 牛牛的背包问题](https://www.nowcoder.com/practice/bf877f837467488692be703735db84e6?tpId=122\&tqId=33698\&ru=/exam/oj)



```java
import java.io.*;
import java.util.*;

public class Solution {
    // 给定n袋零食,i袋零食体积为v[i]
    // 给定背包容量w
    // 返回总体积不超过w,一共有多少种放法
    // - 体积为0也算一种放法
    // - 1<=n<=30
    // - 1<=w<=2*10^9
    // - 0<=v[i]<=10^9
    //   - 单个零食体积极大
    //   - 背包体积极大

    public static int MAXN = 40;
    public static int MAXM = 1 << 20;
    // 存储零食体积
    public static long[] arr = new long[MAXM];
    // 存储左半部分所有选择的体积和
    public static long[] lsum = new long[MAXM];
    // 存储右半部分所有选择的体积和
    public static long[] rsum = new long[MAXM];

    // 零食数量
    // [1,2,3,2,3,2]
    public static int n;
    // 背包体积
    // 7
    public static long w;

    public static long compute() {
        int lsize = f(0, n >> 1, 0, w, lsum, 0);
        int rsize = f(n >> 1, n, 0, w, rsum, 0);
        // 左半部分和右半部分体积和的排序
        Arrays.sort(lsum, 0, lsize);
        Arrays.sort(rsum, 0, rsize);
        long ans = 0;
        // 双指针枚举左半部分和右半部分的体积和
        // 0 1 2 3 3 4 5 6 || 0 2 2 3 4 5 5 7
        // 0 1 2 3 4 5 6 7 0 1 2 3 4 5 6 7
        // 0 <-i j-> rsize
        // 左侧从大到小枚举
        // 右侧从小到大枚举
        for (int i = lsize - 1, j = 0; i >= 0; i--) {
            // 当前左侧指针所处的位置处
            // 找到满足条件下的右侧指针的最右距离
            // 便对应当前左侧指针所处的位置，有多少种选择
            // 而后左侧指针左移，其所处位置的值变小
            // 当前右侧指针的位置及其往左一定满足要求
            // 只需要右侧指针继续右移搜索，直到不满足要求
            while (j < rsize && lsum[i] + rsum[j] <= w) {
                j++;
            }
            ans += j;
        }
        return ans;
    }

    // arr[i...e)范围上展开
    // s:当前选择的零食的体积累加和
    // w:背包体积
    // ans:存储所有选择各自的体积和
    // j:当前ans数组的有效大小

    // 计算左侧[1,2,3]所有选择的体积和
    //         0 1 2
    // 传入：       f(0,3,0,7,lsum,0)
    // - 不选1：    f(1,3,0,7,lsum,0)
    //   - 不选2：  f(2,3,0,7,lsum,0)
    //     - 不选3：f(3,3,0,7,lsum,0)->ans[0]=0
    //     - 选择3：f(3,3,3,7,lsum,1)->ans[1]=3
    //   - 选择2：  f(2,3,2,7,lsum,0)
    //     - 不选3：f(3,3,2,7,lsum,2)->ans[2]=2
    //     - 选择3：f(3,3,5,7,lsum,3)->ans[3]=5
    // - 选择1：    f(1,3,1,7,lsum,0)
    //   - 不选2：  f(2,3,1,7,lsum,0)
    //     - 不选3：f(3,3,1,7,lsum,4)->ans[4]=1
    //     - 选择3：f(3,3,4,7,lsum,5)->ans[5]=4
    //   - 选择2：  f(2,3,3,7,lsum,0)
    //     - 不选3：f(3,3,3,7,lsum,6)->ans[6]=3
    //     - 选择3：f(3,3,6,7,lsum,7)->ans[7]=6
    public static int f(int i, int e, long s, long w, long[] ans, int j) {
        if (s > w) {
            // 体积超过背包体积，直接返回当前ans数组的有效大小
            return j;
        }
        if (i == e) {
            // 到达递归基，将当前选择的零食的体积累加和加入ans数组
            ans[j++] = s;
            // 递归基返回当前ans数组的有效大小
            return j;
        } else {
            // 不选择当前零食
            j = f(i + 1, e, s, w, ans, j);
            // j更新：记录了不选择当前零食的体积和
            // 选择当前零食
            j = f(i + 1, e, s + arr[i], w, ans, j);
        }
        // 返回当前ans数组的有效大小
        return j;
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            w = (long) in.nval;
            for (int i = 0; i < n; i++) {
                in.nextToken();
                arr[i] = (long) in.nval;
            }
            out.println(compute());
        }
        out.flush();
        out.close();
    }
}
```



## [Leetcode【难】1755.最接近目标值的子系列和](https://leetcode.cn/problems/closest-subsequence-sum/description/)



```java
import java.util.*;

public class Solution {
    // 给定一个整数数组nums，一个目标值aim
    // 从nums中选择一个子系列（可以不连续，可以为空）
    // 使得子系列的元素和最接近aim
    // 返回最小二者差值的绝对值
    // - 1<=nums.length<=40
    // - -10^7<=nums[i]<=10^7
    // - -10^9<=aim<=10^9

    public static int MAXN = 1 << 20;
    // 左半部分的所有子序列和
    public static int[] lsum = new int[MAXN];
    // 右半部分的所有子序列和
    public static int[] rsum = new int[MAXN];
    // 记录当前填充的位置
    public static int fill;

    public static int minAbsDifference(int[] nums, int aim) {
        int n = nums.length;
        // 如果aim大于所有正数的和或者小于所有负数的和
        // 需要单独进行处理
        long max = 0;
        long min = 0;
        for (int i = 0; i < n; i++) {
            if (nums[i] >= 0) {
                max += nums[i];
            } else {
                min += nums[i];
            }
        }
        if (max < aim) {
            return (int) Math.abs(max - aim);
        }
        if (min > aim) {
            return (int) Math.abs(min - aim);
        }
        // 原始数组排序:[7,-9,15,-2,-2,1,5,8]
        Arrays.sort(nums);
        // [-9,-2,-2,1,5,8,7,15]
        fill = 0;
        // [-9,-2,-2,1]
        // collect(nums,0,4,0,lsum)
        collect(nums, 0, n >> 1, 0, lsum);
        int lszie = fill;
        fill = 0;
        // [5,8,7,15]
        // collect(nums,4,8,0,rsum)
        collect(nums, n >> 1, n, 0, rsum);
        int rsize = fill;
        Arrays.sort(lsum, 0, lszie);
        Arrays.sort(rsum, 0, rsize);
        int ans = Math.abs(aim);
        // 因为原始数组就是升序，
        // 所以左侧数组从0开始，右侧数组从rsize-1开始，二者数组都是升序
        // 当前左侧位置，右侧从右边rsize-1开始
        // 当两边和与aim差值缩小或相等时，都需要继续往左移动右侧指针（当前左侧指针下，和会越来越小）
        // 当当前左侧指针下，右侧指针再往左滑动，差的绝对值变大时，说明来到当前左侧指针下，右侧指针的最优解
        // 差值先逐渐变小，后又变大，说明小于aim小的越来越多
        // 左侧指针右移，此时和会变大，差值会变小，重复
        for (int i = 0, j = rsize - 1; i < lszie; i++) {
            while (j > 0 && Math.abs(aim - lsum[i] - rsum[j - 1]) <= Math.abs(aim - lsum[i] - rsum[j])) {
                j--;
            }
            ans = Math.min(ans, Math.abs(aim - lsum[i] - rsum[j]));
        }
        return ans;
    }

    // 整数数组范围：[i,e)
    // 当前选择的累加和：s
    // sum数组：记录所有可能的累加和
    // [-9,-2,-2,1]:2^2*3=12种
    //   0  1  2 3
    // collect(nums,i,e,s,lsum)
    // collect(nums,0,4,0,lsum)
    // - collect(nums,1,4,0,lsum)
    //   - collect(nums,3,4,0,lsum)
    //     - collect(nums,4,4,0,lsum)->lsum[0]=0
    //     - collect(nums,4,4,1,lsum)->lsum[1]=1
    //   - collect(nums,3,4,-2,lsum)
    //     - collect(nums,4,4,-2,lsum)->lsum[2]=-2
    //     - collect(nums,4,4,-1,lsum)->lsum[3]=-1
    //   - collect(nums,3,4,-4,lsum)
    //     - collect(nums,4,4,-4,lsum)->lsum[4]=-4
    //     - collect(nums,4,4,-3,lsum)->lsum[5]=-3
    // - collect(nums,1,4,-9,lsum)
    //   - collect(nums,3,4,-9,lsum)
    //     - collect(nums,4,4,-9,lsum)->lsum[6]=-9
    //     - collect(nums,4,4,-8,lsum)->lsum[7]=-8
    //   - collect(nums,3,4,-11,lsum)
    //     - collect(nums,4,4,-11,lsum)->lsum[8]=-11
    //     - collect(nums,4,4,-10,lsum)->lsum[9]=-10
    //   - collect(nums,3,4,-13,lsum)
    //     - collect(nums,4,4,-13,lsum)->lsum[10]=-13
    //     - collect(nums,4,4,-12,lsum)->lsum[11]=-12
    public static void collect(int[] nums, int i, int e, int s, int[] sum) {
        if (i == e) {
            sum[fill++] = s;
        } else {
            int j = i + 1;
            while (j < e && nums[j] == nums[i]) {
                j++;
            }
            for (int k = 0; k <= j - i; k++) {
                collect(nums, j, e, s + k * nums[i], sum);
            }
        }
    }
}
```



***



# ✅064【必备】Dijkstra 算法、分图层最短路



## [Leetcode【中】743.网络延迟时间](https://leetcode.cn/problems/network-delay-time/description/)



```java
// Dijkstra（单源最短路径算法）
// 给定一个源点，求解源点到每个点的最短路径
// - 有向图
// - 边权非负

import java.util.*;

public class Solution {
    // 给定n个节点，编号1~n
    // 给定一个数组times，表示有向边
    // times[i]=[ui,vi,wi]:从ui到vi的单向边权重wi
    // 从指定节点出发
    // 最短多久所有节点都可以收到信号

    // 动态邻接表建图+普通堆实现
    public static int networkDelayTime1(int[][] times, int n, int s) {
        // 初始化邻接表
        ArrayList<ArrayList<int[]>> graph = new ArrayList<>();
        for (int i = 0; i <= n; i++) {
            graph.add(new ArrayList<>());
        }
        for (int[] edge : times) {
            graph.get(edge[0]).add(new int[] { edge[1], edge[2] });
        }
        // 初始化源点到其余节点的距离
        int[] distance = new int[n + 1];
        Arrays.fill(distance, Integer.MAX_VALUE);
        distance[s] = 0;
        // 初始化每个节点是否处理
        boolean[] visited = new boolean[n + 1];
        // 初始化小根堆
        PriorityQueue<int[]> heap = new PriorityQueue<>((a, b) -> a[1] - b[1]);
        // 源点入堆
        heap.add(new int[] { s, 0 });
        while (!heap.isEmpty()) {
            // 弹出小根堆堆顶元素
            int u = heap.poll()[0];
            if (visited[u]) {
                continue;
            }
            visited[u] = true;
            // 遍历从该节点出发的所有边
            for (int[] edge : graph.get(u)) {
                int v = edge[0];
                int w = edge[1];
                // 如果目的地节点未被处理且更小距离出现
                if (!visited[v] && distance[u] + w < distance[v]) {
                    distance[v] = distance[u] + w;
                    heap.add(new int[] { v, distance[u] + w });
                }
            }
        }
        // 寻找所有最短距离的最大值
        int ans = Integer.MIN_VALUE;
        for (int i = 1; i <= n; i++) {
            if (distance[i] == Integer.MAX_VALUE) {
                return -1;
            }
            ans = Math.max(ans, distance[i]);
        }
        return ans;
    }

    // 链式前向星+反向索引堆实现
    public static int networkDelayTime2(int[][] times, int n, int s) {
        build(n);
        for (int[] edge : times) {
            addEdge(edge[0], edge[1], edge[2]);
        }
        addOrUpdateOrIgnore(s, 0);
        while (!isEmpty()) {
            int u = pop();
            for (int ei = head[u]; ei > 0; ei = next[ei]) {
                addOrUpdateOrIgnore(to[ei], distance[u] + weight[ei]);
            }
        }
        int ans = Integer.MIN_VALUE;
        for (int i = 1; i <= n; i++) {
            if (distance[i] == Integer.MAX_VALUE) {
                return -1;
            }
            ans = Math.max(ans, distance[i]);
        }
        return ans;
    }

    // 点
    public static int MAXN = 101;
    // 边
    public static int MAXM = 6001;

    // 链式前向星
    public static int[] head = new int[MAXN];
    public static int[] next = new int[MAXM];
    public static int[] to = new int[MAXM];
    public static int[] weight = new int[MAXM];
    public static int cnt;

    // 反向索引堆：堆中存储每个节点
    // 数组下标是节点编号，也是节点在堆中位置
    public static int[] heap = new int[MAXN];

    // where[v]= -1，表示v从未进入堆
    // where[v]= -2，表示v已经弹出堆
    // where[v]= i>=0，表示v在堆上位置
    public static int[] where = new int[MAXN];

    // 堆大小
    public static int heapSize;
    // 每个节点到源点的距离
    public static int[] distance = new int[MAXN];

    // 初始化堆
    public static void build(int n) {
        cnt = 1;
        heapSize = 0;
        // 初始化链式前向星图，每个节点没有出边
        Arrays.fill(head, 1, n + 1, 0);
        // 初始化每个节点都还未进入堆
        Arrays.fill(where, 1, n + 1, -1);
        // 每个节点到源点为无穷大（不可达）
        Arrays.fill(distance, 1, n + 1, Integer.MAX_VALUE);
    }

    // 链式前向星建图：添加一条从u到v权重为w的有向边
    public static void addEdge(int u, int v, int w) {
        next[cnt] = head[u];
        to[cnt] = v;
        weight[cnt] = w;
        head[u] = cnt++;
    }

    // v:目标节点
    // c:从源点到v的距离
    public static void addOrUpdateOrIgnore(int v, int c) {
        // 如果节点从未进入堆，入堆
        if (where[v] == -1) {
            // 放在堆中最后位置
            heap[heapSize] = v;
            // 节点v进入堆，位置是heapSize
            where[v] = heapSize++;
            // 因为该节点首次进入堆，所以到源点距离直接为c
            distance[v] = c;
            // 新节点在堆尾部（右下角）入堆，需要调整堆结构
            heapInsert(where[v]);
        }
        // 如果节点已在堆中，且新距离更短，更新距离并调整堆结构
        else if (where[v] >= 0) {
            if (distance[v] > c) {
                distance[v] = c;
                heapInsert(where[v]);
            }
        }
    }

    // 小根堆调整：从下往上调整
    public static void heapInsert(int i) {
        // i是当前节点，(i - 1) / 2是父节点
        // 如果当前节点距离小于父节点距离，交换并继续向上调整
        while (distance[heap[i]] < distance[heap[(i - 1) / 2]]) {
            swap(i, (i - 1) / 2);
            i = (i - 1) / 2;
        }
    }

    // 弹出堆顶元素
    public static int pop() {
        int ans = heap[0];
        // 弹出堆顶后，用堆底元素替换堆顶
        swap(0, --heapSize);
        // 堆顶往下调整，维护小根堆
        heapify(0);
        where[ans] = -2;
        return ans;
    }

    // 小根堆调整：从上往下调整
    public static void heapify(int i) {
        // i是当前节点，l是左子节点
        int l = i * 2 + 1;
        // 如果当前节点有左子节点
        while (l < heapSize) {
            // 找到当前节点的左子节点、右子节点中距离最小的节点
            int best = l + 1 < heapSize && distance[heap[l + 1]] < distance[heap[l]] ? l + 1 : l;
            // 比较当前节点距离和子节点的最小距离，取较小者
            best = distance[heap[best]] < distance[heap[i]] ? best : i;
            // 如果当前节点距离已经是最小，无需调整，跳出循环
            if (best == i) {
                break;
            }
            // 交换当前节点和较小子节点
            swap(best, i);
            // 更新当前节点为较小子节点，继续向下调整
            i = best;
            l = i * 2 + 1;
        }
    }

    // 堆是否为空
    public static boolean isEmpty() {
        return heapSize == 0;
    }

    // 交换堆中两个节点的位置
    // - 交换堆heap中i和j位置处的节点
    // - 更新节点在堆中的位置where
    public static void swap(int i, int j) {
        int temp = heap[i];
        heap[i] = heap[j];
        heap[j] = temp;
        where[heap[i]] = i;
        where[heap[j]] = j;
    }
}
```



## [洛谷【普及/提高-】P4779【模板】单源最短路径（标准版）](https://www.luogu.com.cn/problem/P4779)



```java
// Dijkstra（单源最短路径算法）
// 给定一个源点，求解源点到每个点的最短路径
// - 有向图
// - 边权非负

import java.util.*;
import java.io.*;

public class Solution {
    // 给定n个节点，编号1~n
    // 给定一个数组times，表示有向边
    // times[i]=[ui,vi,wi]:从ui到vi的单向边权重wi
    // 从指定节点出发
    // 返回每个节点的最短距离

    // 点
    public static int MAXN = 100001;
    // 边
    public static int MAXM = 200001;

    public static int n, m, s;

    // 链式前向星
    public static int[] head = new int[MAXN];
    public static int[] next = new int[MAXM];
    public static int[] to = new int[MAXM];
    public static int[] weight = new int[MAXM];
    public static int cnt;

    // 反向索引堆：堆中存储每个节点
    // 数组下标是节点编号，也是节点在堆中位置
    public static int[] heap = new int[MAXN];

    // where[v]= -1，表示v从未进入堆
    // where[v]= -2，表示v已经弹出堆
    // where[v]= i>=0，表示v在堆上位置
    public static int[] where = new int[MAXN];

    // 堆大小
    public static int heapSize;
    // 每个节点到源点的距离
    public static int[] distance = new int[MAXN];

    // 初始化堆
    public static void build(int n) {
        cnt = 1;
        heapSize = 0;
        // 初始化链式前向星图，每个节点没有出边
        Arrays.fill(head, 1, n + 1, 0);
        // 初始化每个节点都还未进入堆
        Arrays.fill(where, 1, n + 1, -1);
        // 每个节点到源点为无穷大（不可达）
        Arrays.fill(distance, 1, n + 1, Integer.MAX_VALUE);
    }

    // 链式前向星建图：添加一条从u到v权重为w的有向边
    public static void addEdge(int u, int v, int w) {
        next[cnt] = head[u];
        to[cnt] = v;
        weight[cnt] = w;
        head[u] = cnt++;
    }

    // v:目标节点
    // c:从源点到v的距离
    public static void addOrUpdateOrIgnore(int v, int c) {
        // 如果节点从未进入堆，入堆
        if (where[v] == -1) {
            // 放在堆中最后位置
            heap[heapSize] = v;
            // 节点v进入堆，位置是heapSize
            where[v] = heapSize++;
            // 因为该节点首次进入堆，所以到源点距离直接为c
            distance[v] = c;
            // 新节点在堆尾部（右下角）入堆，需要调整堆结构
            heapInsert(where[v]);
        }
        // 如果节点已在堆中，且新距离更短，更新距离并调整堆结构
        else if (where[v] >= 0) {
            if (distance[v] > c) {
                distance[v] = c;
                heapInsert(where[v]);
            }
        }
    }

    // 小根堆调整：从下往上调整
    public static void heapInsert(int i) {
        // i是当前节点，(i - 1) / 2是父节点
        // 如果当前节点距离小于父节点距离，交换并继续向上调整
        while (distance[heap[i]] < distance[heap[(i - 1) / 2]]) {
            swap(i, (i - 1) / 2);
            i = (i - 1) / 2;
        }
    }

    // 弹出堆顶元素
    public static int pop() {
        int ans = heap[0];
        // 弹出堆顶后，用堆底元素替换堆顶
        swap(0, --heapSize);
        // 堆顶往下调整，维护小根堆
        heapify(0);
        where[ans] = -2;
        return ans;
    }

    // 小根堆调整：从上往下调整
    public static void heapify(int i) {
        // i是当前节点，l是左子节点
        int l = i * 2 + 1;
        // 如果当前节点有左子节点
        while (l < heapSize) {
            // 找到当前节点的左子节点、右子节点中距离最小的节点
            int best = l + 1 < heapSize && distance[heap[l + 1]] < distance[heap[l]] ? l + 1 : l;
            // 比较当前节点距离和子节点的最小距离，取较小者
            best = distance[heap[best]] < distance[heap[i]] ? best : i;
            // 如果当前节点距离已经是最小，无需调整，跳出循环
            if (best == i) {
                break;
            }
            // 交换当前节点和较小子节点
            swap(best, i);
            // 更新当前节点为较小子节点，继续向下调整
            i = best;
            l = i * 2 + 1;
        }
    }

    // 堆是否为空
    public static boolean isEmpty() {
        return heapSize == 0;
    }

    // 交换堆中两个节点的位置
    // - 交换堆heap中i和j位置处的节点
    // - 更新节点在堆中的位置where
    public static void swap(int i, int j) {
        int temp = heap[i];
        heap[i] = heap[j];
        heap[j] = temp;
        where[heap[i]] = i;
        where[heap[j]] = j;
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            m = (int) in.nval;
            in.nextToken();
            s = (int) in.nval;
            build(n);
            for (int i = 0, u, v, w; i < m; i++) {
                in.nextToken();
                u = (int) in.nval;
                in.nextToken();
                v = (int) in.nval;
                in.nextToken();
                w = (int) in.nval;
                addEdge(u, v, w);
            }
            Dijkstra();
            out.print(distance[1]);
            for (int i = 2; i <= n; i++) {
                out.print(" " + distance[i]);
            }
            out.println();
        }
        out.flush();
        out.close();
    }

    public static void Dijkstra() {
        addOrUpdateOrIgnore(s, 0);
        while (!isEmpty()) {
            int v = pop();
            for (int ei = head[v]; ei > 0; ei = next[ei]) {
                addOrUpdateOrIgnore(to[ei], distance[v] + weight[ei]);
            }
        }
    }
}
```



## [Leetcode【中】1631.最小体力消耗路径](https://leetcode.cn/problems/path-with-minimum-effort/description/)



```java
import java.util.*;

public class Solution {
    // 给定一个二维矩阵h
    // h[x][y]表示(x,y)位置的高度
    // 现在需要从左上角走到右下角
    // 返回消耗最小的一条路径
    // 一条路径的消耗是该路径上，相邻格子之间高度差值绝对值的最大值

    public static int minimumEffortPath(int[][] heights) {
        // 四个移动方向
        int[] move = new int[] { -1, 0, 1, 0, -1 };
        // 初始化
        int n = heights.length;
        int m = heights[0].length;
        // 每个节点到源点的最小消耗
        int[][] distance = new int[n][m];
        // 记录节点是否被处理
        boolean[][] visited = new boolean[n][m];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                distance[i][j] = Integer.MAX_VALUE;
            }
        }
        distance[0][0] = 0;
        // 小根堆
        PriorityQueue<int[]> heap = new PriorityQueue<>((a, b) -> a[2] - b[2]);
        // 源点入堆
        heap.add(new int[] { 0, 0, 0 });
        while (!heap.isEmpty()) {
            // 弹出堆顶：当前到源点消耗最小的节点
            int[] record = heap.poll();
            int x = record[0];
            int y = record[1];
            int c = record[2];
            // 如果当前节点已经被处理过，直接跳过
            if (visited[x][y]) {
                continue;
            }
            // 如果当前节点是终点，直接返回
            if (x == n - 1 && y == m - 1) {
                return c;
            }
            // 标记当前节点为已处理
            visited[x][y] = true;
            // 遍历当前节点的四个方向
            for (int i = 0; i < 4; i++) {
                int nx = x + move[i];
                int ny = y + move[i + 1];
                // 如果下一个位置不越界，且未被处理过
                if (nx >= 0 && nx < n && ny >= 0 && ny < m && !visited[nx][ny]) {
                    // 计算下一个位置到源点的消耗
                    int nc = Math.max(c, Math.abs(heights[x][y] - heights[nx][ny]));
                    // 如果下一个位置到源点的消耗更小
                    if (nc < distance[nx][ny]) {
                        distance[nx][ny] = nc;
                        heap.add(new int[] { nx, ny, nc });
                    }
                }
            }
        }
        return -1;
    }
}
```



## [Leetcode【难】778.水位上升的泳池中游泳](https://leetcode.cn/problems/swim-in-rising-water/description/)



```java
import java.util.PriorityQueue;

public class Solution {
    // 给定一个n*n的二维整数矩阵grid
    // grod[i][j]表示(i,j)的高度
    // 开始下雨，时间t时，水位高度为t
    // 从一个位置，可以从四周任意方向游泳，前提水位同时淹没两个位置
    // 从左上到右下的最短时间

    public static int swimInWater(int[][] grid) {
        int[] move = new int[] { -1, 0, 1, 0, -1 };
        int n = grid.length;
        int m = grid[0].length;
        int[][] distance = new int[n][m];
        boolean[][] visited = new boolean[n][m];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                distance[i][j] = Integer.MAX_VALUE;
            }
        }
        distance[0][0] = grid[0][0];
        PriorityQueue<int[]> heap = new PriorityQueue<>((a, b) -> a[2] - b[2]);
        heap.add(new int[] { 0, 0, grid[0][0] });
        while (!heap.isEmpty()) {
            int x = heap.peek()[0];
            int y = heap.peek()[1];
            int c = heap.peek()[2];
            heap.poll();
            if (visited[x][y]) {
                continue;
            }
            visited[x][y] = true;
            if (x == n - 1 && y == m - 1) {
                return c;
            }
            for (int i = 0; i < 4; i++) {
                int nx = x + move[i];
                int ny = y + move[i + 1];
                if (nx >= 0 && nx < n && ny >= 0 && ny < m && !visited[nx][ny]) {
                    int nc = Math.max(c, grid[nx][ny]);
                    if (nc < distance[nx][ny]) {
                        distance[nx][ny] = nc;
                        heap.add(new int[] { nx, ny, nc });
                    }
                }
            }
        }
        return -1;
    }
}
```



## [Leetcode【难】864.获取所有钥匙的最短路径](https://leetcode.cn/problems/shortest-path-to-get-all-keys/description/)



```java
public class Solution {
    // 给定一个二维表格grid
    // - '.'表示一个空房间
    // - '#'表示一堵墙
    // - '@'表示起点
    // - '小写字母'表示钥匙
    // - '大写字母'表示对应锁
    // 不能越界行走，不能穿过墙
    // - 途径钥匙，我们收集
    // - 途径锁，我们如果有对应钥匙才可以穿过
    // k把钥匙：1<=k<=6，字母表前k对字母
    // 返回收集所有钥匙需要移动的最少步数，反之返回-1

    // 行、列
    public static int MAXN = 31;
    public static int MAXM = 31;
    // 钥匙数量
    public static int MAXK = 6;
    // 上、右、下、左
    public static int[] move = new int[] { -1, 0, 1, 0, -1 };

    // 网格
    public static char[][] grid = new char[MAXN][];

    // 2^k层网络是否访问过
    public static boolean[][][] visited = new boolean[MAXN][MAXM][1 << MAXK];

    // 0:行
    // 1:列
    // 2:收集钥匙的状态
    public static int[][] queue = new int[MAXN * MAXM * (1 << MAXK)][3];

    public static int l, r, n, m, key;

    // 初始化
    public static void build(String[] g) {
        l = r = key = 0;
        n = g.length;
        m = g[0].length();
        // 初始化网格
        for (int i = 0; i < n; i++) {
            grid[i] = g[i].toCharArray();
        }
        // 初始化队列
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                // 起始位置入队
                if (grid[i][j] == '@') {
                    queue[r][0] = i;
                    queue[r][1] = j;
                    // 0:000000(二进制)
                    queue[r++][2] = 0;
                }
                // 统计最终钥匙状态
                if (grid[i][j] >= 'a' && grid[i][j] <= 'f') {
                    key |= 1 << (grid[i][j] - 'a');
                }
            }
        }
        // 初始化访问数组
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                for (int s = 0; s <= key; s++) {
                    visited[i][j][s] = false;
                }
            }
        }
    }

    // BFS式搜索
    public static int shortestPathAllKeys(String[] g) {
        build(g);
        int level = 1;
        while (l < r) {
            // 遍历当前层（同时也是步数，只不过是因为宽搜，多个方向同时进行搜索）
            for (int k = 0, size = r - l, x, y, s; k < size; k++) {
                // 行
                x = queue[l][0];
                // 列
                y = queue[l][1];
                // 收集钥匙的状态
                s = queue[l++][2];
                // 当前层当前位置遍历四个方向
                for (int i = 0, nx, ny, ns; i < 4; i++) {
                    // 当前位置下一位置
                    // 下一行
                    nx = x + move[i];
                    // 下一列
                    ny = y + move[i + 1];
                    // 下一位置的钥匙状态
                    ns = s;
                    // 越界或者障碍
                    if (nx < 0 || nx == n || ny < 0 || ny == m || grid[nx][ny] == '#') {
                        continue;
                    }
                    // 是锁且没有钥匙，不能通过
                    if (grid[nx][ny] >= 'A' && grid[nx][ny] <= 'F' && ((ns & 1 << (grid[nx][ny] - 'A')) == 0)) {
                        continue;
                    }
                    // 是钥匙，更新下一位置的状态
                    if (grid[nx][ny] >= 'a' && grid[nx][ny] <= 'f') {
                        ns |= (1 << (grid[nx][ny] - 'a'));
                    }
                    // 如果我们搜索搜集到的钥匙的状态等于总钥匙状态，返回当前层
                    if (ns == key) {
                        return level;
                    }
                    // 如果未访问过下一位置，入队
                    if (!visited[nx][ny][ns]) {
                        visited[nx][ny][ns] = true;
                        queue[r][0] = nx;
                        queue[r][1] = ny;
                        queue[r++][2] = ns;
                    }
                }
            }
            // 遍历完当前层，步数加一
            level++;
        }
        return -1;
    }
}
```



## [Leetcode【难】LCP35.电动车游城市](https://leetcode.cn/problems/DFPeFJ/description/)



```java
import java.util.*;

public class Solution {
    // 电动车充满电cnt，每行驶1单位距离消耗1单位电量，话费1单位时间
    // N个景点，编号0~N-1
    // 给定二维数组paths[a,b,x]:景点a到景点b距离x(双向通路)
    // 给定一一维数组charge[i]表示i景点充1单位电量所需要的时间
    // 初始状态电量为0
    // 从起点start到终点end
    // 返回所需要的最短时间

    public static int electricCarPlan(int[][] paths, int cnt, int start, int end, int[] charge) {
        // 初始化n个城市
        int n = charge.length;
        // 初始化n个城市的图
        ArrayList<ArrayList<int[]>> graph = new ArrayList<>();
        for (int i = 0; i < n; i++) {
            graph.add(new ArrayList<>());
        }
        // 初始化无向图
        for (int[] path : paths) {
            graph.get(path[0]).add(new int[] { path[1], path[2] });
            graph.get(path[1]).add(new int[] { path[0], path[2] });
        }
        // (点,到达当前点的电量)
        int[][] distance = new int[n][cnt + 1];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j <= cnt; j++) {
                distance[i][j] = Integer.MAX_VALUE;
            }
        }
        // 初始化起点(起始点,0电量)
        distance[start][0] = 0;
        // 每个点是否访问(从堆里弹出过)
        boolean[][] visited = new boolean[n][cnt + 1];
        // 0:当前点
        // 1:来到当前点的电量
        // 2:来到当前点花费的时间
        PriorityQueue<int[]> heap = new PriorityQueue<>((a, b) -> a[2] - b[2]);
        // 起始点入队
        heap.add(new int[] { start, 0, 0 });
        while (!heap.isEmpty()) {
            // 弹出花费时间最少的堆顶
            int[] record = heap.poll();
            int cur = record[0];
            int power = record[1];
            int cost = record[2];
            if (visited[cur][power]) {
                continue;
            }
            if (cur == end) {
                return cost;
            }
            // 当前点已出堆
            visited[cur][power] = true;
            // 如果电还可以充,充一格电
            if (power < cnt) {
                // 如果当前点,电量+1后,到达(当前点,电量)的时间+充一格电的时间小于到达(当前点,电量+1)花费的时间
                if (!visited[cur][power + 1] && cost + charge[cur] < distance[cur][power + 1]) {
                    // 更新到达(当前点,电量+1)的时间
                    distance[cur][power + 1] = cost + charge[cur];
                    // 入堆
                    heap.add(new int[] { cur, power + 1, cost + charge[cur] });
                }
            }
            for (int[] edge : graph.get(cur)) {
                // 不充电去别的城市
                // 下一个城市
                int nextCity = edge[0];
                // 到达下一个城市剩余电量
                int restPower = power - edge[1];
                // 到达下一个城市花费的总时间
                int nextCost = cost + edge[1];
                // 如果能够到达(电量不为0)且未访问且由当前城市到达下一个城市花费的总时间小于到达(下一个城市,到达下一个城市的电量)
                if (restPower >= 0 && !visited[nextCity][restPower] && nextCost < distance[nextCity][restPower]) {
                    // 更新
                    distance[nextCity][restPower] = nextCost;
                    // 入堆
                    heap.add(new int[] { nextCity, restPower, nextCost });
                }
            }
        }
        return -1;
    }
}
```



## [洛谷【普及+/提高】P4568 \[JLOI2011\] 飞行路线](https://www.luogu.com.cn/problem/P4568)



```java
import java.io.*;
import java.util.*;

public class Solution {
    // 有n个城市,编号0~n-1
    // m种航线,每个航线连接两个城市(无向边),并有价格
    // 最多可以在k次航线中免单
    // 从起始城市到终点城市
    // 返回最少花费

    public static int MAXN = 10001;
    public static int MAXM = 100001;
    public static int MAXK = 11;

    // 链式前向星
    public static int[] head = new int[MAXN];
    public static int[] next = new int[MAXM];
    public static int[] to = new int[MAXM];
    public static int[] weight = new int[MAXM];
    public static int cnt;

    // Dijkstra
    // distance[i][j] : 到达城市i,使用了j次免单的最小花费
    public static int[][] distance = new int[MAXN][MAXK];
    // visited[i][j] : 到达城市i,使用了j次免单的状态是否被访问过
    public static boolean[][] visited = new boolean[MAXN][MAXK];

    // 0 : 到达的城市编号
    // 1 : 已经使用的免单次数
    // 2 : 到达该城市的沿途花费
    public static PriorityQueue<int[]> heap = new PriorityQueue<>((a, b) -> a[2] - b[2]);

    public static int n, m, k, s, t;

    // 初始化Dijkstra
    public static void build() {
        cnt = 1;
        for (int i = 0; i < n; i++) {
            head[i] = 0;
            for (int j = 0; j <= k; j++) {
                distance[i][j] = Integer.MAX_VALUE;
                visited[i][j] = false;
            }
        }
        heap.clear();
    }

    // 添加一条航线
    public static void addEdge(int u, int v, int w) {
        next[cnt] = head[u];
        to[cnt] = v;
        weight[cnt] = w;
        head[u] = cnt++;
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            m = (int) in.nval;
            in.nextToken();
            k = (int) in.nval;
            in.nextToken();
            s = (int) in.nval;
            in.nextToken();
            t = (int) in.nval;
            build();
            for (int i = 0, a, b, c; i < m; i++) {
                in.nextToken();
                a = (int) in.nval;
                in.nextToken();
                b = (int) in.nval;
                in.nextToken();
                c = (int) in.nval;
                addEdge(a, b, c);
                addEdge(b, a, c);
            }
            out.println(Dijkstra());
        }
        out.flush();
        out.close();
    }

    public static int Dijkstra() {
        // 初始化图
        distance[s][0] = 0;
        // 从起始城市开始,使用0次免单,花费为0,入堆
        heap.add(new int[] { s, 0, 0 });
        while (!heap.isEmpty()) {
            // 弹出当前花费最小的航线
            int[] recoed = heap.poll();
            // 当前到达城市编号
            int u = recoed[0];
            // 当前使用的免单次数
            int used = recoed[1];
            // 当前到达该城市的花费
            int cost = recoed[2];
            if (visited[u][used]) {
                continue;
            }
            if (u == t) {
                return cost;
            }
            visited[u][used] = true;
            // 遍历当前城市所有的航线
            for (int ei = head[u], v, w; ei > 0; ei = next[ei]) {
                v = to[ei];
                w = weight[ei];
                // 如果当前免单次数尚未用完,到达(当前城市,当前免单次数+1)的花费>(当前城市,当前免单次数)的花费
                if (used < k && distance[v][used + 1] > distance[u][used]) {
                    // 更新到达(当前城市,当前免单次数+1)的花费
                    distance[v][used + 1] = distance[u][used];
                    heap.add(new int[] { v, used + 1, distance[v][used + 1] });
                }
                // (当前城市的下一城市,当前免单次数)的花费>(当前城市,当前免单次数)+路途价格
                if (distance[v][used] > distance[u][used] + w) {
                    // 更新到达(当前城市的下一城市,当前免单次数)的花费
                    distance[v][used] = distance[u][used] + w;
                    heap.add(new int[] { v, used, distance[v][used] });
                }
            }
        }
        return -1;
    }
}
```



```java
import java.io.*;

public class Solution {
    // 有n个城市,编号0~n-1
    // m种航线,每个航线连接两个城市(无向边),并有价格
    // 最多可以在k次航线中免单
    // 从起始城市到终点城市
    // 返回最少花费

    public static int MAXN = 10001;
    public static int MAXM = 100001;
    public static int MAXK = 11;

    // 链式前向星
    public static int[] head = new int[MAXN];
    public static int[] next = new int[MAXM];
    public static int[] to = new int[MAXM];
    public static int[] weight = new int[MAXM];
    public static int cnt;

    // Dijkstra
    // distance[i][j] : 到达城市i,使用了j次免单的最小花费
    public static int[][] distance = new int[MAXN][MAXK];
    // visited[i][j] : 到达城市i,使用了j次免单的状态是否被访问过
    public static boolean[][] visited = new boolean[MAXN][MAXK];

    // 0 : 到达的城市编号
    // 1 : 已经使用的免单次数
    // 2 : 到达该城市的沿途花费
    public static int[][] heap = new int[MAXN * MAXK][3];

    public static int heapSize;

    public static int n, m, k, s, t;

    // 初始化Dijkstra
    public static void build() {
        cnt = 1;
        for (int i = 0; i < n; i++) {
            head[i] = 0;
            for (int j = 0; j <= k; j++) {
                distance[i][j] = Integer.MAX_VALUE;
                visited[i][j] = false;
            }
        }
    }

    // 添加一条航线
    public static void addEdge(int u, int v, int w) {
        next[cnt] = head[u];
        to[cnt] = v;
        weight[cnt] = w;
        head[u] = cnt++;
    }

    public static void push(int u, int t, int c) {
        heap[heapSize][0] = u;
        heap[heapSize][1] = t;
        heap[heapSize][2] = c;
        int i = heapSize++;
        while (heap[i][2] < heap[(i - 1) / 2][2]) {
            swap(i, (i - 1) / 2);
            i = (i - 1) / 2;
        }
    }

    public static int u, used, cost;

    public static void pop() {
        u = heap[0][0];
        used = heap[0][1];
        cost = heap[0][2];
        swap(0, --heapSize);
        heapify(0);
    }

    public static void heapify(int i) {
        int l = i * 2 + 1;
        while (l < heapSize) {
            int best = l + 1 < heapSize && heap[l + 1][2] < heap[l][2] ? l + 1 : l;
            best = heap[best][2] < heap[i][2] ? best : i;
            if (best == i) {
                break;
            }
            swap(best, i);
            i = best;
            l = i * 2 + 1;
        }
    }

    public static void swap(int i, int j) {
        int[] tmp = heap[i];
        heap[i] = heap[j];
        heap[j] = tmp;
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            m = (int) in.nval;
            in.nextToken();
            k = (int) in.nval;
            in.nextToken();
            s = (int) in.nval;
            in.nextToken();
            t = (int) in.nval;
            build();
            for (int i = 0, a, b, c; i < m; i++) {
                in.nextToken();
                a = (int) in.nval;
                in.nextToken();
                b = (int) in.nval;
                in.nextToken();
                c = (int) in.nval;
                addEdge(a, b, c);
                addEdge(b, a, c);
            }
            out.println(Dijkstra());
        }
        out.flush();
        out.close();
    }

    public static int Dijkstra() {
        // 初始化图
        distance[s][0] = 0;
        // 从起始城市开始,使用0次免单,花费为0,入堆
        push(s, 0, 0);
        while (heapSize > 0) {
            // 弹出当前花费最小的航线
            pop();
            if (visited[u][used]) {
                continue;
            }
            if (u == t) {
                return cost;
            }
            visited[u][used] = true;
            // 遍历当前城市所有的航线
            for (int ei = head[u], v, w; ei > 0; ei = next[ei]) {
                v = to[ei];
                w = weight[ei];
                // 如果当前免单次数尚未用完,到达(当前城市,当前免单次数+1)的花费>(当前城市,当前免单次数)的花费
                if (used < k && distance[v][used + 1] > distance[u][used]) {
                    // 更新到达(当前城市,当前免单次数+1)的花费
                    distance[v][used + 1] = distance[u][used];
                    push(v, used + 1, distance[v][used + 1]);
                }
                // (当前城市的下一城市,当前免单次数)的花费>(当前城市,当前免单次数)+路途价格
                if (distance[v][used] > distance[u][used] + w) {
                    // 更新到达(当前城市的下一城市,当前免单次数)的花费
                    distance[v][used] = distance[u][used] + w;
                    push(v, used, distance[v][used]);
                }
            }
        }
        return -1;
    }
}
```



***



# ✅065【必备】A 星、Floyd、Bellman-Ford、SPFA



```java
// A*
// 最小边选择（入小根堆排序元素）
// 当前节点到源点的距离+当前节点到终点的预估距离
// 当前节点到终点的预估距离<=当前节点到终点的真实最短距离
// 预估函数
// - 曼哈顿距离
// - 欧氏距离（勾股定理）
// - 对角线距离
// 和Dijkstra一致：源点到目标点的最短距离

import java.util.*;

public class Solution {
    // 给定一二维矩阵grid
    // grid[x][y]=0代表障碍
    // grid[x][y]=1代表道路
    // 返回从(sX,sY)到(eX,eY)的最短距离

    // 上、右、下、左
    public static int[] move = new int[] { -1, 0, 1, 0, -1 };

    // Dijkstra
    public static int minDistance1(int[][] grid, int sX, int sY, int eX, int eY) {
        // 首先要保证起点和终点不是障碍
        if (grid[sX][sY] == 0 || grid[eX][eY] == 0) {
            return -1;
        }
        int n = grid.length;
        int m = grid[0].length;
        // 初始化源点到当前点的距离矩阵
        int[][] distance = new int[n][m];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                distance[i][j] = Integer.MAX_VALUE;
            }
        }
        // 初始化起始点到起始点的距离为1
        distance[sX][sY] = 1;
        // 初始化访问数组，用于记录是否访问过当前点
        boolean[][] visited = new boolean[n][m];
        // 小根堆
        // 0：当前点的横坐标
        // 1：当前点的纵坐标
        // 2：当前点到起始点的距离
        PriorityQueue<int[]> heap = new PriorityQueue<>((a, b) -> a[2] - b[2]);
        // 起始点入堆
        heap.add(new int[] { sX, sY, 1 });
        while (!heap.isEmpty()) {
            // 弹出当前距离起始点最近的点
            int[] cur = heap.poll();
            int x = cur[0];
            int y = cur[1];
            if (visited[x][y]) {
                continue;
            }
            visited[x][y] = true;
            if (x == eX && y == eY) {
                return distance[x][y];
            }
            // 遍历当前点的上下左右四个方向
            for (int i = 0, nx, ny; i < 4; i++) {
                nx = x + move[i];
                ny = y + move[i + 1];
                if (nx >= 0 &&
                        nx < n &&
                        ny >= 0 &&
                        ny < m &&
                        grid[nx][ny] == 1 &&
                        !visited[nx][ny] &&
                        distance[x][y] + 1 < distance[nx][ny]) {
                    distance[nx][ny] = distance[x][y] + 1;
                    heap.add(new int[] { nx, ny, distance[x][y] + 1 });
                }
            }
        }
        return -1;
    }

    // A*算法
    // 在Dijkstra算法的基础上，加上启发函数
    // 当前点到源点的距离+当前点到目标点的目测距离（曼哈顿函数）
    public static int minDistance2(int[][] grid, int sX, int sY, int eX, int eY) {
        if (grid[sX][sY] == 0 || grid[eX][eY] == 0) {
            return -1;
        }
        int n = grid.length;
        int m = grid[0].length;
        int[][] distance = new int[n][m];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                distance[i][j] = Integer.MAX_VALUE;
            }
        }
        distance[sX][sY] = 1;
        boolean[][] visited = new boolean[n][m];
        // 小根堆
        // 0：当前点的横坐标
        // 1：当前点的纵坐标
        // 2：当前点到起始点的距离+当前点到目标点的目测距离（曼哈顿函数）
        PriorityQueue<int[]> heap = new PriorityQueue<>((a, b) -> a[2] - b[2]);
        heap.add(new int[] { sX, sY, 1 + d1(sX, sY, eX, eY) });
        while (!heap.isEmpty()) {
            int[] cur = heap.poll();
            int x = cur[0];
            int y = cur[1];
            if (x == eX && y == eY) {
                return distance[x][y];
            }
            if (visited[x][y]) {
                continue;
            }
            visited[x][y] = true;
            for (int i = 0, nx, ny; i < 4; i++) {
                nx = x + move[i];
                ny = y + move[i + 1];
                if (nx >= 0 &&
                        nx < n &&
                        ny >= 0 &&
                        ny < m &&
                        grid[nx][ny] == 1 &&
                        !visited[nx][ny] &&
                        distance[x][y] + 1 < distance[nx][ny]) {
                    distance[nx][ny] = distance[x][y] + 1;
                    // 入堆元素：当前点的横坐标、当前点的纵坐标、当前点到起始点的距离+当前点到目标点的目测距离（曼哈顿函数）
                    heap.add(new int[] { nx, ny, distance[x][y] + 1 + d1(nx, ny, eX, eY) });
                }
            }
        }
        return -1;
    }

    // 曼哈顿距离
    public static int d1(int x, int y, int i, int j) {
        return (Math.abs(x - i)) + (Math.abs(y - j));
    }

    // 对角线距离
    public static int d2(int x, int y, int i, int j) {
        return Math.max(Math.abs(x - i), Math.abs(y - j));
    }

    // 欧氏距离
    public static double d3(int x, int y, int i, int j) {
        return Math.sqrt(Math.pow(x - i, 2) + Math.pow(y - j, 2));
    }

    // 随机生成二维矩阵
    public static int[][] randomGrid(int n) {
        int[][] grid = new int[n][n];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                if (Math.random() < 0.3) {
                    grid[i][j] = 0;
                } else {
                    grid[i][j] = 1;
                }
            }
        }
        return grid;
    }

    public static void main(String[] args) {
        int Size = 5000;
        int testTime = 10;
        System.out.println("Dijkstra和A*");
        for (int i = 0; i < testTime; i++) {
            int n = (int) (Math.random() * Size) + 1;
            int[][] grid = randomGrid(n);
            int sX = (int) (Math.random() * n);
            int sY = (int) (Math.random() * n);
            int eX = (int) (Math.random() * n);
            int eY = (int) (Math.random() * n);
            System.out.println("Size:" + n + " sX:" + sX + " sY:" + sY + " eX:" + eX + " eY:" + eY);
            long s1 = System.currentTimeMillis();
            int ans1 = minDistance1(grid, sX, sY, eX, eY);
            long e1 = System.currentTimeMillis();
            System.out.println("运行时间（毫秒）：" + (e1 - s1));
            long s2 = System.currentTimeMillis();
            int ans2 = minDistance2(grid, sX, sY, eX, eY);
            long e2 = System.currentTimeMillis();
            System.out.println("运行时间（毫秒）：" + (e2 - s2));
            if (ans1 == ans2) {
                System.out.println(i + "次测试正确");
            } else {
                System.out.println("出错了!!!");
            }
            System.out.println(i + "次测试结束========");
        }
    }
}
```



## [洛谷【普及/提高-】P2910 \[USACO08OPEN\] Clear And Present Danger S](https://www.luogu.com.cn/problem/P2910)



```java
// Floyd
// 获得图中任意两点之间的最短距离
// 适用于：任何图、无论有向无向、不管边权正负，不能出现负环（保证存在最短路径）

import java.io.*;

public class Solution {
    // 给定n个节点，m条点
    // 给定一条路径，路径上的点为path[1...m]
    // 给给n*n的二维矩阵distance
    // distance[i][j]表示i到j的最短距离
    // 返回完成该路径的最短需要距离

    public static int MAXN = 101;

    public static int MAXM = 10001;

    public static int[] path = new int[MAXM];

    public static int[][] distance = new int[MAXN][MAXM];

    public static int n, m, ans;

    public static void build() {
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                distance[i][j] = Integer.MAX_VALUE;
            }
        }
    }

    // 枚举所有跳板，更新所有点之间的最短距离
    public static void Floyd() {
        // 枚举所有跳板
        for (int bridge = 0; bridge < n; bridge++) {
            // 枚举所有起点
            for (int start = 0; start < n; start++) {
                // 枚举所有终点
                for (int end = 0; end < n; end++) {
                    // 起点->跳板->终点
                    // (起点,跳板) + (跳板,终点) < (起点,终点)
                    // 更新(起点,终点)的最短距离
                    if (distance[start][bridge] != Integer.MAX_VALUE &&
                            distance[bridge][end] != Integer.MAX_VALUE &&
                            distance[start][end] > distance[start][bridge] + distance[bridge][end]) {
                        distance[start][end] = distance[start][bridge] + distance[bridge][end];
                    }
                }
            }
        }
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            m = (int) in.nval;
            for (int i = 0; i < m; i++) {
                in.nextToken();
                path[i] = (int) in.nval - 1;
            }
            build();
            for (int i = 0; i < n; i++) {
                for (int j = 0; j < n; j++) {
                    in.nextToken();
                    distance[i][j] = (int) in.nval;
                }
            }
            Floyd();
            ans = 0;
            for (int i = 1; i < m; i++) {
                ans += distance[path[i - 1]][path[i]];
            }
            out.println(ans);
        }
        out.flush();
        out.close();
    }
}
```



## [Leetcode【中】787.K 站中转最便宜的航班](https://leetcode.cn/problems/cheapest-flights-within-k-stops/description/)



```java
// Bellman-Ford
// 单源最短路径
// 解决了有负权边但没有负环的图

// 松弛
// 假设源点为A，A到任意点F最短距离为distance[F]
// 现从P出发，去往S，边权W
// 若distance[P]+W<distance[S]
// 则更新distance[S]=distance[P]+W
// 那么，从P出发的这条边就对S进行了松弛操作

// 存在最短路
// 假设存在最短路，那么1次松弛操作会使1个点的最短路的边数+1
// 而从源点出发到任何点的最短路最多走过n个点，最多n-1条边，那么松弛轮数必然<=n-1
// 而如果存在一个负环，则会无限进行松弛操作：第n轮

import java.util.*;

public class Solution {
    // n个城市通过一些航班连接
    // 数组flights[i]=[fromi,toi,pricei]表示从城市fromi到toi的价格为pricei
    // 返回一条最多经过k次中转的最便宜航线的价格

    public static int findCheapestPrice(int n, int[][] flights, int s, int e, int k) {
        // 从起始点s到每个点的最短距离
        // 本轮中转中起始点到达每个点的最短距离
        int[] cur = new int[n];
        // 初始化为无穷
        Arrays.fill(cur, Integer.MAX_VALUE);
        // 从起始点s到s的距离为0
        cur[s] = 0;
        // k次中转
        for (int i = 0; i <= k; i++) {
            // 从cur复制到next
            // 下一轮中转中起始点到达每个点的最短距离
            int[] next = Arrays.copyOf(cur, n);
            // 遍历所有航班
            for (int[] edge : flights) {
                // 如果从起始点可以到达edge[0]（上一轮中转中）
                // 而edge[0]是本次航班的起点
                if (cur[edge[0]] != Integer.MAX_VALUE) {
                    // edge[1]是本次航班的终点
                    // 那么本轮中转中起始点到达edge[1]的距离为：
                    // 上一轮中转中起始点到达edge[0]的距离 + 本次航班的价格
                    // 与本轮中转中起始点到达edge[1]的距离
                    // 取小
                    next[edge[1]] = Math.min(next[edge[1]], cur[edge[0]] + edge[2]);
                }
            }
            // 原下一轮中转状态变为本轮中转状态
            cur = next;
        }
        return cur[e] == Integer.MAX_VALUE ? -1 : cur[e];
    }
}
```



## [洛谷【普及/提高-】P3385【模板】负环](https://www.luogu.com.cn/problem/P3385)



```java
// Bellman-Ford+SPFA优化
// 解决有负边（无负环）的图单源最短路径
// 每一轮进行松弛操作时，那些上一轮被松弛过的节点才可能会继续引起松弛操作
// 原因：只有当前节点的最短距离更新了，它才有可能影响后续其他节点的最短距离
// 因此可以维护一个SPFA队列，存储这一轮都哪些节点被松弛过（distance变小了）
// 不过只优化了常数时间

import java.io.*;
import java.util.*;

public class Solution {
    // 给定n个节点的有向图
    // 负环：边权之和为负的回路
    // 判断图中是否有从1出发的负环

    public static int MAXN = 2001;

    public static int MAXM = 6001;

    // 链式前向星
    public static int[] head = new int[MAXN];
    public static int[] next = new int[MAXM];
    public static int[] to = new int[MAXM];
    public static int[] weight = new int[MAXM];
    public static int cnt;

    // SPFA队列
    public static int MAXQ = 4000001;

    // 从源点出发到每个节点的距离
    public static int[] distance = new int[MAXN];

    // 每个节点被松弛的次数
    public static int[] updateCnt = new int[MAXN];
    // SPFA队列
    public static int[] queue = new int[MAXQ];
    // 双指针
    public static int l, r;
    // 记录所有节点中在队列的
    public static boolean[] enter = new boolean[MAXN];

    public static void build(int n) {
        cnt = 1;
        l = r = 0;
        Arrays.fill(head, 1, n + 1, 0);
        Arrays.fill(enter, 1, n + 1, false);
        Arrays.fill(distance, 1, n + 1, Integer.MAX_VALUE);
        Arrays.fill(updateCnt, 1, n + 1, 0);
    }

    public static void addEdge(int u, int v, int w) {
        next[cnt] = head[u];
        to[cnt] = v;
        weight[cnt] = w;
        head[u] = cnt++;
    }

    public static boolean SPFA(int n) {
        distance[1] = 0;
        updateCnt[1]++;
        queue[r++] = 1;
        enter[1] = true;
        while (l < r) {
            int u = queue[l++];
            enter[u] = false;
            for (int ei = head[u], v, w; ei > 0; ei = next[ei]) {
                v = to[ei];
                w = weight[ei];
                if (distance[u] + w < distance[v]) {
                    distance[v] = distance[u] + w;
                    if (!enter[v]) {
                        // 当一个节点的松弛次数超过n-1，说明图中存在负环
                        if (++updateCnt[v] > n - 1) {
                            return true;
                        }
                        queue[r++] = v;
                        enter[v] = true;
                    }
                }
            }
        }
        return false;
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        in.nextToken();
        int cases = (int) in.nval;
        for (int i = 0, n, m; i < cases; i++) {
            in.nextToken();
            n = (int) in.nval;
            in.nextToken();
            m = (int) in.nval;
            build(n);
            for (int j = 0, u, v, w; j < m; j++) {
                in.nextToken();
                u = (int) in.nval;
                in.nextToken();
                v = (int) in.nval;
                in.nextToken();
                w = (int) in.nval;
                if (w >= 0) {
                    addEdge(u, v, w);
                    addEdge(v, u, w);
                } else {
                    addEdge(u, v, w);
                }
            }
            out.println(SPFA(n) ? "YES" : "NO");
        }
        out.flush();
        out.close();
    }
}
```



***



# ✅066【必备】一维动态规划



任何动态规划问题都必然存在着**重复调用行为的递归**



## [Leetcode【易】509.斐波那契数](https://leetcode.cn/problems/fibonacci-number/description/)



```java
import java.util.*;

public class Solution {
    // 斐波那契数
    // F(0)=0,F(1)=1,F(n)=F(n-1)+F(n-2),n>=2
    // 返回F(n)

    // 常规暴力递归:O(2^n)（自顶向下）
    public static int fib1(int n) {
        return f1(n);
    }

    public static int f1(int i) {
        if (i == 0) {
            return 0;
        } else if (i == 1) {
            return 1;
        } else {
            return f1(i - 1) + f1(i - 2);
        }
    }

    // 记忆化搜索递归:O(n)（自顶向下）
    public static int fib2(int n) {
        // 定义一个数组存储n位以前的斐波那契数
        // 解决重复计算问题
        int[] dp = new int[n + 1];
        Arrays.fill(dp, -1);
        return f2(n, dp);
    }

    public static int f2(int i, int[] dp) {
        if (i == 0) {
            return 0;
        } else if (i == 1) {
            return 1;
        }
        // 如果dp[i]不为-1,说明之前已经计算过
        if (dp[i] != -1) {
            return dp[i];
        }
        // 运行到这一步说明dp[i]尚未计算,因此计算并存储到dp[i]中
        dp[i] = f2(i - 1, dp) + f2(i - 2, dp);
        return dp[i];
    }

    // 动态规划:O(n)（自底向上）
    // 使用dp记忆化数组
    public static int fib3(int n) {
        if (n == 0) {
            return 0;
        } else if (n == 1) {
            return 1;
        }
        int[] dp = new int[n + 1];
        dp[0] = 0;
        dp[1] = 1;
        for (int i = 2; i <= n; i++) {
            dp[i] = dp[i - 1] + dp[i - 2];
        }
        return dp[n];
    }

    // 动态规划:O(n)（自底向上）
    // 使用三个变量滚动优化空间复杂度
    public static int fib4(int n) {
        if (n == 0) {
            return 0;
        } else if (n == 1) {
            return 1;
        }
        int pre = 0, cur = 1, next = 0;
        for (int i = 2; i <= n; i++) {
            next = pre + cur;
            pre = cur;
            cur = next;
        }
        return cur;
    }
}
```



## [Leetcode【中】983.最低票价](https://leetcode.cn/problems/minimum-cost-for-tickets/description/)



```java
import java.util.Arrays;

public class Solution {
    // 给定一个数组days，表示第几天出来
    // 给定一个costs数组
    // - 为期1 天的出行售价costs[1]
    // - 为期7 天的出行售价costs[2]
    // - 为期30天的出行售价costs[3]
    // 返回days数组中的每一天都在出行的最小花费

    public static int[] durations = { 1, 7, 30 };

    // 暴力递归（自顶到底）从左往右
    public static int mincostTickets1(int[] days, int[] costs) {
        return f1(days, costs, 0);
    }

    // 从days[i]位置开始，到最后一天，最少花费
    public static int f1(int[] days, int[] costs, int i) {
        // 此时days[i]已经越界，后续无旅行
        if (i == days.length) {
            return 0;
        }
        int ans = Integer.MAX_VALUE;
        // days[i]开始往后的出行
        // 遍历3中选择，分别是1天、7天、30天的出行
        for (int k = 0, j = i; k < 3; k++) {
            // 如果当前days[i]天+选择的方案的天数>days[j]天
            // 那么我们就找了days[i]天+选择的方案的天数覆盖了数组中的片段的右侧
            while (j < days.length && days[i] + durations[k] > days[j]) {
                j++;
            }
            // 计算刚从得到的右侧j开始，到最后一天的最少花费
            // 加上当前选择的方案的成本
            // 与之前的ans比较，取较小值
            // 也就是选择了当前遍历的3个选择中消费最少的那个
            ans = Math.min(ans, costs[k] + f1(days, costs, j));
        }
        return ans;
    }

    // 记忆化搜索（自顶到底）从左往右
    public static int mincostTickets2(int[] days, int[] costs) {
        int[] dp = new int[days.length];
        Arrays.fill(dp, Integer.MAX_VALUE);
        return f2(days, costs, 0, dp);
    }

    public static int f2(int[] days, int[] costs, int i, int[] dp) {
        if (i == days.length) {
            return 0;
        }
        if (dp[i] != Integer.MAX_VALUE) {
            return dp[i];
        }
        int ans = Integer.MAX_VALUE;
        for (int k = 0, j = i; k < 3; k++) {
            while (j < days.length && days[i] + durations[k] > days[j]) {
                j++;
            }
            ans = Math.min(ans, costs[k] + f2(days, costs, j, dp));
        }
        dp[i] = ans;
        return ans;
    }

    // 动态规划（自底到顶）从右往左
    public static int MAXN = 366;
    public static int[] dp = new int[MAXN];

    public static int mincostTickets3(int[] days, int[] costs) {
        int n = days.length;
        Arrays.fill(dp, Integer.MAX_VALUE);
        dp[n] = 0;
        for (int i = n - 1; i >= 0; i--) {
            for (int k = 0, j = i; k < 3; k++) {
                while (j < days.length && days[i] + durations[k] > days[j]) {
                    j++;
                }
                dp[i] = Math.min(dp[i], costs[k] + dp[j]);
            }
        }
        return dp[0];
    }
}
```



## [Leetcode【中】91.解码方法](https://leetcode.cn/problems/decode-ways/description/)



```java
import java.util.Arrays;

public class Solution {
    // 一解码方案如下：
    // - 'A' -> 1
    // - 'B' -> 2
    // - ...
    // - 'Z' -> 26
    // 给定一个只包含数字的非空字符串s
    // 返回s有多少种解码方案

    // 暴力递归
    public static int numDecodings1(String s) {
        return f1(s.toCharArray(), 0);
    }

    // 从s[i]位置开始往后，有多少种解码方案
    // 三种方案
    // - 0开头，不能转
    // - 转1个字符（一定可以转）
    // - 转2个字符（可能可以转）
    public static int f1(char[] s, int i) {
        if (i == s.length) {
            return 1;
        }
        int ans = 0;
        if (s[i] == '0') {
            ans = 0;
        } else {
            ans = f1(s, i + 1);
            if (i + 1 < s.length && ((s[i] - '0') * 10 + s[i + 1] - '0') <= 26) {
                ans += f1(s, i + 2);
            }
        }
        return ans;
    }

    // 记忆化搜索
    public static int numDecodings2(String s) {
        int[] dp = new int[s.length()];
        Arrays.fill(dp, -1);
        return f2(s.toCharArray(), 0, dp);
    }

    public static int f2(char[] s, int i, int[] dp) {
        if (i == s.length) {
            return 1;
        }
        if (dp[i] != -1) {
            return dp[i];
        }
        int ans;
        if (s[i] == '0') {
            ans = 0;
        } else {
            ans = f2(s, i + 1, dp);
            if (i + 1 < s.length && ((s[i] - '0') * 10 + s[i + 1] - '0') <= 26) {
                ans += f2(s, i + 2, dp);
            }
        }
        dp[i] = ans;
        return ans;
    }

    // 严格位置依赖的动态规划（从后往前）
    // dp[i]依赖dp[i+1]和dp[i+2]
    // - 如果s[i]不是0，那么dp[i]至少有dp[i+1]种方案
    // - 如果s[i+1]s[i+2]可以一起转，dp[i]还要再加上dp[i+2]
    // - 如果s[i]是0，那么dp[i]只能为0
    public static int numDecodings3(String str) {
        char[] s = str.toCharArray();
        int n = s.length;
        int[] dp = new int[n + 1];
        dp[n] = 1;
        for (int i = n - 1; i >= 0; i--) {
            if (s[i] == '0') {
                dp[i] = 0;
            } else {
                dp[i] = dp[i + 1];
                if (i + 1 < s.length && ((s[i] - '0') * 10 + s[i + 1] - '0') <= 26) {
                    dp[i] += dp[i + 2];
                }
            }
        }
        return dp[0];
    }

    // 空间压缩，变量滚动（从后往前）
    public static int numDecodings4(String s) {
        // dp[0...n-1]
        // dp[i+1]
        // dp[n]
        int n = 1;
        // dp[i+2]
        // dp[n+1]
        int nn = 0;
        for (int i = s.length() - 1, cur; i >= 0; i--) {
            if (s.charAt(i) == '0') {
                cur = 0;
            } else {
                cur = n;
                if (i + 1 < s.length() && ((s.charAt(i) - '0') * 10 + s.charAt(i + 1) - '0') <= 26) {
                    cur += nn;
                }
            }
            nn = n;
            n = cur;
        }
        return n;
    }
}
```



## [Leetcode【难】639.解码方法 II](https://leetcode.cn/problems/decode-ways-ii/description/)



```java
import java.util.Arrays;

public class Solution {
    // 给定一解码规则
    // - 26个大写字母：'A'->"1"、'B'->"2"、...、'Z'->"26"
    // - "*"：可以表示从 '1' 到 '9' 的任一数字（不包括 '0'）
    // 给定1个字符串，由数字和字符'*'组成
    // 返回解码的所有方案总数（对1000000007取模）

    public static long MOD = 1000000007;

    // 暴力递归
    public static int numDecodings1(String str) {
        return f1(str.toCharArray(), 0);
    }

    // s[i....] 有多少种有效转化
    public static int f1(char[] s, int i) {
        // base case到头了，返回1
        if (i == s.length) {
            return 1;
        }
        // 如果只转i位置，且i位置为0，返回0
        if (s[i] == '0') {
            return 0;
        }
        // 如果只转i位置
        // - i位置为*，有9种方案
        // - i位置为1-9，有1种方案
        int ans = f1(s, i + 1) * (s[i] == '*' ? 9 : 1);
        // 如果转i和i+1两个位置
        if (i + 1 < s.length) {
            // 如果i位置不是*
            if (s[i] != '*') {
                // i+1也不是*，且组成的数字<=26，有1种方案
                if (s[i + 1] != '*') {
                    if ((s[i] - '0') * 10 + s[i + 1] - '0' <= 26) {
                        ans += f1(s, i + 2);
                    }
                }
                // i+1位置是*
                // - i位置为1，有9种方案
                // - i位置为2，有6种方案
                else {
                    if (s[i] == '1') {
                        ans += f1(s, i + 2) * 9;
                    }
                    if (s[i] == '2') {
                        ans += f1(s, i + 2) * 6;
                    }
                }
            }
            // 如果i位置是*
            else {
                // i+1位置不是*
                // - i+1位置为1-6，有2种方案
                // - i+1位置为7-9，有1种方案
                if (s[i + 1] != '*') {
                    if (s[i + 1] <= '6') {
                        ans += f1(s, i + 2) * 2;
                    } else {
                        ans += f1(s, i + 2);
                    }
                }
                // i+1位置是*
                // - i位置为1，有9种方案
                // - i位置为2，有6种方案
                // 一共15种方案
                else {
                    ans += f1(s, i + 2) * 15;
                }
            }
        }
        return (int) (ans % MOD);
    }

    // 记忆化搜索
    public static int numDecodings2(String str) {
        char[] s = str.toCharArray();
        long[] dp = new long[s.length + 1];
        Arrays.fill(dp, -1);
        return (int) f2(s, 0, dp);
    }

    public static long f2(char[] s, int i, long[] dp) {
        if (i == s.length) {
            return 1;
        }
        if (s[i] == '0') {
            return 0;
        }
        if (dp[i] != -1) {
            return dp[i];
        }
        long ans = f2(s, i + 1, dp) * (s[i] == '*' ? 9 : 1);
        if (i + 1 < s.length) {
            if (s[i] != '*') {
                if (s[i + 1] != '*') {
                    if ((s[i] - '0') * 10 + s[i + 1] - '0' <= 26) {
                        ans += f2(s, i + 2, dp);
                    }
                } else {
                    if (s[i] == '1') {
                        ans += f2(s, i + 2, dp) * 9;
                    }
                    if (s[i] == '2') {
                        ans += f2(s, i + 2, dp) * 6;
                    }
                }
            } else {
                if (s[i + 1] != '*') {
                    if (s[i + 1] <= '6') {
                        ans += f2(s, i + 2, dp) * 2;
                    } else {
                        ans += f2(s, i + 2, dp);
                    }
                } else {
                    ans += f2(s, i + 2, dp) * 15;
                }
            }
        }
        dp[i] = ans % MOD;
        return dp[i];
    }

    public static int numDecodings3(String str) {
        char[] s = str.toCharArray();
        int n = s.length;
        long[] dp = new long[n + 1];
        dp[n] = 1;
        for (int i = n - 1; i >= 0; i--) {
            if (s[i] != '0') {
                dp[i] = dp[i + 1] * (s[i] == '*' ? 9 : 1);
                if (i + 1 < n) {
                    if (s[i] != '*') {
                        if (s[i + 1] != '*') {
                            if ((s[i] - '0') * 10 + s[i + 1] - '0' <= 26) {
                                dp[i] += dp[i + 2];
                            }
                        } else {
                            if (s[i] == '1') {
                                dp[i] += dp[i + 2] * 9;
                            }
                            if (s[i] == '2') {
                                dp[i] += dp[i + 2] * 6;
                            }
                        }
                    } else {
                        if (s[i + 1] != '*') {
                            if (s[i + 1] <= '6') {
                                dp[i] += dp[i + 2] * 2;
                            } else {
                                dp[i] += dp[i + 2];
                            }
                        } else {
                            dp[i] += dp[i + 2] * 15;
                        }
                    }
                }
                dp[i] %= MOD;
            }
        }
        return (int) dp[0];
    }

    public static int numDecodings4(String str) {
        char[] s = str.toCharArray();
        int m = s.length;
        long c = 0, n = 1, nn = 0;
        for (int i = m - 1; i >= 0; i--) {
            if (s[i] != '0') {
                c = (s[i] == '*' ? 9 : 1) * n;
                if (i + 1 < m) {
                    if (s[i] != '*') {
                        if (s[i + 1] != '*') {
                            if ((s[i] - '0') * 10 + s[i + 1] - '0' <= 26) {
                                c += nn;
                            }
                        } else {
                            if (s[i] == '1') {
                                c += nn * 9;
                            }
                            if (s[i] == '2') {
                                c += nn * 6;
                            }
                        }
                    } else {
                        if (s[i + 1] != '*') {
                            if (s[i + 1] <= '6') {
                                c += nn * 2;
                            } else {
                                c += nn;
                            }
                        } else {
                            c += nn * 15;
                        }
                    }
                }
                c %= MOD;
            }
            nn = n;
            n = c;
            c = 0;
        }
        return (int) n;
    }
}
```



## [Leetcode【中】264.丑数 II](https://leetcode.cn/problems/ugly-number-ii/description/)



```java
public class Solution {
    // 丑数：拆分的因子都是质数2、3或5的正整数
    // 第1个丑数默认为1
    // 返回第n个丑数

    // 所有的丑数都是由原始丑数1经过若干次*2、*3、*5得到的
    // 那么对于第k个丑数，一定是由之前的某个丑数*2、*3、*5得到的
    // 也可以理解为：
    // 三组丑数数组
    // - [2,4,6,8,...]
    // - [3,6,9,12,...]
    // - [5,10,15,20,...]
    // 混合升序排序

    public static int nthUglyNumber(int n) {
        // dp[i]表示第i个丑数
        int[] dp = new int[n + 1];
        // dp[1]表示第1个丑数，默认为1
        dp[1] = 1;
        // 第一个丑数：1
        // i2->1(2)、i3->1(3)、i5->1(5),最小的2：i2++
        // 第二个丑数：2
        // i2->2(4)、i3->1(3)、i5->1(5),最小的3：i3++
        // 第三个丑数：3
        // i2->2(4)、i3->2(6)、i5->1(5),最小的4：i2++
        // 第四个丑数：4
        // i2->3(6)、i3->2(6)、i5->1(5),最小的5：i5++
        // 第五个丑数：5
        // i2->3(6)、i3->2(6)、i5->2(10),最小的6：i2++,i3++
        // 第六个丑数：6
        // i2->4(8)、i3->3(9)、i5->2(10),最小的8：i2++
        // 第七个丑数：8
        // i2->5(10)、i3->3(9)、i5->2(10),最小的9：i3++
        // 第八个丑数：9
        // i2->5(10)、i3->4(12)、i5->2(10),最小的10：i2++,i5++
        // 第九个丑数：10
        // i2->6(12)、i3->4(12)、i5->3(15),最小的12：i3++
        for (int i = 2, i2 = 1, i3 = 1, i5 = 1, a, b, c, cur; i <= n; i++) {
            a = dp[i2] * 2;
            b = dp[i3] * 3;
            c = dp[i5] * 5;
            cur = Math.min(Math.min(a, b), c);
            if (cur == a) {
                i2++;
            }
            if (cur == b) {
                i3++;
            }
            if (cur == c) {
                i5++;
            }
            dp[i] = cur;
        }
        return dp[n];
    }
}
```



## [Leetcode【难】32.最长有效括号](https://leetcode.cn/problems/longest-valid-parentheses/description/)



```java
public class Solution {
    // 给定一个字符串，只由"("和")"组成
    // 那么一对左右括号按照左在前、右在后配对，则有效
    // 返回字符串中最长的连续的有效配对的子串长度

    public static int longestValidParentheses(String str) {
        char[] s = str.toCharArray();
        // dp[i]子串必须以i位置的字符结尾的前提下，往左整体有效的最大长度
        int[] dp = new int[s.length];
        int ans = 0;
        // dp[i]有两种情况
        // - s[i] ->'(' ,dp[i]=0
        // - s[i] ->')' ,由dp[i-1]长度往前跳到p=i-dp[i-1]-1（注意不要越左界）
        // - s[p]->')' ,dp[i]=0
        // - s[p]->'(' ,dp[i]=dp[i-1]+2+dp[p-1]
        for (int i = 1, p; i < s.length; i++) {
            if (s[i] == ')') {
                p = i - dp[i - 1] - 1;
                if (p >= 0 && s[p] == '(') {
                    dp[i] = dp[i - 1] + 2 + (p - 1 >= 0 ? dp[p - 1] : 0);
                }
            }
            ans = Math.max(ans, dp[i]);
        }
        return ans;
    }
}
```



## [Leetcode【中】467.环绕字符串中唯一的子字符串](https://leetcode.cn/problems/unique-substrings-in-wraparound-string/description/)



```java
public class Solution {
    // 给定一个初始字符串base="abcdefghijklmnopqrstuvwxyz"
    // 他会进行无限环绕
    // "..zabcdefghijklmnopqrstuvwxyzabcdefghijklmnopqrstuvwxyzabcd.."
    // 给定一字符串str
    // 返回str有多少种子串出现在了无线环绕的字符串中

    public static int findSubstringInWraproundString(String str) {
        int n = str.length();
        // 字符串转换为int类型数组，'a'->0,'b'->1,...,'z'->25
        int[] s = new int[n];
        for (int i = 0; i < n; i++) {
            s[i] = str.charAt(i) - 'a';
        }
        // dp[0]表示以'a'结尾的最长往左延伸字串长度，
        // dp[1]表示以'b'结尾的最长往左延伸字串长度，
        // ...
        // dp[25]表示以'z'结尾的最长往左延伸字串长度，
        int[] dp = new int[26];
        dp[s[0]] = 1;
        for (int i = 1, cur, pre, len = 1; i < n; i++) {
            cur = s[i];
            pre = s[i - 1];
            // 前一个字符是'z'并且当前字符是'a'
            // 或者前一个字符比当前字符的ascii码少1
            if ((pre == 25 && cur == 0) || pre + 1 == cur) {
                len++;
            } else {
                len = 1;
            }
            dp[cur] = Math.max(dp[cur], len);
        }
        int ans = 0;
        for (int i = 0; i < 26; i++) {
            ans += dp[i];
        }
        return ans;
    }
}
```



## [Leetcode【难】940.不同的子序列 II](https://leetcode.cn/problems/distinct-subsequences-ii/description/)



```java
public class Solution {
    // 给定一个字符串str
    // 按照字符串中字符的顺序，挑选字符组成子字符串（空集不算）
    // 返回子字符串种类的数量，结果对1000000007取模

    public static int distinctSubseqII(String str) {
        int MOD = 1000000007;
        char[] s = str.toCharArray();
        // cnt[x-'a']表示以字符x结尾的子字符串的种类数量
        int[] cnt = new int[26];
        // 初始化定义一个空集
        // 遍历的每个字符
        // 在上一轮的所有字符串的结尾新增一个字符x
        int all = 1, newAdd;
        for (char x : s) {
            // 纯新增的=all-当前字符上次的记录数量
            // 当前字符的记录=当前字符上次的记录数量+纯新增的
            // all=上一次的all+纯新增的
            newAdd = (all - cnt[x - 'a'] + MOD) % MOD;
            cnt[x - 'a'] = (cnt[x - 'a'] + newAdd) % MOD;
            all = (all + newAdd) % MOD;
        }
        return (all - 1 + MOD) % MOD;
    }
}
```



***



# ✅067【必备】二维动态规划



## [Leetcode【中】64.最小路径和](https://leetcode.cn/problems/minimum-path-sum/description/)



```java
public class Solution {
    // 给定一个m*n的二维网格
    // 每个位置值非负
    // 返回从左上角到右下角路径累加和的最小值

    // 暴力递归
    public static int minPathSum1(int[][] grid) {
        // 从目标点到左上角的路径累加和的最小值
        return f1(grid, grid.length - 1, grid[0].length - 1);
    }

    // 从(i,j)位置到左上角的路径累加和的最小值
    // 每次只能向上或向左移动一个
    // 那么当前位置+
    // - 向左移动后位置到左上角的路径累加和
    // - 向上移动后位置到左上角的路径累加和
    // 取其中较小的一个
    // 递归基：i=0,j=0时，直接返回grid[0][0]
    public static int f1(int[][] grid, int i, int j) {
        if (i == 0 && j == 0) {
            return grid[0][0];
        }
        int up = Integer.MAX_VALUE;
        int left = Integer.MAX_VALUE;
        if (i - 1 >= 0) {
            up = f1(grid, i - 1, j);
        }
        if (j - 1 >= 0) {
            left = f1(grid, i, j - 1);
        }
        return grid[i][j] + Math.min(up, left);
    }

    // 记忆化搜索
    public static int minPathSum2(int[][] grid) {
        int n = grid.length;
        int m = grid[0].length;
        int[][] dp = new int[n][m];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                dp[i][j] = -1;
            }
        }
        return f2(grid, grid.length - 1, grid[0].length - 1, dp);
    }

    public static int f2(int[][] grid, int i, int j, int[][] dp) {
        if (dp[i][j] != -1) {
            return dp[i][j];
        }
        int ans;
        if (i == 0 && j == 0) {
            ans = grid[0][0];
        } else {
            int up = Integer.MAX_VALUE;
            int left = Integer.MAX_VALUE;
            if (i - 1 >= 0) {
                up = f2(grid, i - 1, j, dp);
            }
            if (j - 1 >= 0) {
                left = f2(grid, i, j - 1, dp);
            }
            ans = grid[i][j] + Math.min(up, left);
        }
        dp[i][j] = ans;
        return ans;
    }

    // 严格位置依赖的动态规划（从前往后）
    public static int minPathSum3(int[][] grid) {
        int n = grid.length;
        int m = grid[0].length;
        int[][] dp = new int[n][m];
        dp[0][0] = grid[0][0];
        // 首行只能向右
        for (int j = 1; j < m; j++) {
            dp[0][j] = dp[0][j - 1] + grid[0][j];
        }
        // 首列只能向下
        for (int i = 1; i < n; i++) {
            dp[i][0] = dp[i - 1][0] + grid[i][0];
        }
        // 其他位置可以从上方或左方到达，选取较小的一个
        for (int i = 1; i < n; i++) {
            for (int j = 1; j < m; j++) {
                dp[i][j] = Math.min(dp[i - 1][j], dp[i][j - 1]) + grid[i][j];
            }
        }
        return dp[n - 1][m - 1];
    }

    // 严格位置依赖的动态规划+空间压缩
    // 对于二维网格
    // 我们首先初始化第一行的数据（一维数组）
    // 那么后续的每行数据处理时
    // 我们只需要更手动新当前一维数组的首个位置（其余位置还是上一行中对应位置到源点的最小值）
    // 那么当前行的第二个位置就是
    // - 当前行的首个位置
    // - 当前行的第二个位置的原始数据
    //   - 也就是上一行的第二个位置到源点的最小值
    // 的较小值
    // 当前行的第三个位置就是
    // - 当前行的第二个位置
    // - 当前行的第三个位置的原始数据
    //   - 也就是上一行的第三个位置到源点的最小值
    // 的较小值
    public static int minPathSum4(int[][] grid) {
        int n = grid.length;
        int m = grid[0].length;
        int[] dp = new int[m];
        dp[0] = grid[0][0];
        // 首行只能向右
        for (int i = 1; i < m; i++) {
            dp[i] = dp[i - 1] + grid[0][i];
        }
        // 更新
        for (int i = 1; i < n; i++) {
            dp[0] += grid[i][0];
            for (int j = 1; j < m; j++) {
                dp[j] = Math.min(dp[j - 1], dp[j]) + grid[i][j];
            }
        }
        return dp[m - 1];
    }
}
```



## [Leetcode【中】79.单词搜索](https://leetcode.cn/problems/word-search/description/)



```java
public class Solution {
    // 给定一个m*n的二维字符网格board和一个目标字符串word
    // 判断word是否存在于board中
    // - 单词必须按照字母顺序连接相邻的单元格
    // - 同一个单元格不能重复利用

    public static boolean exist(char[][] board, String word) {
        char[] w = word.toCharArray();
        for (int i = 0; i < board.length; i++) {
            for (int j = 0; j < board[0].length; j++) {
                if (f(board, i, j, w, 0)) {
                    return true;
                }
            }
        }
        return false;
    }

    // 在二维网格board的(i,j)位置处，是否匹配目标字符串w[k]
    public static boolean f(char[][] b, int i, int j, char[] w, int k) {
        // 如果我们已经来到了字符串的越界位置
        // 说明之前的字符都匹配成功了
        if (k == w.length) {
            return true;
        }
        // 如果我们来到了网格的越界位置或者当前位置的字符不匹配
        if (i < 0 || i == b.length || j < 0 || j == b[0].length || b[i][j] != w[k]) {
            return false;
        }
        // 不越界，并且当前的成功匹配：b[i][j] == w[k]
        char tmp = b[i][j];
        // 为了不重复利用当前位置的字符，将其标记为已访问
        b[i][j] = 0;
        // 继续递归匹配后续的字符
        boolean ans = f(b, i - 1, j, w, k + 1)
                || f(b, i + 1, j, w, k + 1)
                || f(b, i, j - 1, w, k + 1)
                || f(b, i, j + 1, w, k + 1);
        // 递归完成后，恢复当前位置的字符
                b[i][j] = tmp;
        return ans;
    }
}
```



## [Leetcode【中】1143.最长公共子序列](https://leetcode.cn/problems/longest-common-subsequence/description/)



```java
public class Solution {
    // 给定两个字符串s1和s2
    // 字符串的子序列不一定连续
    // 返回二者的最长公共子序列的长度

    public static int longestCommonSubsequence1(String str1, String str2) {
        char[] s1 = str1.toCharArray();
        char[] s2 = str2.toCharArray();
        int n = s1.length;
        int m = s2.length;
        return f1(s1, s2, n - 1, m - 1);
    }

    // 返回s1、s2分别以i1位置、i2位置为结尾的最长公共子序列的长度
    // - s1[0...i1]
    // - s2[0...i2]
    public static int f1(char[] s1, char[] s2, int i1, int i2) {
        // 这里需要处理i1或i2为-1的情况:
        // 当i1或i2为-1时，s1或s2的子序列为空字符串，返回0
        // 不方便进行动态规划填表
        if (i1 < 0 || i2 < 0) {
            return 0;
        }
        // 两个字符串当前的结尾是否同时为最长公共子序列的结尾
        int p1 = f1(s1, s2, i1 - 1, i2 - 1);
        int p2 = s1[i1] == s2[i2] ? (p1 + 1) : 0;
        // 两个字符串当前的结尾中，有一个不是最长公共子序列的结尾
        int p3 = f1(s1, s2, i1 - 1, i2);
        int p4 = f1(s1, s2, i1, i2 - 1);
        return Math.max(Math.max(p1, p2), Math.max(p3, p4));
    }

    public static int longestCommonSubsequence2(String str1, String str2) {
        char[] s1 = str1.toCharArray();
        char[] s2 = str2.toCharArray();

        int n = s1.length;
        int m = s2.length;
        return f2(s1, s2, n, m);
    }

    // 因此我们这里做出优化：
    // n表示s1前长度为n的子字符串
    // m表示s2前长度为m的子字符串
    public static int f2(char[] s1, char[] s2, int n, int m) {
        if (n == 0 || m == 0) {
            return 0;
        }
        int ans = 0;
        // 原四种情况的前两种合并：
        // 如果二者的结尾字符相同，那么直接在计算二者长度都减一的情况下的最长公共子序列长度，再加上1
        if (s1[n - 1] == s2[m - 1]) {
            ans = 1 + f2(s1, s2, n - 1, m - 1);
        } else {
            // 如果二者的结尾字符串不同，那么则比较二者各自减一的情况
            ans = Math.max(f2(s1, s2, n - 1, m), f2(s1, s2, n, m - 1));
        }
        return ans;
    }

    // 记忆化搜索
    public static int longestCommonSubsequence3(String str1, String str2) {
        char[] s1 = str1.toCharArray();
        char[] s2 = str2.toCharArray();
        int n = s1.length;
        int m = s2.length;
        int[][] dp = new int[n + 1][m + 1];
        for (int i = 0; i <= n; i++) {
            for (int j = 0; j <= m; j++) {
                dp[i][j] = -1;
            }
        }
        return f3(s1, s2, n, m, dp);
    }

    public static int f3(char[] s1, char[] s2, int n, int m, int[][] dp) {
        if (n == 0 || m == 0) {
            return 0;
        }
        if (dp[n][m] != -1) {
            return dp[n][m];
        }
        int ans;
        if (s1[n - 1] == s2[m - 1]) {
            ans = 1 + f3(s1, s2, n - 1, m - 1, dp);
        } else {
            ans = Math.max(f3(s1, s2, n - 1, m, dp), f3(s1, s2, n, m - 1, dp));
        }
        dp[n][m] = ans;
        return ans;
    }

    // 严格位置依赖的动态规划
    public static int longestCommonSubsequence4(String str1, String str2) {
        char[] s1 = str1.toCharArray();
        char[] s2 = str2.toCharArray();
        int n = s1.length;
        int m = s2.length;
        int[][] dp = new int[n + 1][m + 1];
        for (int l1 = 1; l1 <= n; l1++) {
            for (int l2 = 1; l2 <= m; l2++) {
                if (s1[l1 - 1] == s2[l2 - 1]) {
                    dp[l1][l2] = 1 + dp[l1 - 1][l2 - 1];
                } else {
                    dp[l1][l2] = Math.max(dp[l1 - 1][l2], dp[l1][l2 - 1]);
                }
            }
        }
        return dp[n][m];
    }

    // 严格位置依赖的动态规划+空间压缩
    public static int longestCommonSubsequence5(String str1, String str2) {
        char[] s1, s2;
        if (str1.length() >= str2.length()) {
            s1 = str1.toCharArray();
            s2 = str2.toCharArray();
        } else {
            s1 = str2.toCharArray();
            s2 = str1.toCharArray();
        }
        // 较长
        int n = s1.length;
        // 较短
        int m = s2.length;
        // 初始化的数组占地小：0行0列都为0
        int[] dp = new int[m + 1];
        for (int l1 = 1; l1 <= n; l1++) {
            // 这里设置两个变量记录是因为：
            // 我们只使用了一维数组，也就是每一行的状态
            // 但是现在呢：
            // a,b
            // c,d（实际为一行内容）
            // 初始时：lUp=a,rUp=b
            // 如果我们if成立，那么的位原b置会被1+a也就是d覆盖
            // 本轮判断结束后呢，我们需要更新lUp，让其等于上一轮的rUp=b
            // 循环往复
            int lUp = 0, rUp = 0;
            for (int l2 = 1; l2 <= m; l2++) {
                rUp = dp[l2];
                if (s1[l1 - 1] == s2[l2 - 1]) {
                    dp[l2] = 1 + lUp;
                } else {
                    dp[l2] = Math.max(dp[l2], dp[l2 - 1]);
                }
                lUp = rUp;
            }
        }
        return dp[m];
    }
}
```



## [Leetcode【中】516.最长回文子序列](https://leetcode.cn/problems/longest-palindromic-subsequence/description/)



```java
public class Solution {
    // 给定一个字符串
    // 找到其中的可以不连续的最长回文子序列
    // 返回该序列的长度

    // 暴力DP
    public static int longestPalindromeSubseq6(String str) {
        char[] s = str.toCharArray();
        int n = s.length;
        return f6(s, 0, n - 1);
    }

    // 片段s[l...r]的最长回文子序列长度
    public static int f6(char[] s, int l, int r) {
        // 递归基1：最终只剩下一个字符
        // - 一定构成1个字符长度的回文
        if (l == r) {
            return 1;
        }
        // 递归基2：最终只剩下两个字符
        // - 若两个字符相同，构成2个字符长度的回文
        // - 若两个字符不同，构成1个字符长度的回文（任意留一个字符即可）
        if (l + 1 == r) {
            return s[l] == s[r] ? 2 : 1;
        }
        // 递归
        if (s[l] == s[r]) {
            // 如果s[l]和s[r]相同，那么它们可以构成回文
            // 回文的长度至少为2
            return 2 + f6(s, l + 1, r - 1);
        } else {
            // 如果s[l]和s[r]不同，那么它们不能构成回文
            // 返回左进一或右减一中最长回文子序列的较大值
            return Math.max(f6(s, l + 1, r), f6(s, l, r - 1));
        }
    }

    // 记忆化搜索
    public static int longestPalindromeSubseq7(String str) {
        char[] s = str.toCharArray();
        int n = s.length;
        int[][] dp = new int[n][n];
        return f7(s, 0, n - 1, dp);
    }

    public static int f7(char[] s, int l, int r, int[][] dp) {
        if (l == r) {
            return 1;
        }
        if (l + 1 == r) {
            return s[l] == s[r] ? 2 : 1;
        }
        if (dp[l][r] != 0) {
            return dp[l][r];
        }
        int ans;
        if (s[l] == s[r]) {
            ans = 2 + f7(s, l + 1, r - 1, dp);
        } else {
            ans = Math.max(f7(s, l + 1, r, dp), f7(s, l, r - 1, dp));
        }
        dp[l][r] = ans;
        return ans;
    }

    // 严格位置依赖的动态规划
    // n=6
    //   0 1 2 3 4 5
    // 0 1 ○
    // 1 X 1 ○
    // 2 X X 1 ○
    // 3 X X X 1 ○
    // 4 X X X X 1 ○
    // 5 X X X X X 1
    public static int longestPalindromeSubseq8(String str) {
        char[] s = str.toCharArray();
        int n = s.length;
        int[][] dp = new int[n][n];
        // 从下往上，遍历行
        for (int l = n - 1; l >= 0; l--) {
            dp[l][l] = 1;
            // 处理 ○ 位置，也就是两个字符串的情况
            // - 若两个字符相同，构成2个字符长度的回文
            // - 若两个字符不同，构成1个字符长度的回文（任意留一个字符即可）
            if (l + 1 < n) {
                dp[l][l + 1] = s[l] == s[l + 1] ? 2 : 1;
            }
            // 遍历列，从左往右
            // 处理 空白 部分的位置
            // - 如果二者相等，当前位置=1+左下角位置
            // - 如果二者不相等，当前位置=向下减一 || 向左减一中较大值
            for (int r = l + 2; r < n; r++) {
                if (s[l] == s[r]) {
                    dp[l][r] = 2 + dp[l + 1][r - 1];
                } else {
                    dp[l][r] = Math.max(dp[l + 1][r], dp[l][r - 1]);
                }
            }
        }
        return dp[0][n - 1];
    }

    // 严格位置依赖的动态规划+空间压缩
    // n=6
    //   0 1 2 3 4 5
    // 0 1 ○
    // 1 X 1 ○
    // 2 X X 1 ○
    // 3 X X X 1 ○
    // 4 X X X X 1 ○
    // 5 X X X X X 1
    public static int longestPalindromeSubseq9(String str) {
        char[] s = str.toCharArray();
        int n = s.length;
        int[] dp = new int[n];
        for (int l = n - 1, leftDown = 0, rightDown; l >= 0; l--) {
            // dp[l][l]处
            dp[l] = 1;
            // dp[l][l+1]处，并使用leftDown记下左下角位置的dp
            if (l + 1 < n) {
                leftDown = dp[l + 1];
                dp[l + 1] = s[l] == s[l + 1] ? 2 : 1;
            }
            // 处理 空白 部分的位置
            // - 如果二者相等，当前位置=1+左下角位置
            // - 如果二者不相等，当前位置=向下减一 || 向左减一中较大值
            for (int r = l + 2; r < n; r++) {
                // 使用rightDown记下正下方位置的dp
                rightDown = dp[r];
                if (s[l] == s[r]) {
                    dp[r] = 2 + leftDown;
                } else {
                    dp[r] = Math.max(dp[r - 1], dp[r]);
                }
                // 每行向右遍历
                leftDown = rightDown;
            }
        }
        return dp[n - 1];
    }

    // 原序字符串 与 逆序字符串 的最长公共子序列
    // 就是原序的最长回文子序列

    public static int longestPalindromeSubseq1(String str1) {
        char[] s1 = str1.toCharArray();
        char[] s2 = new StringBuilder(str1).reverse().toString().toCharArray();
        int n = s1.length;
        int m = s2.length;
        return f1(s1, s2, n - 1, m - 1);
    }

    // 返回s1、s2分别以i1位置、i2位置为结尾的最长公共子序列的长度
    // - s1[0...i1]
    // - s2[0...i2]
    public static int f1(char[] s1, char[] s2, int i1, int i2) {
        // 这里需要处理i1或i2为-1的情况:
        // 当i1或i2为-1时，s1或s2的子序列为空字符串，返回0
        // 不方便进行动态规划填表
        if (i1 < 0 || i2 < 0) {
            return 0;
        }
        // 两个字符串当前的结尾是否同时为最长公共子序列的结尾
        int p1 = f1(s1, s2, i1 - 1, i2 - 1);
        int p2 = s1[i1] == s2[i2] ? (p1 + 1) : 0;
        // 两个字符串当前的结尾中，有一个不是最长公共子序列的结尾
        int p3 = f1(s1, s2, i1 - 1, i2);
        int p4 = f1(s1, s2, i1, i2 - 1);
        return Math.max(Math.max(p1, p2), Math.max(p3, p4));
    }

    public static int longestPalindromeSubseq2(String str1) {
        char[] s1 = str1.toCharArray();
        char[] s2 = new StringBuilder(str1).reverse().toString().toCharArray();
        int n = s1.length;
        int m = s2.length;
        return f2(s1, s2, n, m);
    }

    // 因此我们这里做出优化：
    // n表示s1前长度为n的子字符串
    // m表示s2前长度为m的子字符串
    public static int f2(char[] s1, char[] s2, int n, int m) {
        if (n == 0 || m == 0) {
            return 0;
        }
        int ans = 0;
        // 原四种情况的前两种合并：
        // 如果二者的结尾字符相同，那么直接在计算二者长度都减一的情况下的最长公共子序列长度，再加上1
        if (s1[n - 1] == s2[m - 1]) {
            ans = 1 + f2(s1, s2, n - 1, m - 1);
        } else {
            // 如果二者的结尾字符串不同，那么则比较二者各自减一的情况
            ans = Math.max(f2(s1, s2, n - 1, m), f2(s1, s2, n, m - 1));
        }
        return ans;
    }

    // 记忆化搜索
    public static int longestPalindromeSubseq3(String str1) {
        char[] s1 = str1.toCharArray();
        char[] s2 = new StringBuilder(str1).reverse().toString().toCharArray();
        int n = s1.length;
        int m = s2.length;
        int[][] dp = new int[n + 1][m + 1];
        for (int i = 0; i <= n; i++) {
            for (int j = 0; j <= m; j++) {
                dp[i][j] = -1;
            }
        }
        return f3(s1, s2, n, m, dp);
    }

    public static int f3(char[] s1, char[] s2, int n, int m, int[][] dp) {
        if (n == 0 || m == 0) {
            return 0;
        }
        if (dp[n][m] != -1) {
            return dp[n][m];
        }
        int ans;
        if (s1[n - 1] == s2[m - 1]) {
            ans = 1 + f3(s1, s2, n - 1, m - 1, dp);
        } else {
            ans = Math.max(f3(s1, s2, n - 1, m, dp), f3(s1, s2, n, m - 1, dp));
        }
        dp[n][m] = ans;
        return ans;
    }

    // 严格位置依赖的动态规划
    public static int longestPalindromeSubseq4(String str1) {
        char[] s1 = str1.toCharArray();
        char[] s2 = new StringBuilder(str1).reverse().toString().toCharArray();
        int n = s1.length;
        int m = s2.length;
        int[][] dp = new int[n + 1][m + 1];
        for (int l1 = 1; l1 <= n; l1++) {
            for (int l2 = 1; l2 <= m; l2++) {
                if (s1[l1 - 1] == s2[l2 - 1]) {
                    dp[l1][l2] = 1 + dp[l1 - 1][l2 - 1];
                } else {
                    dp[l1][l2] = Math.max(dp[l1 - 1][l2], dp[l1][l2 - 1]);
                }
            }
        }
        return dp[n][m];
    }

    // 严格位置依赖的动态规划+空间压缩
    public static int longestPalindromeSubseq5(String str1) {
        char[] s1, s2;
        if (str1.length() >= str1.length()) {
            s1 = str1.toCharArray();
            s2 = new StringBuilder(str1).reverse().toString().toCharArray();
        } else {
            s1 = str1.toCharArray();
            s2 = new StringBuilder(str1).reverse().toString().toCharArray();
        }
        // 较长
        int n = s1.length;
        // 较短
        int m = s2.length;
        // 初始化的数组占地小：0行0列都为0
        int[] dp = new int[m + 1];
        for (int l1 = 1; l1 <= n; l1++) {
            // 这里设置两个变量记录是因为：
            // 我们只使用了一维数组，也就是每一行的状态
            // 但是现在呢：
            // a,b
            // c,d（实际为一行内容）
            // 初始时：lUp=a,rUp=b
            // 如果我们if成立，那么的位原b置会被1+a也就是d覆盖
            // 本轮判断结束后呢，我们需要更新lUp，让其等于上一轮的rUp=b
            // 循环往复
            int lUp = 0, rUp = 0;
            for (int l2 = 1; l2 <= m; l2++) {
                rUp = dp[l2];
                if (s1[l1 - 1] == s2[l2 - 1]) {
                    dp[l2] = 1 + lUp;
                } else {
                    dp[l2] = Math.max(dp[l2], dp[l2 - 1]);
                }
                lUp = rUp;
            }
        }
        return dp[m];
    }
}
```



## [牛客【】二叉树](https://www.nowcoder.com/practice/aaefe5896cce4204b276e213e725f3ea)



```java
import java.io.*;

public class Solution {
    // 给定n个节点，高度不能超过m
    // 返回所有二叉树的种类个数
    // 对结果1000000007取模

    public static int MAXN = 51;

    public static int MOD = 1000000007;

    // 记忆化搜索
    public static long[][] dp1 = new long[MAXN][MAXN];

    static {
        for (int i = 0; i < MAXN; i++) {
            for (int j = 0; j < MAXN; j++) {
                dp1[i][j] = -1;
            }
        }
    }

    public static int compute1(int n, int m) {
        if (n == 0) {
            // 空树
            return 1;
        }
        if (m == 0) {
            return 0;
        }
        if (dp1[n][m] != -1) {
            return (int) dp1[n][m];
        }
        long ans = 0;
        // n个节点，头占1个，单独占1层
        for (int k = 0; k < n; k++) {
            // 后续子树
            // 左树占k个节点，高度为m-1
            // 右树占n-k-1个节点，高度为m-1
            // 左树和右树的结构数相乘，再累加
            ans = (ans + ((long) compute1(k, m - 1) * compute1(n - k - 1, m - 1)) % MOD) % MOD;
        }
        dp1[n][m] = ans;
        return (int) ans;
    }

    // 严格位置依赖的动态规划
    public static long[][] dp2 = new long[MAXN][MAXN];

    //   m
    // n
    //   0 1 2 3 4 5
    // 0 1 1 1 1 1 1
    // 1 0
    // 2 0
    // 3 0
    // 4 0
    // 5 0
    public static int compute2(int n, int m) {
        // n=0，空树，返回1
        for (int j = 0; j <= m; j++) {
            dp2[0][j] = 1;
        }
        // 遍历空白区域
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= m; j++) {
                dp2[i][j] = 0;
                for (int k = 0; k < i; k++) {
                    dp2[i][j] = (dp2[i][j] + dp2[k][j - 1] * dp2[i - k - 1][j - 1]) % MOD;
                }
            }
        }
        return (int) dp2[n][m];
    }

    // 严格位置依赖的动态规划+空间压缩
    public static long[] dp3 = new long[MAXN];

    //   m
    // n
    //   0 1 2 3 4 5
    // 0 1 1 1 1 1 1
    // 1 0
    // 2 0
    // 3 0
    // 4 0
    // 5 0
    public static int compute3(int n, int m) {
        dp3[0] = 1;
        // n个结点，0高度
        for (int i = 1; i <= n; i++) {
            dp3[i] = 0;
        }
        // 遍历列，从左往右
        for (int j = 1; j <= m; j++) {
            // 遍历行，自底向上
            // 第0行无需计算，都为1
            for (int i = n; i >= 1; i--) {
                dp3[i] = 0;
                for (int k = 0; k < i; k++) {
                    dp3[i] = (dp3[i] + dp3[k] * dp3[i - k - 1]) % MOD;
                }
            }
        }
        return (int) dp3[n];
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            int n = (int) in.nval;
            in.nextToken();
            int m = (int) in.nval;
            out.println(compute1(n, m));
        }
        out.flush();
        out.close();
    }
}
```



## [Leetcode【难】329.矩阵中的最长递增路径](https://leetcode.cn/problems/longest-increasing-path-in-a-matrix/description/)



```java
public class Solution {
    // 给定一个m*n的二维网格，每个单元都有非负值
    // 要求路径上所有值严格递增
    // - 可以上下左右移动
    // 返回最长递增路径长度

    public static int longestIncreasingPath1(int[][] grid) {
        int ans = 0;
        for (int i = 0; i < grid.length; i++) {
            for (int j = 0; j < grid[0].length; j++) {
                ans = Math.max(ans, f1(grid, i, j));
            }
        }
        return ans;
    }

    public static int f1(int[][] grid, int i, int j) {
        int next = 0;
        if (i > 0 && grid[i][j] < grid[i - 1][j]) {
            next = Math.max(next, f1(grid, i - 1, j));
        }
        if (i + 1 < grid.length && grid[i][j] < grid[i + 1][j]) {
            next = Math.max(next, f1(grid, i + 1, j));
        }
        if (j > 0 && grid[i][j] < grid[i][j - 1]) {
            next = Math.max(next, f1(grid, i, j - 1));
        }
        if (j + 1 < grid[0].length && grid[i][j] < grid[i][j + 1]) {
            next = Math.max(next, f1(grid, i, j + 1));
        }
        return next + 1;
    }

    public static int longestIncreasingPath2(int[][] grid) {
        int n = grid.length;
        int m = grid[0].length;
        int[][] dp = new int[n][m];
        int ans = 0;
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                ans = Math.max(ans, f2(grid, i, j, dp));
            }
        }
        return ans;
    }

    public static int f2(int[][] grid, int i, int j, int[][] dp) {
        if (dp[i][j] != 0) {
            return dp[i][j];
        }
        int next = 0;
        if (i > 0 && grid[i][j] < grid[i - 1][j]) {
            next = Math.max(next, f2(grid, i - 1, j, dp));
        }
        if (i + 1 < grid.length && grid[i][j] < grid[i + 1][j]) {
            next = Math.max(next, f2(grid, i + 1, j, dp));
        }
        if (j > 0 && grid[i][j] < grid[i][j - 1]) {
            next = Math.max(next, f2(grid, i, j - 1, dp));
        }
        if (j + 1 < grid[0].length && grid[i][j] < grid[i][j + 1]) {
            next = Math.max(next, f2(grid, i, j + 1, dp));
        }
        dp[i][j] = next + 1;
        return next + 1;
    }
}
```



***



# ✅068【必备】更多二维动态规划



## [Leetcode【难】115.不同的子序列](https://leetcode.cn/problems/distinct-subsequences/description/)



```java
public class Solution {
    // 给定两个字符串 s 和 t，
    // 统计并返回s的子序列中t出现的次数
    // 答案对1000000007取模

    // 暴力递归
    public static int numDistinct1(String str, String target) {
        // 原始字符串
        char[] s = str.toCharArray();
        // 目标字符串
        char[] t = target.toCharArray();
        int n = s.length;
        int m = t.length;
        return process1(s, t, n, m);
    }

    public static int process1(char[] s, char[] t, int n, int m) {
        // 1、当m==0时，空的目标字符串
        // - 原始字符串不为空，返回1
        // - 原始字符串为空，仍返回1
        // 2、当n==0时，空的原始字符串
        // - 目标字符串不为空，返回0
        // - 目标字符串为空，仍返回1
        // 因此我们需要先判断目标字符串是否为空
        // 如果目标字符串为空，无论原始字符串是否为空，都需要返回1
        if (m == 0) {
            // 如果目标字符串为空
            // - 只有空串一个可能
            return 1;
        }
        if (n == 0) {
            // 如果原始字符串为空
            return 0;
        }
        // 原始字符串片段的末尾不要
        int p1 = process1(s, t, n - 1, m);
        // 原始字符串片段的末尾要
        int p2 = 0;
        if (s[n - 1] == t[m - 1]) {
            p2 = process1(s, t, n - 1, m - 1);
        }
        // 原始字符串片段的末尾不要 + 原始字符串片段的末尾要
        return p1 + p2;
    }

    // 记忆化搜索
    public static int numDistinct2(String str, String target) {
        char[] s = str.toCharArray();
        char[] t = target.toCharArray();
        int n = s.length;
        int m = t.length;
        // 初始化目标字符串m为空（0）的dp数组部分为1，其余初始化为0
        int[][] dp = new int[n + 1][m + 1];
        for (int i = 0; i <= n; i++) {
            dp[i][0] = 1;
        }
        // 第零行、第零列都已初始化
        // 从(1,1)遍历到(n,m)
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= m; j++) {
                // 当前原始字符串的末尾字符不要
                dp[i][j] = dp[i - 1][j];
                // 当前原始字符串的末尾字符要
                // - 前提：二者当前片段的字符一致
                if (s[i - 1] == t[j - 1]) {
                    // 才能加上二者片段末尾都减一的位置
                    dp[i][j] += dp[i - 1][j - 1];
                }
            }
        }
        return dp[n][m];
    }

    // 空间压缩
    public static int numDistinct3(String str, String target) {
        char[] s = str.toCharArray();
        char[] t = target.toCharArray();
        int n = s.length;
        int m = t.length;
        int[] dp = new int[m + 1];
        dp[0] = 1;
        for (int i = 1; i <= n; i++) {
            // 因为我们当前位置相关的是上一行当前位置和左减一的位置
            // 所以我们从右往左遍历
            for (int j = m; j >= 1; j--) {
                // 因为我们这里如果不要当前原始字符的末尾
                // 那么就相当于是等于上一行当前位置的dp值
                // 所以我们直接继承上一行当前位置的dp值
                // dp[j] = dp[j];
                if (s[i - 1] == t[j - 1]) {
                    dp[j] += dp[j - 1];
                }
            }
        }
        return dp[m];
    }
}
```



## [Leetcode【中】72.编辑距离](https://leetcode.cn/problems/edit-distance/description/)



```java
public class Solution {
    // 给定两个单词w1和w2
    // 现在需要将w1转换为w2
    // 可以插入（代价a）、删除（代价b）、替换（代价c）
    // 返回将w1转换为w2的最低代价

    // 暴力递归
    public static int minDistance1(String w1, String w2) {
        char[] s1 = w1.toCharArray();
        char[] s2 = w2.toCharArray();
        return f1(s1, s2, s1.length, s2.length, 1, 1, 1);
    }

    // s1[0...i-1]
    // s2[0...j-1]
    // i和j分别表示s1和s2处理的字符串的长度
    public static int f1(char[] s1, char[] s2, int i, int j, int a, int b, int c) {
        // 若当前处理的原始字符串片段为空
        // 插入s2的当前所有字符
        if (i == 0) {
            return j * a;
        }
        // 若当前处理的目标字符串片段为空
        // 删除s1的当前所有字符
        if (j == 0) {
            return i * b;
        }
        // 若原始字符串和目标字符串的最后一个字符相等
        // 则处理长度都-1
        // 则直接转换
        // 该情况相比于其余的几种，一定是最优的
        if (s1[i - 1] == s2[j - 1]) {
            return f1(s1, s2, i - 1, j - 1, a, b, c);
        }
        // 若原始字符串和目标字符串的最后一个字符不相等
        // 则有三种情况
        // - 替换：s1的最后一个字符替换为s2的最后一个字符
        //   - 接着处理i-1长度的s1和j-1长度的s2
        int p1 = f1(s1, s2, i - 1, j - 1, a, b, c) + c;
        // - 插入：在s1的最后一个字符后插入s2的最后一个字符
        //   - 接着处理i长度的s1和j-1长度的s2
        int p2 = f1(s1, s2, i, j - 1, a, b, c) + a;
        // - 删除：删除s1的最后一个字符
        //   - 接着处理i-1长度的s1和j长度的s2
        int p3 = f1(s1, s2, i - 1, j, a, b, c) + b;
        return Math.min(Math.min(p1, p2), p3);
    }

    // 记忆化搜索
    public static int minDistance2(String w1, String w2) {
        return f2(w1, w2, 1, 1, 1);
    }

    // s1[0...i-1]
    // s2[0...j-1]
    // - s1的最后一个字符参与转换
    //   - 变成s2的最后一个字符
    //     - 相等：代价0
    //     - 不相等：代价c（替换）
    //   - 变成s2的倒数第二个字符
    //     - 再插入s1的最后一个字符：代驾a（插入）
    // - s1的最后一个字符不参与转换
    //   - 删除：代驾b（删除）
    public static int f2(String w1, String w2, int a, int b, int c) {
        // 原始字符串
        char[] s1 = w1.toCharArray();
        // 目标字符串
        char[] s2 = w2.toCharArray();
        int n = s1.length;
        int m = s2.length;
        int[][] dp = new int[n + 1][m + 1];
        // 若目标字符串为空
        // 删除s1的所有字符
        for (int i = 1; i <= n; i++) {
            dp[i][0] = i * b;
        }
        // 若原始字符串为空
        // 插入s2的所有字符
        for (int j = 1; j <= m; j++) {
            dp[0][j] = j * a;
        }
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= m; j++) {
                // s1和s2的最后一个字符都参与
                // - 且二者相等
                int p1 = Integer.MAX_VALUE;
                if (s1[i - 1] == s2[j - 1]) {
                    p1 = dp[i - 1][j - 1];
                }
                // - 且二者不相等：替换
                int p2 = Integer.MAX_VALUE;
                if (s1[i - 1] != s2[j - 1]) {
                    p2 = dp[i - 1][j - 1] + c;
                }
                // - 插入s2的最后一个字符
                int p3 = dp[i][j - 1] + a;
                // 原始字符串最后一个字符不参与
                // - 删除s1的最后一个字符
                int p4 = dp[i - 1][j] + b;
                dp[i][j] = Math.min(Math.min(p1, p2), Math.min(p3, p4));
            }
        }
        return dp[n][m];
    }

    // 贪心优化
    public static int minDistance3(String str1, String str2) {
        int a = 1;
        int b = 1;
        int c = 1;
        char[] s1 = str1.toCharArray();
        char[] s2 = str2.toCharArray();
        int n = s1.length;
        int m = s2.length;
        int[][] dp = new int[n + 1][m + 1];
        for (int i = 1; i <= n; i++) {
            dp[i][0] = i * b;
        }
        for (int j = 1; j <= m; j++) {
            dp[0][j] = j * a;
        }
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= m; j++) {
                // 这里优化思路可以直接参考暴力递归
                if (s1[i - 1] == s2[j - 1]) {
                    dp[i][j] = dp[i - 1][j - 1];
                } else {
                    dp[i][j] = Math.min(Math.min(dp[i - 1][j - 1] + c, dp[i - 1][j] + b), dp[i][j - 1] + a);
                }
            }
        }
        return dp[n][m];
    }

    // 空间压缩
    public static int minDistance4(String str1, String str2) {
        int a = 1;
        int b = 1;
        int c = 1;
        char[] s1 = str1.toCharArray();
        char[] s2 = str2.toCharArray();
        int n = s1.length;
        int m = s2.length;
        int[] dp = new int[m + 1];
        for (int j = 1; j <= m; j++) {
            dp[j] = j * a;
        }
        // 二位递归的子状态：
        // X X
        // X X
        for (int i = 1, leftUp, backUp; i <= n; i++) {
            // 遍历的当前行的上一行的左上方元素
            leftUp = (i - 1) * b;
            // 初始化遍历的当前行的左侧元素
            dp[0] = i * b;
            for (int j = 1; j <= m; j++) {
                // 遍历的当前行的上一行的正上方元素
                backUp = dp[j];
                if (s1[i - 1] == s2[j - 1]) {
                    dp[j] = leftUp;
                } else {
                    dp[j] = Math.min(Math.min(dp[j] + b, dp[j - 1] + a), leftUp + c);
                }
                leftUp = backUp;
            }
        }
        return dp[m];
    }
}
```



## [Leetcode【中】97.交错字符串](https://leetcode.cn/problems/interleaving-string/description/)



```java
public class Solution {
    // 给定三个字符串s1、s2、s3，
    // s1和s2可以任意交错，但是各自的字符相对位置保持不变
    // 判断s3是否由s1和s2交错组成

    // 暴力递归
    public static boolean isInterleave1(String str1, String str2, String str3) {
        if (str1.length() + str2.length() != str3.length()) {
            return false;
        }
        return f(str1, str2, str3, 0, 0, 0);
    }

    public static boolean f(String s1, String s2, String s3, int i, int j, int k) {
        if (k == s3.length()) {
            return i == s1.length() && j == s2.length();
        }
        if (i == s1.length()) {
            return s2.substring(j).equals(s3.substring(k));
        }
        if (j == s2.length()) {
            return s1.substring(i).equals(s3.substring(k));
        }
        boolean p1 = s1.charAt(i) == s3.charAt(k) && f(s1, s2, s3, i + 1, j, k + 1);
        boolean p2 = s2.charAt(j) == s3.charAt(k) && f(s1, s2, s3, i, j + 1, k + 1);
        return p1 || p2;
    }

    // 记忆化搜索
    // dp[i][j]
    // s1[0...i-1]和s2[0...j-1]，能否交错组成出s3[0...i+j-1]
    public static boolean isInterleave2(String str1, String str2, String str3) {
        if (str1.length() + str2.length() != str3.length()) {
            return false;
        }
        char[] s1 = str1.toCharArray();
        char[] s2 = str2.toCharArray();
        char[] s3 = str3.toCharArray();
        int n = s1.length;
        int m = s2.length;
        boolean[][] dp = new boolean[n + 1][m + 1];
        dp[0][0] = true;
        // s2为空串
        for (int i = 1; i <= n; i++) {
            if (s1[i - 1] != s3[i - 1]) {
                break;
            }
            dp[i][0] = true;
        }
        // s1为空串
        for (int j = 1; j <= m; j++) {
            if (s2[j - 1] != s3[j - 1]) {
                break;
            }
            dp[0][j] = true;
        }
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= m; j++) {
                dp[i][j] = ((s1[i - 1] == s3[i + j - 1] && dp[i - 1][j])
                        || (s2[j - 1] == s3[i + j - 1] && dp[i][j - 1]));
            }
        }
        return dp[n][m];
    }

    // 空间压缩
    public static boolean isInterleave3(String str1, String str2, String str3) {
        if (str1.length() + str2.length() != str3.length()) {
            return false;
        }
        char[] s1 = str1.toCharArray();
        char[] s2 = str2.toCharArray();
        char[] s3 = str3.toCharArray();
        int n = s1.length;
        int m = s2.length;
        boolean[] dp = new boolean[m + 1];
        dp[0] = true;
        // s2为空串
        for (int j = 1; j <= m; j++) {
            if (s2[j - 1] != s3[j - 1]) {
                break;
            }
            dp[j] = true;
        }
        for (int i = 1; i <= n; i++) {
            dp[0] = s1[i - 1] == s3[i - 1] && dp[0];
            for (int j = 1; j <= m; j++) {
                dp[j] = ((s1[i - 1] == s3[i + j - 1] && dp[j])
                        || (s2[j - 1] == s3[i + j - 1] && dp[j - 1]));
            }
        }
        return dp[m];
    }
}
```



***



# ✅069【必备】三维动态规划



## [Leetcode【中】474.一和零](https://leetcode.cn/problems/ones-and-zeroes/description/)



```java
public class Solution {
    // 给定一组字符串，每个字符串都由0或1组成
    // 选择一个该组字符串的子集
    // 要求子集中字符串总的1的数量不超过n，0的数量不超过m
    // 返回该子集的最大元素数量

    public static int zeros, ones;

    // 统计传入字符串中0和1的数量
    public static void zerosAndOnes(String str) {
        zeros = 0;
        ones = 0;
        for (int i = 0; i < str.length(); i++) {
            if (str.charAt(i) == '0') {
                zeros++;
            } else {
                ones++;
            }
        }
    }

    // 暴力递归
    public static int findMaxForm1(String[] strs, int m, int n) {
        return f1(strs, 0, m, n);
    }

    // strs[i...]可以自由选择
    // - 0的数量不超过z
    // - 1的数量不超过o
    public static int f1(String[] strs, int i, int z, int o) {
        if (i == strs.length) {
            return 0;
        }
        // 不使用当前的字符串
        int p1 = f1(strs, i + 1, z, o);
        // 使用当前的字符串
        int p2 = 0;
        zerosAndOnes(strs[i]);
        if (zeros <= z && ones <= o) {
            p2 = 1 + f1(strs, i + 1, z - zeros, o - ones);
        }
        return Math.max(p1, p2);
    }

    // 记忆化搜索
    public static int findMaxForm2(String[] strs, int m, int n) {
        int[][][] dp = new int[strs.length][m + 1][n + 1];
        for (int i = 0; i < strs.length; i++) {
            for (int z = 0; z <= m; z++) {
                for (int o = 0; o <= n; o++) {
                    dp[i][z][o] = -1;
                }
            }
        }
        return f2(strs, 0, m, n, dp);
    }

    public static int f2(String[] strs, int i, int z, int o, int[][][] dp) {
        if (i == strs.length) {
            return 0;
        }
        if (dp[i][z][o] != -1) {
            return dp[i][z][o];
        }
        int p1 = f2(strs, i + 1, z, o, dp);
        int p2 = 0;
        zerosAndOnes(strs[i]);
        if (zeros <= z && ones <= o) {
            p2 = 1 + f2(strs, i + 1, z - zeros, o - ones, dp);
        }
        int ans = Math.max(p1, p2);
        dp[i][z][o] = ans;
        return ans;
    }

    // 严格位置依赖的动态规划
    public static int findMaxForm3(String[] strs, int m, int n) {
        int[][][] dp = new int[strs.length + 1][m + 1][n + 1];
        for (int i = strs.length - 1; i >= 0; i--) {
            zerosAndOnes(strs[i]);
            for (int z = 0; z <= m; z++) {
                for (int o = 0; o <= n; o++) {
                    int p1 = dp[i + 1][z][o];
                    int p2 = 0;
                    if (zeros <= z && ones <= o) {
                        p2 = 1 + dp[i + 1][z - zeros][o - ones];
                    }
                    dp[i][z][o] = Math.max(p1, p2);
                }
            }
        }
        return dp[0][m][n];
    }

    // 严格位置依赖的动态规划+空间压缩
    // 4 u v w x y
    // 3 p q r s t
    // 2 k l m n o
    // 1 f g h i j
    // 0 a b c d e
    //   0 1 2 3 4
    public static int findMaxForm4(String[] strs, int m, int n) {
        int[][] dp = new int[m + 1][n + 1];
        for (String s : strs) {
            zerosAndOnes(s);
            // 当前层的例如y[z][o]取决于
            // - 上一层同样的位置y[z][o]处
            // - 上一层的[z-zeros][o-ones]处
            // 为了每一层遍历不相互影响
            // 我们需要从右上往左下遍历
            for (int z = m; z >= zeros; z--) {
                for (int o = n; o >= ones; o--) {
                    dp[z][o] = Math.max(dp[z][o], 1 + dp[z - zeros][o - ones]);
                }
            }
        }
        return dp[m][n];
    }
}
```



## [Leetcode【难】879.盈利计划](https://leetcode.cn/problems/profitable-schemes/description/)



```java
public class Solution {
    // n个员工，每个员工只能参与一种工作
    // i种工作产生profit[i]的利润，需要group[i]个员工
    // 返回能做到员工不能超过n，利润不能少于p的计划有多少个
    // 结果对1000000007取模

    // 暴力递归
    public static int profitableSchemes1(int n, int minProfit, int[] group, int[] profit) {
        return f1(group, profit, 0, n, minProfit);
    }

    // i:来到了i号工作
    // r:员工还有r人
    // s:利润还差s才能达标
    public static int f1(int[] g, int[] p, int i, int r, int s) {
        // 人没了
        if (r <= 0) {
            return s <= 0 ? 1 : 0;
        }
        // 工作没了
        if (i == g.length) {
            return s <= 0 ? 1 : 0;
        }
        // 不要当前工作
        int p1 = f1(g, p, i + 1, r, s);
        // 要当前工作
        int p2 = 0;
        if (g[i] <= r) {
            p2 = f1(g, p, i + 1, r - g[i], s - p[i]);
        }
        return p1 + p2;
    }

    public static int MID = 1000000007;

    // 记忆化搜索
    public static int profitableSchemes2(int n, int minProfit, int[] group, int[] profit) {
        int m = group.length;
        int[][][] dp = new int[m][n + 1][minProfit + 1];
        for (int a = 0; a < m; a++) {
            for (int b = 0; b <= n; b++) {
                for (int c = 0; c <= minProfit; c++) {
                    dp[a][b][c] = -1;
                }
            }
        }
        return f2(group, profit, 0, n, minProfit, dp);
    }

    public static int f2(int[] g, int[] p, int i, int r, int s, int[][][] dp) {
        if (r <= 0) {
            return s == 0 ? 1 : 0;
        }
        if (i == g.length) {
            return s == 0 ? 1 : 0;
        }
        if (dp[i][r][s] != -1) {
            return dp[i][r][s];
        }
        int p1 = f2(g, p, i + 1, r, s, dp);
        int p2 = 0;
        if (g[i] <= r) {
            p2 = f2(g, p, i + 1, r - g[i], Math.max(s - p[i], 0), dp);
        }
        dp[i][r][s] = (p1 + p2) % MID;
        return dp[i][r][s];
    }

    // 严格位置依赖+空间压缩
    public static int profitableSchemes3(int n, int minProfit, int[] group, int[] profit) {
        // 初始化每一层任务的员工数和利润
        int[][] dp = new int[n + 1][minProfit + 1];
        // 初始化第0层任务的员工数和利润
        // 任务为0，还差利润为0时，无论还剩多少员工，都有1种方案
        for (int r = 0; r <= n; r++) {
            dp[r][0] = 1;
        }
        int m = group.length;
        for (int i = 0; i < m; i++) {
            for (int r = n; r >= group[i]; r--) {
                for (int s = minProfit; s >= 0; s--) {
                    // 当前任务下的员工数和利润
                    // - 不选当前任务，维持上一次员工数和利润
                    // - 选当前任务，员工数减少group[i]，还需利润减少profit[i]
                    dp[r][s] = (dp[r][s] + dp[r - group[i]][Math.max(0, s - profit[i])]) % MID;
                }
            }
        }
        return dp[n][minProfit];
    }
}
```



## [Leetcode【中】688.骑士在棋盘上的概率](https://leetcode.cn/problems/knight-probability-in-chessboard/description/)



```java
public class Solution {
    // n*n的二维棋盘，从(row,col)出发，进行k次移动
    // 棋盘范围(0,0)~(n-1,n-1)
    // 每次移动有8种可能，每次在基本方向上移动两个单元格
    // 返回k次移动后仍然在棋盘上的概率

    // 暴力递归
    public static double knightProbability1(int n, int k, int row, int col) {
        return f1(n, row, col, k);
    }

    // 从(i,j)出发，还有k步要走，返回最后还在棋盘上的概率
    public static double f1(int n, int i, int j, int k) {
        if (i < 0 || i >= n || j < 0 || j >= n) {
            return 0;
        }
        if (k == 0) {
            return 1;
        }
        double ans = 0;
        ans += (f1(n, i - 2, j + 1, k - 1) / 8);
        ans += (f1(n, i - 2, j - 1, k - 1) / 8);
        ans += (f1(n, i + 2, j + 1, k - 1) / 8);
        ans += (f1(n, i + 2, j - 1, k - 1) / 8);
        ans += (f1(n, i - 1, j + 2, k - 1) / 8);
        ans += (f1(n, i - 1, j - 2, k - 1) / 8);
        ans += (f1(n, i + 1, j + 2, k - 1) / 8);
        ans += (f1(n, i + 1, j - 2, k - 1) / 8);
        return ans;
    }

    // 记忆化搜索
    public static double knightProbability2(int n, int k, int row, int col) {
        double[][][] dp = new double[n][n][k + 1];
        for (int i1 = 0; i1 < n; i1++) {
            for (int j1 = 0; j1 < n; j1++) {
                for (int t = 0; t <= k; t++) {
                    dp[i1][j1][t] = -1;
                }
            }
        }
        return f2(n, row, col, k, dp);
    }

    public static double f2(int n, int i, int j, int k, double[][][] dp) {
        if (i < 0 || i >= n || j < 0 || j >= n) {
            return 0;
        }
        if (dp[i][j][k] != -1) {
            return dp[i][j][k];
        }
        double ans = 0;
        if (k == 0) {
            ans = 1;
        } else {
            ans += (f2(n, i - 2, j + 1, k - 1, dp) / 8);
            ans += (f2(n, i - 2, j - 1, k - 1, dp) / 8);
            ans += (f2(n, i + 2, j + 1, k - 1, dp) / 8);
            ans += (f2(n, i + 2, j - 1, k - 1, dp) / 8);
            ans += (f2(n, i - 1, j + 2, k - 1, dp) / 8);
            ans += (f2(n, i - 1, j - 2, k - 1, dp) / 8);
            ans += (f2(n, i + 1, j + 2, k - 1, dp) / 8);
            ans += (f2(n, i + 1, j - 2, k - 1, dp) / 8);
        }
        dp[i][j][k] = ans;
        return ans;
    }
}
```



## [Leetcode【难】2435.矩阵中和能被 K 整除的路径](https://leetcode.cn/problems/paths-in-matrix-whose-sum-is-divisible-by-k/description/)



```java
public class Solution {
    // 给定一个二维矩阵
    // 从(0,0)出发，到(n-1,m-1)
    // 每次只能向右或向下走
    // 返回路径和能被k整除
    // 结果对1000000007取模

    public static int MOD = 1000000007;

    // 暴力递归
    public static int numberOfPaths1(int[][] grid, int k) {
        int n = grid.length;
        int m = grid[0].length;
        return f1(grid, n, m, k, 0, 0, 0);
    }

    // 从(i,j)出发到(n-1.m-1)
    // 路径和对k取模为r的总数
    public static int f1(int[][] grid, int n, int m, int k, int i, int j, int r) {
        // 递归基
        if (i == n - 1 && j == m - 1) {
            return grid[i][j] % k == r ? 1 : 0;
        }
        // r:从当前(i,j)3位置出发时需要的余数：5
        // k:总路径的模数：7
        // 从(i-1,j-1)3位置时新的需要的余数=7+5-3=2
        int need = (k + r - (grid[i][j] % k)) % k;
        int ans = 0;
        if (i + 1 < n) {
            ans = f1(grid, n, m, k, i + 1, j, need);
        }
        if (j + 1 < m) {
            ans = (ans + f1(grid, n, m, k, i, j + 1, need)) % MOD;
        }
        return ans;
    }

    // 记忆化搜索
    public static int numberOfPaths2(int[][] grid, int k) {
        int n = grid.length;
        int m = grid[0].length;
        int[][][] dp = new int[n][m][k];
        for (int a = 0; a < n; a++) {
            for (int b = 0; b < m; b++) {
                for (int c = 0; c < k; c++) {
                    dp[a][b][c] = -1;
                }
            }
        }
        return f2(grid, n, m, k, 0, 0, 0, dp);
    }

    public static int f2(int[][] grid, int n, int m, int k, int i, int j, int r, int[][][] dp) {
        if (i == n - 1 && j == m - 1) {
            return grid[i][j] % k == r ? 1 : 0;
        }
        if (dp[i][j][r] != -1) {
            return dp[i][j][r];
        }
        int need = (k + r - grid[i][j] % k) % k;
        int ans = 0;
        if (i + 1 < n) {
            ans = f2(grid, n, m, k, i + 1, j, need, dp);
        }
        if (j + 1 < m) {
            ans = (ans + f2(grid, n, m, k, i, j + 1, need, dp)) % MOD;
        }
        dp[i][j][r] = ans;
        return ans;
    }

    // 严格位置依赖的动态规划
    public static int numberOfPaths3(int[][] grid, int k) {
        int n = grid.length;
        int m = grid[0].length;
        int[][][] dp = new int[n][m][k];
        // 初始化终点[n-1][m-1]
        // 只有终点对MOD取模对应的位置为1
        dp[n - 1][m - 1][grid[n - 1][m - 1] % k] = 1;
        // 左上角(0,0)->右下角(n-1,m-1)
        // 初始化最后一列m-1
        // 从下往上处理
        for (int i = n - 2; i >= 0; i--) {
            // 遍历每个位置(i,m-1)所有的余数r
            for (int r = 0; r < k; r++) {
                // 从当前位置出发需要的余数为r和从下一位置出发需要的新的余数
                // 二者位于一条路径上
                dp[i][m - 1][r] = dp[i + 1][m - 1][(k + r - grid[i][m - 1] % k) % k];
            }
        }
        // 初始化最后一行n-1
        // 从右往左处理
        for (int j = m - 2; j >= 0; j--) {
            // 遍历每个位置(n-1,j)所有的余数r
            for (int r = 0; r < k; r++) {
                // 从当前位置出发需要的余数为r和从下一位置出发需要的新的余数
                // 二者位于一条路径上
                dp[n - 1][j][r] = dp[n - 1][j + 1][(k + r - grid[n - 1][j] % k) % k];
            }
        }

        for (int i = n - 2; i >= 0; i--) {
            for (int j = m - 2; j >= 0; j--) {
                for (int r = 0; r < k; r++) {
                    int need = (k + r - grid[i][j] % k) % k;
                    dp[i][j][r] = dp[i + 1][j][need];
                    dp[i][j][r] = (dp[i][j][r] + dp[i][j + 1][need]) % MOD;
                }
            }
        }
        return dp[0][0][0];
    }
}
```



## [Leetcode【难】87.扰乱字符串](https://leetcode.cn/problems/scramble-string/description/)



```java
public class Solution {
    // 扰乱字符串s得到字符串t
    // 步骤1：如果字符串长度为1，算法停止
    // 步骤2：如果字符串长度大于1
    // - 随机一个下标位置将字符串分割为两个非空子字符串
    // - 给定字符串s，可以拆分为x和y，满足s=x+y
    // - 可以决定是否交换x和y的位置
    // - 即s=x+y或s=y+x
    // - 循环此过程
    // 给定两个字符串s1和s2，判断s2是否是s1的扰乱字符串

    // 暴力递归
    public static boolean isScramble1(String str1, String str2) {
        char[] s1 = str1.toCharArray();
        char[] s2 = str2.toCharArray();
        int n = s1.length;
        return f1(s1, 0, n - 1, s2, 0, n - 1);
    }

    // s1[l1....r1]
    // s2[l2....r2]
    // 是不是扰乱串的关系
    public static boolean f1(char[] s1, int l1, int r1, char[] s2, int l2, int r2) {
        // 递归基
        if (l1 == r1 && l2 == r2) {
            return s1[l1] == s2[l2];
        }
        // 不交错
        for (int i = l1, j = l2; i < r1 && j < r2; i++, j++) {
            if (f1(s1, l1, i, s2, l2, j) && f1(s1, i + 1, r1, s2, j + 1, r2)) {
                return true;
            }
        }
        // 交错
        for (int i = l1, j = r2; i < r1 && j >= l2; i++, j--) {
            if (f1(s1, l1, i, s2, j, r2) && f1(s1, i + 1, r1, s2, l2, j - 1)) {
                return true;
            }
        }
        return false;
    }

    // 暴力递归（四维降三维）
    public static boolean isScramble2(String str1, String str2) {
        char[] s1 = str1.toCharArray();
        char[] s2 = str2.toCharArray();
        int n = s1.length;
        return f2(s1, s2, 0, 0, n);
    }

    public static boolean f2(char[] s1, char[] s2, int l1, int l2, int len) {
        // 递归基
        if (len == 1) {
            return s1[l1] == s2[l2];
        }
        // 不交错
        // 左侧k个字符，右侧len-k个字符
        for (int k = 1; k < len; k++) {
            if (f2(s1, s2, l1, l2, k) && f2(s1, s2, l1 + k, l2 + k, len - k)) {
                return true;
            }
        }
        // 交错！
        // 左侧k个字符，右侧len-k个字符
        for (int k = 1; k < len; k++) {
            if (f2(s1, s2, l1, l2 + len - k, k) && f2(s1, s2, l1 + k, l2, len - k)) {
                return true;
            }
        }
        return false;
    }

    // 记忆化搜索
    public static boolean isScramble3(String str1, String str2) {
        char[] s1 = str1.toCharArray();
        char[] s2 = str2.toCharArray();
        int n = s1.length;
        // dp[l1][l2][len] == 0 表示没计算过
        // dp[l1][l2][len] == 1 表示是扰乱字符串
        // dp[l1][l2][len] == -1 表示不是扰乱字符串
        int[][][] dp = new int[n][n][n + 1];
        return f3(s1, s2, 0, 0, n, dp);
    }

    public static boolean f3(char[] s1, char[] s2, int l1, int l2, int len, int[][][] dp) {
        if (len == 1) {
            return s1[l1] == s2[l2];
        }
        if (dp[l1][l2][len] != 0) {
            return dp[l1][l2][len] == 1;
        }
        boolean ans = false;
        // 不交错
        for (int k = 1; k < len; k++) {
            if (f3(s1, s2, l1, l2, k, dp) && f3(s1, s2, l1 + k, l2 + k, len - k, dp)) {
                ans = true;
                break;
            }
        }
        // 交错（贪心）
        if (!ans) {
            for (int k = 1; k < len; k++) {
                if (f3(s1, s2, l1, l2 + len - k, k, dp) && f3(s1, s2, l1 + k, l2, len - k, dp)) {
                    ans = true;
                    break;
                }
            }
        }
        dp[l1][l2][len] = ans ? 1 : -1;
        return ans;
    }

    public static boolean isScramble4(String str1, String str2) {
        char[] s1 = str1.toCharArray();
        char[] s2 = str2.toCharArray();
        int n = s1.length;
        boolean[][][] dp = new boolean[n][n][n + 1];
        // 递归基：len=1
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                dp[i][j][1] = s1[i] == s2[j];
            }
        }
        // 遍历所有可能的长度len
        for (int len = 2; len <= n; len++) {
            // 遍历所有可能的起始位置l1和l2
            for (int l1 = 0; l1 <= n - len; l1++) {
                for (int l2 = 0; l2 <= n - len; l2++) {
                    // 该长度下，所有可能的划分位置
                    for (int k = 1; k < len; k++) {
                        if (dp[l1][l2][k] && dp[l1 + k][l2 + k][len - k]) {
                            dp[l1][l2][len] = true;
                            break;
                        }
                    }
                    if (!dp[l1][l2][len]) {
                        for (int k = 1; k < len; k++) {
                            if (dp[l1][l2 + len - k][k] && dp[l1 + k][l2][len - k]) {
                                dp[l1][l2][len] = true;
                                break;
                            }
                        }
                    }
                }
            }
        }
        return dp[0][0][n];
    }
}
```



***



# ✅070【必备】子数组最大累加和与扩展-上



## [Leetcode【中】53.最大子数组和](https://leetcode.cn/problems/maximum-subarray/description/)



```java
public class Solution {
    // 给定一个一维整数数组nums
    // 返回子数组的最大累加和

    public static int maxSubArray1(int[] nums) {
        int n = nums.length;
        // dp[i]：nums[0..i]中以nums[i]结尾的子数组的最大累加和
        int[] dp = new int[n];
        dp[0] = nums[0];
        int ans = nums[0];
        for (int i = 1; i < n; i++) {
            dp[i] = Math.max(nums[i], dp[i - 1] + nums[i]);
            ans = Math.max(ans, dp[i]);
        }
        return ans;
    }

    // 空间压缩
    public static int maxSubArray2(int[] nums) {
        int ans = nums[0];
        for (int i = 1, tmp = nums[0]; i < nums.length; i++) {
            tmp = Math.max(nums[i], tmp + nums[i]);
            ans = Math.max(ans, tmp);
        }
        return ans;
    }

    // 返回最大累加和的信息
    // - 开头left
    // - 结尾right
    // - 最大累加和sum
    public static int left;

    public static int right;

    public static int sum;

    public static int maxSubArray3(int[] nums) {
        sum = Integer.MIN_VALUE;
        for (int l = 0, r = 0, tmp = Integer.MIN_VALUE; r < nums.length; r++) {
            if (tmp >= 0) {
                tmp += nums[r];
            } else {
                tmp = nums[r];
                l = r;
            }
            if (tmp > sum) {
                sum = tmp;
                left = l;
                right = r;
            }
        }
        return sum;
    }
}
```



## [Leetcode【中】198.打家劫舍](https://leetcode.cn/problems/house-robber/description/)



```java
public class Solution {
    // 给定一个一维整数数组nums
    // 挑选任意数组中不相邻位置的元素
    // 返回最大累加和

    public static int rob1(int[] nums) {
        int n = nums.length;
        if (n == 1) {
            return nums[0];
        }
        if (n == 2) {
            return Math.max(nums[0], nums[1]);
        }
        int[] dp = new int[n];
        dp[0] = nums[0];
        dp[1] = Math.max(nums[0], nums[1]);
        for (int i = 2; i < n; i++) {
            dp[i] = Math.max(dp[i - 1], Math.max(dp[i - 2] + nums[i], nums[i]));
        }
        return dp[n - 1];
    }

    // 空间压缩
    public static int rob2(int[] nums) {
        int n = nums.length;
        if (n == 1) {
            return nums[0];
        }
        if (n == 2) {
            return Math.max(nums[0], nums[1]);
        }
        int prepre = nums[0];
        int pre = Math.max(nums[0], nums[1]);
        for (int i = 2; i < n; i++) {
            int cur = Math.max(pre, Math.max(prepre + nums[i], nums[i]));
            prepre = pre;
            pre = cur;
        }
        return pre;
    }
}
```



## [Leetcode【中】918.环形子数组的最大和](https://leetcode.cn/problems/maximum-sum-circular-subarray/description/)



```java
public class Solution {
    // 环形数组nums，位置0和位置n-1位置的元素相邻
    // 返回最大连续非空子数组的最大累加和

    public static int maxSubarraySumCircular(int[] nums) {
        int n = nums.length;
        int all = nums[0];
        // 最大累加和分为两种情况
        // - 最大累加和不跨边界
        //   - 正常求连续数组的最大累加和
        // - 最大累加和跨边界
        //   - 最大累加和 = 数组总和 - 正常求连续数组的最小累加和
        int maxsum = nums[0];
        int minsum = nums[0];
        for (int i = 1, maxpre = nums[0], minpre = nums[0]; i < n; i++) {
            all += nums[i];
            maxpre = Math.max(nums[i], nums[i] + maxpre);
            maxsum = Math.max(maxsum, maxpre);
            minpre = Math.min(nums[i], nums[i] + minpre);
            minsum = Math.min(minsum, minpre);
        }
        // 特殊情况：如果所有元素都是负数
        // 那么最小累加和就是数组总和
        // 那么如果还按照正常求最大跨界累加和的话，答案为0
        // 但实际上应该是最大的那个负数
        return all == minsum ? maxsum : Math.max(maxsum, all - minsum);
    }
}
```



## [Leetcode【中】213.打家劫舍 II](https://leetcode.cn/problems/house-robber-ii/description/)



```java
public class Solution {
    // 给定一一维环形数组，首位相连
    // 任意挑选不能相邻的元素
    // 返回最大累加和

    public static int rob(int[] nums) {
        if (nums.length == 1) {
            return nums[0];
        }
        return Math.max(f(nums, 1, nums.length - 1), nums[0] + f(nums, 2, nums.length - 2));
    }

    // nums[l...r]范围内，挑选任意不相邻的元素，返回最大累加和
    public static int f(int[] nums, int l, int r) {
        if (l > r) {
            return 0;
        }
        if (l == r) {
            return nums[l];
        }
        if (l + 1 == r) {
            return Math.max(nums[l], nums[r]);
        }
        int prepre = nums[l];
        int pre = Math.max(nums[l], nums[l + 1]);
        for (int i = l + 2; i <= r; i++) {
            int cur = Math.max(pre, Math.max(prepre + nums[i], nums[i]));
            prepre = pre;
            pre = cur;
        }
        return pre;
    }
}
```



## [Leetcode【中】2560.打家劫舍 IV](https://leetcode.cn/problems/house-robber-iv/description/)



```java
public class Solution {
    // 给定一个一维数组
    // 给定一个整数k
    // 元素挑选规则
    // - 不能挑选相邻的元素
    // - 挑选的元素个数至少有k个
    // 挑选的标准：元素的大小不能超过ability
    // 返回最小的挑选标准

    public static int minCapability(int[] nums, int k) {
        int n = nums.length;
        // 挑选标准
        // - 上不需要超过元素最大值
        // - 下不需要超过元素最小值
        int l = nums[0], r = nums[0];
        for (int i = 0; i < n; i++) {
            l = Math.min(l, nums[i]);
            r = Math.max(r, nums[i]);
        }
        // 二分查找
        // - 上边界：元素最大值
        // - 下边界：元素最小值
        int mid, ans = 0;
        while (l <= r) {
            mid = l + (r - l) / 2;
            if (mostRob1(nums, n, mid) >= k) {
                ans = mid;
                r = mid - 1;
            } else {
                l = mid + 1;
            }
        }
        return ans;
    }

    // 盗贼能力为ability时
    // 最多能挑选多少不相邻的元素

    // 记忆化搜索
    public static int mostRob1(int[] nums, int n, int ability) {
        if (n == 1) {
            return nums[0] <= ability ? 1 : 0;
        }
        if (n == 2) {
            return (nums[0] <= ability || nums[1] <= ability) ? 1 : 0;
        }
        int[] dp = new int[n];
        dp[0] = nums[0] <= ability ? 1 : 0;
        dp[1] = (nums[0] <= ability || nums[1] <= ability) ? 1 : 0;
        for (int i = 2; i < n; i++) {
            dp[i] = Math.max(dp[i - 1], (nums[i] <= ability ? 1 : 0) + dp[i - 2]);
        }
        return dp[n - 1];
    }

    // 空间压缩
    public static int mostRob2(int[] nums, int n, int ability) {
        if (n == 1) {
            return nums[0] <= ability ? 1 : 0;
        }
        if (n == 2) {
            return (nums[0] <= ability || nums[1] <= ability) ? 1 : 0;
        }
        int prepre = nums[0] <= ability ? 1 : 0;
        int pre = (nums[0] <= ability || nums[1] <= ability) ? 1 : 0;
        for (int i = 2; i < n; i++) {
            int cur = Math.max(pre, (nums[i] <= ability ? 1 : 0) + prepre);
            prepre = pre;
            pre = cur;
        }
        return pre;
    }

    // 贪心优化
    public static int mostRob3(int[] nums, int n, int ability) {
        int ans = 0;
        for (int i = 0; i < n; i++) {
            if (nums[i] <= ability) {
                ans++;
                i++;
            }
        }
        return ans;
    }
}
```



## [Leetcode【难】面试题 17.24.最大子矩阵](https://leetcode.cn/problems/max-submatrix-lcci/description/)



```java
import java.util.Arrays;

public class Solution {
    // 给定一个二维矩阵grid
    // 返回最大子矩阵累加和的左上角和右下角坐标

    // 压缩数组（降维）
    public static int[] getMaxMatrix(int[][] grid) {
        int n = grid.length;
        int m = grid[0].length;
        int max = Integer.MIN_VALUE;
        int a = 0, b = 0, c = 0, d = 0;
        int[] nums = new int[m];
        // 遍历压缩数组的起始行
        for (int i = 0; i < n; i++) {
            Arrays.fill(nums, 0);
            // 遍历当前压缩数组起始行下对应的结束行
            for (int j = i; j < n; j++) {
                // 更新当前的压缩数组
                // 一维数组最大连续子数组的累加和
                for (int l = 0, r = 0, pre = Integer.MIN_VALUE; r < m; r++) {
                    nums[r] += grid[j][r];
                    if (pre >= 0) {
                        pre += nums[r];
                    } else {
                        pre = nums[r];
                        l = r;
                    }
                    if (pre > max) {
                        max = pre;
                        a = i;
                        b = l;
                        c = j;
                        d = r;
                    }
                }
            }
        }
        return new int[] { a, b, c, d };
    }
}
```



***



# ✅071【必备】子数组最大累加和与扩展-下



## [Leetcode【中】152.乘积最大子数组](https://leetcode.cn/problems/maximum-product-subarray/description/)



```java
public class Solution {
    // 给定一个整数数组nums
    // 返回最大非空连续子数组的乘积

    public static int maxProduct(int[] nums) {
        // 数组元素存在负数
        // - 当前元素为<0时，那么以当前元素结尾的最大连续子数组的乘积
        //   - 可能是当前元素<0本身
        //   - 也可能是当前元素<0与之前的最大连续子数组>0的乘积
        //   - 也可能是当前元素<0与之前的最大连续子数组<0的乘积
        //   - 也可能是当前元素<0与之前的最小连续子数组>0的乘积
        //   - 也可能是当前元素<0与之前的最小连续子数组<0的乘积
        // - 当前元素为>0时，那么以当前元素结尾的最大连续子数组的乘积
        //   - 可能是当前元素>0本身
        //   - 也可能是当前元素>0与之前的最大连续子数组>0的乘积
        double ans = nums[0], min = nums[0], max = nums[0], curmin, curmax;
        for (int i = 1; i < nums.length; i++) {
            curmin = Math.min(nums[i], Math.min(min * nums[i], max * nums[i]));
            curmax = Math.max(nums[i], Math.max(min * nums[i], max * nums[i]));
            min = curmin;
            max = curmax;
            ans = Math.max(ans, max);
        }
        return (int) ans;
    }
}
```



## [Leetcode【难】689.三个无重复子数组的最大和](https://leetcode.cn/problems/maximum-sum-of-3-non-overlapping-subarrays/description/)



```java
import java.util.Arrays;

public class Solution {
    // 给定一个整数数组nums，一个整数k
    // 找出三个长度为k、互不重叠，全部数字和最大的子数组
    // 返回这三个子数组的起始位置
    // 如果存在多个结果，返回字典序最小的那组

    public static int[] maxSumOfThreeSubarrays(int[] nums, int k) {
        int n = nums.length;
        // sums[i]：以nums[i]开头的长度为k的子数组的累加和
        int[] sums = new int[n];
        for (int l = 0, r = 0, sum = 0; r < n; r++) {
            sum += nums[r];
            if (r - l + 1 == k) {
                sums[l] = sum;
                sum -= nums[l];
                l++;
            }
        }
        // prefix[i]：[0~i]范围内所有长度为k的子数组中，最大累加和的子数组的起始位置
        int[] prefix = new int[n];
        // Arrays.fill(prefix, 0);
        // 初始化第k-1个元素：就是[0~i]=[0~k-1]刚好只有一个子数组
        prefix[k - 1] = 0;
        for (int i = k; i < n - 2 * k; i++) {
            // 如果当前位置往前数k个元素的累加和大于前一个位置的prefix
            if (sums[i - (k - 1)] > sums[prefix[i - 1]]) {
                prefix[i] = i - (k - 1);
            } else {
                prefix[i] = prefix[i - 1];
            }
        }
        // suffix[i]：[i~n-1]范围内所有长度为k的子数组中，最大累加和的子数组的起始位置
        int[] suffix = new int[n];
        // Arrays.fill(suffix, 0);
        // 初始化第n-k个元素：就是[i~n-1]=[n-k~n-1]刚好只有一个子数组
        suffix[n - k] = n - k;
        for (int i = n - k - 1; i >= 2 * k - 1; i--) {
            // 如果当前位置往后数k个元素的累加和大于后一个位置的suffix
            // 或者等于后一个位置的suffix，但是当前位置的字典序更小
            if (sums[i] >= sums[suffix[i + 1]]) {
                suffix[i] = i;
            } else {
                suffix[i] = suffix[i + 1];
            }
        }
        // 遍历位于中间的起始位置i，结束位置j，长度为k的数组
        // - 可移动的范围[k,n-k]
        // 那么左侧的最大累加和的子数组的起始位置为prefix[i-1]
        // 那么右侧的最大累加和的子数组的起始位置为suffix[j+1]
        int a = 0, b = 0, c = 0, max = 0;
        for (int p, s, i = k, j = k + k - 1, sum; j < n - k; i++, j++) {
            p = prefix[i - 1];
            s = suffix[j + 1];
            sum = sums[p] + sums[i] + sums[s];
            if (sum > max) {
                max = sum;
                a = p;
                b = i;
                c = s;
            }
        }
        return new int[] { a, b, c };
    }
}
```



***



# ✅072【必备】最长递增子序列与扩展



## [Leetcode【中】300.最长递增子序列](https://leetcode.cn/problems/longest-increasing-subsequence/description/)



```java
public class Solution {
    // 给定一个一维整数数组
    // 返回其中严格递增的最长子序列的长度

    public static int lengthOfLIS1(int[] nums) {
        int n = nums.length;
        // dp[i]表示以nums[i]结尾的最长严格递增子序列的长度
        int[] dp = new int[n];
        int ans = 0;
        for (int i = 0; i < n; i++) {
            // 初始化每个位置的最长严格递增子序列长度为1
            dp[i] = 1;
            // 往前遍历
            for (int j = 0; j < i; j++) {
                // 如果找到一个比nums[i]小的数
                // 那么dp[i]可以更新为dp[j]+1
                // 后续可以继续更新新的dp[i]
                if (nums[j] < nums[i]) {
                    dp[i] = Math.max(dp[i], dp[j] + 1);
                }
            }
            // 更新当前位置往前遍历找到的最长严格递增子序列长度
            ans = Math.max(ans, dp[i]);
        }
        return ans;
    }

    // 最优解
    // 初始化ends数组
    // ends[i]表示当前遍历位置情况下，
    // 长度为i+1的最长严格递增子序列的结尾数字（最小值）
    public static int lengthOfLIS2(int[] nums) {
        int n = nums.length;
        int[] ends = new int[n];
        int len = 0;
        for (int i = 0, find; i < n; i++) {
            find = BS(ends, len, nums[i]);
            if (find == -1) {
                // 如果没有找到
                // 那么当前的数就可以
                // 扩展当前的最长严格递增子序列长度+1
                ends[len++] = nums[i];
            } else {
                // 如果找到了>=num的首个位置
                // 那么当前的数就可以
                // 替换ends数组中该位置的数字
                // 因为当前的数更小
                ends[find] = nums[i];
            }
        }
        return len;
    }

    // 在严格递增数组ends[0...len-1]中
    // 返回>=num的首个位置（一定是最靠左的）
    // 如果不存在返回-1
    public static int BS(int[] ends, int len, int num) {
        int l = 0, r = len - 1, mid, ans = -1;
        while (l <= r) {
            mid = l + (r - l) / 2;
            if (ends[mid] >= num) {
                ans = mid;
                r = mid - 1;
            } else {
                l = mid + 1;
            }
        }
        return ans;
    }
}
```



## [Leetcode【难】354.俄罗斯套娃信封问题](https://leetcode.cn/problems/russian-doll-envelopes/description/)



```java
import java.util.Arrays;

public class Solution {
    // 给定一个二维数组envelopes
    // envelopes[i]=[wi,hi]表示每个信封的宽度和高度
    // 信封嵌套的前提是：
    // - 一个信封的宽度和高度都大于另外一个信封
    // - 信封不准旋转
    // 返回最多可以嵌套多少层

    public static int maxEnvelopes(int[][] envelopes) {
        int n = envelopes.length;
        // 首先对信封进行排序
        // - 宽度升序排序
        // - 若宽度一致,则按高度降序排序
        // (高度降序时为了避免高度一致的也嵌套问题)
        Arrays.sort(envelopes, (a, b) -> a[0] != b[0] ? (a[0] - b[0]) : (b[1] - a[1]));
        // ends[i]表示高度元素中,长度为i+1的最长递增子序列的最小结尾
        int[] ends = new int[n];
        int len = 0;
        // [[1,6],[1,5],[1,2],[2,6],[2,4],[2,2],[5,9],[5,7],[5,1]]
        for (int i = 0, find, num; i < n; i++) {
            // 此时呢,依据 高度元素 找到最长递增子序列的长度
            num = envelopes[i][1];
            find = BS(ends, len, num);
            if (find == -1) {
                ends[len++] = num;
            } else {
                ends[find] = num;
            }
        }
        return len;
    }

    public static int BS(int[] ends, int len, int num) {
        int l = 0, r = len - 1, mid, ans = -1;
        while (l <= r) {
            mid = l + (r - l) / 2;
            if (ends[mid] >= num) {
                ans = mid;
                r = mid - 1;
            } else {
                l = mid + 1;
            }
        }
        return ans;
    }
}
```



## [Leetcode【难】2111.使数组 K 递增的最少操作次数](https://leetcode.cn/problems/minimum-operations-to-make-the-array-k-increasing/description/)



```java
public class Solution {
    // 给定一个一维数组arr,一个正整数k
    // 要求:
    // - 0,k,2k,3k...
    // - 1,k+1,2k+1,3K+1...
    // - 2,k+2,2k+2,3k+3...
    // - k<=i<=n-1,arr[i-k]<=arr[i]
    // 如上的每一组都要求是不下降子序列
    // 我们可以调整任意组任意位置的元素,来满足要求
    // 返回最少需要的操作次数

    // 按组划分,求每一组的最长不下降子序列
    // 累加求和(当前组长度 - 当前组最长不下降子序列长度)

    public static int MAXN = 100001;

    public static int[] nums = new int[MAXN];

    public static int[] ends = new int[MAXN];

    public static int kIncreasing(int[] arr, int k) {
        int n = arr.length;
        int ans = 0;
        for (int i = 0, size; i < k; i++) {
            size = 0;
            for (int j = i; j < n; j += k) {
                nums[size++] = arr[j];
            }
            ans += size - lengthOfNoDecreasing(size);
        }
        return ans;
    }

    // nums[0...size-1]范围内最长不下降子序列的长度
    public static int lengthOfNoDecreasing(int size) {
        int len = 0;
        for (int i = 0, find; i < size; i++) {
            find = BS(len, nums[i]);
            if (find == -1) {
                ends[len++] = nums[i];
            } else {
                ends[find] = nums[i];
            }
        }
        return len;
    }

    public static int BS(int len, int num) {
        int l = 0, r = len - 1, mid, ans = -1;
        while (l <= r) {
            mid = l + (r - l) / 2;
            if (num < ends[mid]) {
                ans = mid;
                r = mid - 1;
            } else {
                l = mid + 1;
            }
        }
        return ans;
    }
}
```



## [Leetcode【中】646.最长数对链](https://leetcode.cn/problems/maximum-length-of-pair-chain/description/)



```java
import java.util.Arrays;

public class Solution {
    // 给定一二维数组pairs
    // pairs[i]=[li,ri]
    // 定义一种跟随关系p
    // 要求:p[i-1][0]<p[i-1][1]<p[i][0]<p[i][1]
    // 返回该跟随关系的最长长度

    // [[1,2],[1,5],[1,7],[3,4],[3,6],[5,6],[5,9]]

    public static int findLongestChain1(int[][] pairs) {
        int n = pairs.length;
        Arrays.sort(pairs, (a, b) -> a[0] != b[0] ? (a[0] - b[0]) : (a[1] - b[1]));
        // ends[i]存储的是长度为i+1的跟随关系最后一对右边界的最小值
        int[] ends = new int[n];
        int len = 0;
        for (int[] pair : pairs) {
            // 遍历pairs数组,每次比较的是
            // pairs[i][0]与ends[j]的大小关系
            int find = BS(ends, len, pair[0]);
            if (find == -1) {
                // 如果当前数对的左边界
                // 大于ends数组中最大数对的右边界
                // 扩展ends数组
                ends[len++] = pair[1];
            } else {
                // 如果当前数对的左边界
                // 小于等于ends数组中某个数对的右边界
                // 选择当前数对和ends数组中该数对的右边界中
                // 较小的
                ends[find] = Math.min(ends[find], pair[1]);
            }
        }
        return len;
    }

    // 找到当前数对的左边界,在ends数组中
    // 首个大于等于当前数对左边界的右边界位置
    public static int BS(int[] ends, int len, int num) {
        int l = 0, r = len - 1, mid, ans = -1;
        while (l <= r) {
            mid = l + (r - l) / 2;
            if (ends[mid] >= num) {
                ans = mid;
                r = mid - 1;
            } else {
                l = mid + 1;
            }
        }
        return ans;
    }

    // [[1,2],[1,5],[1,7],[3,4],[3,6],[5,6],[5,9]]
    // [[1,2],[3,4],[1,5],[3,6],[5,6],[1,7],[5,9]]

    // 贪心
    public static int findLongestChain2(int[][] pairs) {
        int pre = Integer.MIN_VALUE, ans = 0;
        Arrays.sort(pairs, (a, b) -> (a[1] != b[1]) ? (a[1] - b[1]) : (a[0] - b[0]));
        for (int[] pair : pairs) {
            if (pre < pair[0]) {
                pre = pair[1];
                ans++;
            }
        }
        return ans;
    }
}
```



## [洛谷【提高+/省选-】P8776 \[蓝桥杯 2022 省 A\] 最长不下降子序列](https://www.luogu.com.cn/problem/P8776)



```java
import java.io.*;

public class Solution {
    // 给定一个长度为n的数组arr,和一个整数k
    // k表示有一次机会可以将数组arr中连续k个数全部统一修改为任意一个值
    // 机会可用可不用
    // 返回最长不下降子序列长度

    // 将k看作一个宽度为k的滑块,从左边界滑到右边界

    public static int MAXN = 100001;

    public static int[] arr = new int[MAXN];

    public static int[] right = new int[MAXN];

    public static int[] ends = new int[MAXN];

    public static int n, k;

    public static int compute() {
        right();
        int len = 0;
        int ans = 0;
        // 滑块[0,k-1,k]从左边界滑到右边界
        for (int i = 0, j = k, find, left; j < n; i++, j++) {
            // 查找滑块右侧arr[k]在ends数组中
            // 第一个大于arr[k]的位置find
            // ends数组中[0...find-1]+arr[k]
            // 构成了一个滑块左侧的小于滑块右侧arr[k]的最长不下降子序列
            find = BSUp(len, arr[j]);
            left = find == -1 ? len : find;
            // 获取答案
            ans = Math.max(ans, left + k + right[j]);

            // 这里记录arr[0..n-1-k]中
            // ends[i]表示长度为i+1的最长不下降子序列的末尾元素(最小值)
            find = BSUp(len, arr[i]);
            if (find == -1) {
                ends[len++] = arr[i];
            } else {
                ends[find] = arr[i];
            }
        }
        // 这个是特殊情况：
        // 滑块在最右侧
        ans = Math.max(ans, len + k);
        return ans;
    }

    // 辅助数组
    // arr[i..n-1]范围内
    // 以arr[i]开头的最长不下降子序列长度
    // 记录到right[i]中
    public static void right() {
        int len = 0;
        // 从后往前遍历
        // 原始的是从左往右不下降子序列
        // 颠倒一下，从右往左不上升子序列
        // 二者等价

        // 从右往左遍历
        // right[i]就是
        // 以arr[i]开头的最长不下降子序列长度
        for (int i = n - 1; i >= 0; i--) {
            // ends数组中最长不上升子序列中首个大于arr[i]的位置
            int find = BSDown(len, arr[i]);
            if (find == -1) {
                ends[len++] = arr[i];
                // 当前遍历位置i的元素拓展了ends数组长度
                right[i] = len;
            } else {
                ends[find] = arr[i];
                // 当前遍历位置i的元素取代了ends数组中find位置的元素
                right[i] = find + 1;
            }
        }
    }

    // 最长不下降子序列(递增)
    // 1 2 3 4 5 6 7
    // 找到第一个大于num的位置
    // 二分查找
    public static int BSUp(int len, int num) {
        int l = 0, r = len - 1, mid, ans = -1;
        while (l <= r) {
            mid = (l + r) / 2;
            if (ends[mid] > num) {
                ans = mid;
                r = mid - 1;
            } else {
                l = mid + 1;
            }
        }
        return ans;
    }

    // 最长不上升子序列(递减)
    // 7 6 5 4 3 2 1
    // 找到第一个小于num的位置
    // 二分查找
    public static int BSDown(int len, int num) {
        int l = 0, r = len - 1, mid, ans = -1;
        while (l <= r) {
            mid = (l + r) / 2;
            if (ends[mid] < num) {
                ans = mid;
                r = mid - 1;
            } else {
                l = mid + 1;
            }
        }
        return ans;
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            k = (int) in.nval;
            for (int i = 0; i < n; i++) {
                in.nextToken();
                arr[i] = (int) in.nval;
            }
            if (k >= n) {
                out.println(n);
            } else {
                out.println(compute());
            }
        }
        out.flush();
        out.close();
    }
}
```



***



# ✅073【必备】01 背包、有依赖的背包



## [洛谷【普及-】P1048 \[NOIP 2005 普及组\] 采药](https://www.luogu.com.cn/problem/P1048)



```java
import java.io.*;
import java.util.*;

public class Solution {
    // 给定一个整数t，表示背包的容量
    // 给定一个整数m，表示货物的数量
    // costs[i]表示第i个货物的体积
    // values[i]表示第i个货物的价值
    // 返回不超过总容量的情况下，能够获得最大的价值

    public static int MAXM = 101;

    public static int MAXT = 1001;

    public static int[] cost = new int[MAXM];

    public static int[] val = new int[MAXM];

    public static int[][] dp2 = new int[MAXM + 1][MAXT + 1];

    public static int[] dp3 = new int[MAXT];

    public static int t, m;

    // 暴力递归
    public static int compute1() {
        return f(m, t);
    }

    // i：当前处理的还剩多少个物品
    // rest：当前还剩下的容量
    public static int f(int i, int rest) {
        if (i == 0) {
            return 0;
        }
        // 不要i号物品
        int p1 = f(i - 1, rest);
        // 要i号物品
        int p2 = 0;
        if (rest >= cost[i]) {
            p2 = val[i] + f(i - 1, rest - cost[i]);
        }
        return Math.max(p1, p2);
    }

    // 严格位置依赖的动态规划
    public static int compute2() {
        // dp[i][j]
        // 前i个物品，总容量不超过j的前提下，获得价值
        // - dp[i][0]都初始化为0
        //   - 前i个物品，总容量为0，价值一定为0
        // - dp[0][j]都初始化为0
        //   - 前0个物品，总容量为j，价值一定为0
        for (int i = 1; i <= m; i++) {
            for (int j = 0; j <= t; j++) {
                // 不要i号物品
                // - 体积总和没有变化
                // - 等价：前i-1个物品，总容量为j的前提下，获得价值
                dp2[i][j] = dp2[i - 1][j];
                // 要i号物品
                // - 体积总和需要增加cost[i]
                // - 等价：前i-1个物品，总容量为j-cost[i]有意义（大于等于0）的前提下
                //   - 原dp[i][j]
                //   - 前i-1个物品，总容量不超过j-cost[i]，可获得的最大价值dp[i-1][j-cost[i]]+val[i]（当前物品的价值）
                //   - 取较大者
                if (j - cost[i] >= 0) {
                    dp2[i][j] = Math.max(dp2[i][j], dp2[i - 1][j - cost[i]] + val[i]);
                }
            }
        }
        return dp2[m][t];
    }

    // 空间压缩
    public static int compute3() {
        Arrays.fill(dp3, 0, t + 1, 0);
        // 先遍历m个物品
        for (int i = 1; i <= m; i++) {
            // 后遍历t容量
            // 参考2的依赖关系
            // - 当前行的当前位置j
            // - 上一行的当前位置j
            // - 上一行的j-cost[i]位置
            // 因为二者实际为同一行
            // - 修改了为当前行
            // - 没有动为上一行
            // 因此我们需要从后往前遍历
            for (int j = t; j >= cost[i]; j--) {
                dp3[j] = Math.max(dp3[j], dp3[j - cost[i]] + val[i]);
            }
        }
        return dp3[t];
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            t = (int) in.nval;
            in.nextToken();
            m = (int) in.nval;
            for (int i = 1; i <= m; i++) {
                in.nextToken();
                cost[i] = (int) in.nval;
                in.nextToken();
                val[i] = (int) in.nval;
            }
            out.println(compute2());
        }
        out.flush();
        out.close();
    }
}
```



## [Leetcode【易】bytedance-006.夏季特惠](https://leetcode.cn/problems/tJau2o/description/)



```java
import java.io.*;
import java.util.*;

public class Solution {
    // 有x元预算
    // n个游戏均有折扣
    // 原价a_i元，现价b_i元
    // 获得的快乐值w_i
    // 可能存在冲动消费使最终消费超过预算
    // 现在需要：获得的总优惠金额>=超过预算的总金额
    // 就觉得不会吃亏
    // 返回不会亏的最大快乐值

    // 优惠金额=原价-现价
    // 优惠金额相当于变相提升了我们的预算额度
    // 我们每买一个游戏，会花费现价b_i元
    // 但是呢我们的预算也会增加a_i-b_i元
    // 那么如果(a_i-b_i)-b_i>0的话
    // 说明买当前的游戏，预算提升额度>当前游戏花费
    // 那么当前的游戏是一定要买的，我们的预算也会因此增加
    // 当我们初次遍历完一遍所有游戏
    // 处理完必须要买的游戏后
    // 我们此时的“预算”就是我们最终预算
    // 在当前“预算”下，处理那些“需要考虑是否购买”
    // - 也就是提升预算的额度<当前游戏实际花费的
    // - 因为就算我们购买需要考虑的游戏
    // - 这里仍然会累加优惠额度,只不过当前游戏的花费更大
    // - 那么需要考虑的游戏的实际花费就是:
    //   - 现价-优惠额度
    // 必须要买的+需要考虑的游戏中购买的
    // 就是最终的方案

    public static int MAXX = 100001;

    public static int MAXN = 501;

    // 需要考虑是否买的商品
    // - 花费
    public static int[] cost = new int[MAXN];
    // - 快乐值
    public static long[] val = new long[MAXN];

    public static long[] dp = new long[MAXX];

    public static int n, m, x;

    public static long compute() {
        Arrays.fill(dp, 0, x + 1, 0);
        for (int i = 1; i <= m; i++) {
            for (int j = x; j >= cost[i]; j--) {
                dp[j] = Math.max(dp[j], dp[j - cost[i]] + val[i]);
            }
        }
        return dp[x];
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            m = 1;
            in.nextToken();
            x = (int) in.nval;
            long ans = 0;
            long happy = 0;
            for (int i = 1, pre, cur, well; i <= n; i++) {
                in.nextToken();
                // 原价
                pre = (int) in.nval;
                in.nextToken();
                // 现价
                cur = (int) in.nval;
                in.nextToken();
                // 快乐值
                happy = (long) in.nval;

                well = (pre - cur) - cur;
                if (well >= 0) {
                    x += well;
                    ans += happy;
                } else {
                    cost[m] = -well;
                    val[m++] = happy;
                }
            }
            ans += compute();
            out.println(ans);
        }
        out.flush();
        out.close();
    }
}
```



## [Leetcode【中】494.目标和](https://leetcode.cn/problems/target-sum/description/)



```java
import java.util.*;

public class Solution {
    // 给定一个一维非负整数数组nums和一个整数target
    // 数组中每个整数前可以添加'+'或'-'号
    // 例如:nums[2,1]
    // - 串联起来得到"+2-1=1"
    // 返回如上构造下
    // 有多少种不同构造方式最终得到的结果=target

    // 暴力递归
    public static int findTargetSumWays1(int[] nums, int target) {
        return f1(nums, target, 0, 0);
    }

    // nums[0..i-1]范围上形成的累加和为sum
    // 现在来到了nums[i]位置
    // nums[i...]范围上，每个数字前边可以标记'+'或'-'
    public static int f1(int[] nums, int target, int i, int sum) {
        if (i == nums.length) {
            return sum == target ? 1 : 0;
        }
        return f1(nums, target, i + 1, sum + nums[i]) + f1(nums, target, i + 1, sum - nums[i]);
    }

    // 记忆化搜索
    // 因为sum可能取负数
    // 因此我们选择二层哈希表嵌套
    // 第一层哈希表：i->(sum,value)
    // 第二层哈希表：sum->value
    public static int findTargetSumWays2(int[] nums, int target) {
        // i,sum->value
        HashMap<Integer, HashMap<Integer, Integer>> dp = new HashMap<>();
        return f2(nums, target, 0, 0, dp);
    }

    // i:当前我们来到了nums[i]的位置
    // sum:nums[0..i-1]形成的累加和
    // value:从起始状态开始
    // 最终可以得到target的不同构造方式数
    public static int f2(int[] nums, int target, int i, int sum, HashMap<Integer, HashMap<Integer, Integer>> dp) {
        // 递归基
        // 来到数组nums的右边界
        // - 如果当前累加和sum等于target
        // - 则说明找到一种构造方式
        // - 否则说明没有找到
        if (i == nums.length) {
            return sum == target ? 1 : 0;
        }
        // 如果当前状态(i,sum)之前已经计算过
        // 则直接返回缓存的结果
        if (dp.containsKey(i) && dp.get(i).containsKey(sum)) {
            return dp.get(i).get(sum);
        }
        // 如果当前状态(i,sum)之前没有计算过
        // 则递归计算
        // - 分别计算当前位置i添加'+'号和'-'号的情况
        // - 累加两种情况的构造方式数
        int ans = f2(nums, target, i + 1, sum + nums[i], dp) + f2(nums, target, i + 1, sum - nums[i], dp);
        // 缓存当前状态(i,sum)的构造方式数
        dp.putIfAbsent(i, new HashMap<>());
        dp.get(i).put(sum, ans);
        return ans;
    }

    // 记忆化搜索
    // 严格位置依赖的动态规划——平移
    public static int findTargetSumWays3(int[] nums, int target) {
        int sumNum = 0;
        for (int num : nums) {
            sumNum += num;
        }
        if (target < -sumNum || target > sumNum) {
            return 0;
        }
        int n = nums.length;
        // - nums中所有元素前边为'-'号：最小值
        // - nums中所有元素前边为'+'号：最大值
        // -sumNum ~ +sumNum
        // -> 2 * sumNum + 1个元素
        // -> 0 ~ 2 * sumNum
        int m = 2 * sumNum + 1;
        // dp[i][j]：
        // nums[0...i-1]范围上形成的累加和为j-sumNum
        // nums[i...n-1]范围上，每个数字可以标记+或者-
        int[][] dp = new int[n + 1][m];
        // 初始化：
        // - 递归基：nums[0...n-1]范围上形成的累加和恰好为target+sumNum-sumNum
        dp[n][target + sumNum] = 1;
        // 从右往左
        for (int i = n - 1; i >= 0; i--) {
            // 从下往上
            for (int j = -sumNum; j <= sumNum; j++) {
                // nums[i]标记为'+'号，且不越上界
                if (j + nums[i] + sumNum < m) {
                    dp[i][j + sumNum] += dp[i + 1][j + nums[i] + sumNum];
                }
                // nums[i]标记为'-'号，且不越下界
                if (j - nums[i] + sumNum >= 0) {
                    dp[i][j + sumNum] += dp[i + 1][j - nums[i] + sumNum];
                }
            }
        }
        return dp[0][sumNum];
    }

    // 1、
    // 虽然本题是非负数组
    // 但是因为每个元素前边可以添加'+'或'-'号
    // 因此无论是非负数组,还是任意整数数组,无伤大雅
    // 2、
    // （剪枝）
    // - 如果所有非负nums元素累加和<target
    // - 如果所有负nums元素累加和>target
    // 则说明无论如何构造都无法得到target
    // 因此直接返回0
    // 3、
    // （剪枝）
    // 对于非负数组，无论每个元素前边为'+'号还是'-'号
    // 最终形成的累加和的奇偶性不会改变
    // 那么所有非负nums元素累加和需要和target的奇偶性一致
    // 才会存在答案
    // 4、
    // 对于非负数组，无非是将数组元素划分为两组
    // 使得sum(A)-sum(B)=target
    // 继续sum(A)-sum(B)+sum(A)+sum(B)=target+sum(A)+sum(B)
    // 因此sum(A)=(target+非负数组元素累加和)/2
    // 即返回有多少种挑选方案，使得其累加和为特定结果
    public static int findTargetSumWays4(int[] nums, int target) {
        int sum = 0;
        for (int n : nums) {
            sum += n;
        }
        if ((sum < target) || (-sum > target) || (((sum & 1) ^ (target & 1)) == 1)) {
            return 0;
        }
        return f(nums, (target + sum) >> 1);
    }

    // 非负数组nums
    // 选择若干元素，使得累加和为t
    // 返回方案数

    // 01背包+空间压缩
    // dp[i][j]=dp[i-1][j]+dp[i-1][j-num]
    public static int f(int[] nums, int t) {
        if (t < 0) {
            return 0;
        }
        int[] dp = new int[t + 1];
        // 初始化：
        // - 一个元素都不选择，累加和为0的方案数为1（空集）
        dp[0] = 1;
        // 从上往下
        for (int num : nums) {
            // 从右往左
            for (int j = t; j >= num; j--) {
                dp[j] += dp[j - num];
            }
        }
        return dp[t];
    }
}
```



## [Leetcode【中】1049.最后一块石头的重量 II](https://leetcode.cn/problems/last-stone-weight-ii/description/)



```java
public class Solution {
    // 给定一个一维整数数组stones
    // stones[i]表示第i块石头的重量
    // 每一回合任意挑选两个石头x,y
    // 每次粉碎结果：
    // - x==y,两块石头都会被完全粉碎
    // - x<y ,x会被完全粉碎，y的新重量为y-x
    // 返回最后只剩下的一块石头的最小可能重量
    // 没有石头剩下，返回0

    public static int lastStoneWeightII(int[] stones) {
        int sum = 0;
        for (int num : stones) {
            sum += num;
        }
        // 从nums中任意选择一组元素
        // 使得其累加和尽可能接近<=sum/2
        int near = f(stones, sum / 2);
        // 最后剩下的石头重量总和为sum-near
        return sum - near - near;
    }

    // 非负数组中,选择若干元素,使得其累加和尽可能接近t
    // 01背包问题(子集累加和尽量接近t) + 空间压缩
    public static int f(int[] nums, int t) {
        int[] dp = new int[t + 1];
        for (int num : nums) {
            for (int j = t; j >= num; j--) {
                // dp[i][j] = Math.max(dp[i-1][j], dp[i-1][j-nums[i]]+nums[i])
                dp[j] = Math.max(dp[j], dp[j - num] + num);
            }
        }
        return dp[t];
    }
}
```



## [洛谷【普及+/提高】P1064 \[NOIP 2006 提高组\] 金明的预算方案](https://www.luogu.com.cn/problem/P1064)



```java
import java.io.*;
import java.util.*;

public class Solution {
    // 每个主件有若干附件,每个附件想购买必须先购买主件
    // m个物品:
    // - 1~m:物品编号
    // - vi:价格(花费)
    // - pi:重要程度(价格*重要程度=收益)
    // - qi:主件编号(0表示主件)(最多2个附件)
    // 总预算n,返回最大收益

    public static int MAXN = 33001;

    public static int MAXM = 61;

    // 花费
    public static int[] cost = new int[MAXM];
    // 收益
    public static int[] val = new int[MAXM];
    // 主件
    public static boolean[] king = new boolean[MAXM];
    // 附件数量
    public static int[] fans = new int[MAXM];
    // 附件
    public static int[][] follows = new int[MAXM][2];

    public static int[][] dp1 = new int[MAXM][MAXN];

    public static int[] dp2 = new int[MAXN];

    public static int n, m;

    public static void clear() {
        for (int i = 0; i <= m; i++) {
            Arrays.fill(dp1[i], 0);
        }
        Arrays.fill(dp2, 0);
        Arrays.fill(fans, 0);
        Arrays.fill(king, false);
        for (int i = 0; i < 2; i++) {
            Arrays.fill(follows[i], 0);
        }
        Arrays.fill(cost, 0);
        Arrays.fill(val, 0);
    }

    // 严格位置依赖的动态规划
    public static int compute1() {
        // 上一次展开的主商品编号
        int p = 0;
        for (int i = 1, fan1, fan2; i <= m; i++) {
            // 主件
            if (king[i]) {
                for (int j = 0; j <= n; j++) {
                    // 不购买当前主商品
                    dp1[i][j] = dp1[p][j];
                    // 购买当前主商品
                    if (j - cost[i] >= 0) {
                        dp1[i][j] = Math.max(dp1[i][j], dp1[p][j - cost[i]] + val[i]);
                    }
                    fan1 = fans[i] >= 1 ? follows[i][0] : -1;
                    fan2 = fans[i] >= 2 ? follows[i][1] : -1;
                    // 主商品+附件1
                    if (fan1 != -1 && j - cost[i] - cost[fan1] >= 0) {
                        dp1[i][j] = Math.max(dp1[i][j], dp1[p][j - cost[i] - cost[fan1]] + val[i] + val[fan1]);
                    }
                    // 主商品+附件2
                    if (fan2 != -1 && j - cost[i] - cost[fan2] >= 0) {
                        dp1[i][j] = Math.max(dp1[i][j], dp1[p][j - cost[i] - cost[fan2]] + val[i] + val[fan2]);
                    }
                    // 主商品+附件1+附件2
                    if (fan1 != -1 && fan2 != -1 && j - cost[i] - cost[fan1] - cost[fan2] >= 0) {
                        dp1[i][j] = Math.max(dp1[i][j],
                                dp1[p][j - cost[i] - cost[fan1] - cost[fan2]] + val[i] + val[fan1] + val[fan2]);
                    }
                }
                // 更新上一次展开的主商品编号
                p = i;
            }
        }
        // 返回最后一次展开的主商品编号的最大收益
        return dp1[p][n];
    }

    // 空间压缩
    public static int compute2() {
        for (int i = 1, fan1, fan2; i <= m; i++) {
            // 主件
            if (king[i]) {
                for (int j = n; j >= cost[i]; j--) {
                    // 不购买当前商品
                    // dp2[j] = dp2[j];
                    // 购买当前主商品
                    dp2[j] = Math.max(dp2[j], dp2[j - cost[i]] + val[i]);
                    // 附件1
                    fan1 = fans[i] >= 1 ? follows[i][0] : -1;
                    // 主商品+附件1
                    if (fan1 != -1 && j - cost[i] - cost[fan1] >= 0) {
                        dp2[j] = Math.max(dp2[j], dp2[j - cost[i] - cost[fan1]] + val[i] + val[fan1]);
                    }
                    // 附件2
                    fan2 = fans[i] >= 2 ? follows[i][1] : -1;
                    // 主商品+附件2
                    if (fan2 != -1 && j - cost[i] - cost[fan2] >= 0) {
                        dp2[j] = Math.max(dp2[j], dp2[j - cost[i] - cost[fan2]] + val[i] + val[fan2]);
                    }
                    // 主商品+附件1+附件2
                    if (fan1 != -1 && fan2 != -1 && j - cost[i] - cost[fan1] - cost[fan2] >= 0) {
                        dp2[j] = Math.max(dp2[j],
                                dp2[j - cost[i] - cost[fan1] - cost[fan2]] + val[i] + val[fan1] + val[fan2]);
                    }
                }
            }
        }
        // 返回最大收益
        return dp2[n];
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            m = (int) in.nval;
            clear();
            for (int i = 1, v, p, q; i <= m; i++) {
                in.nextToken();
                v = (int) in.nval;
                in.nextToken();
                p = (int) in.nval;
                in.nextToken();
                q = (int) in.nval;
                // 花费
                cost[i] = v;
                // 收益
                val[i] = v * p;
                // 主件
                king[i] = q == 0;
                // 附件
                if (q != 0) {
                    // 主件q的附件数量+1,并存储对于附件编号
                    follows[q][fans[q]++] = i;
                }
            }
            out.println(compute1());
        }
        out.flush();
        out.close();
    }
}
```



## [牛客【】购物单](https://www.nowcoder.com/practice/f9c6f980eeec43ef85be20755ddbeaf4)



```java
import java.io.*;
import java.util.*;

public class Solution {
    // 每个主件有若干附件,每个附件想购买必须先购买主件
    // m个物品:
    // - 1~m:物品编号
    // - vi:价格(花费)
    // - pi:重要程度(价格*重要程度=收益)
    // - qi:主件编号(0表示主件)(最多2个附件)
    // 总预算n,返回最大收益

    public static int MAXN = 33001;

    public static int MAXM = 61;

    // 花费
    public static int[] cost = new int[MAXM];
    // 收益
    public static int[] val = new int[MAXM];
    // 主件
    public static boolean[] king = new boolean[MAXM];
    // 附件数量
    public static int[] fans = new int[MAXM];
    // 附件
    public static int[][] follows = new int[MAXM][2];

    public static int[][] dp1 = new int[MAXM][MAXN];

    public static int[] dp2 = new int[MAXN];

    public static int n, m;

    public static void clear() {
        for (int i = 0; i <= m; i++) {
            Arrays.fill(dp1[i], 0);
        }
        Arrays.fill(dp2, 0);
        Arrays.fill(fans, 0);
        Arrays.fill(king, false);
        for (int i = 0; i < 2; i++) {
            Arrays.fill(follows[i], 0);
        }
        Arrays.fill(cost, 0);
        Arrays.fill(val, 0);
    }

    // 严格位置依赖的动态规划
    public static int compute1() {
        // 上一次展开的主商品编号
        int p = 0;
        for (int i = 1, fan1, fan2; i <= m; i++) {
            // 主件
            if (king[i]) {
                for (int j = 0; j <= n; j++) {
                    // 不购买当前主商品
                    dp1[i][j] = dp1[p][j];
                    // 购买当前主商品
                    if (j - cost[i] >= 0) {
                        dp1[i][j] = Math.max(dp1[i][j], dp1[p][j - cost[i]] + val[i]);
                    }
                    fan1 = fans[i] >= 1 ? follows[i][0] : -1;
                    fan2 = fans[i] >= 2 ? follows[i][1] : -1;
                    // 主商品+附件1
                    if (fan1 != -1 && j - cost[i] - cost[fan1] >= 0) {
                        dp1[i][j] = Math.max(dp1[i][j], dp1[p][j - cost[i] - cost[fan1]] + val[i] + val[fan1]);
                    }
                    // 主商品+附件2
                    if (fan2 != -1 && j - cost[i] - cost[fan2] >= 0) {
                        dp1[i][j] = Math.max(dp1[i][j], dp1[p][j - cost[i] - cost[fan2]] + val[i] + val[fan2]);
                    }
                    // 主商品+附件1+附件2
                    if (fan1 != -1 && fan2 != -1 && j - cost[i] - cost[fan1] - cost[fan2] >= 0) {
                        dp1[i][j] = Math.max(dp1[i][j],
                                dp1[p][j - cost[i] - cost[fan1] - cost[fan2]] + val[i] + val[fan1] + val[fan2]);
                    }
                }
                // 更新上一次展开的主商品编号
                p = i;
            }
        }
        // 返回最后一次展开的主商品编号的最大收益
        return dp1[p][n];
    }

    // 空间压缩
    public static int compute2() {
        for (int i = 1, fan1, fan2; i <= m; i++) {
            // 主件
            if (king[i]) {
                for (int j = n; j >= cost[i]; j--) {
                    // 不购买当前商品
                    // dp2[j] = dp2[j];
                    // 购买当前主商品
                    dp2[j] = Math.max(dp2[j], dp2[j - cost[i]] + val[i]);
                    // 附件1
                    fan1 = fans[i] >= 1 ? follows[i][0] : -1;
                    // 主商品+附件1
                    if (fan1 != -1 && j - cost[i] - cost[fan1] >= 0) {
                        dp2[j] = Math.max(dp2[j], dp2[j - cost[i] - cost[fan1]] + val[i] + val[fan1]);
                    }
                    // 附件2
                    fan2 = fans[i] >= 2 ? follows[i][1] : -1;
                    // 主商品+附件2
                    if (fan2 != -1 && j - cost[i] - cost[fan2] >= 0) {
                        dp2[j] = Math.max(dp2[j], dp2[j - cost[i] - cost[fan2]] + val[i] + val[fan2]);
                    }
                    // 主商品+附件1+附件2
                    if (fan1 != -1 && fan2 != -1 && j - cost[i] - cost[fan1] - cost[fan2] >= 0) {
                        dp2[j] = Math.max(dp2[j],
                                dp2[j - cost[i] - cost[fan1] - cost[fan2]] + val[i] + val[fan1] + val[fan2]);
                    }
                }
            }
        }
        // 返回最大收益
        return dp2[n];
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            m = (int) in.nval;
            clear();
            for (int i = 1, v, p, q; i <= m; i++) {
                in.nextToken();
                v = (int) in.nval;
                in.nextToken();
                p = (int) in.nval;
                in.nextToken();
                q = (int) in.nval;
                // 花费
                cost[i] = v;
                // 收益
                val[i] = v * p;
                // 主件
                king[i] = q == 0;
                // 附件
                if (q != 0) {
                    // 主件q的附件数量+1,并存储对于附件编号
                    follows[q][fans[q]++] = i;
                }
            }
            out.println(compute1());
        }
        out.flush();
        out.close();
    }
}
```



***



# ✅074【必备】分组背包、完全背包



## [洛谷【普及-】P1757 通天之分组背包](https://www.luogu.com.cn/problem/P1757)



```java
import java.util.*;
import java.io.*;

public class Solution {
    // 给定一个正整数m，表示背包的容量
    // 给定一个正整数n，表示货物的数量
    // 给定一个数组arr
    // - arr[i][0]表示货物i的体积
    // - arr[i][1]表示货物i的价值
    // - arr[i][2]表示货物i的组号
    // 同一组中货物最多只能挑选1件
    // 返回最大价值

    public static int MAXM = 1001;

    public static int MAXN = 1001;

    public static int[][] arr = new int[MAXN][3];

    public static int m, n;

    public static int f1() {
        int teams = 1;
        for (int i = 2; i <= n; i++) {
            if (arr[i - 1][2] != arr[i][2]) {
                teams++;
            }
        }
        // dp[i][j]
        // 1~i组范围内，每组物品最多挑选1个，容量不超过j的最大价值
        int[][] dp = new int[teams + 1][m + 1];
        // 初始化
        // dp[0][...]=0：0组挑选物品，容量任意，价值恒为0
        // dp[...][0]=0:任意组挑选物品，容量为0，价值最大为0
        for (int start = 1, end = 2, i = 1; start <= n; i++) {
            while (end <= n && arr[end][2] == arr[start][2]) {
                end++;
            }
            // start...end-1 -> i组
            for (int j = 0; j <= m; j++) {
                // 不选第i组的物品
                dp[i][j] = dp[i - 1][j];
                // 遍历选择第i组的所有物品
                for (int k = start; k < end; k++) {
                    if (j >= arr[k][0]) {
                        dp[i][j] = Math.max(dp[i][j], dp[i - 1][j - arr[k][0]] + arr[k][1]);
                    }
                }
            }
            // 处理下一组物品
            start = end++;
        }
        // 返回最大价值
        return dp[teams][m];
    }

    public static int f2() {
        int[] dp = new int[m + 1];
        for (int start = 1, end = 2; start <= n;) {
            while (end <= n && arr[end][2] == arr[start][2]) {
                end++;
            }
            // 不选第i组的物品
            // dp[j]=dp[j];
            // 选择第i组的物品
            // - 因为，这里是当前行当前位置依赖上一行当前位置和上一行当前左侧位置
            // - 但实际上，二者为一行
            // - 修改了就是当前行，还没动，就是上一行
            // - 如果我们从左往右遍历，前边遍历过的位置变成了当前行，而我们还需要这些位置上一行的数据
            // - 因此我们需要从右往左遍历
            for (int j = m; j >= 0; j--) {
                for (int k = start; k < end; k++) {
                    if (j >= arr[k][0]) {
                        dp[j] = Math.max(dp[j], dp[j - arr[k][0]] + arr[k][1]);
                    }
                }
            }
            // 处理下一组物品
            start = end++;
        }
        // 返回最大价值
        return dp[m];
    }

    public static void main(String[] args) throws Exception {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            m = (int) in.nval;
            in.nextToken();
            n = (int) in.nval;
            for (int i = 1; i <= n; i++) {
                in.nextToken();
                arr[i][0] = (int) in.nval;
                in.nextToken();
                arr[i][1] = (int) in.nval;
                in.nextToken();
                arr[i][2] = (int) in.nval;
            }
            Arrays.sort(arr, 0, n, (a, b) -> a[2] - b[2]);
            out.println(f1());
            out.println(f2());
        }
        out.flush();
        out.close();
    }
}
```



## [Leetcode【难】2218.从栈中取出 K 个硬币的最大面值和](https://leetcode.cn/problems/maximum-value-of-k-coins-from-piles/description/)



```java
import java.util.*;

public class Solution {
    // 现在呢有n个硬币栈，每个栈中均有正整数个带面值的硬币
    // 每一次操作，从任意一个栈的栈顶弹出一个硬币，并从栈中移除
    // 给定一个二维数组piles
    // piles[i]表示第i个栈中从顶到底的硬币面值
    // 给定一个正整数m
    // 返回m次操作下，取出的最大硬币面值之和

    // 如何转化为分组背包
    // 每个栈看作一组
    // - 方案一：拿出0个硬币
    // - 方案二：拿出1个硬币
    // - 方案三：拿出2个硬币
    // ...
    // - 方案k：拿出k个硬币
    // 当前组也就是只能k种方案选一个

    public static int maxValueOfCoins1(List<List<Integer>> piles, int m) {
        // 组数
        int n = piles.size();
        // dp[i][j]
        // [1~i]组范围内，每组选择一种方案，操作数不超过j的情况下，最大的硬币面值之和
        // 初始数
        // - dp[0][j]=0：不考虑任何组，操作数不超过j的情况下，最大的硬币面值之和为0
        // - dp[i][0]=0：考虑[1~i]组，操作数不超过0的情况下，最大的硬币面值之和为0
        int[][] dp = new int[n + 1][m + 1];
        for (int i = 1; i <= n; i++) {
            // 当前组
            List<Integer> team = piles.get(i - 1);
            // 小剪枝
            // - 当前组的硬币数超过m，当前组最多只能操作m次
            // - 当前组的硬币数不足m，当前组最多只能操作当前组的硬币数次
            int t = Math.min(team.size(), m);
            int[] teamSum = new int[t + 1];
            // teamSum[k]：当前组拿出k个硬币的面值之和
            for (int k = 0, sum = 0; k < t; k++) {
                sum += team.get(k);
                teamSum[k + 1] = sum;
            }
            for (int j = 0; j <= m; j++) {
                // 不选当前组的任何硬币
                dp[i][j] = dp[i - 1][j];
                // 选当前组的k个硬币
                for (int k = 1; k <= Math.min(t, j); k++) {
                    dp[i][j] = Math.max(dp[i][j], dp[i - 1][j - k] + teamSum[k]);
                }
            }
        }
        return dp[n][m];
    }

    // 空间压缩
    public static int maxValueOfCoins2(List<List<Integer>> piles, int m) {
        int[] dp = new int[m + 1];
        for (List<Integer> team : piles) {
            int t = Math.min(team.size(), m);
            int[] teamSum = new int[t + 1];
            for (int j = 0, sum = 0; j < t; j++) {
                sum += team.get(j);
                teamSum[j + 1] = sum;
            }
            for (int j = m; j > 0; j--) {
                for (int k = 1; k <= Math.min(t, j); k++) {
                    dp[j] = Math.max(dp[j], dp[j - k] + teamSum[k]);
                }
            }
        }
        return dp[m];
    }
}
```



## [洛谷【普及-】P1616 疯狂的采药](https://www.luogu.com.cn/problem/P1616)



```java
import java.io.*;

public class Solution {
    // 给定一个整数t，表示背包容量
    // 给定一个整数m，表示有m种货物
    // - costs[i]:第i种货物的体积
    // - weights[i]:第i种货物的价值
    // 每种货物可以不限量拿
    // 返回最大价值

    public static int MAXT = 10000001;

    public static int MAXM = 10001;

    public static int[] cost = new int[MAXM];

    public static int[] val = new int[MAXM];

    public static int t, m;

    public static long f1() {
        // dp[i][j]
        // 表示前i种商品，体积不超过j的情况下，最大价值
        // - dp[0][j]:前0种商品，体积不超过j的情况下，最大价值，0
        // - dp[i][0]:前i种商品，体积不超过0的情况下，最大价值，0
        long[][] dp = new long[m + 1][t + 1];
        // 遍历m种商品，编号1~m
        for (int i = 1; i <= m; i++) {
            // 遍历总体积不超过t的所有情况
            for (int j = 0; j <= t; j++) {
                // i号商品一个都不要：
                // 前i种商品，体积不超过j的情况下，最大价值
                // 等于
                // 前i-1种商品，体积不超过j的情况下，最大价值
                dp[i][j] = dp[i - 1][j];
                // 要i号商品
                // - 限定体积不超过cost[i]
                //   - j的范围：[0,cost[i]-1]
                //   - 都直接等价于dp[i-1][j]
                // - 限定体积超过cost[i]
                //   - 要1个i号商品
                //     - j的范围：[cost[i],2*cost[i]-1]
                //     - 比较dp[i][j]：也就是等价于前i-1种商品，体积不超过j的情况下，最大价值
                //     - 和dp[i][j-cost[i]]+val[i]：前i-1种商品，体积不超过j-cost[i]的情况下，最大价值+1个i号商品的价值
                //   - 要2个i号商品
                //     - j的范围：[2*cost[i],3*cost[i]-1]
                //   - ...
                if (j >= cost[i]) {
                    dp[i][j] = Math.max(dp[i][j], dp[i][j - cost[i]] + val[i]);
                }
            }
        }
        return dp[m][t];
    }

    public static long f2() {
        long[] dp = new long[t + 1];
        // 遍历m种商品，编号1~m
        for (int i = 1; i <= m; i++) {
            // 遍历总体积不超过t的所有情况
            // 这里的当前行当前位置依赖
            // - 上一行当前位置
            // - 当前行当前左侧位置
            // 因为修改了就为当前行,不懂就是上一行
            // 所以我们需要从左往右遍历
            for (int j = cost[i]; j <= t; j++) {
                dp[j] = Math.max(dp[j], dp[j - cost[i]] + val[i]);
            }
        }
        return dp[t];
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            t = (int) in.nval;
            in.nextToken();
            m = (int) in.nval;
            for (int i = 1; i <= m; i++) {
                in.nextToken();
                cost[i] = (int) in.nval;
                in.nextToken();
                val[i] = (int) in.nval;
            }
            out.println(f1());
            out.println(f2());
        }
        out.flush();
        out.close();
    }
}
```



## [Leetcode【难】10.正则表达式匹配](https://leetcode.cn/problems/regular-expression-matching/description/)



```java
public class Solution {
    // 给定两个字符串s、p
    // - s中一定不含有'.'、'*'字符
    // - p中可能含有'.'、'*'字符
    // '.'可以替换为任意一个字符
    // '*'可以让'*'前边的那个字符的数量修改为任意个
    // 默认p中
    // - 不会以'*'开头
    // - 不会有多个'*'相邻
    // 返回p是否可以匹配出s

    // 暴力递归
    public static boolean isMatch1(String str, String pat) {
        char[] s = str.toCharArray();
        char[] p = pat.toCharArray();
        return f1(s, p, 0, 0);
    }

    // s[i...]
    // p[j...]
    // 前者能否被后者匹配出来
    // - 当前的p[j]一定不是'*'
    public static boolean f1(char[] s, char[] p, int i, int j) {
        if (i == s.length) {
            // s没了
            if (j == p.length) {
                // p没了
                return true;
            } else {
                // p还有
                // 此时需要依靠'*'
                // p[j+1]是'*'，那么p[j,j+1]这一组可以消除
                return j + 1 < p.length && p[j + 1] == '*' && f1(s, p, i, j + 2);
            }
        } else if (j == p.length) {
            // s还有
            // p没了
            return false;
        } else {
            // s还有s[i...]
            // p还有p[j...]
            if (j + 1 == p.length || p[j + 1] != '*') {
                // p[j+1]!='*'(二者当前位置需要进行字符匹配判断)
                // 或者
                // p[j+1]越界了
                return (s[i] == p[j] || p[j] == '.') && f1(s, p, i + 1, j + 1);
            } else {
                // p[j+1]=='*'
                // 并且
                // p[j+1]不越界
                // - 不匹配s[i]，消去p[j,j+1]
                boolean p1 = f1(s, p, i, j + 2);
                // - 匹配s[i]：因为p[j+1]='*'的存在，所以我们可以匹配s[i]，但因为我们可以取任意数量的p[j]，所以只移动s[i]的指针
                boolean p2 = (s[i] == p[j] || p[j] == '.') && f1(s, p, i + 1, j);
                return p1 || p2;
            }
        }
    }

    // 记忆化搜索
    public static boolean isMatch2(String str, String pat) {
        char[] s = str.toCharArray();
        char[] p = pat.toCharArray();
        int[][] dp = new int[s.length + 1][p.length + 1];
        return f2(s, p, 0, 0, dp);
    }

    // dp[i][j]==0: 表示i,j这个位置没有计算过
    // dp[i][j]==1: 表示i,j这个位置计算过，返回true
    // dp[i][j]==-1: 表示i,j这个位置计算过，返回false
    public static boolean f2(char[] s, char[] p, int i, int j, int[][] dp) {
        if (dp[i][j] != 0) {
            return dp[i][j] == 1;
        }
        boolean ans;
        if (i == s.length) {
            // s没了
            if (j == p.length) {
                // p也没了
                ans = true;
            } else {
                // p还有
                // 此时需要依靠'*'
                // p[j+1]是'*'，那么p[j,j+1]这一组可以消除
                ans = j + 1 < p.length && p[j + 1] == '*' && f2(s, p, i, j + 2, dp);
            }
        } else if (j == p.length) {
            // s还有
            // p没了
            ans = false;
        } else {
            // s还有
            // p还有
            if (j + 1 == p.length || p[j + 1] != '*') {
                // p[j+1]越界
                // 或者
                // p[j+1]不是'*'
                ans = (s[i] == p[j] || p[j] == '.') && f2(s, p, i + 1, j + 1, dp);
            } else {
                // p[j+1]不越界
                // 且
                // p[j+1]是'*'
                ans = (f2(s, p, i, j + 2, dp)) || ((s[i] == p[j] || p[j] == '.') && f2(s, p, i + 1, j, dp));
            }
        }
        dp[i][j] = ans ? 1 : -1;
        return ans;
    }

    // 空间压缩
    public static boolean isMatch3(String str, String pat) {
        char[] s = str.toCharArray();
        char[] p = pat.toCharArray();
        int n = s.length;
        int m = p.length;
        // dp[i][j]表示s[i...]是否可以被p[j...]匹配出来
        boolean[][] dp = new boolean[n + 1][m + 1];
        // 初始化
        // - 即s没了，p也没了
        // - dp[n][m]=true: 表示s[n...]可以被p[m...]匹配出来
        dp[n][m] = true;
        // - s没了，p还有
        // - dp[n][j]需要
        //   - p[j+1]是'*'，那么p[j,j+1]这一组可以消除
        //   - p[j+2]后续也需要可以消除
        for (int j = m - 1; j >= 0; j--) {
            dp[n][j] = j + 1 < m && p[j + 1] == '*' && dp[n][j + 2];
        }
        // - s还有，p没了
        // - dp[i][m]=false: 表示s[i...]不能被p[m...]匹配出来
        for (int i = n - 1; i >= 0; i--) {
            dp[i][m] = false;
        }
        // s还有，p还有
        for (int i = n - 1; i >= 0; i--) {
            for (int j = m - 1; j >= 0; j--) {
                if (j + 1 == m || p[j + 1] != '*') {
                    // p[j+1]越界
                    // 或者
                    // p[j+1]不是'*'
                    dp[i][j] = (s[i] == p[j] || p[j] == '.') && dp[i + 1][j + 1];
                } else {
                    // p[j+1]不越界
                    // 且
                    // p[j+1]是'*'
                    // - 不匹配s[i]，消去p[j,j+1]
                    boolean p1 = dp[i][j + 2];
                    // - 匹配s[i]：因为p[j+1]='*'的存在，所以我们可以匹配s[i]，但因为我们可以取任意数量的p[j]，所以只移动s[i]的指针
                    boolean p2 = (s[i] == p[j] || p[j] == '.') && dp[i + 1][j];
                    dp[i][j] = p1 || p2;
                }
            }
        }
        return dp[0][0];
    }
}
```



## [Leetcode【难】44.通配符匹配](https://leetcode.cn/problems/wildcard-matching/description/)



```java
public class Solution {
    // 给定两个字符串s、p
    // - s中一定不含有'?'、'*'字符
    // - p中可能含有'?'、'*'字符
    // '?'可以替换为任意一个字符
    // '*'可以匹配任意字符串
    // 返回p是否可以匹配出s

    // 暴力递归
    public static boolean isMatch1(String str, String pat) {
        char[] s = str.toCharArray();
        char[] p = pat.toCharArray();
        return f1(s, p, 0, 0);
    }

    // s[i...]
    // p[j...]
    // 前者能否被后者匹配出来
    public static boolean f1(char[] s, char[] p, int i, int j) {
        if (i == s.length) {
            // s没了
            if (j == p.length) {
                // p没了
                return true;
            } else {
                // p还有
                // p[j]是'*'，那么直接可以消除
                return p[j] == '*' && f1(s, p, i, j + 1);
            }
        } else if (j == p.length) {
            // s还有
            // p没了
            return false;
        } else {
            // s还有s[i...]
            // p还有p[j...]
            if (p[j] != '*') {
                // p[j]!='*'
                // 比较当前位置二者的字符
                return (s[i] == p[j] || p[j] == '?') && f1(s, p, i + 1, j + 1);
            } else {
                // p[j]=='*'
                // - 使用p[j]
                boolean p1 = f1(s, p, i + 1, j);
                // - 不使用p[j]
                boolean p2 = f1(s, p, i, j + 1);
                return p1 || p2;
            }
        }
    }

    // 记忆化搜索
    public static boolean isMatch2(String str, String pat) {
        char[] s = str.toCharArray();
        char[] p = pat.toCharArray();
        int[][] dp = new int[s.length + 1][p.length + 1];
        return f2(s, p, 0, 0, dp);
    }

    // dp[i][j]==0: 表示i,j这个位置没有计算过
    // dp[i][j]==1: 表示i,j这个位置计算过，返回true
    // dp[i][j]==-1: 表示i,j这个位置计算过，返回false
    public static boolean f2(char[] s, char[] p, int i, int j, int[][] dp) {
        if (dp[i][j] != 0) {
            return dp[i][j] == 1;
        }
        boolean ans;
        if (i == s.length) {
            // s没了
            if (j == p.length) {
                // p也没了
                ans = true;
            } else {
                // p还有
                // p[j]是'*'，那么直接可以消除
                ans = p[j] == '*' && f2(s, p, i, j + 1, dp);
            }
        } else if (j == p.length) {
            // s还有
            // p没了
            ans = false;
        } else {
            // s还有
            // p还有
            if (p[j] != '*') {
                // p[j]!='*'
                // 比较当前位置二者的字符
                ans = (s[i] == p[j] || p[j] == '?') && f2(s, p, i + 1, j + 1, dp);
            } else {
                // p[j]=='*'
                // - 使用p[j]
                boolean p1 = f2(s, p, i + 1, j, dp);
                // - 不使用p[j]
                boolean p2 = f2(s, p, i, j + 1, dp);
                ans = p1 || p2;
            }
        }
        dp[i][j] = ans ? 1 : -1;
        return ans;
    }

    // 空间压缩
    public static boolean isMatch3(String str, String pat) {
        char[] s = str.toCharArray();
        char[] p = pat.toCharArray();
        int n = s.length;
        int m = p.length;
        // dp[i][j]表示s[i...]是否可以被p[j...]匹配出来
        boolean[][] dp = new boolean[n + 1][m + 1];
        // 初始化
        // - 即s没了，p也没了
        // - dp[n][m]=true: 表示s[n...]可以被p[m...]匹配出来
        dp[n][m] = true;
        // - s没了，p还有
        // - dp[n][j]需要
        //   - p[j]是'*'，那么直接可以消除
        //   - 同时依赖dp[n][j+1]
        for (int j = m - 1; j >= 0; j--) {
            dp[n][j] = p[j] == '*' && dp[n][j + 1];
        }
        // - s还有，p没了
        // - dp[i][m]=false: 表示s[i...]不能被p[m...]匹配出来
        for (int i = n - 1; i >= 0; i--) {
            dp[i][m] = false;
        }
        // s还有，p还有
        for (int i = n - 1; i >= 0; i--) {
            for (int j = m - 1; j >= 0; j--) {
                if (p[j] != '*') {
                    // p[j]!='*'
                    // 比较当前位置二者的字符
                    dp[i][j] = (s[i] == p[j] || p[j] == '?') && dp[i + 1][j + 1];
                } else {
                    // p[j]是'*'
                    // - 使用p[j]
                    boolean p1 = dp[i + 1][j];
                    // - 不使用p[j]
                    boolean p2 = dp[i][j + 1];
                    dp[i][j] = p1 || p2;
                }
            }
        }
        return dp[0][0];
    }
}
```



## [洛谷【普及/提高-】P2918 \[USACO08NOV\] Buying Hay S](https://www.luogu.com.cn/problem/P2918)



```java
import java.io.*;
import java.util.*;

public class Solution {
    // n个提供干草的公司
    // - cost[i]表示i公司购买一次干草的价钱
    // - val[i]表示i公司购买一次提供的干草数量
    // 每个公司的干草可以购买任意次
    // 至少需要购买h数量的干草，最少需要花多少钱

    public static int MAXN = 101;

    public static int MAXM = 55001;

    public static int[] cost = new int[MAXN];

    public static int[] val = new int[MAXN];

    public static int n, h, maxVal, m;

    // dp[i][j]
    // - i表示前i个公司：数据量确定
    // - j表示干草数量严格必须为j的前提下，最少花多少钱m，数据量确定
    //   - j需要进行扩充，增加一个所有公司最大的干草出售数量
    //   - 确保即使j情况下凑不出来，稍微多一些干草也有最小的方案
    // - j表示花钱总额不超过j的前提下，最多买多少草h，数据量不定

    public static int f1() {
        int[][] dp = new int[n + 1][m + 1];
        // 初始化
        // - dp[0][j]：0行表示前0个公司，无论购买多少干草，花费都是Integer.MAX_VALUE（无效解）！！！
        //   - 无效解：因为前0个公司无论购买多少干草，都无法满足要求
        // - dp[i][0]：0列表示前i个公司，购买0磅干草，花费都是0
        // dp[0][0]=0
        Arrays.fill(dp[0], 1, m + 1, Integer.MAX_VALUE);
        for (int i = 1; i <= n; i++) {
            for (int j = 0; j <= m; j++) {
                dp[i][j] = dp[i - 1][j];
                if (j >= val[i] && dp[i][j - val[i]] != Integer.MAX_VALUE) {
                    dp[i][j] = Math.min(dp[i][j], dp[i][j - val[i]] + cost[i]);
                }
            }
        }
        int ans = Integer.MAX_VALUE;
        for (int j = h; j <= m; j++) {
            ans = Math.min(ans, dp[n][j]);
        }
        return ans;
    }

    public static int f2() {
        int[] dp = new int[m + 1];
        Arrays.fill(dp, 1, m + 1, Integer.MAX_VALUE);
        for (int i = 1; i <= n; i++) {
            for (int j = val[i]; j <= m; j++) {
                if (dp[j - val[i]] != Integer.MAX_VALUE) {
                    dp[j] = Math.min(dp[j], dp[j - val[i]] + cost[i]);
                }
            }
        }
        int ans = Integer.MAX_VALUE;
        for (int j = h; j <= m; j++) {
            ans = Math.min(ans, dp[j]);
        }
        return ans;
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            h = (int) in.nval;
            maxVal = 0;
            for (int i = 1; i <= n; i++) {
                in.nextToken();
                val[i] = (int) in.nval;
                in.nextToken();
                cost[i] = (int) in.nval;
                maxVal = Math.max(maxVal, val[i]);
            }
            // 此处需要扩充购买的干草量
            m = h + maxVal;
            out.println(f1());
            out.println(f2());
        }
        out.flush();
        out.close();
    }
}
```



***



# ✅075【必备】多重背包、混合背包



## [洛谷【普及+/提高】P1776 宝物筛选](https://www.luogu.com.cn/problem/P1776)



```java
import java.io.*;

public class Solution {
    // n种货物，背包容量为t
    // 单个货物
    // - v[i]：单个货物的价值
    // - w[i]：单个货物的体积
    // - c[i]：该货物的数量
    // 单个货物使用不超过其数量，总体积不超过背包容量
    // 返回货物最大价值

    public static int MAXN = 40001;

    public static int MAXT = 40001;

    public static int[] v = new int[MAXN];
    public static int[] w = new int[MAXN];
    public static int[] c = new int[MAXN];

    public static int n, t;

    public static int f1() {
        // dp[i][j]
        // 编号1~i的货物，总体积不超过j的最大价值
        // 初始化
        // - dp[0][...]：没有货物，无论背包容量多大，价值都为0
        // - dp[...][0]：背包容量为0，无论有点多少货物，价值都为0
        int[][] dp = new int[n + 1][t + 1];
        for (int i = 1; i <= n; i++) {
            for (int j = 0; j <= t; j++) {
                // 不要i号货物
                dp[i][j] = dp[i - 1][j];
                // 要i号货物
                for (int k = 1; k <= c[i] && w[i] * k <= j; k++) {
                    dp[i][j] = Math.max(dp[i][j], dp[i - 1][j - k * w[i]] + k * v[i]);
                }
            }
        }
        return dp[n][t];
    }

    // 空间压缩
    public static int f2() {
        int[] dp = new int[t + 1];
        for (int i = 1; i <= n; i++) {
            for (int j = t; j >= 0; j--) {
                for (int k = 1; k <= c[i] && w[i] * k <= j; k++) {
                    dp[j] = Math.max(dp[j], dp[j - k * w[i]] + k * v[i]);
                }
            }
        }
        return dp[t];
    }

    // 二进制分组转为01背包
    public static int f3() {
        // 转化后的01货物数量
        int m = 0;
        // 处理货物
        // 暂存数组
        int[] tempV = new int[MAXN];
        int[] tempW = new int[MAXN];
        for (int i = 1; i <= n; i++) {
            // 处理第i种货物
            for (int k = 1; k <= c[i]; k <<= 1) {
                // 货物价值
                tempV[++m] = k * v[i];
                // 货物体积
                tempW[m] = k * w[i];
                c[i] -= k;
            }
            if (c[i] > 0) {
                tempV[++m] = c[i] * v[i];
                tempW[m] = c[i] * w[i];
            }
        }
        // 将暂存数组中数据拷贝到原数组
        for (int i = 1; i <= m; i++) {
            v[i] = tempV[i];
            w[i] = tempW[i];
        }

        // 标准01背包空间压缩模板
        int[] dp = new int[t + 1];
        for (int i = 1; i <= m; i++) {
            for (int j = t; j >= w[i]; j--) {
                dp[j] = Math.max(dp[j], dp[j - w[i]] + v[i]);
            }
        }
        return dp[t];
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            t = (int) in.nval;
            for (int i = 1; i <= n; i++) {
                in.nextToken();
                v[i] = (int) in.nval;
                in.nextToken();
                w[i] = (int) in.nval;
                in.nextToken();
                c[i] = (int) in.nval;
            }
            out.println(f1());
            // out.println(f2());
            out.println(f3());
        }
        out.flush();
        out.close();
    }
}
```



## [洛谷【普及/提高-】P1833 樱花](https://www.luogu.com.cn/problem/P1833)



```java
import java.io.*;

public class Solution {
    // n种货物，背包容量为t(t<=1000)
    // 单个货物
    // - w[i]：单个货物的体积(w[i]>0)
    // - v[i]：单个货物的价值
    // - c[i]：该货物的数量
    // - - c[i]==0：货物数量无限
    // - - c[i]!=0：货物数量有限
    // 单个货物使用不超过其数量，总体积不超过背包容量
    // 返回货物最大价值

    public static int MAXN = 100001;

    public static int MAXT = 1001;

    public static int ENOUGH = 1001;

    public static int[] w = new int[MAXN];
    public static int[] v = new int[MAXN];
    public static int[] c = new int[MAXN];

    public static int n, t;

    public static int f1() {
        // dp[i][j]
        // 编号1~i的货物，总体积不超过j的最大价值
        // 初始化
        // - dp[0][...]：没有货物，无论背包容量多大，价值都为0
        // - dp[...][0]：背包容量为0，无论有点多少货物，价值都为0
        int[][] dp = new int[n + 1][t + 1];
        for (int i = 1; i <= n; i++) {
            for (int j = 0; j <= t; j++) {
                // 不要i号货物
                dp[i][j] = dp[i - 1][j];
                // 要i号货物
                for (int k = 1; k <= c[i] && w[i] * k <= j; k++) {
                    dp[i][j] = Math.max(dp[i][j], dp[i - 1][j - k * w[i]] + k * v[i]);
                }
            }
        }
        return dp[n][t];
    }

    // 空间压缩
    public static int f2() {
        int[] dp = new int[t + 1];
        for (int i = 1; i <= n; i++) {
            for (int j = t; j >= 0; j--) {
                for (int k = 1; k <= c[i] && w[i] * k <= j; k++) {
                    dp[j] = Math.max(dp[j], dp[j - k * w[i]] + k * v[i]);
                }
            }
        }
        return dp[t];
    }

    // 二进制分组转为01背包
    public static int f3() {
        // 转化后的01货物数量
        int m = 0;
        // 处理货物
        int[] tempV = new int[MAXN];
        int[] tempW = new int[MAXN];
        for (int i = 1; i <= n; i++) {
            // 处理第i种货物
            for (int k = 1; k <= c[i]; k <<= 1) {
                // 货物体积
                tempW[m] = k * w[i];
                // 货物价值
                tempV[++m] = k * v[i];
                c[i] -= k;
            }
            if (c[i] > 0) {
                tempV[++m] = c[i] * v[i];
                tempW[m] = c[i] * w[i];
            }
        }
        // 将暂存数组中数据拷贝到原数组
        for (int i = 1; i <= m; i++) {
            v[i] = tempV[i];
            w[i] = tempW[i];
        }

        // 标准01背包空间压缩模板
        int[] dp = new int[t + 1];
        for (int i = 1; i <= m; i++) {
            for (int j = t; j >= w[i]; j--) {
                dp[j] = Math.max(dp[j], dp[j - w[i]] + v[i]);
            }
        }
        return dp[t];
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        in.parseNumbers();
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            int hour1 = (int) in.nval;
            in.nextToken();
            in.nextToken();
            int minute1 = (int) in.nval;
            in.nextToken();
            int hour2 = (int) in.nval;
            in.nextToken();
            in.nextToken();
            int minute2 = (int) in.nval;
            t = (hour2 - hour1) * 60 + minute2 - minute1;
            in.nextToken();
            n = (int) in.nval;
            for (int i = 1; i <= n; i++) {
                in.nextToken();
                w[i] = (int) in.nval;
                in.nextToken();
                v[i] = (int) in.nval;
                in.nextToken();
                c[i] = (int) in.nval;
                if (c[i] == 0) {
                    c[i] = ENOUGH;
                }
            }
            // out.println(f1());
            // out.println(f2());
            out.println(f3());
        }
        out.flush();
        out.close();
    }
}
```



***



# ✅076【必备】区间 dp-上



## [Leetcode【难】1312.让字符串成为回文串的最少插入次数](https://leetcode.cn/problems/minimum-insertion-steps-to-make-a-string-palindrome/)



```java
public class Solution {
    // 给定一个字符串s
    // 现在在任意位置插入任意字符
    // 返回至少需要几次操作，才可以使s变成回文串

    // 暴力递归
    public static int minInsertions1(String str) {
        char[] s = str.toCharArray();
        int n = s.length;
        return f1(s, 0, n - 1);
    }

    // s[l,r]这个范围内，至少需要几次插入，才能变成回文串
    public static int f1(char[] s, int l, int r) {
        // 递归基
        // 只剩下最后一个回文串，需要插入0个
        if (l == r) {
            return 0;
        }
        // 只剩下两个字符
        if (l + 1 == r) {
            return s[l] == s[r] ? 0 : 1;
        }
        // s[l...r]不止两个字符
        if (s[l] == s[r]) {
            // 最外层字符相等，直接递归内部
            return f1(s, l + 1, r - 1);
        } else {
            // 最外层字符不相等，左右两侧需要插入一个字符（也就是处理一个字符）
            return Math.min(f1(s, l, r - 1), f1(s, l + 1, r)) + 1;
        }
    }

    // 记忆化搜索
    public static int minInsertions2(String str) {
        char[] s = str.toCharArray();
        int n = s.length;
        int[][] dp = new int[n][n];
        for (int i = 0; i < n; i++) {
            for (int j = i; j < n; j++) {
                dp[i][j] = -1;
            }
        }
        return f2(s, 0, n - 1, dp);
    }

    public static int f2(char[] s, int l, int r, int[][] dp) {
        if (dp[l][r] != -1) {
            return dp[l][r];
        }
        int ans = 0;
        if (l == r) {
            ans = 0;
        } else if (l + 1 == r) {
            ans = s[l] == s[r] ? 0 : 1;
        } else {
            if (s[l] == s[r]) {
                ans = f2(s, l + 1, r - 1, dp);
            } else {
                ans = Math.min(f2(s, l, r - 1, dp), f2(s, l + 1, r, dp)) + 1;
            }
        }
        dp[l][r] = ans;
        return ans;
    }

    // 严格位置依赖的动态规划
    //   0 1 2 3 4
    // 0 0 ?
    // 1 ✕ 0 ?
    // 2 ✕ ✕ 0 ?
    // 3 ✕ ✕ ✕ 0 ?
    // 4 ✕ ✕ ✕ ✕ 0
    public static int minInsertions3(String str) {
        char[] s = str.toCharArray();
        int n = s.length;
        int[][] dp = new int[n][n];
        // 初始化
        // - l=r=i：只有一个字符，需要插入0个
        for (int i = 0; i < n; i++) {
            dp[i][i] = 0;
        }
        // - s[l...l+1]：只有两个字符，需要插入0个或1个
        for (int l = 0; l < n - 1; l++) {
            dp[l][l + 1] = s[l] == s[l + 1] ? 0 : 1;
        }
        // 从下往上
        for (int l = n - 3; l >= 0; l--) {
            // 从左往右
            for (int r = l + 2; r < n; r++) {
                if (s[l] == s[r]) {
                    dp[l][r] = dp[l + 1][r - 1];
                } else {
                    dp[l][r] = Math.min(dp[l][r - 1], dp[l + 1][r]) + 1;
                }
            }
        }
        // 答案：dp[0][n-1]
        return dp[0][n - 1];
    }

    // 空间压缩
    //   0 1 2 3 4
    // 0 ?
    // 1 ✕ 0 ?
    // 2 ✕ ✕ 0 ?
    // 3 ✕ ✕ ✕ 0 ?
    // 4 ✕ ✕ ✕ ✕ 0
    public static int minInsertions4(String str) {
        char[] s = str.toCharArray();
        int n = s.length;
        if (n == 1) {
            return 0;
        }
        int[] dp = new int[n];
        // 初始化
        // - 第n-1行第n-1列：一定为0
        // - 第n-2行第n-2列：一定为0
        // - 第n-2行第n-1列：判断s[n-2]和s[n-1]是否相等
        dp[n - 1] = s[n - 1] == s[n - 2] ? 0 : 1;
        // 从第n-3行开始往上遍历
        // 从左往右遍历
        for (int l = n - 3, left, right; l >= 0; l--) {
            // 记录当前位置左斜下方的值
            left = dp[l + 1];
            // 从[n-3][n-2]开始确定?的值
            dp[l + 1] = s[l] == s[l + 1] ? 0 : 1;
            for (int r = l + 2; r < n; r++) {
                // 记录当前位置正下方的值
                right = dp[r];
                if (s[l] == s[r]) {
                    // 如果两边字符一致，当前位置的值等于左斜下方的值
                    dp[r] = left;
                } else {
                    // 如果两边字符不一致，当前位置的值等于正左方和正下方的较小值加1
                    dp[r] = Math.min(dp[r - 1], dp[r]) + 1;
                }
                // 横向遍历，向右移动
                left = right;
            }
        }
        // 答案：dp[0][n-1]
        return dp[n - 1];
    }
}
```



## [Leetcode【中】486.预测赢家](https://leetcode.cn/problems/predict-the-winner/)



```java
public class Solution {
    // 给定一个整数数组nums，现在有两个玩家
    // 玩家一先手，二者初始分值都是0
    // 每一轮，玩家从数组任意一端取一个数字，数组长度-1
    // 玩家选中的数字累加作分值
    // 数组为空时游戏结束
    // 玩家一分值更大或者二者分值相等，玩家一获胜，返回true
    // 每个玩家每轮玩法唯一目的都是使自身分值最大化

    // 暴力递归
    public static boolean predictTheWinner1(int[] nums) {
        int sum = 0;
        for (int num : nums) {
            sum += num;
        }
        int n = nums.length;
        int first = f1(nums, 0, n - 1);
        return first >= sum - first;
    }

    // 游戏进行到nums[l...r]，且轮到玩家一
    // 返回玩家一最终获得的分数
    public static int f1(int[] nums, int l, int r) {
        // 只剩一个数字
        if (l == r) {
            return nums[l];
        }
        // 只剩两个数字
        if (l == r - 1) {
            return Math.max(nums[l], nums[r]);
        }
        // 不止两个数字
        // - 玩家一拿走左侧，留下nums[l+1...r]
        // - - 玩家二拿走左侧，留下nums[l+2...r]
        // - - 玩家二拿走右侧，留下nums[l+1...r-1]
        // - 本着利己的原则，玩家二拿走再次轮到玩家一拿时
        // - 玩家一一定是留给自己的较小的一个方案
        int p1 = nums[l] + Math.min(f1(nums, l + 2, r), f1(nums, l + 1, r - 1));
        // - 玩家一拿走右侧，留下nums[l...r-1]
        // - - 玩家二拿走左侧，留下nums[l+1...r-1]
        // - - 玩家二拿走右侧，留下nums[l...r-2]
        // - 玩家一一定是留给自己的较小的一个方案
        int p2 = nums[r] + Math.min(f1(nums, l + 1, r - 1), f1(nums, l, r - 2));
        return Math.max(p1, p2);
    }

    // 记忆化搜索
    public static boolean predictTheWinner2(int[] nums) {
        int sum = 0;
        for (int num : nums) {
            sum += num;
        }
        int n = nums.length;
        int[][] dp = new int[n][n];
        for (int i = 0; i < n; i++) {
            for (int j = i; j < n; j++) {
                dp[i][j] = -1;
            }
        }
        int first = f2(nums, 0, n - 1, dp);
        return first >= sum - first;
    }

    public static int f2(int[] nums, int l, int r, int[][] dp) {
        if (dp[l][r] != -1) {
            return dp[l][r];
        }
        int ans;
        if (l == r) {
            ans = nums[l];
        } else if (l == r - 1) {
            ans = Math.max(nums[l], nums[r]);
        } else {
            int p1 = nums[l] + Math.min(f2(nums, l + 2, r, dp), f2(nums, l + 1, r - 1, dp));
            int p2 = nums[r] + Math.min(f2(nums, l + 1, r - 1, dp), f2(nums, l, r - 2, dp));
            ans = Math.max(p1, p2);
        }
        dp[l][r] = ans;
        return ans;
    }

    // 严格位置依赖
    //   0 1 2 3 4
    // 0 0 ?
    // 1 ✕ 1 ?
    // 2 ✕ ✕ 2 ?
    // 3 ✕ ✕ ✕ 3 ?
    // 4 ✕ ✕ ✕ ✕ 4
    public static boolean predictTheWinner3(int[] nums) {
        int sum = 0;
        for (int num : nums) {
            sum += num;
        }
        int n = nums.length;
        // dp[l][r]
        // - 表示游戏进行到nums[l...r]，且轮到玩家一
        // - 返回玩家一最终获得的分数
        int[][] dp = new int[n][n];
        dp[n - 1][n - 1] = nums[n - 1];
        for (int i = 0; i < n - 1; i++) {
            dp[i][i] = nums[i];
            dp[i][i + 1] = Math.max(nums[i], nums[i + 1]);
        }
        // 从下往上
        for (int l = n - 3; l >= 0; l--) {
            // 从左往右
            for (int r = l + 2; r < n; r++) {
                // 玩家一拿走左侧
                int p1 = nums[l] + Math.min(dp[l + 2][r], dp[l + 1][r - 1]);
                // 玩家一拿走右侧
                int p2 = nums[r] + Math.min(dp[l + 1][r - 1], dp[l][r - 2]);
                dp[l][r] = Math.max(p1, p2);
            }
        }
        int first = dp[0][n - 1];
        return first >= sum - first;
    }
}
```



## [Leetcode【中】1039.多边形三角剖分的最低得分](https://leetcode.cn/problems/minimum-score-triangulation-of-polygon/)



```java
public class Solution {
    // 给定一个凸n边形
    // 每个顶点都有一个整数值nums[i]（顺时针）
    // 现将该多边形拆为n-2个三角形
    // 拆分不能有交叉线
    // 每个三角形的值等于三个顶点值的乘积
    // 三角形拆分分数=∑(n-2)三角形的值
    // 返回三角形拆分分数最小值

    // 暴力递归
    public static int minScoreTriangulation1(int[] v) {
        return f1(v, 0, v.length - 1);
    }

    // 在v[l..r]范围内进行三角行划分
    // - 确保三角拆分不会有交叉
    public static int f1(int[] v, int l, int r) {
        if (l == r || l == r - 1) {
            // v[l..r]：1个顶点或2个顶点
            return 0;
        } else {
            // v[l..r]：至少3个顶点
            int ans = Integer.MAX_VALUE;
            for (int m = l + 1; m < r; m++) {
                // v[l...m]
                // l,m 及在二者之间再挑选一个点构成一个三角形
                int p1 = f1(v, l, m);
                // v[m...r]
                // m,r 及在二者之间再挑选一个点构成一个三角形
                int p2 = f1(v, m, r);
                // v[l...m...r]
                // l,m,r 3个顶点构成了一个三角形
                int p3 = v[l] * v[m] * v[r];
                ans = Math.min(ans, p1 + p2 + p3);
            }
            return ans;
        }
    }

    // 记忆化搜索
    public static int minScoreTriangulation2(int[] v) {
        int n = v.length;
        int[][] dp = new int[n][n];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                dp[i][j] = -1;
            }
        }
        return f2(v, 0, n - 1, dp);
    }

    public static int f2(int[] v, int l, int r, int[][] dp) {
        if (dp[l][r] != -1) {
            return dp[l][r];
        }
        int ans = Integer.MAX_VALUE;
        if (l == r || l == r - 1) {
            ans = 0;
        } else {
            for (int m = l + 1; m < r; m++) {
                int p1 = f2(v, l, m, dp);
                int p2 = f2(v, m, r, dp);
                int p3 = v[l] * v[m] * v[r];
                ans = Math.min(ans, p1 + p2 + p3);
            }
        }
        dp[l][r] = ans;
        return ans;
    }

    // 严格位置依赖
    // v[l...r]:l <= r
    //   0 1 2 3 4 5 6 r
    // 0 0 0
    // 1 ✕ 0 0
    // 2 ✕ ✕ 0 0
    // 3 ✕ ✕ ✕ 0 0
    // 4 ✕ ✕ ✕ ✕ 0 0
    // 5 ✕ ✕ ✕ ✕ ✕ 0 0
    // 6 ✕ ✕ ✕ ✕ ✕ ✕ 0
    // l
    public static int minScoreTriangulation3(int[] v) {
        int n = v.length;
        int[][] dp = new int[n][n];
        for (int l = n - 3; l >= 0; l--) {
            for (int r = l + 2; r < n; r++) {
                dp[l][r] = Integer.MAX_VALUE;
                for (int m = l + 1; m < r; m++) {
                    dp[l][r] = Math.min(dp[l][r], dp[l][m] + dp[m][r] + v[l] * v[m] * v[r]);
                }
            }
        }
        return dp[0][n - 1];
    }
}
```



## [Leetcode【难】1547.切棍子的最小成本](https://leetcode.cn/problems/minimum-cost-to-cut-a-stick/)



```java
import java.util.Arrays;

public class Solution {
    // 给定一个长度n的棍子，标记0~n-1共n个位置
    // 给定一个一维整数数组cuts[i]表示在i位置切一刀，0 < cuts[i] < n-1
    // 切的顺序自定义
    // 每次切的成本=被切棍子的长度
    // 返回切棍子的最小成本

    // 暴力递归
    public static int minCost1(int n, int[] cuts) {
        int m = cuts.length;
        Arrays.sort(cuts);
        int[] c = new int[m + 2];
        c[0] = 0;
        for (int i = 1; i <= m; i++) {
            c[i] = cuts[i - 1];
        }
        c[m + 1] = n;
        return f1(c, 1, m);
    }

    // c[l...r]挑选一个切点m
    // 本次代价为c[r+1]-c[l-1]
    // 下一次为:
    // - c[l...m-1]
    // - c[m+1...r]
    public static int f1(int[] c, int l, int r) {
        if (l > r) {
            return 0;
        } else if (l == r) {
            return c[r + 1] - c[l - 1];
        }
        int ans = Integer.MAX_VALUE;
        for (int m = l; m <= r; m++) {
            ans = Math.min(ans, f1(c, l, m - 1) + f1(c, m + 1, r));
        }
        return ans + c[r + 1] - c[l - 1];
    }

    // 记忆化搜索
    public static int minCost2(int n, int[] cuts) {
        int m = cuts.length;
        Arrays.sort(cuts);
        int[] c = new int[m + 2];
        c[0] = 0;
        for (int i = 1; i <= m; i++) {
            c[i] = cuts[i - 1];
        }
        c[m + 1] = n;
        int[][] dp = new int[m + 2][m + 2];
        for (int i = 0; i <= m + 1; i++) {
            Arrays.fill(dp[i], -1);
        }
        return f2(c, 1, m, dp);
    }

    public static int f2(int[] c, int l, int r, int[][] dp) {
        if (dp[l][r] != -1) {
            return dp[l][r];
        }
        if (l > r) {
            return 0;
        } else if (l == r) {
            return c[r + 1] - c[l - 1];
        }
        int ans = Integer.MAX_VALUE;
        for (int m = l; m <= r; m++) {
            ans = Math.min(ans, f2(c, l, m - 1, dp) + f2(c, m + 1, r, dp));
        }
        dp[l][r] = ans + c[r + 1] - c[l - 1];
        return dp[l][r];
    }

    // 严格位置依赖
    public static int minCost3(int n, int[] cuts) {
        int m = cuts.length;
        Arrays.sort(cuts);
        int[] c = new int[m + 2];
        c[0] = 0;
        for (int i = 1; i <= m; i++) {
            c[i] = cuts[i - 1];
        }
        c[m + 1] = n;
        // dp[l][r]表示c[l...r]的最小成本
        int[][] dp = new int[m + 2][m + 2];
        for (int i = 1; i <= m; i++) {
            dp[i][i] = c[i + 1] - c[i - 1];
        }
        // 从下往上，从左往右
        for (int l = m - 1; l >= 1; l--) {
            for (int r = l + 1; r <= m; r++) {
                int next = Integer.MAX_VALUE;
                for (int k = l; k <= r; k++) {
                    next = Math.min(next, dp[l][k - 1] + dp[k + 1][r]);
                }
                dp[l][r] = next + c[r + 1] - c[l - 1];
            }
        }
        return dp[1][m];
    }
}
```



## [Leetcode【难】312.戳气球](https://leetcode.cn/problems/burst-balloons/description/)



```java
public class Solution {
    // n个气球，编号0~n-1，每个球数值nums[i]
    // 自定义戳破所有气球
    // 每次戳破气球得分=nums[i-1]*nums[i]*nums[i+1]
    // - 每次戳破气球，数组自动删除该气球
    // - 若i-1或i+1超过范围，默认为1
    // 返回最大分值

    // 暴力递归
    public static int maxCoins1(int[] nums) {
        int n = nums.length;
        int[] arr = new int[n + 2];
        arr[0] = arr[n + 1] = 1;
        for (int i = 1; i <= n; i++) {
            arr[i] = nums[i - 1];
        }
        return f1(arr, 1, n);
    }

    // arr[l...r]
    // - arr[l-1]气球存在
    // - arr[r+1]气球存在
    public static int f1(int[] arr, int l, int r) {
        if (l == r) {
            return arr[l - 1] * arr[l] * arr[r + 1];
        } else {
            // l-1,l,l+1...r-1,r,r+1
            // l位置气球最后打爆
            int p1 = arr[l - 1] * arr[l] * arr[r + 1] + f1(arr, l + 1, r);
            // r位置气球最后打爆
            int p2 = arr[l - 1] * arr[r] * arr[r + 1] + f1(arr, l, r - 1);
            int ans = Math.max(p1, p2);
            // l...k-1,k,k+1...r
            for (int k = l + 1; k < r; k++) {
                int p3 = arr[l - 1] * arr[k] * arr[r + 1] + f1(arr, l, k - 1) + f1(arr, k + 1, r);
                ans = Math.max(ans, p3);
            }
            return ans;
        }
    }

    // 记忆化搜索
    public static int maxCoins2(int[] nums) {
        int n = nums.length;
        int[] arr = new int[n + 2];
        arr[0] = arr[n + 1] = 1;
        for (int i = 1; i <= n; i++) {
            arr[i] = nums[i - 1];
        }
        int[][] dp = new int[n + 2][n + 2];
        for (int i = 1; i <= n; i++) {
            for (int j = i; j <= n; j++) {
                dp[i][j] = -1;
            }
        }
        return f2(arr, 1, n, dp);
    }

    public static int f2(int[] arr, int l, int r, int[][] dp) {
        if (dp[l][r] != -1) {
            return dp[l][r];
        }
        int ans = 0;
        if (l == r) {
            ans = arr[l - 1] * arr[l] * arr[r + 1];
        } else {
            // l-1,l,l+1...r-1,r,r+1
            // l位置气球最后打爆
            int p1 = arr[l - 1] * arr[l] * arr[r + 1] + f2(arr, l + 1, r, dp);
            // r位置气球最后打爆
            int p2 = arr[l - 1] * arr[r] * arr[r + 1] + f2(arr, l, r - 1, dp);
            ans = Math.max(p1, p2);
            // l...k-1,k,k+1...r
            for (int k = l + 1; k < r; k++) {
                int p3 = arr[l - 1] * arr[k] * arr[r + 1] + f2(arr, l, k - 1, dp) + f2(arr, k + 1, r, dp);
                ans = Math.max(ans, p3);
            }
        }
        dp[l][r] = ans;
        return ans;
    }

    // 严格位置依赖
    public static int maxCoins3(int[] nums) {
        int n = nums.length;
        int[] arr = new int[n + 2];
        arr[0] = arr[n + 1] = 1;
        for (int i = 1; i <= n; i++) {
            arr[i] = nums[i - 1];
        }
        int[][] dp = new int[n + 2][n + 2];
        for (int i = 1; i <= n; i++) {
            dp[i][i] = arr[i - 1] * arr[i] * arr[i + 1];
        }
        for (int l = n; l >= 1; l--) {
            for (int r = l + 1; r <= n; r++) {
                int p1 = arr[l - 1] * arr[l] * arr[r + 1] + dp[l + 1][r];
                int p2 = arr[l - 1] * arr[r] * arr[r + 1] + dp[l][r - 1];
                dp[l][r] = Math.max(p1, p2);
                for (int k = l + 1; k < r; k++) {
                    int p3 = arr[l - 1] * arr[k] * arr[r + 1] + dp[l][k - 1] + dp[k + 1][r];
                    dp[l][r] = Math.max(dp[l][r], p3);
                }
            }
        }
        return dp[1][n];
    }
}
```



## [Leetcode【中】面试题 08.14.布尔运算](https://leetcode.cn/problems/boolean-evaluation-lcci/)



```java
public class Solution {
    // 给定一个布尔表达式的字符串
    // 由0或1、&或^或|交替组成
    // 现在可以添加符号改变运算顺序
    // 返回有多少种方案得到指定结果

    // 暴力递归
    public static int countEval1(String str, int result) {
        char[] s = str.toCharArray();
        int[] ft = f1(s, 0, s.length - 1);
        return ft[result];
    }

    public static int[] f1(char[] s, int l, int r) {
        int f = 0, t = 0;
        if (l == r) {
            f = s[l] == '0' ? 1 : 0;
            t = s[l] == '1' ? 1 : 0;
        } else {
            int[] tmp;
            for (int k = l + 1; k < r; k += 2) {
                tmp = f1(s, l, k - 1);
                int a = tmp[0];
                int b = tmp[1];
                tmp = f1(s, k + 1, r);
                int c = tmp[0];
                int d = tmp[1];
                if (s[k] == '&') {
                    f += a * c + a * d + b * c;
                    t += b * d;
                } else if (s[k] == '|') {
                    f += a * c;
                    t += a * d + b * c + b * d;
                } else {
                    f += a * c + b * d;
                    t += a * d + b * c;
                }
            }
        }
        int[] ft = new int[] { f, t };
        return ft;
    }

    // 记忆化搜索
    public static int countEval2(String str, int result) {
        char[] s = str.toCharArray();
        int n = s.length;
        int[][][] dp = new int[n][n][];
        int[] ft = f2(s, 0, n - 1, dp);
        return ft[result];
    }

    public static int[] f2(char[] s, int l, int r, int[][][] dp) {
        if (dp[l][r] != null) {
            return dp[l][r];
        }
        int t = 0, f = 0;
        if (l == r) {
            f = s[l] == '0' ? 1 : 0;
            t = s[l] == '1' ? 1 : 0;
        } else {
            int[] tmp;
            for (int k = l + 1; k < r; k += 2) {
                tmp = f2(s, l, k - 1, dp);
                int a = tmp[0];
                int b = tmp[1];
                tmp = f2(s, k + 1, r, dp);
                int c = tmp[0];
                int d = tmp[1];
                if (s[k] == '&') {
                    f += a * c + a * d + c * b;
                    t += b * d;
                } else if (s[k] == '|') {
                    f += a * c;
                    t += a * d + b * c + b * d;
                } else {
                    f += a * c + b * d;
                    t += a * d + b * c;
                }
            }
        }
        dp[l][r] = new int[] { f, t };
        return dp[l][r];
    }
}
```



***



# ✅077【必备】区间 dp-下



## [牛客【】括号区间匹配](https://www.nowcoder.com/practice/e391767d80d942d29e6095a935a5b96b)



```java
import java.io.*;

public class Solution {
    // 给定一个由'['、']'、'('、')、四种符号组成的字符串
    // 匹配成功有两种
    // - 并列："[]()[]"
    // - 嵌套："[[]()]"
    // 无法匹配
    // - "([)]"
    // 返回最少插入多少个括号就能使整个字符串中的括号匹配成功

    public static void main(String[] args) throws IOException {
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        String str = in.readLine();
        out.println(compute(str));
        out.flush();
        out.close();
        in.close();
    }

    public static int compute(String str) {
        char[] s = str.toCharArray();
        int n = s.length;
        int[][] dp = new int[n][n];
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < n; j++) {
                dp[i][j] = -1;
            }
        }
        return f(s, 0, s.length - 1, dp);
    }

    // s[l...r]配对至少需要几个字符
    public static int f(char[] s, int l, int r, int[][] dp) {
        // 片段长度为1
        if (l == r) {
            return 1;
        }
        // 片段长度为2
        if (l == r - 1) {
            if ((s[l] == '(' && s[r] == ')') || (s[l] == '[' && s[r] == ']')) {
                return 0;
            }
            return 2;
        }
        // 片段长度 >= 3
        // - 已尝试过
        if (dp[l][r] != -1) {
            return dp[l][r];
        }
        // - 未尝试过
        // 1、左右边界配来就配对
        int p1 = Integer.MAX_VALUE;
        if ((s[l] == '(' && s[r] == ')') || (s[l] == '[' && s[r] == ']')) {
            p1 = f(s, l + 1, r - 1, dp);
        }
        // 2、左右边界不配对，遍历所有划分点
        int p2 = Integer.MAX_VALUE;
        for (int m = l; m < r; m++) {
            p2 = Math.min(p2, f(s, l, m, dp) + f(s, m + 1, r, dp));
        }
        int ans = Math.min(p1, p2);
        dp[l][r] = ans;
        return ans;
    }
}
```



## [洛谷【提高+/省选-】P4170 \[CQOI2007\] 涂色](https://www.luogu.com.cn/problem/P4170)



```java
import java.io.*;

public class Solution {
    // 给定一个长度为n的目标字符串
    // 每次操作能对长度相等的字符串中连续的片段涂上一种颜色
    // 返回至少需要多少次操作才能得到目标字符串
    // 目标：RGBGR
    // 一、RRRRR
    // 二、RGGGR
    // 三、RGBGR
    // 返回3次

    public static void main(String[] args) throws IOException {
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        String str = in.readLine();
        out.println(strangePrinter(str));
        out.flush();
        out.close();
        in.close();
    }

    public static int strangePrinter(String str) {
        char[] s = str.toCharArray();
        int n = s.length;
        // dp[l][r]
        // 表示将s[l...r]涂上目标颜色至少需要多少次操作
        int[][] dp = new int[n][n];
        // 初始化
        // - 片段长度为1
        for (int i = 0; i < n; i++) {
            dp[i][i] = 1;
        }
        // - 片段长度为2
        for (int i = 0; i < n - 1; i++) {
            dp[i][i + 1] = s[i] == s[i + 1] ? 1 : 2;
        }
        // - 片段长度 >= 3
        //   0 1 2 3 4 5 6 r
        // 0 1 ?
        // 1 ✕ 1 ?
        // 2 ✕ ✕ 1 ?
        // 3 ✕ ✕ ✕ 1 ?
        // 4 ✕ ✕ ✕ ✕ 1 ?
        // 5 ✕ ✕ ✕ ✕ ✕ 1 ?
        // 6 ✕ ✕ ✕ ✕ ✕ ✕ 1
        // l
        for (int l = n - 3; l >= 0; l--) {
            for (int r = l + 2; r < n; r++) {
                if (s[l] == s[r]) {
                    // 左右边界一致
                    // 直接继承一个边界的操作数
                    // 而不是：dp[l][r] = dp[l + 1][r - 1] + 1;
                    // 比如"AAAAA"
                    // 只需要一次操作即可
                    dp[l][r] = dp[l][r - 1];
                    // dp[l][r] = dp[l + 1][r];
                } else {
                    // 左右边界不一致
                    // 遍历所有可能分割点
                    int ans = Integer.MAX_VALUE;
                    for (int m = l; m < r; m++) {
                        ans = Math.min(ans, dp[l][m] + dp[m + 1][r]);
                    }
                    dp[l][r] = ans;
                }
            }
        }
        return dp[0][n - 1];
    }
}
```



## [Leetcode【难】664.奇怪的打印机](https://leetcode.cn/problems/strange-printer/description/)



```java
import java.io.*;

public class Solution {
    // 给定一个长度为n的目标字符串
    // 每次操作能对长度相等的字符串中连续的片段涂上一种颜色
    // 返回至少需要多少次操作才能得到目标字符串
    // 目标：RGBGR
    // 一、RRRRR
    // 二、RGGGR
    // 三、RGBGR
    // 返回3次

    public static void main(String[] args) throws IOException {
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        String str = in.readLine();
        out.println(strangePrinter(str));
        out.flush();
        out.close();
        in.close();
    }

    public static int strangePrinter(String str) {
        char[] s = str.toCharArray();
        int n = s.length;
        // dp[l][r]
        // 表示将s[l...r]涂上目标颜色至少需要多少次操作
        int[][] dp = new int[n][n];
        // 初始化
        // - 片段长度为1
        for (int i = 0; i < n; i++) {
            dp[i][i] = 1;
        }
        // - 片段长度为2
        for (int i = 0; i < n - 1; i++) {
            dp[i][i + 1] = s[i] == s[i + 1] ? 1 : 2;
        }
        // - 片段长度 >= 3
        //   0 1 2 3 4 5 6 r
        // 0 1 ?
        // 1 ✕ 1 ?
        // 2 ✕ ✕ 1 ?
        // 3 ✕ ✕ ✕ 1 ?
        // 4 ✕ ✕ ✕ ✕ 1 ?
        // 5 ✕ ✕ ✕ ✕ ✕ 1 ?
        // 6 ✕ ✕ ✕ ✕ ✕ ✕ 1
        // l
        for (int l = n - 3; l >= 0; l--) {
            for (int r = l + 2; r < n; r++) {
                if (s[l] == s[r]) {
                    // 左右边界一致
                    // 直接继承一个边界的操作数
                    // 而不是：dp[l][r] = dp[l + 1][r - 1] + 1;
                    // 比如"AAAAA"
                    // 只需要一次操作即可
                    dp[l][r] = dp[l][r - 1];
                    // dp[l][r] = dp[l + 1][r];
                } else {
                    // 左右边界不一致
                    // 遍历所有可能分割点
                    int ans = Integer.MAX_VALUE;
                    for (int m = l; m < r; m++) {
                        ans = Math.min(ans, dp[l][m] + dp[m + 1][r]);
                    }
                    dp[l][r] = ans;
                }
            }
        }
        return dp[0][n - 1];
    }
}
```



## [洛谷【普及+/提高】P3205 \[HNOI2010\] 合唱队](https://www.luogu.com.cn/problem/P3205)



```java
import java.io.*;

public class Solution {
    // 给定一个长度为n的数组，同时也是目标队列
    // 例如 1850 1900 1700 1650 1800 1750
    // 初始顺序随机
    // 现在呢进行排队：
    // 1850
    // 1850,1900，因为 1900>1850
    // 1700,1850,1900，因为 1700<1900
    // 1650,1700,1850,1900，因为 1650<1700
    // 1650,1700,1850,1900,1800，因为 1800>1650
    // 1750,1650,1700,1850,1900,1800，因为 1750<1800
    // 得到目标队列： 1750,1650,1700,1850,1900,1800
    // 返回有多少种初始队列按如上规则得到目标队列

    public static int MAXN = 1001;

    public static int[] nums = new int[MAXN];

    public static int n;

    public static int MOD = 19650827;

    public static int compute1() {
        // dp[l][r][0]：行程nums[l...r]，且左侧l位置最后出现
        // dp[l][r][1]：行程nums[l...r]，且右侧r位置最后出现
        int[][][] dp = new int[n + 1][n + 1][2];
        // 初始化
        // - 长度为1，只有一种方案
        for (int i = 1; i <= n; i++) {
            dp[i][i][0] = 1;
            dp[i][i][1] = 1;
        }
        // - 长度为2
        // - - 7 9：7先进，9后进，79有1种；9先进，7后进，79有1种
        // - - 9 7：9先进，7后进，97有0种；9先进，7后进，97有0种
        for (int i = 1; i < n; i++) {
            if (nums[i] < nums[i + 1]) {
                dp[i][i + 1][0] = 1;
                dp[i][i + 1][1] = 1;
            }
        }
        // - 长度为3及以上
        //   0 1 2 3 4 5 r
        // 0 - - - - - -
        // 1 - ✓ ?
        // 2 - ✕ ✓ ?
        // 3 - ✕ ✕ ✓ ?
        // 4 - ✕ ✕ ✕ ✓ ?
        // 5 - ✕ ✕ ✕ ✕ ✓
        // l
        // nums[l...r]
        // [...a,b...c,d...]
        // [ 4,6 2,8 ]
        for (int l = n - 2; l >= 1; l--) {
            for (int r = l + 2; r <= n; r++) {
                // 左侧最后进来
                // - 4<6:[6,2,8]
                // - 左侧小于新的左侧
                if (nums[l] < nums[l + 1]) {
                    dp[l][r][0] = (dp[l][r][0] + dp[l + 1][r][0]) % MOD;
                }
                // - 4<8:[6,2,8]
                // - 左侧小于右侧
                if (nums[l] < nums[r]) {
                    dp[l][r][0] = (dp[l][r][0] + dp[l + 1][r][1]) % MOD;
                }
                // 右侧最后进来
                // - 8>2:[4,6,2]
                // - 右侧大于新的右侧
                if (nums[r] > nums[r - 1]) {
                    dp[l][r][1] = (dp[l][r][1] + dp[l][r - 1][1]) % MOD;
                }
                // - 8>4:[4,6,2]
                // - 右侧大于左侧
                if (nums[r] > nums[l]) {
                    dp[l][r][1] = (dp[l][r][1] + dp[l][r - 1][0]) % MOD;
                }
            }
        }
        return (dp[1][n][0] + dp[1][n][1]) % MOD;
    }

    public static int compute2() {
        int[][] dp = new int[n + 1][2];
        // 初始化
        // - 长度为1
        for (int i = 1; i <= n; i++) {
            dp[i][0] = 1;
            dp[i][1] = 1;
        }
        // - 长度为2
        for (int i = 1; i < n; i++) {
            if (nums[i] < nums[i + 1]) {
                dp[i][0] = 1;
                dp[i][1] = 1;
            }
        }
        // - 长度3及以上
        for (int l = n - 2; l >= 1; l--) {
            if (nums[l] < nums[l + 1]) {
                dp[l + 1][0] = 1;
                dp[l + 1][1] = 1;
            } else {
                dp[l + 1][0] = 0;
                dp[l + 1][1] = 0;
            }
            for (int r = l + 2; r <= n; r++) {
                int a = 0;
                int b = 0;
                if (nums[l] < nums[l + 1]) {
                    a = (a + dp[r][0]) % MOD;
                }
                if (nums[l] < nums[r]) {
                    a = (a + dp[r][1]) % MOD;
                }
                if (nums[r] > nums[l]) {
                    b = (b + dp[r - 1][0]) % MOD;
                }
                if (nums[r] > nums[r - 1]) {
                    b = (b + dp[r - 1][1]) % MOD;
                }
                dp[r][0] = a;
                dp[r][1] = b;
            }
        }
        return (dp[n][0] + dp[n][1]) % MOD;
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            for (int i = 1; i <= n; i++) {
                in.nextToken();
                nums[i] = (int) in.nval;
            }
            if (n == 1) {
                out.println(1);
            } else {
                out.println(compute1());
                out.println(compute2());
            }
        }
        out.flush();
        out.close();
    }
}
```



## [Leetcode【难】546.移除盒子](https://leetcode.cn/problems/remove-boxes/description/)



```java
public class Solution {
    // 给定一组不同颜色的盒子数组boxes
    // 现在需要经过若干轮去掉所有盒子
    // 每一轮可以移除相同颜色的连续的k个盒子
    // 对应得分k*k
    // 返回最大积分

    // [1,3,2,2,2,3,4,3,1]
    // - [1,3,3,4,3,1]:消了3个2:3*3=9分
    // - [1,3,3,3,1]:消了1个4:1*1=1分
    // - [1,1]:消了3个3:3*3=9分
    // - []:消了2个1:2*2=4分

    public static int removeBoxes(int[] boxes) {
        int n = boxes.length;
        int[][][] dp = new int[n][n][n];
        return f(boxes, 0, n - 1, 0, dp);
    }

    // boxes[l....r]范围去消除，前面跟着k个连续的和boxes[l]颜色一样的盒子
    // 这种情况下，返回最大得分
    // - 先消前缀
    // - - 消掉前缀及l位置，从l+1位置再次开始
    // - 不动前缀
    // - - 当前左边界boxes[l]
    // - - 假设boxes[l]与boxes[l+1]不同
    // - - 且boxes(l...r)中还存在多组（每个位置都有1个及以上）与boxes[l]一致的格子
    // - - 设这些组位置为boxes[s1...s2],boxes[s3...s4],...,boxes[sm...sn]
    // - - 遍历左边界及前缀往右与每个组消除的得分
    // - - boxes[l]+前缀+boxes[s1...s2]
    // - - boxes[l]+前缀+boxes[s3...s4]
    // - - ...
    // - - boxes[l]+前缀+boxes[sm...sn]

    public static int f(int[] boxes, int l, int r, int k, int[][][] dp) {
        // 递归基
        if (l > r) {
            return 0;
        }
        // 记忆化搜索
        if (dp[l][r][k] > 0) {
            return dp[l][r][k];
        }
        // l <= r
        // 贪心剪枝
        // boxes[l]与boxes[l+1]相同、与boxes[l+2]相同，...，与boxes[s]相同
        // 那么我们直接将左边界移动到当前组（颜色一致且位置相邻）的最后一个位置
        int s = l;
        while (s + 1 <= r && boxes[l] == boxes[s + 1]) {
            s++;
        }
        // boxes[l...s]都是一种颜色，boxes[s+1]就不是同一种颜色了
        // cnt是总前缀数量 : 之前的相同前缀数(k个) + l...s这段颜色相同的部分(s-l+1个)
        int cnt = k + s - l + 1;
        // 可能性1 : 前缀先消
        // - 从boxes[l+1]再次开始
        int ans = cnt * cnt + f(boxes, s + 1, r, 0, dp);
        // 可能性2 : 前缀跟着哪个后续相同颜色的组（颜色相同位置相邻的若干位置）的开头，一起消掉
        for (int m = s + 2; m <= r; m++) {
            if (boxes[l] == boxes[m] && boxes[m - 1] != boxes[m]) {
                // boxes[l] == boxes[m]：遍历后续相同颜色的组
                // boxes[m]!=boxes[m-1]：剪枝操作，只遍历每组的开头位置
                ans = Math.max(ans, f(boxes, s + 1, m - 1, 0, dp) + f(boxes, m, r, cnt, dp));
            }
        }
        dp[l][r][k] = ans;
        return ans;
    }
}
```



## [洛谷【省选/NOI-】CF1107E Vasya and Binary String](https://www.luogu.com.cn/problem/CF1107E)（不能远程测评但方法可行）



```java
import java.io.*;

public class Solution {
    // 给定一个正整数n
    // 给定一组长度为n的不同颜色的盒子数组boxes
    // 给定一个长度为n的得分数组scores
    // 现在需要经过若干轮去掉所有盒子
    // 每一轮可以移除相同颜色的连续的k个盒子
    // 对应得分scores[k]（得分不一定是长度越长分数越高）
    // 返回最大积分

    public static int MAXN=101;

    public static String box;

    public static int[] boxes=new int[MAXN];

    public static int[] scores=new int[MAXN];

    public static int n;

    // 7
    // 1101001
    // 3 4 9 100 1 2 3
    // 1101001 → 111001 → 11101 → 1111 → ∅。
    // 3+3+3+100=109分

    public static void main(String[] args) throws IOException {
        // StreamTokenizer in=new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        // PrintWriter out=new PrintWriter(new BufferedWriter(new OutputStreamWriter(System.out)));
        // while(in.nextToken()!=StreamTokenizer.TT_EOF){
        //     n=(int)in.nval;
        //     in.nextToken();
        //     box=in.sval;
        //     for(int i=0;i<n;i++){
        //         boxes[i]=box.charAt(i)-'0';
        //     }
        //     for(int i=1;i<=n;i++){
        //         in.nextToken();
        //         scores[i]=(int)in.nval;
        //     }
        //     out.println(removeBoxes(boxes));
        // }
        // out.flush();
        // out.close();
        n=7;
        boxes=new int[]{1,1,0,1,0,0,1};
        scores=new int[]{0,3,4,9,100,1,2,3};
        // 109
        System.out.println(removeBoxes(boxes));
        n=5;
        boxes=new int[]{1,0,1,0,1};
        scores=new int[]{0,3,10,15,15,15};
        // 23
        System.out.println(removeBoxes(boxes));
    }

    public static int removeBoxes(int[] boxes) {
        int n = boxes.length;
        int[][][] dp = new int[n][n][n];
        return f(boxes, 0, n - 1, 0, dp);
    }

    // boxes[l....r]范围去消除，前面跟着k个连续的和boxes[l]颜色一样的盒子
    // 这种情况下，返回最大得分
    // - 先消前缀
    // - - 消掉前缀及l位置，从l+1位置再次开始
    // - 不动前缀
    // - - 当前左边界boxes[l]
    // - - 假设boxes[l]与boxes[l+1]不同
    // - - 且boxes(l...r)中还存在多组（每个位置都有1个及以上）与boxes[l]一致的格子
    // - - 设这些组位置为boxes[s1...s2],boxes[s3...s4],...,boxes[sm...sn]
    // - - 遍历 左边界及前缀 往右与每个组（与boxes[l]颜色相同）中每个位置消除的得分
    // - - boxes[l]+前缀+boxes[s1...s2]
    // - - boxes[l]+前缀+boxes[s3...s4]
    // - - ...
    // - - boxes[l]+前缀+boxes[sm...sn]

    public static int f(int[] boxes, int l, int r, int k, int[][][] dp) {
        // 递归基
        if (l > r) {
            return 0;
        }
        // 记忆化搜索
        if (dp[l][r][k] > 0) {
            return dp[l][r][k];
        }
        // l <= r
        int s = l;

        // cnt是总前缀数量 : 之前的相同前缀数(k个) + 1个
        int cnt = k + 1;
        // 可能性1 : 前缀先消
        // - 从boxes[l+1]再次开始
        int ans = scores[cnt] + f(boxes, s + 1, r, 0, dp);
        // 可能性2 : 前缀跟着哪个后续相同颜色的组（颜色相同位置相邻的若干位置）的所有可能位置，一起消掉
        for (int m = s + 1; m <= r; m++) {
            if (boxes[l] == boxes[m]) {
                // boxes[l] == boxes[m]：遍历后续所有相同颜色的组的所有位置
                ans = Math.max(ans, f(boxes, s + 1, m - 1, 0, dp) + f(boxes, m, r, cnt, dp));
            }
        }
        dp[l][r][k] = ans;
        return ans;
    }
}
```



## [Leetcode【难】1000.合并石头的最低成本](https://leetcode.cn/problems/minimum-cost-to-merge-stones/description/)



```java
public class Solution {
    // n堆石头排一排，第i堆有stones[i]块石头
    // 每次将k堆石头合并为一堆，代价为k堆石头的总数
    // 返回把所有石头合并成一堆的最低成本
    // 如果无法合并成一堆返回-1

    public static int mergeStones(int[] stones, int k) {
        int n = stones.length;
        // 5堆石头，每次合并3堆
        // - 1 2 3 4 5
        // - 6 4 5
        // - 15
        if ((n - 1) % (k - 1) != 0) {
            return -1;
        }
        // 前缀累加和
        // presum[i] : 前i堆石头的总数
        int[] presum = new int[n + 1];
        for (int i = 0, j = 1, sum = 0; i < n; i++, j++) {
            sum += stones[i];
            presum[j] = sum;
        }
        // dp[l][r]
        // s[l...r]范围内石头，合并彻底的最小代价
        int[][] dp = new int[n][n];
        //   0 1 2 3 4
        // 0 ✓
        // 1 0 ✓
        // 2 0 0 ✓
        // 3 0 0 0 ✓
        // 4 0 0 0 0 ✓
        for (int l = n - 2; l >= 0; l--) {
            for (int r = l + 1; r < n; r++) {
                // s[l...r]范围内石头，合并彻底的最小代价
                int ans = Integer.MAX_VALUE;
                // 遍历所有可能的合并方式
                // - s[l]： 1份与s[l+1...r]
                // - s[l...l+k-1]： k份与s[l+k...r]
                // - s[l...l+2k-1]：2k份与s[l+2k...r]
                // - ...
                for (int m = l; m < r; m += k - 1) {
                    ans = Math.min(ans, dp[l][m] + dp[m + 1][r]);
                }
                // s[l...r]最后一次合并，合并成1堆
                if ((r - l) % (k - 1) == 0) {
                    ans += presum[r + 1] - presum[l];
                }
                dp[l][r] = ans;
            }
        }
        return dp[0][n - 1];
    }
}
```



## [Leetcode【难】统计不同回文子序列](https://leetcode.cn/problems/count-different-palindromic-subsequences/description/)



```java
import java.util.*;

public class Solution {
    // 给定一个字符串
    // 返回有多少种不同的非空回文子序列
    // 结果对1000000007取模

    public static final int MOD = 1000000007;

    public static int countPalindromicSubsequences(String str) {
        char[] s = str.toCharArray();
        int n = s.length;
        // last[i]：
        // - left遍历时：从左往右i字符上次出现的位置
        // - right遍历时：从右往左i字符上次出现的位置
        int[] last = new int[256];
        // left[i]：i位置左侧和s[i]字符一致且最近的位置
        int[] left = new int[n];
        Arrays.fill(left, -1);
        for (int i = 0; i < n; i++) {
            left[i] = last[s[i]];
            last[s[i]] = i;
        }
        // right[i]：i位置右侧和s[i]字符一致且最近的位置
        int[] right = new int[n];
        Arrays.fill(right, n);
        for (int i = n - 1; i >= 0; i--) {
            right[i] = last[s[i]];
            last[s[i]] = i;
        }
        // dp[i][j]
        // s[i...j]范围上有多少不同的回文子序列
        long[][] dp = new long[n][n];
        // 初始化：长度为1的子序列
        for (int i = 0; i < n; i++) {
            dp[i][i] = 1;
        }
        for (int i = n - 2; i >= 0; i--) {
            for (int j = i + 1; j < n; j++) {
                // 如果左右边界字符不一样
                if (s[i] != s[j]) {
                    dp[i][j] = dp[i][j - 1] + dp[i + 1][j] - dp[i + 1][j - 1] + MOD;
                }
                // 如果左右边界字符一致
                else {
                    // s[i]左边界右侧最近的和s[i]字符一致的位置
                    int l = right[i];
                    // s[j]右边界左侧最近的和s[j]字符一致的位置
                    int r = left[j];
                    if (l > r) {
                        // 如果s[i+1...j-1]范围内没有s[i]==s[j]这个字符
                        // - 原s[i+1...j-1]范围内的回文子序列
                        // - 原s[i+1...j-1]范围内的回文子序列左右边界加上s[i]和s[j]这两个字符
                        // - s[i]或s[j]
                        // - s[i]和s[j]
                        dp[i][j] = dp[i + 1][j - 1] * 2 + 2;
                    } else if (l == r) {
                        // 如果s[i+1...j-1]范围内有1个s[i]==s[j]这个字符
                        // - 原s[i+1...j-1]范围内的回文子序列
                        // - 原s[i+1...j-1]范围内的回文子序列左右边界加上s[i]和s[j]这两个字符
                        // - s[i]或s[j]
                        dp[i][j] = dp[i + 1][j - 1] * 2 + 1;
                    } else {
                        // 如果s[i+1...j-1]范围内有2个及以上s[i]==s[j]这个字符
                        // - 原s[i+1...j-1]范围内的回文子序列
                        // - 原s[i+1...j-1]范围内的回文子序列左右边界加上s[i]和s[j]这两个字符
                        // - 但是第二种对于s[l+1...r-1]这个范围，会与在其左右边界加上s[l]和s[r]这两个字符的可能重复
                        dp[i][j] = dp[i + 1][j - 1] * 2 - dp[l + 1][r - 1] + MOD;
                    }
                }
                dp[i][j] %= MOD;
            }
        }
        return (int) dp[0][n - 1];
    }
}
```



***



# ✅078【必备】树型 dp-上



## [Leetcode【难】1373.二叉搜索子树的最大键值和](https://leetcode.cn/problems/maximum-sum-bst-in-binary-tree/description/)



```java
public class Solution {
    // 二叉搜索树
    // - 任意节点的左子树键值都小于此节点的键值
    // - 任意节点的右子树键值都大于此节点的键值
    // - 任意节点的左子树和右子树都是二叉搜索树
    // 给定一个root为根的二叉树
    // - 键值可正可负可为0
    // 返回最大的二叉搜索子树的键值和

    // public static class TreeNode {
    //     public int val;
    //     public TreeNode left;
    //     public TreeNode right;
    // }

    public static int maxSumBST(TreeNode root) {
        return f(root).maxBSTSum;
    }

    public static class Info {
        // 最大键值
        public int max;
        // 最小键值
        public int min;
        // 键值和
        public int sum;
        // 是否是二叉搜索树
        public boolean isBST;
        // 最大二叉搜索子树键值和
        public int maxBSTSum;

        public Info(int a, int b, int c, boolean d, int e) {
            max = a;
            min = b;
            sum = c;
            isBST = d;
            maxBSTSum = e;
        }
    }

    public static Info f(TreeNode x) {
        // 叶子节点（子节点为空）
        if (x == null) {
            // 当当前节点为空节点时
            // - 最大键值为Integer.MIN_VALUE
            // - 最小键值为Integer.MAX_VALUE
            // - 键值和为0
            // - 是二叉搜索树
            // - 最大二叉搜索子树键值和为0
            return new Info(Integer.MIN_VALUE, Integer.MAX_VALUE, 0, true, 0);
        }
        // 非叶子节点
        // - 左子树
        Info infoL = f(x.left);
        // - 右子树
        Info infoR = f(x.right);
        // - 最大键值
        int max = Math.max(x.val, Math.max(infoL.max, infoR.max));
        // - 最小键值
        int min = Math.min(x.val, Math.min(infoL.min, infoR.min));
        // - 键值和
        int sum = infoL.sum + infoR.sum + x.val;
        // - 是否是二叉搜索树
        boolean isBST = infoL.isBST && infoR.isBST && infoL.max < x.val && x.val < infoR.min;
        // - 左右子树最大二叉搜索子树键值和
        int maxBSTSum = Math.max(infoL.maxBSTSum, infoR.maxBSTSum);
        // 如果当前节点作根是二叉搜索树
        if (isBST) {
            maxBSTSum = Math.max(maxBSTSum, sum);
        }
        return new Info(max, min, sum, isBST, maxBSTSum);
    }
}
```



## [Leetcode【易】543.二叉树的直径](https://leetcode.cn/problems/diameter-of-binary-tree/description/)



```java
public class Solution {
    // 跟定一二叉树
    // 两个节点之间的路径指的是
    // - 从当前节点出发，到达另一个节点的长度
    // - 当前节点-->二者公共父亲-->另一个节点
    // - 不能经过重复节点
    // 返回最长路径

    public static class TreeNode {
        public int val;
        public TreeNode left;
        public TreeNode right;
    }

    public static int diameterOfBinaryTree(TreeNode root) {
        return f(root).diameter;
    }

    public static class Info {
        // 以当前节点为根节点的二叉树中最大直径
        public int diameter;
        // 以当前节点为根节点的二叉树最大高度
        public int height;

        public Info(int a, int b) {
            diameter = a;
            height = b;
        }
    }

    public static Info f(TreeNode x) {
        if (x == null) {
            // 当前节点为空
            // 以当前节点为根节点
            // - 最大直径为0
            // - 最大高度为0
            return new Info(0, 0);
        }
        // 当前节点不为空
        // - 左子树
        Info lInfo = f(x.left);
        // - 右子树
        Info rInfo = f(x.right);
        // 当前节点为根节点
        // - 最大高度
        int height = Math.max(lInfo.height, rInfo.height) + 1;
        // - 左右子树中的最大直径
        int diameter = Math.max(lInfo.diameter, rInfo.diameter);
        // 更新最大直径
        // - 以当前节点为公共父亲节点，连接左右子树的最大高度
        diameter = Math.max(diameter, lInfo.height + rInfo.height);
        return new Info(diameter, height);
    }
}
```



## [Leetcode【中】979.在二叉树中分配硬币](https://leetcode.cn/problems/distribute-coins-in-binary-tree/description/)



```java
public class Solution {
    // 给定一个有n个结点、root为根结点的二叉树
    // 每个结点node都有对应node.val个硬币
    // 硬币总数为n个硬币
    // 一次移动
    // - 一个硬币从当前节点移动到相邻的节点上
    // 需要多少次移动，使得每个节点都只有一个硬币

    public static class TreeNode {
        public int val;
        public TreeNode left;
        public TreeNode right;
    }

    public static int distributeCoins(TreeNode root) {
        return f(root).move;
    }

    public static class Info {
        // 以当前节点为根节点的子树
        // - 节点数量
        public int cnt;
        // - 硬币数量
        public int sum;
        // - 需要移动的次数
        public int move;

        public Info(int cnt, int sum, int move) {
            this.cnt = cnt;
            this.sum = sum;
            this.move = move;
        }
    }

    public static Info f(TreeNode x) {
        if (x == null) {
            return new Info(0, 0, 0);
        }
        Info lInfo = f(x.left);
        Info rInfo = f(x.right);
        int cnts = lInfo.cnt + rInfo.cnt + 1;
        int sums = lInfo.sum + rInfo.sum + x.val;
        int moves = lInfo.move + rInfo.move + Math.abs(lInfo.cnt - lInfo.sum) + Math.abs(rInfo.cnt - rInfo.sum);
        return new Info(cnts, sums, moves);
    }
}
```



## [洛谷【普及/提高-】P1352 没有上司的舞会](https://www.luogu.com.cn/problem/P1352)



```java
import java.io.*;
import java.util.*;

public class Solution {
    // 给定一个节点n个的二叉树
    // - 每个节点有对应的值
    // 父节点可以理解为子节点的上司
    // - 上司来了，员工就不会来
    // 每来一个员工就会增加键值
    // 返回最大键值

    public static int MAXN = 6001;
    public static int[] nums = new int[MAXN];
    public static boolean[] boss = new boolean[MAXN];

    // 链式前向星
    public static int[] head = new int[MAXN];
    public static int[] next = new int[MAXN];
    public static int[] to = new int[MAXN];
    public static int cnt;

    // no[i]：i为根节点，i不来的情况下，该子树的最大键值
    public static int[] no = new int[MAXN];
    // yes[i]：i为根节点，i来的情况下，该子树的最大键值
    public static int[] yes = new int[MAXN];

    public static int n, finalBOSS;

    public static void build(int n) {
        Arrays.fill(boss, 1, n + 1, true);
        Arrays.fill(head, 1, n + 1, 0);
        cnt = 1;
    }

    public static void addEdge(int u, int v) {
        next[cnt] = head[u];
        to[cnt] = v;
        head[u] = cnt++;
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            build(n);
            for (int i = 1; i <= n; i++) {
                in.nextToken();
                nums[i] = (int) in.nval;
            }
            for (int i = 1; i < n; i++) {
                in.nextToken();
                int son = (int) in.nval;
                in.nextToken();
                int father = (int) in.nval;
                addEdge(father, son);
                boss[son] = false;
            }
            for (int i = 1; i <= n; i++) {
                if (boss[i]) {
                    finalBOSS = i;
                    break;
                }
            }
            f(finalBOSS);
            out.println(Math.max(yes[finalBOSS], no[finalBOSS]));
        }
        out.flush();
        out.close();
    }

    public static void f(int cur) {
        // 当前节点不来
        no[cur] = 0;
        // 当前节点来
        yes[cur] = nums[cur];
        // 遍历当前节点的子节点
        for (int ei = head[cur]; ei > 0; ei = next[ei]) {
            int v = to[ei];
            f(v);
            // 当前节点不来，子节点来或不来都可以
            no[cur] += Math.max(yes[v], no[v]);
            // 当前节点来，子节点一定不来
            yes[cur] += no[v];
        }
    }
}
```



## [Leetcode【中】337.打家劫舍 III](https://leetcode.cn/problems/house-robber-iii/description/)



```java
public class Solution {
    // 给定一个节点n个的二叉树
    // - 每个节点有对应的值
    // 父节点可以理解为子节点的上司
    // - 上司来了，员工就不会来
    // 每来一个员工就会增加键值
    // 返回最大键值

    public static class TreeNode {
        int val;
        TreeNode left;
        TreeNode right;
    }

    // 输入：[3,2,3,null,3,null,1]
    //  3
    // / \
    // 2  3
    //  \  \
    //   3  1
    // 根节点：3
    public int rob(TreeNode root) {
        if (root == null) {
            return 0;
        }
        int[] ans = help(root);
        return Math.max(ans[0], ans[1]);
    }

    public static int[] help(TreeNode x) {
        if (x == null) {
            return new int[] { 0, 0 };
        }
        int[] left = help(x.left);
        int[] right = help(x.right);
        // 当前节点不来
        int no = Math.max(left[0], left[1]) + Math.max(right[0], right[1]);
        // 当前节点来
        int yes = x.val + left[0] + right[0];
        return new int[] { no, yes };
    }
}
```



## [Leetcode【难】968.监控二叉树](https://leetcode.cn/problems/binary-tree-cameras/description/)



```java
public class Solution {
    // 给定一个二叉树
    // 在一个节点安装摄像头
    // - 该节点的摄像头可以覆盖其父节点、自身、子节点
    // 覆盖全部节点，返回最少摄像头

    public static class TreeNode {
        public int val;
        public TreeNode left;
        public TreeNode right;
    }

    public static int ans;

    public int minCameraCover(TreeNode toot) {
        ans = 0;
        // 对于根节点：
        // 假设根节点有父节点
        // 如果根节点没有被覆盖，那么就需要在根节点安装摄像头
        if (f(toot) == 0) {
            ans++;
        }
        return ans;
    }

    // 对于当前节点（假设每个节点都有父节点）
    // - 0：没有被覆盖，其子节点都被覆盖
    // - 1：被覆盖，其子节点也都被覆盖，x没有摄像头
    // - 2：被覆盖，其子节点也都被覆盖，x有摄像头
    // 对于二叉树的一个节点，其左右子节点
    // - 00 01 10 02 20 return 2
    // - 11 return 0
    // - 12 21 22 return 1

    public static int f(TreeNode cur) {
        // 当前节点为空，那么可以设为被覆盖，但无摄像头
        if (cur == null) {
            return 1;
        }
        // 当前节点不为空
        int left = f(cur.left);
        int right = f(cur.right);
        // 当前节点的子节点的子节点都已经被覆盖
        // 但是当前节点的子节点有没有被覆盖的
        // 当前节点需要安装摄像头
        if (left == 0 || right == 0) {
            ans++;
            return 2;
        }
        // 当前节点的子节点的子节点都已经被覆盖
        // 并且当前节点的子节点也都被覆盖
        // 当前节点不需要安装摄像头
        if (left == 1 && right == 1) {
            return 0;
        }
        // 当前节点的子节点的子节点都已经被覆盖
        // 并且当前节点的子节点也都被覆盖
        // 当前节点被覆盖，但没有摄像头
        return 1;
    }
}
```



## [Leetcode【中】437.路径总和 III](https://leetcode.cn/problems/path-sum-iii/description/)



```java
import java.util.*;

public class Solution {
    // 给定一个二叉树
    // 给定一个目标整数target
    // 规定路径
    // - 不需要从根节点开始，不需要在子节点结束
    // - 路径方向必须向下（也就是从父节点到子节点）
    // 返回所有路径累加和等于target的数目

    public static class TreeNode {
        public int val;
        public TreeNode left;
        public TreeNode right;
    }

    public static int ans;

    public static int pathSum(TreeNode root, int sum) {
        HashMap<Long, Integer> preSum = new HashMap<>();
        // 一个节点都不选，有一个前缀和为0的路径
        preSum.put(0L, 1);
        ans = 0;
        f(root, sum, 0, preSum);
        return ans;
    }

    // sum：从头节点出发，来到x时，x上方累加和为多少
    // 路径以x作结尾时，路径累加和等于target的路径数量，累加到ans上
    public static void f(TreeNode x, int target, long sum, HashMap<Long, Integer> preSum) {
        if (x != null) {
            // 从头节点出发，到当前节点x的路径累加和
            sum += x.val;
            // 路径总累加和-目标target值=多出来的累加和
            // 在哈希表中查询从头节点出发到当前节点的所有子路径中，有多少个路径的累加和刚好等于多出来的累加和
            // 那么就有多少条路径的累加和等于target
            ans += preSum.getOrDefault(sum - target, 0);
            // 存储从头节点出发到当前节点的路径累加和
            preSum.put(sum, preSum.getOrDefault(sum, 0) + 1);
            // 继续深入左子树
            f(x.left, target, sum, preSum);
            // 继续深入右子树
            f(x.right, target, sum, preSum);
            // 回溯
            preSum.put(sum, preSum.get(sum) - 1);
        }
    }
}
```



***



# ✅079【必备】树型 dp-下



## [Leetcode【中】2477.到达首都的最少油耗](https://leetcode.cn/problems/minimum-fuel-cost-to-report-to-the-capital/description/)



```java
import java.util.*;

public class Solution {
    // 给定一个n节点的树（无向、连通、无环图）
    // 每个节点代表一个城市，编号0~n-1，n-1条路
    // 0号城市是首都
    // 给定一个二维数组roads
    // - roads[i]=[ai,bi]表示城市ai和bi之间的一条双向路
    // 每个城市都有一个代表，需要去首都参加会议
    // 每个城市都有一辆车，对应整数seats表示该车座位数目
    // 每个城市的代表可以座他们自己城市的车，也可以乘坐其他城市的车，中途也可以更换乘坐的车
    // 一条路一辆车的油耗为一升汽油
    // 返回所有人到达首都需要的最少油量

    public static long minimumFuelCost(int[][] roads, int seats) {
        // 城市节点个数
        int n = roads.length + 1;
        // 构建城市网络
        ArrayList<ArrayList<Integer>> graph = new ArrayList<>();
        for (int i = 0; i < n; i++) {
            graph.add(new ArrayList<>());
        }
        // 无向图
        for (int[] r : roads) {
            graph.get(r[0]).add(r[1]);
            graph.get(r[1]).add(r[0]);
        }
        // 以当前i节点为根节点
        // - size[i]表示该子树的节点个数
        int[] size = new int[n];
        // - cost[i]表示该子树上所有节点到达i节点的最少油量
        long[] cost = new long[n];
        f(graph, seats, 0, -1, size, cost);
        return cost[0];
    }

    // graph：城市网络
    // seats：每辆车的座位数
    // u：当前节点
    // p：u的父节点
    // size：以当前i节点为根节点的子树节点个数
    // cost：以当前i节点为根节点的子树上所有节点到达i节点的最少油量
    public static void f(ArrayList<ArrayList<Integer>> graph, int seats, int u, int p, int[] size, long[] cost) {
        // 初始化以u为根节点的子树信息
        // - 该子树节点个数初始化为1
        size[u] = 1;
        for (int v : graph.get(u)) {
            // 遍历u的所有子节点v（不包括u的父节点p）
            // - 因为当前的网络是无向图，所以每个节点的子节点可能包括其父节点
            if (v != p) {
                f(graph, seats, v, u, size, cost);
                // 更新u的子树节点个数
                size[u] += size[v];
                // 更新u的子树上所有节点到达i节点的最少油量
                cost[u] += cost[v];
                // a/b向上取整，≈(a+b-1)/b
                cost[u] += (size[v] + seats - 1) / seats;
            }
        }
    }
}
```



## [Leetcode【难】2246.相邻字符不同的最长路径](https://leetcode.cn/problems/longest-path-with-different-adjacent-characters/description/)



```java
import java.util.ArrayList;

public class Solution {
    // 给定一棵树（连通、无向、无环图）
    // 节点编号0~n-1，0号节点为根节点
    // 用长度为n的数组parents表示这棵树
    // - parents[i]是i节点的父节点
    // - parents[0]=-1
    // 给定一个长度为n的数组s存储字符
    // - s[i]是i节点的字符
    // 返回图中一个任意相邻节点字符不同的路径的
    // 最长长度

    public static int longestPath(int[] parents, String str) {
        int n = parents.length;
        char[] s = str.toCharArray();
        // 构建图
        ArrayList<ArrayList<Integer>> graph = new ArrayList<>();
        for (int i = 0; i < n; i++) {
            graph.add(new ArrayList<>());
        }
        for (int i = 1; i < n; i++) {
            graph.get(parents[i]).add(i);
        }
        return f(s, graph, 0).maxPath;
    }

    public static class Info {
        // 以当前节点为根节点
        // - 从当前根节点出发，最深的路径长度
        public int maxPathFromRoot;
        // - 该根节点所在的树中，最长的路径长度
        public int maxPath;

        public Info(int maxPathFromRoot, int maxPath) {
            this.maxPathFromRoot = maxPathFromRoot;
            this.maxPath = maxPath;
        }
    }

    public static Info f(char[] s, ArrayList<ArrayList<Integer>> graph, int u) {
        // u节点是叶子节点
        if (graph.get(u).isEmpty()) {
            return new Info(1, 1);
        }
        // 与根节点u字符不一致的子节点中，从当前根节点出发
        // - 第一深的路径
        int max1 = 0;
        // - 第二深的路径
        int max2 = 0;
        // 以当前根节点所在的树中，最长的路径
        int maxPath = 0;
        // 遍历所有子节点
        for (int v : graph.get(u)) {
            // 计算v的信息
            Info vInfo = f(s, graph, v);
            // 更新当前树的最长路径
            maxPath = Math.max(maxPath, vInfo.maxPath);
            // 当前根节点u与子节点v字符不一致
            if (s[u] != s[v]) {
                if (vInfo.maxPathFromRoot > max1) {
                    max2 = max1;
                    max1 = vInfo.maxPathFromRoot;
                } else if (vInfo.maxPathFromRoot > max2) {
                    max2 = vInfo.maxPathFromRoot;
                }
            }
        }
        // 更新从当前根节点出发的最深路径
        int maxPathFromRoot = max1 + 1;
        // 更新当前树的最长路径
        maxPath = Math.max(maxPath, max1 + max2 + 1);
        return new Info(maxPathFromRoot, maxPath);
    }
}
```



## [Leetcode【难】2258.移除子树后的二叉树高度](https://leetcode.cn/problems/height-of-binary-tree-after-subtree-removal-queries/description/)



```java
// DFN序模板题

public class Solution {
    // 给定一个二叉树
    // - 根节点root
    // - 节点个数为n
    // - 每个节点分配一个[1,n]的唯一值
    // 给定一个查询数组queries，长度m，queries[i]表示
    // - 第i次操作
    // - 移除以queries[i]的值作根节点的子树
    // - 每次操作之间没有继承关系
    // 返回一个长度m的数组answer
    // - answer[i]表示第i次操作后，树的高度

    public static class TreeNode {
        public int val;
        public TreeNode left;
        public TreeNode right;
    }

    public static int MAXN = 100010;

    // 给定一n节点的二叉树
    // - 每个节点上有一个[1,n]唯一的值

    // DFN序数组
    // - i表示原二叉树节点上的值
    // - DFN[i]表示该值所在节点对应的DFN序
    public static int[] DFN = new int[MAXN];
    // size数组
    // - i表示新的DFN序重构的二叉树中的节点
    // - size[i]表示以该节点为根的子树的节点数
    public static int[] size = new int[MAXN];
    // deep数组
    // - i表示新的DFN序重构的二叉树中的节点
    // - deep[i]表示该节点的深度
    public static int[] deep = new int[MAXN];
    // 遍历deep数组
    // - 从左往右前i个节点的deep值的最大值
    public static int[] maxl = new int[MAXN];
    // - 从右往左前i个节点的deep值的最大值
    public static int[] maxr = new int[MAXN];

    // DFNx序
    public static int DFNCount;

    public static int[] treeQueries(TreeNode root, int[] queries) {
        DFNCount = 0;
        f(root, 0);
        // 新编号的DFN序二叉树
        // - 从左往右遍历前i个节点的deep值的最大值
        maxl[0] = Integer.MIN_VALUE;
        for (int i = 1; i <= DFNCount; i++) {
            maxl[i] = Math.max(maxl[i - 1], deep[i]);
        }
        // - 从右往左遍历前i个节点的deep值的最大值
        maxr[DFNCount + 1] = Integer.MIN_VALUE;
        for (int i = DFNCount; i >= 1; i--) {
            maxr[i] = Math.max(maxr[i + 1], deep[i]);
        }
        // 遍历查询数组
        int m = queries.length;
        int[] ans = new int[m];
        for (int i = 0; i < m; i++) {
            // 因为如果当前节点的DFN序为i，对应的以当前节点为根节点的子树的节点个数为size[i]
            // 那么DFN序中[i..i+size[i])的节点都在以当前节点为根节点的子树中
            // 因此这个范围内的节点都在删除的子树中
            // - 找到该范围左侧片段的deep值的最大值
            int l = maxl[DFN[queries[i]] - 1];
            // - 找到该范围右侧片段的deep值的最大值
            int r = maxr[DFN[queries[i]] + size[DFN[queries[i]]]];
            ans[i] = Math.max(l, r);
        }
        return ans;
    }

    // 遍历原二叉树
    // - x表示当前节点
    // - k表示当前节点的深度
    public static void f(TreeNode x, int k) {
        // 更新DFN序
        int i = ++DFNCount;
        // 根据当前节点的值x.val为当前节点x分配DFN序i
        DFN[x.val] = i;
        // 当前节点x对应DFN序为i
        // - 以其为根节点的子树节点个数初始化为1
        size[i] = 1;
        // 当前节点x对应DFN序为i
        // - 深度为k
        deep[i] = k;
        // 如果有左节点
        if (x.left != null) {
            // 更新深度
            f(x.left, k + 1);
            // 当前节点x对应DFN序为i
            // - 其子节点x.left对应DFN序为DFN[x.left.val]
            // - 以其字节点为根的子树节点个数为size[DFN[x.left.val]]
            size[i] += size[DFN[x.left.val]];
        }
        if (x.right != null) {
            // 更新深度
            f(x.right, k + 1);
            // 当前节点x对应DFN序为i
            // - 其子节点x.right对应DFN序为DFN[x.right.val]
            // - 以其字节点为根的子树节点个数为size[DFN[x.right.val]]
            size[i] += size[DFN[x.right.val]];
        }
    }
}
```



## [Leetcode【难】2322.从树中删除边的最小分数](https://leetcode.cn/problems/minimum-score-after-removals-on-a-tree/description/)



```java
import java.util.*;

public class Solution {
    // 给定一个无向连通树
    // - 编号0~n-1的节点，n-1条边
    // 给定一个长度n的数组nums
    // - nums[i]表示第i个节点的值
    // 给定一个长度n-1的二维整数数组edges
    // - edges[i]=[ai,bi]表示ai和bi之间的一条边
    // 删除树中的两条不同的边以形成三个各自连通的组件
    // 对于一种删除方案的得分计算
    // - 分别获取三个组件中每个组件所有节点值的异或值
    // - 得分=最大-最小
    // 返回最小得分

    public static int MAXN = 1001;

    // 原二叉树的一编号为x的节点
    // - x对应的DFN序编号为DFN[x]
    public static int[] DFN = new int[MAXN];
    // - x对应的DFN序编号为DFN[x],
    // - 以其为根节点的子树节点个数为size[DFN[x]]
    public static int[] size = new int[MAXN];
    // - x对应的DFN序编号为DFN[x],
    // - 以其为根节点的子树所有节点值的异或和为xor[DFN[x]]
    public static int[] xor = new int[MAXN];

    public static int DFNCount;

    public static int minimumScore(int[] nums, int[][] edges) {
        // 节点个数
        int n = nums.length;
        // 构建无向树
        ArrayList<ArrayList<Integer>> graph = new ArrayList<>();
        for (int i = 0; i < n; i++) {
            graph.add(new ArrayList<>());
        }
        for (int[] e : edges) {
            graph.get(e[0]).add(e[1]);
            graph.get(e[1]).add(e[0]);
        }
        // DFN序重构
        Arrays.fill(DFN, 0, n, 0);
        DFNCount = 0;
        f(nums, graph, 0);
        // 枚举所有可能的删除方案
        int m = edges.length;
        int ans = Integer.MAX_VALUE;
        // 对于要删除的一条边
        // - DFN序小的节点在上方
        // - DFN序大的节点在下方
        // - - 下方节点就是被删除子树的根节点
        for (int i = 0, a, b, small, big, sum1, sum2, sum3; i < m; i++) {
            a = Math.max(DFN[edges[i][0]], DFN[edges[i][1]]);
            for (int j = i + 1; j < m; j++) {
                b = Math.max(DFN[edges[j][0]], DFN[edges[j][1]]);
                // 找到二者中DFN序的较小者和较大者
                if (a < b) {
                    small = a;
                    big = b;
                } else {
                    small = b;
                    big = a;
                }
                // 以下方节点为根节点的子树所有节点值的异或和
                sum1 = xor[big];
                if (big < small + size[small]) {
                    // 下方节点在上方节点的子树中
                    // 从上方节点所起的子树中减去以下方节点所起的子树
                    sum2 = xor[small] ^ xor[big];
                    // 二叉树减去以上方节点为根节点的子树
                    sum3 = xor[1] ^ xor[small];
                } else {
                    // 下方节点不在上方节点的子树中
                    // 以上方节点为根节点的子树
                    sum2 = xor[small];
                    // 二叉树减去
                    // - 以下方节点为根节点的子树
                    // - 以上方节点为根节点的子树
                    sum3 = xor[1] ^ sum1 ^ sum2;
                }
                ans = Math.min(ans, Math.max(Math.max(sum1, sum2), sum3) - Math.min(Math.min(sum1, sum2), sum3));
            }
        }
        return ans;
    }

    // 遍历二叉树
    public static void f(int[] nums, ArrayList<ArrayList<Integer>> graph, int u) {
        // 更新DFN序
        int i = ++DFNCount;
        // 当前节点为u，对应DFN序为i
        DFN[u] = i;
        // 当前节点为u
        // - 初始化以当前节点为根节点的子树节点个数
        size[i] = 1;
        // 当前节点为u
        // - 初始化以当前节点为根节点的子树所有节点值的异或和
        xor[i] = nums[u];
        // 遍历当前节点所有子节点
        for (int v : graph.get(u)) {
            // 无向树的缘故
            // - 存在u-->v
            // - 也有v-->u
            if (DFN[v] == 0) {
                f(nums, graph, v);
                size[i] += size[DFN[v]];
                xor[i] ^= xor[DFN[v]];
            }
        }
    }
}
```



## [洛谷【普及+/提高】P2014 \[CTSC1997\] 选课](https://www.luogu.com.cn/problem/P2014)



```java
import java.io.*;
import java.util.*;

public class Solution {
    // 现有n门课程，每门课有对应学分，有或无对应的直接选修课
    // - 必须先修完直接选修课才能修当前课程
    // 一学期需要选择m门课程进行学习
    // 最大能获得多少学分

    public static int MAXN = 301;
    public static int[] nums = new int[MAXN];
    public static ArrayList<ArrayList<Integer>> graph;

    static {
        graph = new ArrayList<>();
        for (int i = 0; i < MAXN; i++) {
            graph.add(new ArrayList<>());
        }
    }

    public static int[][][] dp = new int[MAXN][][];

    public static int n, m;

    public static void build(int n) {
        for (int i = 0; i <= n; i++) {
            graph.get(i).clear();
        }
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            m = (int) in.nval + 1;
            build(n);
            for (int i = 1; i <= n; i++) {
                in.nextToken();
                int pre = (int) in.nval;
                graph.get(pre).add(i);
                in.nextToken();
                nums[i] = (int) in.nval;
            }
            out.println(compute());
        }
        out.flush();
        out.close();
    }

    public static int compute() {
        for (int i = 0; i <= n; i++) {
            dp[i] = new int[graph.get(i).size() + 1][m + 1];
        }
        for (int i = 0; i <= n; i++) {
            for (int j = 0; j < dp[i].length; j++) {
                for (int k = 0; k <= m; k++) {
                    dp[i][j][k] = -1;
                }
            }
        }
        return f(0, graph.get(0).size(), m);
    }

    // 默认所有没有先修课的课程有一个公共的虚拟选修课
    // - i:当前节点
    // - j:在i号节点及i号节点的前j个子树上挑选节点
    // - k:当前还需要挑选k门课程
    // 返回最大累计和
    public static int f(int i, int j, int k) {
        // 不需要再选课程了
        if (k == 0) {
            return 0;
        }
        // 在当前节点及其前j个子树上
        // - 选1门课程
        if (j == 0 || k == 1) {
            return nums[i];
        }
        if (dp[i][j][k] != -1) {
            return dp[i][j][k];
        }
        // 第j个子树不选
        int ans = f(i, j - 1, k);
        // 第j个子树选
        // - 给当前节点留1个位置的前提下
        // - 在第j个子树上遍历所有可能的留有空位置的数量s
        // - 留个前j-1个子树及根节点的位置数量也就是k-s
        int v = graph.get(i).get(j - 1);
        for (int s = 1; s < k; s++) {
            ans = Math.max(ans, f(i, j - 1, k - s) + f(v, graph.get(v).size(), s));
        }
        dp[i][j][k] = ans;
        return ans;
    }
}
```



```java
import java.io.*;
import java.util.*;

public class Solution {
    // 现有n门课程，每门课有对应学分，有或无对应的直接选修课
    // - 必须先修完直接选修课才能修当前课程
    // 一学期需要选择m门课程进行学习
    // 最大能获得多少学分

    public static int MAXN = 301;

    public static int[] nums = new int[MAXN];

    // 链式前向星
    public static int edgeCount;
    public static int[] head = new int[MAXN];
    public static int[] next = new int[MAXN];
    public static int[] to = new int[MAXN];

    // DFN序
    public static int DFNCount;
    public static int[] val = new int[MAXN + 1];
    public static int[] size = new int[MAXN + 1];

    // 动态规划
    public static int[][] dp = new int[MAXN + 2][MAXN];

    public static int n, m;

    public static void build(int n, int m) {
        edgeCount = 1;
        Arrays.fill(head, 0, n + 1, 0);
        DFNCount = 0;
        Arrays.fill(dp[n + 2], 0, m + 1, 0);
    }

    public static void addEdge(int u, int v) {
        next[edgeCount] = head[u];
        to[edgeCount] = v;
        head[u] = edgeCount++;
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            m = (int) in.nval;
            build(n, m);
            for (int i = 1; i <= n; i++) {
                in.nextToken();
                addEdge((int) in.nval, i);
                in.nextToken();
                nums[i] = (int) in.nval;
            }
            out.println(compute());
        }
        out.flush();
        out.close();
    }

    public static int compute() {
        f(0);
        for (int i = n + 1; i >= 2; i--) {
            for (int j = 1; j <= m; j++) {
                dp[i][j] = Math.max(dp[i + size[i]][j], val[i] + dp[i + 1][j - 1]);
            }
        }
        return dp[2][m];
    }

    // 返回该二叉树的节点个数
    public static int f(int u) {
        int i = ++DFNCount;
        val[i] = nums[u];
        size[i] = 1;
        for (int ei = head[u], v; ei > 0; ei = next[ei]) {
            v = to[ei];
            size[i] += f(v);
        }
        return size[i];
    }
}
```



***



# ✅080【必备】状压 dp-上



## [Leetcode【中】464.我能赢么](https://leetcode.cn/problems/can-i-win/description/)



```java
public class Solution {
    // 给定一个整数n和m
    // 现有两个玩家
    // 两个玩家轮流从公共整数池中抽取[1,n]的整数（不放回）
    // 二者抽取的整数会累加
    // 在谁抽过之后，累加和>=m，谁获胜
    // 先出手的玩家稳赢返回true，反之返回false
    // 两位玩家都绝对聪明，只为自己考虑

    public static boolean canIWin(int n, int m) {
        if (m == 0) {
            // 如果累加和要求超过0
            // - 先手还未抽取就已经满足
            // - 先手获胜
            return true;
        }
        if (n * (n + 1) / 2 < m) {
            // 如果所有数字累加和都小于m
            // - 那么先手赢不了
            // - 返回false
            return false;
        }
        // dp[status]=0;该状态未计算过
        // dp[status]=1;该状态计算过，先手赢
        // dp[status]=-1;该状态计算过，先手输
        int[] dp = new int[1 << (n + 1)];
        // n=7
        // 0 1 2 3 4 5 6 7
        // 1 1 1 1 1 1 1 1
        // [1,7]的所有数字都可以选择
        // 11111111
        // 一共有2^(7+1)-1种状态
        return f(n, (1 << (n + 1)) - 1, m, dp);
    }

    public static boolean f(int n, int status, int rest, int[] dp) {
        if (rest <= 0) {
            // 轮到先手，但是还未抽取，就已经累加和>=m
            return false;
        }
        if (dp[status] != 0) {
            // 该状态之前已经计算过
            return dp[status] == 1;
        }
        // rest>0
        boolean ans = false;
        for (int i = 1; i <= n; i++) {
            // 要保证
            // - 当前选取的数字i还可以选择
            // - 当前先手选择过之后，后手进行选择的时候返回false
            if ((status & (1 << i)) != 0 && !f(n, (status ^ (1 << i)), rest - i, dp)) {
                ans = true;
                break;
            }
        }
        dp[status] = ans ? 1 : -1;
        return ans;
    }
}
```



## [Leetcode【中】473.火柴拼正方形](https://leetcode.cn/problems/matchsticks-to-square/description/)



```java
import java.util.Arrays;

public class Solution {
    // 给定一个整数数组matchsticks
    // matchsticks[i]表示第i根火柴的长度
    // 现在需要所有的火柴拼成一个正方形
    // 也就是将所有元素分为4组，每组的累加和相等
    // 可以拼成返回true，否则返回false

    public static boolean makesquare(int[] nums) {
        int sum = 0;
        for (int num : nums) {
            sum += num;
        }
        if (sum % 4 != 0) {
            return false;
        }
        Arrays.sort(nums);
        if (nums[nums.length - 1] > sum / 4) {
            return false;
        }
        int n = nums.length;
        int[] dp = new int[1 << n];
        return f(nums, sum / 4, (1 << n) - 1, 0, 4, dp);
    }

    // nums:火柴长度数组
    // limit:拼凑的正方形的边长
    // cur:当前正在拼凑的边已经凑的长度
    // rest:当前边的编号4->3->2->1->0
    public static boolean f(int[] nums, int limit, int status, int cur, int rest, int[] dp) {
        if (rest == 0) {
            // 四条边都已经拼完了
            // 所有火柴也都被使用了
            return status == 0;
        }
        if (dp[status] != 0) {
            // 之前计算过这个状态
            // 直接返回结果
            return dp[status] == 1;
        }
        boolean ans = false;
        // 遍历所有边
        for (int i = 0; i < nums.length; i++) {
            // 需要保证
            // - 当前火柴未被使用
            // - 算上当前火柴不会超过边长
            if ((status & (1 << i)) != 0 && cur + nums[i] <= limit) {
                if (cur + nums[i] == limit) {
                    // 当前火柴刚好凑满边长
                    // 下一条边从0开始
                    ans = f(nums, limit, status ^ (1 << i), 0, rest - 1, dp);
                } else {
                    // 当前火柴还没凑满边长
                    // 继续累加
                    ans = f(nums, limit, status ^ (1 << i), cur + nums[i], rest, dp);
                }
                if (ans) {
                    // 找到一种方案
                    // 直接返回
                    break;
                }
            }
        }
        dp[status] = ans ? 1 : -1;
        return ans;
    }
}
```



## [Leetcode【中】698.划分为 k 个相等的子集](https://leetcode.cn/problems/partition-to-k-equal-sum-subsets/description/)



```java
import java.util.Arrays;

public class Solution {
    // 给定一个整数数组matchsticks
    // matchsticks[i]表示第i个元素的值
    // 现在需要将所有元素分为k组，每组的累加和相等
    // 可以拼成返回true，否则返回false

    public static boolean canPartitionKSubsets1(int[] nums, int k) {
        int sum = 0;
        for (int num : nums) {
            sum += num;
        }
        if (sum % k != 0) {
            return false;
        }
        Arrays.sort(nums);
        if (nums[nums.length - 1] > sum / k) {
            return false;
        }
        int n = nums.length;
        int[] dp = new int[1 << n];
        return f1(nums, sum / k, (1 << n) - 1, 0, k, dp);
    }

    // nums:长度数组
    // limit:拼凑的正n边形的边长
    // cur:当前正在拼凑的边已经凑的长度
    // rest:当前边的编号4->3->2->1->0
    public static boolean f1(int[] nums, int limit, int status, int cur, int rest, int[] dp) {
        if (rest == 0) {
            // 所有边都已经拼完了
            // 所有长度也都被使用了
            return status == 0;
        }
        if (dp[status] != 0) {
            // 之前计算过这个状态
            // 直接返回结果
            return dp[status] == 1;
        }
        boolean ans = false;
        // 遍历所有边
        for (int i = 0; i < nums.length; i++) {
            // 需要保证
            // - 当前长度未被使用
            // - 算上当前长度不会超过边长
            if ((status & (1 << i)) != 0 && cur + nums[i] <= limit) {
                if (cur + nums[i] == limit) {
                    // 当前长度刚好凑满边长
                    // 下一条边从0开始
                    ans = f1(nums, limit, status ^ (1 << i), 0, rest - 1, dp);
                } else {
                    // 当前长度还没凑满边长
                    // 继续累加
                    ans = f1(nums, limit, status ^ (1 << i), cur + nums[i], rest, dp);
                }
                if (ans) {
                    // 找到一种方案
                    // 直接返回
                    break;
                }
            }
        }
        dp[status] = ans ? 1 : -1;
        return ans;
    }

    // 暴力递归+剪枝
    public static boolean canPartitionKSubsets2(int[] nums, int k) {
        int sum = 0;
        for (int num : nums) {
            sum += num;
        }
        if (sum % k != 0) {
            return false;
        }
        Arrays.sort(nums);
        if (nums[nums.length - 1] > sum / k) {
            return false;
        }
        return f2(new int[k], sum / k, nums, nums.length - 1);
    }

    // k个组，每个组有一个当前组的累加和
    // 从大到小尝试每个数字放在每个组中
    // 剪枝
    // - 当前数字放时，对于累加和相同的组，挑选一个放即可
    public static boolean f2(int[] group, int target, int[] nums, int index) {
        if (index < 0) {
            return true;
        }
        int num = nums[index];
        for (int i = 0; i < group.length; i++) {
            if (group[i] + num <= target) {
                group[i] += num;
                if (f2(group, target, nums, index - 1)) {
                    return true;
                }
                group[i] -= num;
                while (i + 1 < group.length && group[i + 1] == group[i]) {
                    i++;
                }
            }
        }
        return false;
    }
}
```



## [洛谷【普及+/提高】P1171 售货员的难题](https://www.luogu.com.cn/problem/P1171)



```java
import java.io.*;

public class Solution {
    // 旅行商问题（TSP问题）
    // 现有n个村庄（1<=n<=20），一个售货员
    // 各村庄之间路程s已知（1<=s<=1000）：有权有向图（邻接矩阵存储）
    // 从商店出发，经过每个村庄一次，最终返回商店
    // 返回最短路径

    public static int MAXN = 19;
    public static int[][] graph = new int[MAXN][MAXN];
    public static int[][] dp = new int[1 << MAXN][MAXN];
    public static int n;

    public static void build() {
        for (int s = 0; s < (1 << n); s++) {
            for (int i = 0; i < n; i++) {
                dp[s][i] = -1;
            }
        }
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            build();
            for (int i = 0; i < n; i++) {
                for (int j = 0; j < n; j++) {
                    in.nextToken();
                    graph[i][j] = (int) in.nval;
                }
            }
            out.println(compute());
        }
        out.flush();
        out.close();
    }

    public static int compute() {
        return f(1, 0);
    }

    // 状态s：所有村庄当前的状态
    // - 1：走过了
    // - 0：可以走
    // i：当前所在的村庄
    public static int f(int s, int i) {
        if (s == (1 << n) - 1) {
            // 走过了所有村庄，准备返回商店
            return graph[i][0];
        }
        if (dp[s][i] != -1) {
            // 当前路径之前走过，直接返回
            return dp[s][i];
        }
        int ans = Integer.MAX_VALUE;
        // 遍历所有当前村庄的下一个落脚点
        for (int j = 0; j < n; j++) {
            // 只考虑可以走的村庄（除去已经走过的村庄）
            if ((s & (1 << j)) == 0) {
                // 计算当前路径的距离，更新答案
                // - graph[i][j]：当前村庄到下一个村庄的距离
                // - f(s | (1 << j), j)：下一个村庄到商店的最短距离
                ans = Math.min(ans, graph[i][j] + f(s | (1 << j), j));
            }
        }
        dp[s][i] = ans;
        return ans;
    }
}
```



```java
import java.io.*;

public class Solution {
    // 旅行商问题（TSP问题）
    // 现有n个村庄（1<=n<=20），一个售货员
    // 各村庄之间路程s已知（1<=s<=1000）：有权有向图（邻接矩阵存储）
    // 从商店出发，经过每个村庄一次，最终返回商店
    // 返回最短路径

    public static int MAXN = 19;
    public static int[] start = new int[MAXN];
    public static int[] back = new int[MAXN];

    // 不算起始商店与其他村庄之间的来往距离
    public static int[][] graph = new int[MAXN][MAXN];
    public static int[][] dp = new int[1 << MAXN][MAXN];
    public static int n;

    public static void build() {
        for (int s = 0; s < (1 << n); s++) {
            for (int i = 0; i < n; i++) {
                dp[s][i] = -1;
            }
        }
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval - 1;
            build();
            in.nextToken();
            for (int i = 0; i < n; i++) {
                in.nextToken();
                start[i] = (int) in.nval;
            }
            for (int i = 0; i < n; i++) {
                in.nextToken();
                back[i] = (int) in.nval;
                for (int j = 0; j < n; j++) {
                    in.nextToken();
                    graph[i][j] = (int) in.nval;
                }
            }
            out.println(compute());
        }
        out.flush();
        out.close();
    }

    public static int compute() {
        int ans = Integer.MAX_VALUE;
        // 遍历商店去往的所有村庄
        for (int i = 0; i < n; i++) {
            ans = Math.min(ans, start[i] + f(1 << i, i));
        }
        return ans;
    }

    // 状态s：所有村庄当前的状态
    // - 1：走过了
    // - 0：可以走
    // i：当前所在的村庄
    public static int f(int s, int i) {
        if (s == (1 << n) - 1) {
            // 走过了所有村庄，准备返回商店
            return back[i];
        }
        if (dp[s][i] != -1) {
            // 当前路径之前走过，直接返回
            return dp[s][i];
        }
        int ans = Integer.MAX_VALUE;
        // 遍历所有当前村庄的下一个落脚点
        for (int j = 0; j < n; j++) {
            // 只考虑可以走的村庄（除去已经走过的村庄）
            if ((s & (1 << j)) == 0) {
                // 计算当前路径的距离，更新答案
                // - graph[i][j]：当前村庄到下一个村庄的距离
                // - f(s | (1 << j), j)：下一个村庄到商店的最短距离
                ans = Math.min(ans, graph[i][j] + f(s | (1 << j), j));
            }
        }
        dp[s][i] = ans;
        return ans;
    }
}
```



***



# ✅081【必备】状压 dp-下



## [Leetcode【难】1434.每个人戴不同帽子的方案数](https://leetcode.cn/problems/number-of-ways-to-wear-different-hats-to-each-other/description/)



```java
import java.util.*;

public class Solution {
    // 现有编号1~40共40种不同颜色的帽子
    // 有n个人
    // 给定一个二维整数数组hats
    // - hats[i]表示第i个人所有喜欢的帽子颜色列表
    // 现在给每个人安排一种其喜欢的帽子，保证每个人的帽子颜色跟别人不一样
    // 返回方案数，结果对1000000007取模

    public static int MOD = 1000000007;

    public static int numberWays(List<List<Integer>> arr) {
        // 有人喜欢的帽子的颜色编号最大值（剪枝操作）
        int m = 0;
        for (List<Integer> List : arr) {
            for (int hat : List) {
                m = Math.max(m, hat);
            }
        }
        // 总共有n个人
        int n = arr.size();
        // hats[i]表示编号为i的帽子被哪些人喜欢
        // 例如hats[3]=10110表示编号为3的帽子被第1、2、4个人喜欢
        int[] hats = new int[m + 1];
        for (int i = 0; i < n; i++) {
            for (int hat : arr.get(i)) {
                hats[hat] |= (1 << i);
            }
        }
        int[][] dp = new int[m + 1][1 << n];
        for (int i = 0; i <= m; i++) {
            Arrays.fill(dp[i], -1);
        }
        return f1(hats, m, n, 1, 0, dp);
    }

    // m:有人喜欢的帽子的颜色的最大值
    // n:人的数量0~1-n
    // i:当前来到i号帽子
    // s:1-n~0位置上的n个人的状态
    // - 满足了是1
    // 不满足了是0
    public static int f1(int[] hats, int m, int n, int i, int s, int[][] dp) {
        // 所有的人都被满足了
        if (s == (1 << n) - 1) {
            return 1;
        }
        // 有人喜欢的帽子已经遍历完了，还有人没被满足
        if (i == m + 1) {
            return 0;
        }
        // 记忆化搜索
        if (dp[i][s] != -1) {
            return dp[i][s];
        }
        // - i帽子不分配给任何人
        int ans = f1(hats, m, n, i + 1, s, dp);
        // - i帽子分配给所有还没有被满足并且喜欢当前帽子的人
        int cur = hats[i];
        // 用for循环从0 ~ n-1枚举每个人
        for (int pi = 0; pi < n; pi++) {
            // 当前人pi喜欢当前帽子i
            // 且当前人pi还没有被满足
            if ((cur & (1 << pi)) != 0 && (s & (1 << pi)) == 0) {
                ans = (ans + f1(hats, m, n, i + 1, s | (1 << pi), dp)) % MOD;
            }
        }
        // 记忆化搜索
        dp[i][s] = ans;
        return ans;
    }

    public static int f2(int[] hats, int m, int n, int i, int s, int[][] dp) {
        if (s == (1 << n) - 1) {
            return 1;
        }
        if (i == m + 1) {
            return 0;
        }
        if (dp[i][s] != -1) {
            return dp[i][s];
        }
        int ans = f2(hats, m, n, i + 1, s, dp);
        int cur = hats[i];
        // 因为hats[i]是i帽子[n-1,0]共n为状态来描述第j个人是否喜欢当前帽子
        // - 1表示第j个人喜欢当前帽子
        // - 0表示第j个人不喜欢当前帽子
        // cur1:
        // 0 0 0 1 1 0 1 0
        // -cur1:
        // 1 1 1 0 0 1 0 1 + 1 =
        // 1 1 1 0 0 1 1 0
        // &
        // 0 0 0 0 0 0 1 0
        // ^
        // 0 0 0 1 1 0 0 0
        // 因此我们遍历hats[i]上的所有1
        int rightOne;
        while (cur != 0) {
            // 最右侧的1的位置
            // - 也就是喜欢当前帽子的最小编号的人
            rightOne = cur & (-cur);
            // 如果当前人pi还没有被满足
            if ((s & rightOne) == 0) {
                ans = (ans + f2(hats, m, n, i + 1, s | rightOne, dp)) % MOD;
            }
            // 把当前遍历到的1从cur中去掉
            cur ^= rightOne;
        }
        // 记忆化搜索
        dp[i][s] = ans;
        return ans;
    }
}
```



## [Leetcode【难】1994.好子集的数目](https://leetcode.cn/problems/the-number-of-good-subsets/description/)



```java
import java.util.*;

public class Solution {
    // 给定一个整数数组nums
    // - nums[i]在[1,30]范围内
    // - nums.length在[1,10^5]范围内
    // 若nums的某个子集（子序列），其子集的所有元素的乘积是一个或多个互不形同的质数的乘积
    // 返回nums中不同（大小相同，位置不同也算）好子集的数目，结果对1000000007取模

    // 元素的最大值
    public static int MAXVAL = 30;
    // 小于元素最大值的范围内质数有10个
    // 那么10个状态位可以表示所有可能的质数因子组合
    public static int LIMIT = (1 << 10);
    public static int MOD = 1000000007;

    // 30以内的质因子
    // 29 23 19 17 13 11 7 5 3 2
    // 9 8 7 6 5 4 3 2 1 0

    // 对于[0,30]的所有元素
    // - 其质数因子超过1个，该元素无效
    // - 只有其质数因子都不超过1个，该元素才有效

    public static int[] own = {
            0b0000000000, // 0
            0b0000000000, // 1
            0b0000000001, // 2
            0b0000000010, // 3
            0b0000000000, // 4
            0b0000000100, // 5
            0b0000000011, // 6
            0b0000001000, // 7
            0b0000000000, // 8
            0b0000000000, // 9
            0b0000000101, // 10
            0b0000010000, // 11
            0b0000000000, // 12
            0b0000100000, // 13
            0b0000001001, // 14
            0b0000000110, // 15
            0b0000000000, // 16
            0b0001000000, // 17
            0b0000000000, // 18
            0b0010000000, // 19
            0b0000000000, // 20
            0b0000001010, // 21
            0b0000010001, // 22
            0b0100000000, // 23
            0b0000000000, // 24
            0b0000000000, // 25
            0b0000100001, // 26
            0b0000000000, // 27
            0b0000000000, // 28
            0b1000000000, // 29
            0b0000000111 // 30
    };

    // 记忆化搜索
    public static int numberOfGoodSubsets1(int[] nums) {
        // [1,30]
        int[] cnt = new int[MAXVAL + 1];
        // 统计每个数字出现的次数
        for (int num : nums) {
            cnt[num]++;
        }
        // 初始化dp数组
        // dp[i][s]表示在[1...i]范围上的数字，可以组成的质因子组合的状态
        // - 每种质因子只能有1个
        // - s的10个状态位上1表示有该质数，0表示无
        // - s的10个状态位上所有为1的位置代表的质数的乘积，就是当前状态下的好子集的乘积
        int[][] dp = new int[MAXVAL + 1][LIMIT];
        for (int i = 0; i <= MAXVAL; i++) {
            Arrays.fill(dp[i], -1);
        }
        int ans = 0;
        // 遍历10个质因子组成的10个状态位的所有可能
        for (int s = 1; s < LIMIT; s++) {
            // MAXVAL：遍历30以内的所有数字
            ans = (ans + f1(MAXVAL, s, cnt, dp)) % MOD;
        }
        return ans;
    }

    // [1...i]范围上的数字，每种数字数量cnt[i]
    // s表示当前10个质数的状态
    // - 每种质因子只能有1个
    // - s的10个状态位上1表示有该质数，0表示无
    // - s的10个状态位上所有为1的位置代表的质数的乘积，就是当前状态下的好子集的乘积
    public static int f1(int i, int s, int[] cnt, int[][] dp) {
        if (dp[i][s] != -1) {
            return dp[i][s];
        }
        int ans = 0;
        if (i == 1) {
            // 1只能被1整除
            // 1可以在好子集中出现0次或多次
            // cnt[1]表示1在nums中出现的次数
            // 可以与前边所有的组合重新组合的种类数
            // - ans*(1^cnt[1])
            if (s == 0) {
                // 只有当状态s里边需要的质数因子都已经被凑齐了
                // 才能使用1这个数字
                // 否则只使用1这个数字的情况不成立
                ans = 1;
                for (int j = 0; j < cnt[1]; j++) {
                    ans = (ans << 1) % MOD;
                }
            }
        } else {
            // MAXVAL：遍历30以内的所有数字
            // 1. 不包含i的情况
            ans = f1(i - 1, s, cnt, dp);
            // 2. 包含i的情况
            // cur：i的质数因子状态
            int cur = own[i];
            // times：i在nums中出现的次数
            int times = cnt[i];
            // 如果i的质数因子状态有效
            // 且i的个数不为0
            // 并且i的质数因子正是属于当前状态s需要的
            if ((cur != 0) && (times != 0) && ((s & cur) == cur)) {
                // - 更新i到i-1位置
                // - 我们使用了当前数字cur，那么我们需要将状态s中的cur对应的质因子位置去除，异或变0
                // 那么就是f1(i-1...)*times+不包含i的情况ans
                ans = (int) (((long) f1(i - 1, s ^ cur, cnt, dp) * times + ans) % MOD);
            }
        }
        dp[i][s] = ans;
        return ans;
    }

    // 空间压缩
    // 从上往下遍历数字
    // 从右往左遍历状态
    public static int numberOfGoodSubsets2(int[] nums) {
        int[] cnt = new int[MAXVAL + 1];
        for (int num : nums) {
            cnt[num]++;
        }
        int[] dp = new int[LIMIT];
        // dp[s]表示在[1...i]范围上的数字，可以组成的质因子组合的状态
        // - 每种质因子只能有1个
        // - s的10个状态位上1表示有该质数，0表示无
        // - s的10个状态位上所有为1的位置代表的质数的乘积，就是当前状态下的好子集的乘积
        // 初始化dp数组
        // dp[0]表示1在nums中出现的次数
        dp[0] = 1;
        for (int i = 0; i < cnt[1]; i++) {
            dp[0] = (dp[0] << 1) % MOD;
        }
        // 遍历2到30的所有数字
        for (int i = 2, cur, times; i <= MAXVAL; i++) {
            // 得到当前数字的质数因子状态
            cur = own[i];
            // 得到当前数字在nums中出现的次数
            times = cnt[i];
            // - 当前数字需要有效
            // - 当前数字在nums中出现的次数不能为0
            if (cur != 0 && times != 0) {
                // 从右往左遍历所有可能的质因子的状态
                for (int status = LIMIT - 1; status >= 0; status--) {
                    // 如果当前状态s包含（需要）当前数字i的所有质因子
                    if ((status & cur) == cur) {
                        // 当前行的状态s
                        // - 需要上一行去除cur所有质因子的状态status^cur
                        // - 上一行需要的状态*当前数字i的出现次数times
                        // - 再加上不包含当前数字i的情况
                        dp[status] = (int) (((long) dp[status ^ cur] * times + dp[status]) % MOD);
                    }
                }
            }
        }
        int ans = 0;
        // 遍历最终所有可能的质因子组合状态各自的好子集数量
        for (int s = 1; s < LIMIT; s++) {
            ans = (ans + dp[s]) % MOD;
        }
        return ans;
    }
}
```



## [Leetcode【难】分配重复整数](https://leetcode.cn/problems/distribute-repeating-integers/description/)



```java
import java.util.*;

public class Solution {
    // 给定一个长度为n的整数数组nums
    // - 1<=nums.length<=10^5
    // - 1<=nums[i]<=1000
    // - nums中至多有50个不同的数字
    // 现在有一个长度m的整数数组quantity
    // - quantity[i]表示第i位顾客需要quantity[i]个相同的整数数字
    // - 不同顾客之间的分配的数字可以相同
    // 返回能否满足要求

    public static boolean canDistribute(int[] nums, int[] quantity) {
        Arrays.sort(nums);
        // 统计数字种类
        int n = 1;
        for (int i = 1; i < nums.length; i++) {
            if (nums[i - 1] != nums[i]) {
                n++;
            }
        }
        // 统计每个数字的数量
        int[] cnt = new int[n];
        // 第一组
        int c = 1;
        for (int i = 1, j = 0; i < nums.length; i++) {
            if (nums[i - 1] != nums[i]) {
                cnt[j++] = c;
                c = 1;
            } else {
                c++;
            }
        }
        // 最后一组
        cnt[n - 1] = c;
        // 顾客数量
        int m = quantity.length;
        // m个顾客，也就是m个状态位
        // - 1表示满足当前位置的顾客
        // - 0表示不满足当前位置的顾客
        // - 一共2^m种状态
        // sum[i]表示i状态下，需要被满足的顾客一共需要的数字的总数
        int[] sum = new int[1 << m];
        // 遍历所有顾客（从右往左）
        for (int i = 0, need, h; i < quantity.length; i++) {
            // 当前顾客需要的数字数量
            need = quantity[i];
            // 仅满足当前顾客的状态
            h = 1 << i;
            // 遍历所有小于h的状态
            for (int j = 0; j < h; j++) {
                // 也就是说
                // 算上当前顾客的前提下，遍历所有小于h的状态
                // 即当前顾客位置状态为1|小于h的状态
                // 即当前顾客需要的数字数量+小于h的状态对应的需要的数字数量
                sum[h | j] = sum[j] + need;
            }
        }
        // dp[i][j]
        // - i表示m个顾客组成的状态位
        // - j表示前j个数字是否满足顾客需求
        int[][] dp = new int[1 << m][n];
        return f(cnt, sum, (1 << m) - 1, 0, dp);
    }

    // 来到当前index位置的数字
    // 对应的数字个数为cnt[index]
    // status表示m个顾客组成的状态
    // - 1表示需要去满足
    // - 0表示不需要去满足
    public static boolean f(int[] cnt, int[] sum, int status, int index, int[][] dp) {
        // 所有顾客都被满足了
        if (status == 0) {
            return true;
        }
        // 所有数字都被遍历了，但还有顾客没有被满足
        if (index == cnt.length) {
            return false;
        }
        // 之前已经计算过了
        if (dp[status][index] != 0) {
            return dp[status][index] == 1;
        }
        // 尝试所有可能的子集状态
        boolean ans = false;
        // 当前数字的数量
        int k = cnt[index];
        // 遍历所有j的子集：j=(j-1)&status!!!
        for (int j = status; j > 0; j = (j - 1) & status) {
            // 如果当前status的子集状态j需要的数字总数不超过k
            // 并且递归到下一次
            // - 下一次的状态为status^j：j是status的子集，j状态中的1位置已经被满足，那么归零status对应位置的1
            // - 下一次的数字位置为index+1
            if (sum[j] <= k && f(cnt, sum, status ^ j, index + 1, dp)) {
                ans = true;
                break;
            }
        }
        // 如果当前status的所有子集状态j都不能满足当前数字的需求
        // 那么只能尝试下一个数字
        if (!ans) {
            ans = f(cnt, sum, status, index + 1, dp);
        }
        dp[status][index] = ans ? 1 : -1;
        return ans;
    }
}
```



***



# ✅082【必备】用观察优化枚举-上



## [Leetcode【易】121.买卖股票的最佳时机](https://leetcode.cn/problems/best-time-to-buy-and-sell-stock/description/)



```java
public class Solution {
    // 给定一个数组prices
    // prices[i]表示第i天的价格
    // 在第j天买入，在第k天卖出（j<k,prices[j]<prices[k]）
    // 返回能获得的最大利润，否则返回0

    public static int maxProfit(int[] prices) {
        int ans = 0;
        for (int i = 1, min = prices[0]; i < prices.length; i++) {
            min = Math.min(min, prices[i]);
            ans = Math.max(ans, prices[i] - min);
        }
        return ans;
    }
}
```



## [Leetcode【中】122.买卖股票的最佳时机 II](https://leetcode.cn/problems/best-time-to-buy-and-sell-stock-ii/description/)



```java
public class Solution {
    // 给定一个数组prices
    // prices[i]表示第i天的价格
    // 在每一天，可以买入和出售，但只能持有一股
    // 返回能获得的最大利润，否则返回0

    public static int maxProfit(int[] prices) {
        int ans = 0;
        for (int i = 1; i < prices.length; i++) {
            ans += Math.max(prices[i] - prices[i - 1], 0);
        }
        return ans;
    }
}
```



## [Leetcode【难】123.买卖股票的最佳时机 III](https://leetcode.cn/problems/best-time-to-buy-and-sell-stock-iii/description/)



```java
public class Solution {
    // 给定一个数组prices
    // prices[i]表示第i天的价格
    // 一共完成两笔交易
    // 第二次交易必须在第一次交易完成后
    // 返回能获得的最大利润，否则返回0

    public static int maxProfit1(int[] prices) {
        int n = prices.length;
        // dp1[i]：prices[0...i]范围上发生过一笔交易的最大利润
        int[] dp1 = new int[n];
        for (int i = 1, min = prices[0]; i < n; i++) {
            min = Math.min(min, prices[i]);
            dp1[i] = Math.max(dp1[i - 1], prices[i] - min);
        }
        // dp2[i]：prices[0...i]范围上发生过两笔交易，而且第二笔交易在i时刻卖出的最大利润
        int[] dp2 = new int[n];
        int ans = 0;
        // 第二笔交易卖出时刻[1...n-1]
        for (int i = 1; i < n; i++) {
            // 第一笔交易卖出时刻[0...i]
            for (int j = 0; j <= i; j++) {
                dp2[i] = Math.max(dp2[i], dp1[j] + prices[i] - prices[j]);
            }
            ans = Math.max(ans, dp2[i]);
        }
        return ans;
    }

    public static int maxProfit2(int[] prices) {
        int n = prices.length;
        // dp1[i]：prices[0...i]范围上发生过一笔交易的最大利润
        int[] dp1 = new int[n];
        for (int i = 1, min = prices[0]; i < n; i++) {
            min = Math.min(min, prices[i]);
            dp1[i] = Math.max(dp1[i - 1], prices[i] - min);
        }
        // best[i]：prices[0...i]范围上
        // - dp1[i]-prices[i]最大值
        int[] best = new int[n];
        best[0] = dp1[0] - prices[0];
        for (int i = 1; i < n; i++) {
            best[i] = Math.max(best[i - 1], dp1[i] - prices[i]);
        }
        // dp2[i]：prices[0...i]范围上发生过两笔交易，而且第二笔交易在i时刻卖出的最大利润
        int[] dp2 = new int[n];
        int ans = 0;
        // 第二笔交易卖出时刻[1...n-1]
        for (int i = 1; i < n; i++) {
            // 第一笔交易卖出时刻[0...i]
            dp2[i] = best[i] + prices[i];
            ans = Math.max(ans, dp2[i]);
        }
        return ans;
    }

    public static int maxProfit3(int[] prices) {
        int n = prices.length;
        int[] dp1 = new int[n];
        dp1[0] = 0;
        int[] best = new int[n];
        best[0] = dp1[0] - prices[0];
        int[] dp2 = new int[n];
        int ans = 0;
        for (int i = 1, min = prices[0]; i < n; i++) {
            min = Math.min(min, prices[i]);
            dp1[i] = Math.max(dp1[i - 1], prices[i] - min);
            best[i] = Math.max(best[i - 1], dp1[i] - prices[i]);
            dp2[i] = best[i] + prices[i];
            ans = Math.max(ans, dp2[i]);
        }
        return ans;
    }

    public static int maxProfit4(int[] prices) {
        int dp1 = 0;
        int best = dp1 - prices[0];
        int ans = 0;
        for (int i = 1, min = prices[0]; i < prices.length; i++) {
            min = Math.min(min, prices[i]);
            dp1 = Math.max(dp1, prices[i] - min);
            best = Math.max(best, dp1 - prices[i]);
            ans = Math.max(ans, best + prices[i]);
        }
        return ans;
    }
}
```



## [Leetcode【难】188.买卖股票的最佳时机 IV](https://leetcode.cn/problems/best-time-to-buy-and-sell-stock-iv/description/)



```java
public class Solution {
    // 给定一个数组prices
    // prices[i]表示第i天的价格
    // 完成k笔交易
    // 第j+1次交易必须在第j次交易完成后
    // 返回能获得的最大利润，否则返回0

    // 无限次交易
    public static int free(int[] prices) {
        int ans = 0;
        for (int i = 1; i < prices.length; i++) {
            ans += Math.max(0, prices[i] - prices[i - 1]);
        }
        return ans;
    }

    public static int maxProfit1(int k, int[] prices) {
        int n = prices.length;
        if (k >= n / 2) {
            // 剪枝
            // 上升坡最多有n/2个
            // 所以k>=n/2时，等价于无限次交易
            return free(prices);
        }
        int[][] dp = new int[k + 1][n];
        // dp[i][j]
        // - 在prices[0...j]范围上
        // - 完成i次交易
        // - 返回最大利润
        for (int i = 1; i <= k; i++) {
            for (int j = 1; j < n; j++) {
                // - 最后一笔交易在j-1出售
                dp[i][j] = dp[i][j - 1];
                // - 最后一笔交易在j出售
                // 遍历最后一笔交易的所有购入时刻
                for (int p = 0; p < j; p++) {
                    dp[i][j] = Math.max(dp[i][j], dp[i - 1][p] + prices[j] - prices[p]);
                }
            }
        }
        return dp[k][n - 1];
    }

    public static int maxProfit2(int k, int[] prices) {
        int n = prices.length;
        if (k >= n / 2) {
            return free(prices);
        }
        int[][] dp = new int[k + 1][n];
        for (int i = 1, best; i <= k; i++) {
            best = dp[i - 1][0] - prices[0];
            for (int j = 1; j < n; j++) {
                dp[i][j] = Math.max(dp[i][j - 1], best + prices[j]);
                best = Math.max(best, dp[i - 1][j] - prices[j]);
            }
        }
        return dp[k][n - 1];
    }

    public static int maxProfit3(int k, int[] prices) {
        int n = prices.length;
        if (k >= n / 2) {
            return free(prices);
        }
        int[] dp = new int[n];
        for (int i = 1, best, temp; i <= k; i++) {
            best = dp[0] - prices[0];
            for (int j = 1; j < n; j++) {
                temp = dp[j];
                dp[j] = Math.max(dp[j - 1], best + prices[j]);
                best = Math.max(best, temp - prices[j]);
            }
        }
        return dp[n - 1];
    }
}
```



## [Leetcode【中】714.买卖股票的最佳时机含手续费](https://leetcode.cn/problems/best-time-to-buy-and-sell-stock-with-transaction-fee/description/)



```java
public class Solution {
    // 给定一个数组prices
    // prices[i]表示第i天的价格
    // 整数fee代表每次交易的手续费
    // 可以无限次交易
    // 第j+1次交易必须在第j次交易完成后
    // 返回能获得的最大利润

    public static int maxProfit(int[] prices, int fee) {
        // 交易无限情况下
        // done:能获得的最大收益
        // - 0...0范围上最大收益为0元，一次交易都不进行
        int done = 0;
        // prepare:0...0范围上获得的最大收益-当前天以前所有价格的一次购入（一般是当前天的价格）-手续费
        // - 可以理解为：我们把手续费和购入时刻的成本绑定在了一起
        int prepare = 0 - prices[0] - fee;
        // 遍历[1...n-1]
        for (int i = 1; i < prices.length; i++) {
            // 第i天不进行交易
            // 第i天进行交易
            // - 加上当天的价格，就是[0...i]范围上的最大收益
            done = Math.max(done, prepare + prices[i]);
            // 更新prepare
            // - 之前的prepare
            // - 新的最大收益-当前天的价格-手续费
            prepare = Math.max(prepare, done - prices[i] - fee);
        }
        return done;
    }
}
```



## [Leetcode【中】309.买卖股票的最佳时机含冷冻期](https://leetcode.cn/problems/best-time-to-buy-and-sell-stock-with-cooldown/description/)



```java
public class Solution {
    // 给定一个数组prices
    // prices[i]表示第i天的价格
    // 不同交易之间有1天的冷冻期
    // - 如果当天卖出股票，下一天不能买入股票
    // 可以无限次交易
    // - 第j+1次交易必须在第j次交易完成后
    // 返回能获得的最大利润

    public static int maxProfit1(int[] prices) {
        int n = prices.length;
        if (n < 2) {
            return 0;
        }
        // 无限次交易情况下
        // done[i]:[0...i]范围内,可以获得的最大收益
        int[] done = new int[n];
        done[0] = 0;
        done[1] = Math.max(0, prices[1] - prices[0]);
        // prepare[i]:[0...i]范围内,可以获得的最大收益-前边所有价格有一次购入（一般是循环的最后一天） 的最大值
        int[] prepare = new int[n];
        prepare[0] = -prices[0];
        prepare[1] = Math.max(-prices[0], -prices[1]);

        for (int i = 2; i < n; i++) {
            // done[i]
            // - 第i天不交易
            // - 第i天卖出股票
            done[i] = Math.max(done[i - 1], prepare[i - 1] + prices[i]);
            // prepare[i]
            // - 第i天不交易
            // - 第i天买入股票+一天前以前的最大收益
            prepare[i] = Math.max(prepare[i - 1], done[i - 2] - prices[i]);
        }
        return done[n - 1];
    }

    public static int maxProfit2(int[] prices) {
        int n = prices.length;
        if (n < 2) {
            return 0;
        }
        // 无限次交易情况下
        // done2:done[i-2]
        int done2 = 0;
        // done1:done[i-1]
        int done1 = Math.max(0, prices[1] - prices[0]);
        // prepare:prepare[i-1]
        int prepare = Math.max(-prices[0], -prices[1]);
        for (int i = 2, curDone; i < n; i++) {
            // curDone:done[i]
            curDone = Math.max(done1, prepare + prices[i]);
            prepare = Math.max(prepare, done2 - prices[i]);
            done2 = done1;
            done1 = curDone;
        }
        return done1;
    }
}
```



## [Leetcode【难】903.DI 序列的有效排列](https://leetcode.cn/problems/valid-permutations-for-di-sequence/description/)



```java
public class Solution {
    // 给定一个长度为n的字符串s(1<=n<=200)
    // - s[i]是'D'或'I'
    // - D:减少
    // - I:增加
    // 有效排列
    // - 对n+1个在[0...n]范围内的整数组成一个有序排列
    // 使得
    // - s[i]=='D',num[i]>num[i+1]
    // - s[i]=='I',num[i]<num[i+1]
    // 返回有效排列的数量，结果对1000000007取模

    public static int MOD = 1000000007;

    public static int numPermsDISequence1(String s) {
        return f(s.toCharArray(), 0, s.length() + 1, s.length() + 1);
    }

    // 默认0前边的位置是无穷大
    // n: 数字总个数
    // - 初始化：s.length()+1个
    // 当前来到了i位置，那么已经使用了[0...i-1]共i个数字
    // - 初始化：0位置
    // less: 还没有使用过的数字中，比i-1位置的数字小的，有less个
    // - 初始化：s.length()+1个
    // - 比0位置左侧无穷大小的有s.length()+1个
    // 还没有使用过的数字中，比i-1位置的数字大的，有n - i - less个
    public static int f(char[] s, int i, int less, int n) {
        int ans = 0;
        if (i == n) {
            ans = 1;
        } else if (i == 0 || s[i - 1] == 'D') {
            for (int nextLess = 0; nextLess < less; nextLess++) {
                // 如果说，当前位置需要的数字应小于左侧的数字
                // 而，小于左侧数字的有less个
                // 那么这less个的排序浑然天成
                // - 如果我们使用最小的一个，那么比这个还小的有0个
                // - 如果我们使用第二小的，那么比这个还小的有1个
                // - ……
                // - 如果我们使用最大的一个，那么比这个还小的有less-1个
                ans += f(s, i + 1, nextLess, n);
            }
        } else {
            for (int nextLess = less, k = 0; k < n - i - less; k++, nextLess++) {
                // 同理：
                // 比当前位置左侧的数字小的less个
                // 当前位置是i位置，那么已经使用了[0...i-1]共i个数字
                // 因此，比当前位置左侧的数字大的有n - i - less个
                // 当前位置需要的数字应大于左侧位置的数字
                // - 那么如果我们使用这n-i-less个中最小的一个，比当前位置左侧的数字小的数字还有less个
                // - 如果我们使用第二小的，那么比当前位置左侧的数字小的数字还有less+1（n-i-less中最小的）个
                // - 如果我们使用第三小的，那么比当前位置左侧的数字小的数字还有less+2（n-i-less中最小的、第二小的）个
                // - ……
                // - 如果我们使用最大的一个，那么比当前位置左侧的数字小的数字还有less+n-i-less-1个
                ans += f(s, i + 1, nextLess, n);
            }
        }
        return ans % MOD;
    }

    public static int numPermsDISequence2(String str) {
        char[] s = str.toCharArray();
        int n = s.length + 1;
        // dp[i][less]:
        // 0~i-1范围上是已经使用过的数字，i个
        // 还没有使用过的数字中，比i-1位置的数字小的，有less个
        // 返回后续还有多少种有效的排列
        int[][] dp = new int[n + 1][n + 1];
        // 最后一行
        // - 0~n-1范围上已经使用了n个数字
        // - 只剩下最后一个数字
        for (int less = 0; less <= n; less++) {
            dp[n][less] = 1;
        }
        for (int i = n - 1; i >= 0; i--) {
            for (int less = 0; less <= n; less++) {
                if (i == 0 || s[i - 1] == 'D') {
                    for (int nLest = 0; nLest < less; nLest++) {
                        dp[i][less] = (dp[i][less] + dp[i + 1][nLest]) % MOD;
                    }
                } else {
                    for (int nLest = less, k = 0; k < n - i - less; k++, nLest++) {
                        dp[i][less] = (dp[i][less] + dp[i + 1][nLest]) % MOD;
                    }
                }
            }
        }
        return dp[0][n];
    }

    // 从下往上，从右往左
    public static int numPermsDISequence3(String str) {
        char[] s = str.toCharArray();
        int n = s.length + 1;
        int[][] dp = new int[n + 1][n + 1];
        for (int less = 0; less <= n; less++) {
            dp[n][less] = 1;
        }
        for (int i = n - 1; i >= 0; i--) {
            if (i == 0 || s[i - 1] == 'D') {
                dp[i][1] = dp[i + 1][0];
                for (int less = 2; less <= n; less++) {
                    dp[i][less] = (dp[i][less - 1] + dp[i + 1][less - 1]) % MOD;
                }
            } else {
                dp[i][n - i - 1] = dp[i + 1][n - i - 1];
                for (int less = n - i - 2; less >= 0; less--) {
                    dp[i][less] = (dp[i][less + 1] + dp[i + 1][less]) % MOD;
                }
            }
        }
        return dp[0][n];
    }
}
```



***



# ✅083【必备】用观察优化枚举-下



## [Leetcode【难】1235.规划兼职工作](https://leetcode.cn/problems/maximum-profit-in-job-scheduling/description/)



```java
import java.util.*;

public class Solution {
    // 现在需要利用空闲时间兼职
    // - 起始时间startTime[i]
    // - 终止时间endTime[i]
    // - 报酬是profit[i]
    // - 一份工作结束时可以立马开启下一段工作
    // - 工作不能出现时间重叠
    // 返回能获得的最大利润

    public static int MAXN = 50001;

    public static int[][] jobs = new int[MAXN][3];

    public static int[] dp = new int[MAXN];

    public static int jobScheduling(int[] startTime, int[] endTime, int[] profit) {
        // 工作数量
        int n = startTime.length;
        for (int i = 0; i < n; i++) {
            jobs[i][0] = startTime[i];
            jobs[i][1] = endTime[i];
            jobs[i][2] = profit[i];
        }
        // 按照工作结束时间升序排序
        Arrays.sort(jobs, 0, n, (a, b) -> a[1] - b[1]);
        // dp[i]表示
        // 在jobs[0...i]范围内随意按规则挑选工作的最大报酬
        // 初始化
        // - dp[0]表示编号在jobs[0...0]范围内随意按规则挑选工作的最大报酬
        // - 只能选择0编号的工作
        dp[0] = jobs[0][2];
        // 遍历jobs[1...n-1]
        for (int i = 1, start; i < n; i++) {
            // 记录当前工作的开始时间
            start = jobs[i][0];
            // 选择当前工作
            // - 加上当前工作的报酬
            dp[i] = jobs[i][2];
            // 0编号的工作的结束时间（所有结束时间中最小的）小于当前工作的开始时间
            // 往前遍历 存在 结束时间比start早的工作
            // 调用f函数有结果
            if (jobs[0][1] <= start) {
                // - 再加上结束时间小于当前工作开始时间的工作中结束时间最晚的工作的编号对应的最大报酬
                dp[i] += dp[f(i - 1, start)];
            }
            // 不选择当前工作
            // - 保持dp[i-1]不变
            // 取较大者
            dp[i] = Math.max(dp[i], dp[i - 1]);
        }
        return dp[n - 1];
    }

    // 已经按结束时间升序排序好的job
    // 在jobs[0...i]范围上
    // 找到结束时间<=start的最右工作编号
    public static int f(int i, int start) {
        int ans = 0;
        int l = 0;
        int r = i;
        int m;
        while (l <= r) {
            m = (l + r) / 2;
            if (jobs[m][1] <= start) {
                ans = m;
                l = m + 1;
            } else {
                r = m - 1;
            }
        }
        return ans;
    }
}
```



## [Leetcode【难】629.K 个逆序对数组](https://leetcode.cn/problems/k-inverse-pairs-array/description/)



```java
public class Solution {
    // 逆序对：
    // 对于数组nums的任意两个下标i和j
    // - 0<=i<j<nums.length
    // - nums[i]>nums[j]
    // 则为一个逆序对
    // 给定两个整数n和k
    // - 则有一个长度为n的元素是从1到n的数组
    // - 且该数组恰好拥有k个逆序对
    // 返回有多少种排列顺序
    // 结果对1000000007取模

    public static int MOD = 1000000007;

    public static int kInversePairs1(int n, int k) {
        // dp[i][j]
        // - 元素是1、2、3......i
        // - 逆序对恰好j个
        // - 有多少种排列顺序
        int[][] dp = new int[n + 1][k + 1];
        // 初始化：
        // - 元素0个，逆序对0个，只1种排列方案
        dp[0][0] = 1;
        // - 元素i个，逆序对0个，只1种排列方案
        for (int i = 1; i <= n; i++) {
            dp[i][0] = 1;
        }
        // - 元素i个，逆序对j个
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= k; j++) {
                if (i > j) {
                    // 当前元素为i
                    // 前边有i-1个元素
                    // - 当前元素i可以放最左侧，那么就需要前i-1个元素构成0个逆序对
                    // - 当前元素i可以放次左侧，那么就需要前i-1个元素构成1个逆序对
                    // ...
                    // - 当前元素i可以放最右侧，那么就需要前i-1个元素构成j个逆序对
                    // 上一行的最左侧不是i-1个元素的左侧，而是其中之间的某个位置
                    // 这里刚好可以凑出来j个逆序对，也就不需要前i-1个元素再凑逆序对
                    // 因此这里for循环长度为j+1：从左往右
                    for (int p = 0; p <= j; p++) {
                        dp[i][j] = (dp[i][j] + dp[i - 1][p]) % MOD;
                    }
                } else {
                    // i<=j
                    // 当前元素为i
                    // 前边元素i-1个
                    // - 当前元素可以放在前i-1个元素的最左侧，凑出了i-1个逆序对，需要前i-1个元素凑出j-(i-1)个逆序对
                    // - 当前元素放在前i-1个元素的次左侧，凑出了i-2个逆序对，需要前i-1个元素凑出j-(i-2)个逆序对
                    // ...
                    // - 当前元素放在前i-1个元素的最右侧，凑出了0个逆序对，需要前i-1个元素凑出j个逆序对
                    // 所以这里for循环长度为i-1+1=i
                    for (int p = j - i + 1; p <= j; p++) {
                        dp[i][j] = (dp[i][j] + dp[i - 1][p]) % MOD;
                    }
                }
            }
        }
        // 返回元素n个，逆序对k个的排列方案数
        return dp[n][k];
    }

    public static int kInversePairs2(int n, int k) {
        int[][] dp = new int[n + 1][k + 1];
        // 初始化：
        // - 元素0个，逆序对0个，只1种排列方案
        dp[0][0] = 1;
        // - 元素i个，逆序对0个，只1种排列方案
        for (int i = 1; i <= n; i++) {
            dp[i][0] = 1;
        }
        // - 元素i个，逆序对j个
        for (int i = 1; i <= n; i++) {
            // 类滑动窗口
            int window = 1;
            for (int j = 1; j <= k; j++) {
                if (i > j) {
                    // 吸收1个元素，知道j长度
                    window = (window + dp[i - 1][j]) % MOD;
                } else {
                    // 吸收1个元素，吐出1个元素，维持j长度
                    window = ((window + dp[i - 1][j]) % MOD - dp[i - 1][j - i] + MOD) % MOD;
                }
                dp[i][j] = window;
            }
        }
        // 返回元素n个，逆序对k个的排列方案数
        return dp[n][k];
    }
}
```



## [Leetcode【难】514.自由之路](https://leetcode.cn/problems/freedom-trail/description/)



```java
import java.util.Arrays;

public class Solution {
    // 看链接：https://leetcode.cn/problems/freedom-trail/description/

    public static int MAXN = 101;
    public static int MAXC = 26;
    public static int[] ring = new int[MAXN];
    public static int[] key = new int[MAXN];
    public static int[] size = new int[MAXC];
    public static int[][] where = new int[MAXC][MAXN];
    public static int[][] dp = new int[MAXN][MAXN];
    public static int n, m;

    public static int findRotateSteps(String r, String k) {
        build(r, k);
        return f(0, 0);
    }

    public static void build(String r, String k) {
        Arrays.fill(size, 0);
        n = r.length();
        m = k.length();
        for (int i = 0, val; i < n; i++) {
            val = r.charAt(i) - 'a';
            where[val][size[val]++] = i;
            ring[i] = val;
        }
        for (int i = 0; i < m; i++) {
            key[i] = k.charAt(i) - 'a';
        }
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                dp[i][j] = -1;
            }
        }
    }

    // 当前指针指向轮盘i位置，搞定key[j...]所有字符，最小代价
    public static int f(int i, int j) {
        if (j == m) {
            // 搞定了所有字符，代价为0
            return 0;
        }
        if (dp[i][j] != -1) {
            return dp[i][j];
        }
        int ans = 0;
        if (ring[i] == key[j]) {
            // 当前轮盘位置ring[i]==key[j]
            return 1 + f(i, j + 1);
        } else {
            // 当前位置ring[i]!=key[j]
            // -顺时针第一个等于key[j]的位置
            int jump1 = shunClock(i, key[j]);
            int distance1 = ((jump1 > i) ? (jump1 - i) : (n - i + jump1));
            // -逆时针第一个等于key[j]的位置
            int jump2 = niClock(i, key[j]);
            int distance2 = ((i > jump2) ? (i - jump2) : (n - jump2 + i));
            // -选择更近的一个
            ans = Math.min(distance1 + f(jump1, j), distance2 + f(jump2, j));
        }
        dp[i][j] = ans;
        return ans;
    }

    // 从i位置开始，顺时针最近的v的位置
    public static int shunClock(int i, int v) {
        int l = 0;
        int r = size[v] - 1;
        int[] sortV = where[v];
        int find = -1;
        while (l <= r) {
            int mid = l + (r - l) / 2;
            if (sortV[mid] > i) {
                find = mid;
                r = mid - 1;
            } else {
                l = mid + 1;
            }
        }
        // 没有比i大的，返回最小的
        return find == -1 ? sortV[0] : sortV[find];
    }

    // 从i位置开始，逆时针最近的v的位置
    public static int niClock(int i, int v) {
        int l = 0;
        int r = size[v] - 1;
        int[] sortV = where[v];
        int find = -1;
        while (l <= r) {
            int mid = l + (r - l) / 2;
            if (sortV[mid] < i) {
                find = mid;
                l = mid + 1;
            } else {
                r = mid - 1;
            }
        }
        // 没有比i小的，返回最大的
        return find == -1 ? sortV[size[v] - 1] : sortV[find];
    }
}
```



## [牛客【】未排序数组中累加和小于或等于给定值的最长子数组长度](https://www.nowcoder.com/practice/3473e545d6924077a4f7cbc850408ade)



```java
import java.io.*;

public class Solution {
    // 给定一个长度为n的元素可正可负可为零的无序数组arr
    // 给定一个整数k
    // 返回arr所有子数组中累加和不大于k的最长子数组长度
    // 时间复杂度O(n)

    public static int MAXN = 100001;

    public static int[] nums = new int[MAXN];
    public static int[] minSums = new int[MAXN];
    public static int[] minSumEnds = new int[MAXN];

    public static int n, k;

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            in.nextToken();
            k = (int) in.nval;
            for (int i = 0; i < n; i++) {
                in.nextToken();
                nums[i] = (int) in.nval;
            }
            out.println(compute1());
            out.println(compute2());
        }
        out.flush();
        out.close();
    }

    public static int compute1() {
        // 前缀和升序数组
        int[] sums = new int[n + 1];
        for (int i = 0, sum = 0; i < n; i++) {
            sum += nums[i];
            // 因为该数组的作用是：
            // 找到前缀和大于等于某个值的最早的位置
            // 那么当前位置只有两种情况
            // - 当前前缀和大于等于上一前缀和-->选择当前前缀和
            // - 当前前缀和小于上一前缀和-->选择上一前缀和
            sums[i + 1] = Math.max(sum, sums[i]);
        }
        int ans = 0;
        for (int i = 0, sum = 0, pre, len; i < n; i++) {
            // 0...i范围上的累加和
            sum += nums[i];
            // 在sums数组中，首个大于等于sum-k的位置
            pre = f(sums, sum - k);
            // 如果找到了，那么就是i-pre+1，因为前者是从0开始，后者是从1开始，因此需要+1
            len = pre == -1 ? 0 : i - pre + 1;
            ans = Math.max(ans, len);
        }
        return ans;
    }

    public static int f(int[] sums, int num) {
        int l = 0;
        int r = n;
        int mid;
        int ans = -1;
        while (l <= r) {
            mid = l + (r - l) / 2;
            if (sums[mid] >= num) {
                ans = mid;
                r = mid - 1;
            } else {
                l = mid + 1;
            }
        }
        return ans;
    }

    public static int compute2() {
        // nums数组中
        // minSums[i]表示
        // - 以nums[i]开头的nums[i...n-1]的最小累计和片段
        minSums[n - 1] = nums[n - 1];
        // minSUmEnds[i]表示
        // - 以nums[i]开头的nums[i...n-1]的最小累计和片段的结束位置
        minSumEnds[n - 1] = n - 1;
        for (int i = n - 2; i >= 0; i--) {
            if (minSums[i + 1] < 0) {
                // 如果右侧的累加和小于零，那么当前位置加上右侧的累加和一定会变小
                // 因此，当前位置的最小累计和片段就是当前位置加上右侧的最小累计和片段
                minSums[i] = nums[i] + minSums[i + 1];
                minSumEnds[i] = minSumEnds[i + 1];
            } else {
                // 如果右侧的累加和大于等于零，那么当前位置加上右侧的累加和不一定会变小
                // 因此，当前位置的最小累计和片段就是当前位置自己
                minSums[i] = nums[i];
                minSumEnds[i] = i;
            }
        }
        int ans = 0;
        // 滑动窗口，单向滑动
        for (int i = 0, sum = 0, end = 0; i < n; i++) {
            // 逐步吐出左边界，直到右侧可以再扩一组
            while (end < n && sum + minSums[end] <= k) {
                sum += minSums[end];
                end = minSumEnds[end] + 1;
            }
            if (end > i) {
                // 窗口有效
                ans = Math.max(ans, end - i);
                // 吐出当前左边界
                sum -= nums[i];
                // 此时会进入下一轮循环，在减去当前左边界的情况下
                // 判断我们能否右扩一组
            } else {
                // end==i，说明当前位置的最小累计和片段就是当前位置自己
                // 因此，需要将end右移一位
                end = i + 1;
            }
        }
        return ans;
    }
}
```



***



# ✅084【必备】数位 dp-上



## [Leetcode【中】357.统计各位数字都不同的数字个数](https://leetcode.cn/problems/count-numbers-with-unique-digits/description/)



```java
public class Solution {
    // 给定一个整数n，表示十进制数字最多有n位
    // 如果一个数字的每一位都不相同，那么称其为有效数字
    // 返回有效数字的个数

    public static int countNumbersWithUniqueDigits(int n) {
        if (n == 0) {
            return 1;
        }
        int ans = 10;
        // 1:10
        // 2:9*9
        // 3:9*9*8
        // 4:9*9*8*7
        // 累加
        for (int s = 9, i = 9, k = 2; k <= n; i--, k++) {
            s *= i;
            ans += s;
        }
        return ans;
    }
}
```



## [Leetcode【难】902.最大为 N 的数字组合](https://leetcode.cn/problems/numbers-at-most-n-given-digit-set/description/)



```java
public class Solution {
    // 给定一个非递减排序排列的数字数组digits
    // - digits数组中没有'0'
    // - digits数组中包含'1'~'9'
    // 对于digits数组中元素可以使用任意次数
    // 拼凑成一个整数
    // 返回小于等于整数n的正整数个数

    public static int atMostNGivenDigitSet1(String[] strs, int num) {
        int tmp = num / 10;
        int len = 1;
        int offset = 1;
        while (tmp > 0) {
            tmp /= 10;
            len++;
            offset *= 10;
        }
        int m = strs.length;
        int[] digits = new int[m];
        for (int i = 0; i < m; i++) {
            digits[i] = Integer.valueOf(strs[i]);
        }
        return f1(digits, num, offset, len, 0, 0);
    }

    // digits：存储可供我们使用的数字
    // num：目标必须小于等于的整数
    // - num=54321
    // offset：辅助变量
    // - 和num长度一致：10000
    // len：还没有决定的位的长度
    // free：
    // - 如果上一位确定比对应的num小，free=1，当前位可以自由选择
    // - 如果上一位和对应的num相等，free=0，当前位只能选择不大于num对应位的数字
    // fix：
    // - 如果之前的位都没有选择数字，fix=0
    // - 如果之前的位选择了数字，fix=1
    public static int f1(int[] digits, int num, int offset, int len, int free, int fix) {
        if (len == 0) {
            // 所有位都已经完成
            // - 如果到此时仍然没有选择数字，那么就是零位
            // - 如果到此时所有位都已经完成，那么就是1种有效数字
            return fix == 1 ? 1 : 0;
        }
        int ans = 0;
        // num当前位的数字
        int cur = (num / offset) % 10;
        if (fix == 0) {
            // 如果之前从来没有选择过数字，那么当前位依然可以不选择数字
            ans += f1(digits, num, offset / 10, len - 1, 1, 0);
        }
        // 如果上一位选择过数字：
        // - 如果上一位的数字和num对应位相等，那么当前位只能选择不大于num对应位的数字
        // - 如果上一位的数字和num对应位不相等，那么当前位可以选择任意数字
        if (free == 0) {
            // 上一位的数字二者相等
            for (int i : digits) {
                if (i < cur) {
                    ans += f1(digits, num, offset / 10, len - 1, 1, 1);
                } else if (i == cur) {
                    ans += f1(digits, num, offset / 10, len - 1, 0, 1);
                } else {
                    // i>cur
                    // digits是非递减数组
                    break;
                }
            }
        } else {
            // free=1，当前位置可以自由选择
            ans += digits.length * f1(digits, num, offset / 10, len - 1, 1, 1);
        }
        return ans;
    }

    public static int atMostNGivenDigitSet2(String[] strs, int num) {
        int tmp = num / 10;
        int len = 1;
        int offset = 1;
        while (tmp > 0) {
            tmp /= 10;
            len++;
            offset *= 10;
        }
        int m = strs.length;
        int[] digits = new int[m];
        for (int i = 0; i < m; i++) {
            digits[i] = Integer.valueOf(strs[i]);
        }
        int ans = 0;
        // cnt[i]：表示已知前缀比对应的num小，还有i位没有确定，可以自由选择出来多少种
        int[] cnt = new int[len];
        cnt[0] = 1;
        for (int i = m, k = 1; k < len; k++, i *= m) {
            cnt[k] = i;
            ans += i;
        }
        // 已经计算好比num小一位的所有情况
        // 现在计算和num一样长的所有情况
        // 也就是只剩下两种需要考虑的情况
        // - 当前位确定小于num对应位，那么后续len-1位都自由选择
        // - 当前位确定等于num对应位，后续继续递归
        return ans + f2(digits, cnt, num, offset, len);
    }

    public static int f2(int[] digits, int[] cnt, int num, int offset, int len) {
        if (len == 0) {
            // 所有位都已经完成
            // 所有位都等于num对应位，即num
            return 1;
        }
        int ans = 0;
        // num当前位的数字
        int cur = (num / offset) % 10;
        for (int i : digits) {
            if (i < cur) {
                // 如果当前位确定小于num对应位，那么后续len-1位都自由选择
                ans += cnt[len - 1];
            } else if (i == cur) {
                // 如果当前位确定等于num对应位，后续继续递归
                ans += f2(digits, cnt, num, offset / 10, len - 1);
            } else {
                break;
            }
        }
        return ans;
    }
}
```



## [Leetcode【难】2719.统计整数数目](https://leetcode.cn/problems/count-of-integers/description/)



```java
public class Solution {
    // 给定
    // - 两个数字字符串num1、num2
    // - 1<=num1<=num2<=10^22
    // - 两个整数max_sum、min_sum
    // - 1<=min_sum<=max_sum<=400
    // 对于一个整数x
    // - num1<=x<=num2
    // - min_sum<=digit_sum(x)<=max_sum
    // - digit_sum(x)为x的各位数字之和
    // - 则称之为一个好整数
    // 返回好整数的数目，结果对1000000007取模

    public static int MOD = 1000000007;
    public static int MAN = 23;
    public static int MAM = 401;

    public static int[][][] dp = new int[MAN][MAM][2];

    public static void build() {
        for (int i = 0; i < len; i++) {
            for (int j = 0; j <= max; j++) {
                dp[i][j][0] = -1;
                dp[i][j][1] = -1;
            }
        }
    }

    public static char[] num;

    public static int min, max, len;

    public static int count(String num1, String num2, int min_sum, int max_sum) {
        min = min_sum;
        max = max_sum;
        num = num2.toCharArray();
        len = num.length;
        build();
        int ans1 = f(0, 0, 0);
        num = num1.toCharArray();
        len = num.length;
        build();
        int ans2 = f(0, 0, 0);
        int ans = (ans1 - ans2 + MOD) % MOD;
        if (check()) {
            ans++;
        }
        return ans;
    }

    // char[] num：右边界数字
    // len：数字长度
    // 从num的高位出发，当前位置是i位：0<=i<len
    // 之前决定的累加和为sum
    // free：
    // - 0：之前的决定和num一样，后续不可以自由选择数字
    // - 1：之前的决定已经比num小，后续可以自由选择数字
    public static int f(int i, int sum, int free) {
        if (sum > max) {
            // 超过了最大累加和
            return 0;
        }
        if (sum + (len - i) * 9 < min) {
            // 无论如何也满足不了最小累加和
            return 0;
        }
        if (i == len) {
            // 所有位都已经处理完毕
            return 1;
        }
        if (dp[i][sum][free] != -1) {
            return dp[i][sum][free];
        }
        int ans = 0;
        // num当前位数字
        int cur = num[i] - '0';
        // 为什么这里可以当前位从"0"开始选择
        // 因为我们这里是给定一个数num
        // 找到0~num范围内
        // 所有符合要求的数
        // 然后再给定一个数num2
        // 找到num1~num2范围内
        // 所有符合要求的数
        // 范围大的减去范围小的
        if (free == 0) {
            // 当前位不能自由选择
            for (int pick = 0; pick < cur; pick++) {
                ans = (ans + f(i + 1, sum + pick, 1)) % MOD;
            }
            ans = (ans + f(i + 1, sum + cur, 0)) % MOD;
        } else {
            // 当前位可以自由选择
            for (int pick = 0; pick <= 9; pick++) {
                ans = (ans + f(i + 1, sum + pick, 1)) % MOD;
            }
        }
        dp[i][sum][free] = ans;
        return ans;
    }

    // 检查较小的num1是否符合要求
    public static boolean check() {
        int sum = 0;
        for (char cha : num) {
            sum += cha - '0';
        }
        return sum >= min && sum <= max;
    }
}
```



## [Leetcode【难】2376.统计特殊整数](https://leetcode.cn/problems/count-special-integers/description/)



```java
public class Solution {
    // 给定一个正整数n
    // 返回[1,n]范围内每一位都互不相同的正整数个数

    public static int countSpecialNumbers(int n) {
        int tmp = n / 10;
        int len = 1;
        int offset = 1;
        while (tmp > 0) {
            tmp /= 10;
            len++;
            offset *= 10;
        }
        // cnt[i]
        // - n的长度为len，还有i位没有确定，确定了len-i位，也就是已经使用了len-i个数字
        // - 那么当前位可选择的不重复的数字有10-(len-i)种
        int[] cnt = new int[len];
        // 初始化
        // - 还有0位没确定，那么当前的数字各位都已经确定，即为1种
        cnt[0] = 1;
        // - 还有1位没确定，还有可选的数字10-(len-1)种
        // - 还有2位没确定，还有可选的数字10-(len-2)种
        // - ......
        // - 还有len-1位没确定，还有可选的数字10-(len-(len-1))=9种
        for (int i = 1, k = 10 - (len - 1); i < len; i++, k++) {
            cnt[i] = cnt[i - 1] * k;
        }
        int ans = 0;
        // 先计算位数小于len的所有情况
        // - 1位：9种
        // - 2位：9 * 9种
        // - 3位：9 * 9 * 8种
        // - 4位：9 * 9 * 8 * 7种
        // ......
        // 累加
        if (len >= 2) {
            ans = 9;
            for (int i = 2, a = 9, b = 9; i < len; i++, b--) {
                a *= b;
                ans += a;
            }
        }
        // 最高位数字
        int first = n / offset;
        // - 最高位数字选择了一个小于n对应位置的数，那么就是(first-1)*对应的cnt[len-1]
        ans += (first - 1) * cnt[len - 1];
        // - 最高位数字选择了一个等于n对应位置的数，那么调用递归
        ans += f(cnt, n, len - 1, offset / 10, 1 << first);
        return ans;
    }

    // 已经确定了和num一样的前缀，并且一定不为空
    // 还有len长度的位没有确定
    // status：表示9~0这些数字是否被使用了
    // - 第i位（从0开始）如果是1，那么表示i这个数字被使用了
    // - 第i位如果是0，那么表示i这个数字没有被使用
    public static int f(int[] cnt, int num, int len, int offset, int status) {
        if (len == 0) {
            // num自己
            return 1;
        }
        int ans = 0;
        // num当前位的数字
        int first = (num / offset) % 10;
        // 小于num当前位数字的情况
        for (int cur = 0; cur < first; cur++) {
            // 如果cur这个数字没有被使用
            if ((status & (1 << cur)) == 0) {
                ans += cnt[len - 1];
            }
        }
        // 等于num当前位数字并且这个数字没有被使用
        if ((status & (1 << first)) == 0) {
            ans += f(cnt, num % offset, len - 1, offset / 10, status | (1 << first));
        }
        return ans;
    }
}
```



## [Leetcode【难】1012.至少有 1 位重复的数字](https://leetcode.cn/problems/numbers-with-repeated-digits/description/)



```java
public class Solution {
    // 给定一个正整数n
    // 返回[1,n]范围内至少有1位重复数字的正整数个

    public static int numDupDigitsAtMostN(int n) {
        return n - countSpecialNumbers(n);
    }

    public static int countSpecialNumbers(int n) {
        int tmp = n / 10;
        int len = 1;
        int offset = 1;
        while (tmp > 0) {
            tmp /= 10;
            len++;
            offset *= 10;
        }
        // cnt[i]
        // - n的长度为len，还有i位没有确定，确定了len-i位，也就是已经使用了len-i个数字
        // - 那么当前位可选择的不重复的数字有10-(len-i)种
        int[] cnt = new int[len];
        // 初始化
        // - 还有0位没确定，那么当前的数字各位都已经确定，即为1种
        cnt[0] = 1;
        // - 还有1位没确定，还有可选的数字10-(len-1)种
        // - 还有2位没确定，还有可选的数字10-(len-2)种
        // - ......
        // - 还有len-1位没确定，还有可选的数字10-(len-(len-1))=9种
        for (int i = 1, k = 10 - (len - 1); i < len; i++, k++) {
            cnt[i] = cnt[i - 1] * k;
        }
        int ans = 0;
        // 先计算位数小于len的所有情况
        // - 1位：9种
        // - 2位：9 * 9种
        // - 3位：9 * 9 * 8种
        // - 4位：9 * 9 * 8 * 7种
        // ......
        // 累加
        if (len >= 2) {
            ans = 9;
            for (int i = 2, a = 9, b = 9; i < len; i++, b--) {
                a *= b;
                ans += a;
            }
        }
        // 最高位数字
        int first = n / offset;
        // - 最高位数字选择了一个小于n对应位置的数，那么就是(first-1)*对应的cnt[len-1]
        ans += (first - 1) * cnt[len - 1];
        // - 最高位数字选择了一个等于n对应位置的数，那么调用递归
        ans += f(cnt, n, len - 1, offset / 10, 1 << first);
        return ans;
    }

    // 已经确定了和num一样的前缀，并且一定不为空
    // 还有len长度的位没有确定
    // status：表示9~0这些数字是否被使用了
    // - 第i位（从0开始）如果是1，那么表示i这个数字被使用了
    // - 第i位如果是0，那么表示i这个数字没有被使用
    public static int f(int[] cnt, int num, int len, int offset, int status) {
        if (len == 0) {
            // num自己
            return 1;
        }
        int ans = 0;
        // num当前位的数字
        int first = (num / offset) % 10;
        // 小于num当前位数字的情况
        for (int cur = 0; cur < first; cur++) {
            // 如果cur这个数字没有被使用
            if ((status & (1 << cur)) == 0) {
                ans += cnt[len - 1];
            }
        }
        // 等于num当前位数字并且这个数字没有被使用
        if ((status & (1 << first)) == 0) {
            ans += f(cnt, num % offset, len - 1, offset / 10, status | (1 << first));
        }
        return ans;
    }
}
```



***



# ✅085【必备】数位 dp-下



## [洛谷【普及/提高-】P2657 \[SCOI2009\] windy 数](https://www.luogu.com.cn/problem/P2657)



```java
import java.io.*;

public class Solution {
    // 若一个数不含前导零，且任意相邻位置的两个数字只差最少位2，成为windy数
    // 返回[a,b]范围上windy数的个数

    public static int MAXLEN = 11;
    public static int[][][] dp = new int[MAXLEN][11][2];

    public static void build(int len) {
        for (int i = 0; i <= len; i++) {
            for (int j = 0; j <= 10; j++) {
                dp[i][j][0] = dp[i][j][1] = -1;
            }
        }
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            int a = (int) in.nval;
            in.nextToken();
            int b = (int) in.nval;
            out.println(compute(a, b));
        }
        out.flush();
        out.close();
    }

    public static int compute(int a, int b) {
        return cnt(b) - cnt(a - 1);
    }

    public static int cnt(int num) {
        if (num == 0) {
            return 1;
        }
        int tmp = num / 10;
        int len = 1;
        int offset = 1;
        while (tmp > 0) {
            len++;
            offset *= 10;
            tmp /= 10;
        }
        build(len);
        return f(num, offset, len, 10, 0);
    }

    // len：还有len位没有决定
    // pre：表示上一位的数字，如果上一位没有选数字，pre=10
    // free：
    // - 如果上一位确定比num对应位的数字小，那么free=1，表示接下来数字可以自由选择
    // - 如果上一位和num对应位的数字一样，那么free=0，表示接下来数字不能大于num当前位的数字
    public static int f(int num, int offset, int len, int pre, int free) {
        if (len == 0) {
            return 1;
        }
        if (dp[len][pre][free] != -1) {
            return dp[len][pre][free];
        }
        int ans = 0;
        // num当前位上的数字
        int cur = num / offset % 10;
        if (free == 0) {
            // 上一位和num对应位的数字一样
            if (pre == 10) {
                // 之前的位和num一样
                // 上一位还没有选
                // 此时我们来到了num的最高位
                // - 当前位不选择数字
                ans += f(num, offset / 10, len - 1, 10, 1);
                // - 当前位选择小于cur的数字，这里跳过了0，因为我们已经考虑过了当前位不选的情况
                for (int i = 1; i < cur; i++) {
                    ans += f(num, offset / 10, len - 1, i, 1);
                }
                // - 当前位选择等于cur的数字
                ans += f(num, offset / 10, len - 1, cur, 0);
            } else {
                // 之前的位和num一样
                // 上一位选择了pre，因为当前位置不是开头，所以可以从零开始考虑
                for (int i = 0; i <= 9; i++) {
                    // 选择合规的数字
                    if (i <= pre - 2 || i >= pre + 2) {
                        // 因为此时我们需要选择小于等于cur的数字
                        if (i < cur) {
                            ans += f(num, offset / 10, len - 1, i, 1);
                        } else if (i == cur) {
                            ans += f(num, offset / 10, len - 1, cur, 0);
                        }
                    }
                }
            }
        } else {
            // 之前的位确定比num对应的位小，这里我们可以自由选择
            if (pre == 10) {
                // 之前没有选择过数字
                ans += f(num, offset / 10, len - 1, 10, 1);
                // - 当前位选择任意数字，这里跳过了0，因为我们已经考虑过了当前位不选的情况
                for (int i = 1; i <= 9; i++) {
                    ans += f(num, offset / 10, len - 1, i, 1);
                }
            } else {
                // 之前选择的数字为pre
                for (int i = 0; i <= 9; i++) {
                    if (i <= pre - 2 || i >= pre + 2) {
                        ans += f(num, offset / 10, len - 1, i, 1);
                    }
                }
            }
        }
        dp[len][pre][free] = ans;
        return ans;
    }
}
```



## [洛谷【省选/NOI-】P3413 SAC#1 - 萌数](https://www.luogu.com.cn/problem/P3413)



```java
import java.io.*;

public class Solution {
    // 给定两个数字l,r，l<=r<=10^1000
    // 若一个数中存在长度至少为2的回文子串，则为萌数
    // 返回[l,r]范围上萌数的数量，结果对1000000007取模

    public static int MOD = 1000000007;
    public static int MAXN = 1001;
    public static int[][][][] dp = new int[MAXN][11][11][2];

    public static void build(int n) {
        for (int i = 0; i < n; i++) {
            for (int pp = 0; pp < 11; pp++) {
                for (int p = 0; p < 11; p++) {
                    for (int free = 0; free < 2; free++) {
                        dp[i][pp][p][free] = -1;
                    }
                }
            }
        }
    }

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        String[] strs = br.readLine().split(" ");
        out.println(compute(strs[0].toCharArray(), strs[1].toCharArray()));
        out.flush();
        out.close();
        br.close();
    }

    public static int compute(char[] l, char[] r) {
        int ans = (cnt(r) - cnt(l) + MOD) % MOD;
        if (check(l)) {
            ans = (ans + 1) % MOD;
        }
        return ans;
    }

    // 若想要不是萌数的数，也就是不能出现回文字串
    // - aa型
    // - aba型

    // 统计[0,num]范围上萌数的个数
    // 对于num数组
    // num[0]是最高位
    public static int cnt(char[] num) {
        if (num[0] == '0') {
            return 0;
        }
        int n = num.length;
        long all = 0;
        long base = 1;
        for (int i = n - 1; i >= 0; i--) {
            all = (all + (num[i] - '0') * base) % MOD;
            base = (base * 10) % MOD;
        }
        build(n);
        return (int) ((all - f(num, 0, 10, 10, 0) + MOD) % MOD);
    }

    // 从num的高位开始，当前来到第i位
    // 前一位数字为p
    // 前前一位数字为pp
    // free：
    // - 如果之前的位确定比num对应的数字小，free=1，当前位可以自由选择
    // - 如果之前的位和num一样，free=0，当前位不能大于num当前位的数字
    public static int f(char[] num, int i, int pp, int p, int free) {
        if (i == num.length) {
            // 我们从第0位出发，来到第num.length位时，已经完成了所有位的选择，返回1种
            return 1;
        }
        if (dp[i][pp][p][free] != -1) {
            return dp[i][pp][p][free];
        }
        int ans = 0;
        if (free == 0) {
            // 如果上一位和num对应位一样
            if (p == 10) {
                // 我们此时来到了最高位
                // - 当前位不选数字
                ans = (ans + f(num, i + 1, 10, 10, 1)) % MOD;
                // - 当前位选择比num[i]小的数字，但因为是开头，不能选0
                for (int cur = 1; cur < num[i] - '0'; cur++) {
                    ans = (ans + f(num, i + 1, p, cur, 1)) % MOD;
                }
                // - 当前位选择与num[i]一样的数字
                ans = (ans + f(num, i + 1, p, num[i] - '0', 0)) % MOD;
            } else {
                // 当前位需要选择比num[i]小的数字，这里因为已经不是开头，0可以选
                for (int cur = 0; cur < num[i] - '0'; cur++) {
                    if (pp != cur && p != cur) {
                        ans = (ans + f(num, i + 1, p, cur, 1)) % MOD;
                    }
                }
                // - 当前位选择与num[i]一样的数字
                if (pp != num[i] - '0' && p != num[i] - '0') {
                    ans = (ans + f(num, i + 1, p, num[i] - '0', 0)) % MOD;
                }
            }
        } else {
            // 如果之前的位确定比num对应的数字小
            if (p == 10) {
                // 上一位位不选数字，前边的所有位都没有选过数字
                // - 继续不选数字
                ans = (ans + f(num, i + 1, 10, 10, 1)) % MOD;
                // - 当前位选择任意数字，因为是开头，不能选0
                for (int cur = 1; cur <= 9; cur++) {
                    ans = (ans + f(num, i + 1, p, cur, 1)) % MOD;
                }
            } else {
                // 之前位选过数字
                for (int cur = 0; cur <= 9; cur++) {
                    if (pp != cur && p != cur) {
                        ans = (ans + f(num, i + 1, p, cur, 1)) % MOD;
                    }
                }
            }
        }
        dp[i][pp][p][free] = ans;
        return ans;
    }

    // 判断一个数是否是萌数
    public static boolean check(char[] num) {
        for (int pp = -2, p = -1, i = 0; i < num.length; pp++, p++, i++) {
            if (pp >= 0 && num[pp] == num[i]) {
                return true;
            }
            if (p >= 0 && num[p] == num[i]) {
                return true;
            }
        }
        return false;
    }
}
```



## [Leetcode【难】600.不含连续 1 的非负整数](https://leetcode.cn/problems/non-negative-integers-without-consecutive-ones/description/)



```java
public class Solution {
    // 给定一个整数n
    // 统计[0,n]范围内非负整数中
    // 有多少个整数的二进制中不存在连续的1

    public static int findIntegers1(int n) {
        // int类型数，32bit位：31位是符号位，也就是考虑[30,0]范围内
        int[] cnt = new int[31];
        // 0位随便填，只能是0
        cnt[0] = 1;
        // 1位随便填，只能是0或1
        cnt[1] = 2;
        // 2位随便填
        // - 第1位是1，第0位只能是0
        // - 第1位是0，第0位随便填
        // i位随便填
        // - 第i位是1，第i-1位只能是0，第i-2位随便填
        // - 第i位是0，第i-1位随便填
        for (int len = 2; len <= 30; len++) {
            cnt[len] = cnt[len - 1] + cnt[len - 2];
        }
        return f(cnt, n, 30);
    }

    // cnt[i]：共i位可以供我们随便填，可以填出多少种满足要求的数
    // 从num二进制高位开始，当前来到第i位
    public static int f(int[] cnt, int num, int i) {
        if (i == -1) {
            // 第0位都已经决定了
            return 1;
        }
        int ans = 0;
        // num当前位是1
        if ((num & (1 << i)) != 0) {
            // 当前位选0，余下i-1+1=i位随便填
            ans += cnt[i];
            // 如果num有两个连续的1
            if ((num & (1 << (i + 1))) != 0) {
                // 这里是为了避免我们后续进入：f(cnt,num,i-1)
                // 因为这意味着我们可能会
                // 以当前位选1进入下一轮循环，然后在下一位累加上选0的cnt
                // 然后再次以选1进入下下一轮循环，显然不符合要求，直接退出。
                return ans;
            }
        }
        // 当前位和num对应位保持一致 || 当前位是0，我们也必须选0
        // 从下一位开始随便选
        ans += f(cnt, num, i - 1);
        return ans;
    }

    public static int findIntegers2(int n) {
        int[] cnt = new int[31];
        cnt[0] = 1;
        cnt[1] = 2;
        for (int len = 2; len <= 30; len++) {
            cnt[len] = cnt[len - 1] + cnt[len - 2];
        }
        int ans = 0;
        for (int i = 30; i >= -1; i--) {
            if (i == -1) {
                ans++;
                break;
            }
            if ((n & (1 << i)) != 0) {
                ans += cnt[i];
                if ((n & (1 << (i + 1))) != 0) {
                    break;
                }
            }
        }
        return ans;
    }
}
```



## [洛谷【普及+/提高】P2602 \[ZJOI2010\] 数字计数](https://www.luogu.com.cn/problem/P2602)



```java
import java.io.*;

public class Solution {
    // 给定两个整数a,b
    // 1 <= a, b <= 10^12
    // 统计[a,b]范围内所有整数
    // 每个数字g各自出现了多少次
    // 返回一个长度为10的数组

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            long a = (long) in.nval;
            in.nextToken();
            long b = (long) in.nval;
            for (int i = 0; i < 9; i++) {
                out.print(digitsCount(i, a, b) + " ");
            }
            out.println(digitsCount(9, a, b));
        }
        out.flush();
        out.close();
    }

    public static long digitsCount(int d, long a, long b) {
        return count(b, d) - count(a - 1, d);
    }

    // 统计[1,num]范围内所有整数
    // 数字d出现了多少次
    public static long count(long num, int d) {
        long ans = 0;
        // right：右半部分
        // left：左半部分
        for (long right = 1, tmp = num, left, cur; tmp != 0; right *= 10, tmp /= 10) {
            left = tmp / 10;
            // 假设num是30583
            // d!=0,d=5
            // - 个位3：cur<d：0000~3057(3058种)*1(1种) +30585(0种)
            // - 十位8：cur>d：000~304(305种) * 0~9(10种)+3055_(10种)
            // - 百位5：cur=d：00~29(30种) * 0~99(100种) +305__(83+1种)
            // - 千位0：cur<d：0~2(3种) * 0~999(1000种) +35___(0种)
            // - 万位3：cur<d：0种 * 0~9999(10000种) +5____(0种)
            // d=0
            // - 个位3：cur>d：0001~3057(3057种)*1(1种) +30580(1种)
            // - 十位8：cur>d：001~304(304种) * 0~9(10种)+3050_(10种)
            // - 百位5：cur>d：01~29(29种) * 00~99(100种)+300__(100种)
            // - 千位0：cur=d：1~2(2种) * 000~999(1000种)+30___(583+1种)
            // - 万位3：cur>d：0种 * 0~9999(10000种) +0____(10000种)
            if (d == 0) {
                left--;
            }
            ans += left * right;
            cur = tmp % 10;
            if (cur > d) {
                ans += right;
            } else if (cur == d) {
                ans += num % right + 1;
            }
        }
        return ans;
    }
}
```



## [Leetcode【难】233.数字 1 的个数](https://leetcode.cn/problems/number-of-digit-one/description/)



```java
public class Solution {
    // 给定一个整数n
    // 统计[0,n]范围内所有整数
    // 数字1出现了多少次

    public static int countDigitOne(int n) {
        return count(n, 1);
    }

    // 统计[0,num]范围内所有整数
    // 数字d出现了多少次
    public static int count(int num, int d) {
        int ans = 0;
        // right：右半部分
        // left：左半部分
        for (long right = 1, tmp = num, left, cur; tmp != 0; right *= 10, tmp /= 10) {
            left = tmp / 10;
            // 假设num是30583
            // d!=0,d=5
            // - 个位3：cur<d：0000~3057(3058种)*1(1种) +30585(0种)
            // - 十位8：cur>d：000~304(305种) * 0~9(10种)+3055_(10种)
            // - 百位5：cur=d：00~29(30种) * 0~99(100种) +305__(83+1种)
            // - 千位0：cur<d：0~2(3种) * 0~999(1000种) +35___(0种)
            // - 万位3：cur<d：0种 * 0~9999(10000种) +5____(0种)
            // d=0
            // - 个位3：cur>d：0001~3057(3057种)*1(1种) +30580(1种)
            // - 十位8：cur>d：001~304(304种) * 0~9(10种)+3050_(10种)
            // - 百位5：cur>d：01~29(29种) * 00~99(100种)+300__(100种)
            // - 千位0：cur=d：1~2(2种) * 000~999(1000种)+30___(583+1种)
            // - 万位3：cur>d：0种 * 0~9999(10000种) +0____(10000种)
            if (d == 0) {
                left--;
            }
            ans += left * right;
            cur = tmp % 10;
            if (cur > d) {
                ans += right;
            } else if (cur == d) {
                ans += num % right + 1;
            }
        }
        return ans;
    }
}
```



## [洛谷【提高+/省选-】P13085 \[SCOI2009\] windy 数（加强版）](https://www.luogu.com.cn/problem/P13085)



```java
import java.io.*;

public class Solution {
    // 若一个数不含前导零，且任意相邻位置的两个数字只差最少位2，成为windy数
    // 返回[a,b]范围上windy数的个数

    public static int MAXLEN = 21;
    public static long[][][] dp = new long[MAXLEN][11][2];

    public static void build(int len) {
        for (int i = 0; i <= len; i++) {
            for (int j = 0; j <= 10; j++) {
                dp[i][j][0] = dp[i][j][1] = -1;
            }
        }
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            long a = (long) in.nval;
            in.nextToken();
            long b = (long) in.nval;
            out.println(compute(a, b));
        }
        out.flush();
        out.close();
    }

    public static long compute(long a, long b) {
        return cnt(b) - cnt(a - 1);
    }

    public static long cnt(long num) {
        if (num == 0) {
            return 1;
        }
        long tmp = (long) (num / 10);
        int len = 1;
        long offset = 1;
        while (tmp > 0) {
            len++;
            offset *= 10;
            tmp /= 10;
        }
        build(len);
        return f(num, offset, len, 10, 0);
    }

    // len：还有len位没有决定
    // pre：表示上一位的数字，如果上一位没有选数字，pre=10
    // free：
    // - 如果上一位确定比num对应位的数字小，那么free=1，表示接下来数字可以自由选择
    // - 如果上一位和num对应位的数字一样，那么free=0，表示接下来数字不能大于num当前位的数字
    public static long f(long num, long offset, int len, int pre, int free) {
        if (len == 0) {
            return 1;
        }
        if (dp[len][pre][free] != -1) {
            return dp[len][pre][free];
        }
        long ans = 0;
        // num当前位上的数字
        int cur = (int) (num / offset % 10);
        if (free == 0) {
            // 上一位和num对应位的数字一样
            if (pre == 10) {
                // 之前的位和num一样
                // 上一位还没有选
                // 此时我们来到了num的最高位
                // - 当前位不选择数字
                ans += f(num, offset / 10, len - 1, 10, 1);
                // - 当前位选择小于cur的数字，这里跳过了0，因为我们已经考虑过了当前位不选的情况
                for (int i = 1; i < cur; i++) {
                    ans += f(num, offset / 10, len - 1, i, 1);
                }
                // - 当前位选择等于cur的数字
                ans += f(num, offset / 10, len - 1, cur, 0);
            } else {
                // 之前的位和num一样
                // 上一位选择了pre，因为当前位置不是开头，所以可以从零开始考虑
                for (int i = 0; i <= 9; i++) {
                    // 选择合规的数字
                    if (i <= pre - 2 || i >= pre + 2) {
                        // 因为此时我们需要选择小于等于cur的数字
                        if (i < cur) {
                            ans += f(num, offset / 10, len - 1, i, 1);
                        } else if (i == cur) {
                            ans += f(num, offset / 10, len - 1, cur, 0);
                        }
                    }
                }
            }
        } else {
            // 之前的位确定比num对应的位小，这里我们可以自由选择
            if (pre == 10) {
                // 之前没有选择过数字
                ans += f(num, offset / 10, len - 1, 10, 1);
                // - 当前位选择任意数字，这里跳过了0，因为我们已经考虑过了当前位不选的情况
                for (int i = 1; i <= 9; i++) {
                    ans += f(num, offset / 10, len - 1, i, 1);
                }
            } else {
                // 之前选择的数字为pre
                for (int i = 0; i <= 9; i++) {
                    if (i <= pre - 2 || i >= pre + 2) {
                        ans += f(num, offset / 10, len - 1, i, 1);
                    }
                }
            }
        }
        dp[len][pre][free] = ans;
        return ans;
    }
}
```



***



# ✅086【必备】如何得到具体方案



## [牛客【】最长公共子序列](https://www.nowcoder.com/practice/4727c06b9ee9446cab2e859b4bb86bb8)



```java
import java.io.*;

public class Solution {
    // 给定两个字符串str1、和str2
    // 返回他的最长公共子序列中的一种

    public static int MAXN = 5001;

    public static int[][] dp = new int[MAXN][MAXN];

    public static char[] ans = new char[MAXN];

    public static char[] s1;

    public static char[] s2;

    public static int n, m, k;

    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        s1 = br.readLine().toCharArray();
        s2 = br.readLine().toCharArray();
        n = s1.length;
        m = s2.length;
        LCS();
        if (k == 0) {
            out.println(-1);
        } else {
            for (int i = 0; i < k; i++) {
                out.print(ans[i]);
            }
            out.println();
        }
        out.flush();
        out.close();
        br.close();
    }

    public static void LCS() {
        dp();
        k = dp[n][m];
        if (k > 0) {
            for (int len = k, i = n, j = m; len > 0;) {
                if (s1[i - 1] == s2[j - 1]) {
                    ans[--len] = s1[i - 1];
                    i--;
                    j--;
                } else {
                    if (dp[i - 1][j] >= dp[i][j - 1]) {
                        i--;
                    } else {
                        j--;
                    }
                }
            }
        }
    }

    public static void dp() {
        for (int i = 1; i <= n; i++) {
            for (int j = 1; j <= m; j++) {
                if (s1[i - 1] == s2[j - 1]) {
                    dp[i][j] = 1 + dp[i - 1][j - 1];
                } else {
                    dp[i][j] = Math.max(dp[i - 1][j], dp[i][j - 1]);
                }
            }
        }
    }
}
```



## [Leetcode【难】1125.最小的必要团队](https://leetcode.cn/problems/smallest-sufficient-team/description/)



```java
import java.util.*;

public class Solution {
    // 现在有一份技能清单req_skills
    // 现有若干人选people
    // - people[i]是一个字符串数组，代表着其掌握的技能
    // 现在需要凑出一个必要团队，也就是技能清单中所有技能都有人掌握
    // 返回最少的人数的方案中的一种

    public static int[] smallestSufficientTeam(String[] skills, List<List<String>> people) {
        int n = skills.length;
        int m = people.size();
        HashMap<String, Integer> map = new HashMap<>();
        int cnt = 0;
        for (String s : skills) {
            map.put(s, cnt++);
        }
        int[] arr = new int[m];
        for (int i = 0, status; i < m; i++) {
            status = 0;
            for (String s : people.get(i)) {
                if (map.containsKey(s)) {
                    status |= 1 << map.get(s);
                }
            }
            arr[i] = status;
        }
        int[][] dp = new int[m][1 << n];
        for (int i = 0; i < m; i++) {
            Arrays.fill(dp[i], -1);
        }
        int size = f(arr, m, n, 0, 0, dp);
        int[] ans = new int[size];
        for (int i = 0, s = 0, j = 0; s != (1 << n) - 1; i++) {
            // - 距离最后一号人还有至少一人，也就是看dp[i][s]和dp[i+1][s]是否一致
            // - - 若一致，说明当前人不需要
            // - - 若不一致，说明当前人需要
            // - 当来到最后一号人时，但我们还没有凑齐s，说明最后一个人必要
            if (i == m - 1 || dp[i][s] != dp[i + 1][s]) {
                ans[j++] = i;
                s |= arr[i];
            }
        }
        return ans;
    }

    // arr：每个人掌握的技能汇总成的状态arr[i]
    // m：人的总数
    // n：必要技能的总数
    // i：当前来到了第i人
    // s：当前必要技能的状态
    // dp[i][s]：
    // - 当前我们来到了第i号人
    // - 必要技能的状态当前来到了s
    public static int f(int[] arr, int m, int n, int i, int s, int[][] dp) {
        if (s == (1 << n) - 1) {
            // 所有技能都已经凑齐
            return 0;
        }
        if (i == m) {
            // 人是从0号开始遍历的，当前来到了编号m，说明所有人都遍历过了，还没有凑齐
            return Integer.MAX_VALUE;
        }
        if (dp[i][s] != -1) {
            // 当前位置我们已经遍历过了
            return dp[i][s];
        }
        // 1、不要i号人
        int p1 = f(arr, m, n, i + 1, s, dp);
        // 2、要i号人
        int p2 = Integer.MAX_VALUE;
        int next = f(arr, m, n, i + 1, s | arr[i], dp);
        if (next != Integer.MAX_VALUE) {
            p2 = 1 + next;
        }
        int ans = Math.min(p1, p2);
        dp[i][s] = ans;
        return ans;
    }
}
```



## [牛客【】最长递增子序列](https://www.nowcoder.com/practice/30fb9b3cab9742ecae9acda1c75bf927)



```java
import java.io.*;
import java.util.Arrays;

public class Solution {
    // 给定一个长度为n的数组arr
    // 找到字典序最小的最长递增子序列
    // 字典序：
    // - 每个数字看作单独一个字符，因此字典序，120比36更小

    public static int MAXN = 100001;

    public static int[] nums = new int[MAXN];

    // dp[i] : 以nums[i]开头的最长递增子序列的长度
    public static int[] dp = new int[MAXN];

    public static int[] ends = new int[MAXN];

    public static int[] ans = new int[MAXN];

    public static int n, k;

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            for (int i = 0; i < n; i++) {
                in.nextToken();
                nums[i] = (int) in.nval;
            }
            LIS();
            for (int i = 0; i < k - 1; i++) {
                out.print(ans[i] + " ");
            }
            out.println(ans[k - 1]);
        }
        out.flush();
        out.close();
    }

    public static void LIS() {
        k = dp();
        Arrays.fill(ans, 0, k, Integer.MAX_VALUE);
        for (int i = 0; i < n; i++) {
            // 我们要的是从左往右的最长递增子序列

            // 两个片段的逻辑相同

            // 若i<j，且dp[i]=dp[j]，i在左，j在右
            // 则有nums[i]>=nums[j]恒成立，左边大，右边小
            // - 若左边小右边大的话，dp[i]至少是dp[j]+1
            // 因此我们需要以最后一次出现的为准
            if (dp[i] == k) {
                ans[0] = nums[i];
            } else {
                // 当我们从右往左获得dp时
                // 若i<j且dp[i]=dp[j]
                // 则有nums[i]>=nums[j]恒成立
                // - 若左边小右边大，dp[j]至少是dp[i]+1
                // 因此我们需要以最后一次出现的为准
                if (ans[k - dp[i] - 1] < nums[i]) {
                    ans[k - dp[i]] = nums[i];
                }
            }
        }
    }

    // dp[i]：以nums[i]开头的最长递增子序列的长度
    public static int dp() {
        int len = 0;
        for (int i = n - 1, find; i >= 0; i--) {
            find = find(len, nums[i]);
            if (find == -1) {
                ends[len++] = nums[i];
                dp[i] = len;
            } else {
                ends[find] = nums[i];
                dp[i] = find + 1;
            }
        }
        return len;
    }

    // ends[...有效区...]是降序排序
    // 返回<=num的最左位置
    public static int find(int len, int num) {
        int l = 0, r = len - 1, mid, ans = -1;
        while (l <= r) {
            mid = l + (r - l) / 2;
            if (ends[mid] <= num) {
                ans = mid;
                r = mid - 1;
            } else {
                l = mid + 1;
            }
        }
        return ans;
    }
}
```



## [洛谷【普及+/提高】T386911 最长上升子序列输出解](https://www.luogu.com.cn/problem/T386911)



```java
import java.io.*;
import java.util.Arrays;

public class Solution {
    // 给定一个长度为n的数组arr
    // 找到字典序最小的最长递增子序列
    // 字典序：
    // - 每个数字看作单独一个字符，因此字典序，120比36更小

    public static int MAXN = 100001;

    public static int[] nums = new int[MAXN];

    // dp[i] : 以nums[i]开头的最长递增子序列的长度
    public static int[] dp = new int[MAXN];

    public static int[] ends = new int[MAXN];

    public static int[] ans = new int[MAXN];

    public static int n, k;

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            for (int i = 0; i < n; i++) {
                in.nextToken();
                nums[i] = (int) in.nval;
            }
            LIS();
            for (int i = 0; i < k - 1; i++) {
                out.print(ans[i] + " ");
            }
            out.println(ans[k - 1]);
        }
        out.flush();
        out.close();
    }

    public static void LIS() {
        k = dp();
        Arrays.fill(ans, 0, k, Integer.MAX_VALUE);
        for (int i = 0; i < n; i++) {
            // 我们要的是从左往右的最长递增子序列

            // 两个片段的逻辑相同

            // 若i<j，且dp[i]=dp[j]，i在左，j在右
            // 则有nums[i]>=nums[j]恒成立，左边大，右边小
            // - 若左边小右边大的话，dp[i]至少是dp[j]+1
            // 因此我们需要以最后一次出现的为准
            if (dp[i] == k) {
                ans[0] = nums[i];
            } else {
                // 当我们从右往左获得dp时
                // 若i<j且dp[i]=dp[j]
                // 则有nums[i]>=nums[j]恒成立
                // - 若左边小右边大，dp[j]至少是dp[i]+1
                // 因此我们需要以最后一次出现的为准
                if (ans[k - dp[i] - 1] < nums[i]) {
                    ans[k - dp[i]] = nums[i];
                }
            }
        }
    }

    // dp[i]：以nums[i]开头的最长递增子序列的长度
    public static int dp() {
        int len = 0;
        for (int i = n - 1, find; i >= 0; i--) {
            find = find(len, nums[i]);
            if (find == -1) {
                ends[len++] = nums[i];
                dp[i] = len;
            } else {
                ends[find] = nums[i];
                dp[i] = find + 1;
            }
        }
        return len;
    }

    // ends[...有效区...]是降序排序
    // 返回<=num的最左位置
    public static int find(int len, int num) {
        int l = 0, r = len - 1, mid, ans = -1;
        while (l <= r) {
            mid = l + (r - l) / 2;
            if (ends[mid] <= num) {
                ans = mid;
                r = mid - 1;
            } else {
                l = mid + 1;
            }
        }
        return ans;
    }
}
```



## [洛谷【普及+/提高】P1759 通天之潜水](https://www.luogu.com.cn/problem/P1759)



```java
import java.io.*;

public class Solution {
    // n个工具，每个工具对应重量a，阻力b，停留时间c
    // 背包最多不超过m
    // 阻力最大不超过v
    // 希望停留的时间最长，且下标字典序最小
    // - "1 120"比"1 2"字典序小

    public static int MAXN = 101;
    public static int MAXM = 201;
    public static int[] a = new int[MAXN];
    public static int[] b = new int[MAXN];
    public static int[] c = new int[MAXN];

    public static int[][][] dp1 = new int[MAXN][MAXM][MAXM];
    public static String[][][] path1 = new String[MAXN][MAXM][MAXM];

    public static int[][] dp2 = new int[MAXM][MAXM];
    public static String[][] path2 = new String[MAXM][MAXM];

    public static int m, v, n;

    public static void build1() {
        for (int i = 0; i <= n; i++) {
            for (int j = 0; j <= m; j++) {
                for (int k = 0; k <= v; k++) {
                    dp1[i][j][k] = 0;
                    path1[i][j][k] = null;
                }
            }
        }
    }

    public static void build2() {
        for (int i = 0; i <= m; i++) {
            for (int j = 0; j <= v; j++) {
                dp2[i][j] = 0;
                path2[i][j] = null;
            }
        }
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            m = (int) in.nval;
            in.nextToken();
            v = (int) in.nval;
            in.nextToken();
            n = (int) in.nval;
            // build1();
            build2();
            for (int i = 1; i <= n; i++) {
                in.nextToken();
                a[i] = (int) in.nval;
                in.nextToken();
                b[i] = (int) in.nval;
                in.nextToken();
                c[i] = (int) in.nval;
            }
            // compute1();
            // out.println(dp1[n][m][v]);
            // out.println(path1[n][m][v]);
            compute2();
            out.println(dp2[m][v]);
            out.println(path2[m][v]);
        }
        out.flush();
        out.close();
    }

    public static void compute1() {
        for (int i = 1; i <= n; i++) {
            for (int j = 0; j <= m; j++) {
                for (int k = 0; k <= v; k++) {
                    // 1、不要i位置的货
                    dp1[i][j][k] = dp1[i - 1][j][k];
                    path1[i][j][k] = path1[i - 1][j][k];
                    String p;
                    if (j >= a[i] && k >= b[i]) {
                        // 2、要i位置的货
                        // - 路径
                        if (path1[i - 1][j - a[i]][k - b[i]] == null) {
                            p = String.valueOf(i);
                        } else {
                            p = path1[i - 1][j - a[i]][k - b[i]] + " " + String.valueOf(i);
                        }
                        // - 参数
                        if (dp1[i][j][k] < dp1[i - 1][j - a[i]][k - b[i]] + c[i]) {
                            // 如果要i位置货物更优
                            dp1[i][j][k] = dp1[i - 1][j - a[i]][k - b[i]] + c[i];
                            path1[i][j][k] = p;
                        } else if (dp1[i][j][k] == dp1[i - 1][j - a[i]][k - b[i]] + c[i]) {
                            // 如果要不要i位置货物效果一样，比较两种方案的字典序，选小的
                            if (p.compareTo(path1[i][j][k]) < 0) {
                                path1[i][j][k] = p;
                            }
                        }
                    }
                }
            }
        }
    }

    public static void compute2() {
        for (int i = 1; i <= n; i++) {
            for (int j = m; j >= a[i]; j--) {
                for (int k = v; k >= b[i]; k--) {
                    String p;
                    if (path2[j - a[i]][k - b[i]] == null) {
                        p = String.valueOf(i);
                    } else {
                        p = path2[j - a[i]][k - b[i]] + " " + String.valueOf(i);
                    }
                    if (dp2[j][k] < dp2[j - a[i]][k - b[i]] + c[i]) {
                        dp2[j][k] = dp2[j - a[i]][k - b[i]] + c[i];
                        path2[j][k] = p;
                    } else if (dp2[j][k] == dp2[j - a[i]][k - b[i]] + c[i]) {
                        if (p.compareTo(path2[j][k]) < 0) {
                            path2[j][k] = p;
                        }
                    }
                }
            }
        }
    }
}
```



***



# ✅087【必备】动态规划根据数据量猜解法



## [牛客【】打怪兽](https://www.nowcoder.com/practice/736e12861f9746ab8ae064d4aae2d5a9)



```java
import java.io.*;
import java.util.stream.Stream;

public class Solution {
    // 初始能力为0
    // 现在需要从0号怪兽开始，通过一共n个怪兽
    // - 如果当前能力小于i号怪兽，则需要付出b[i]的代价
    // - - 然后当前怪兽会加入你，其能力a[i]会累加到你的能力上
    // - 如果当前能力大于等于i号怪兽
    // - - 可以直接通过
    // - - 也可以付出对应代价，获得对应能力
    // 返回通过所有n个怪兽，需要的最小代价

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            int n = (int) in.nval;
            int[] a = new int[n + 1];
            int[] b = new int[n + 1];
            for (int i = 1; i <= n; i++) {
                in.nextToken();
                a[i] = (int) in.nval;
                in.nextToken();
                b[i] = (int) in.nval;
            }
            out.println(compute1(n, a, b));
        }
        out.flush();
        out.close();
    }

    // 两种情况
    // - 如果能力范围a[i]很大，那么代价b[i]的范围就很小
    // - 如果能力范围a[i]很小，那么代价b[i]的范围就很大

    public static int compute1(int n, int[] a, int[] b) {
        int sum = 0;
        for (int money : b) {
            sum += money;
        }
        // dp[i][j]：
        // - 通过前i个怪兽
        // - 花费不超过j
        // - 最大能力是多少
        int[][] dp = new int[n + 1][sum + 1];
        for (int i = 1; i <= n; i++) {
            for (int j = 0; j <= sum; j++) {
                dp[i][j] = Integer.MIN_VALUE;
                // 不贿赂i号怪兽，其上一轮自身能力已经大于当前怪兽的能力
                if (dp[i - 1][j] >= a[i]) {
                    dp[i][j] = dp[i - 1][j];
                }
                // 贿赂i号怪兽，当前dp[i][j]中的j减去当前怪兽的b[i]有效
                // 然后选择同样价钱下，能力更大的
                if (j >= b[i] && dp[i - 1][j - b[i]] != Integer.MIN_VALUE) {
                    dp[i][j] = Math.max(dp[i][j], dp[i - 1][j - b[i]] + a[i]);
                }
            }
        }
        int ans = -1;
        for (int j = 0; j <= sum; j++) {
            // 找到首个能过通n个怪兽的，就是最小的价钱
            if (dp[n][j] != Integer.MIN_VALUE) {
                ans = j;
                break;
            }
        }
        return ans;
    }

    public static int compute11(int n, int[] a, int[] b) {
        int sum = 0;
        for (int money : b) {
            sum += money;
        }
        int[] dp = new int[sum + 1];
        for (int i = 1; i <= n; i++) {
            for (int j = sum; j >= 0; j--) {
                int cur = Integer.MIN_VALUE;
                if (dp[j] >= a[i]) {
                    cur = dp[j];
                }
                if (j - b[i] >= 0 && dp[j - b[i]] != Integer.MIN_VALUE) {
                    cur = Math.max(cur, dp[j - b[i]] + a[i]);
                }
                dp[j] = cur;
            }
        }
        int ans = -1;
        for (int j = 0; j <= sum; j++) {
            if (dp[j] != Integer.MIN_VALUE) {
                ans = j;
                break;
            }
        }
        return ans;
    }

    public static int compute2(int n, int[] a, int[] b) {
        int sum = 0;
        for (int ability : a) {
            sum += ability;
        }
        // dp[i][j]：
        // - 通过i个怪兽
        // - 能力正好是j
        // - 需要的最小钱数
        int[][] dp = new int[n + 1][sum + 1];
        // 初始化，通过0个怪兽，遍历能力范围，获得不了对应能力，设为无效
        // dp[0][0] = 0;
        for (int j = 1; j <= sum; j++) {
            dp[0][j] = Integer.MAX_VALUE;
        }
        for (int i = 1; i <= n; i++) {
            for (int j = 0; j <= sum; j++) {
                dp[i][j] = Integer.MAX_VALUE;
                // 如果当前能力大于等于i号怪兽的能力
                // 可以直接通过，不需要花钱
                if (j >= a[i] && dp[i - 1][j] != Integer.MAX_VALUE) {
                    dp[i][j] = dp[i - 1][j];
                }
                // 如果当前能力大于等于i号怪兽的能力
                // 在对应位置有效的前提下，可以花钱获得i号怪兽的能力
                // 选择二者较小的，花费少的
                if (j >= a[i] && dp[i - 1][j - a[i]] != Integer.MAX_VALUE) {
                    dp[i][j] = Math.min(dp[i][j], dp[i - 1][j - a[i]] + b[i]);
                }
            }
        }
        int ans = Integer.MAX_VALUE;
        for (int j = 0; j <= sum; j++) {
            ans = Math.min(ans, dp[n][j]);
        }
        return ans == Integer.MAX_VALUE ? -1 : ans;
    }

    public static int compute22(int n, int[] a, int[] b) {
        int sum = 0;
        for (int ability : a) {
            sum += ability;
        }
        int[] dp = new int[sum + 1];
        for (int j = 1; j <= sum; j++) {
            dp[j] = Integer.MAX_VALUE;
        }
        for (int i = 1; i <= n; i++) {
            for (int j = sum; j >= 0; j--) {
                int cur = Integer.MAX_VALUE;
                if (j >= a[i] && dp[j] != Integer.MAX_VALUE) {
                    cur = dp[j];
                }
                if (j >= a[i] && dp[j - a[i]] != Integer.MAX_VALUE) {
                    cur = Math.min(cur, dp[j - a[i]] + b[i]);
                }
                dp[j] = cur;
            }
        }
        int ans = Integer.MAX_VALUE;
        for (int j = 0; j <= sum; j++) {
            ans = Math.min(ans, dp[j]);
        }
        return ans == Integer.MAX_VALUE ? -1 : ans;
    }
}
```



## [洛谷【普及+/提高】P1439 两个排列的最长公共子序列](https://www.luogu.com.cn/problem/P1439)



```java
import java.io.*;

public class Solution {
    // 给定一个整数n(1<=n<=100000)
    // 给定两组由1~n这些数字按不同顺序组成的两个排列
    // 返回二者的最长公共子序列

    public static int MAXN = 100001;

    public static int[] a = new int[MAXN];
    public static int[] b = new int[MAXN];

    public static int[] where = new int[MAXN];
    public static int[] ends = new int[MAXN];

    public static int n;

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            for (int i = 0; i < n; i++) {
                in.nextToken();
                a[i] = (int) in.nval;
            }
            for (int i = 0; i < n; i++) {
                in.nextToken();
                b[i] = (int) in.nval;
            }
            out.println(compute());
        }
        out.flush();
        out.close();
    }

    // 第一组：
    // 2 4 3 1
    // 0 1 2 3
    // 第二组：
    // 2 1 4 3
    // 0 1 2 3
    // 第二组元素在第一组中对应位置是：
    // 0 3 1 2
    // 0 1 2 3
    // 我们要找的是两个序列第一、二组（二者的元素一模一样，只有顺序不一致）的最长公共子序列
    // 为什么我们这里只需要找到第三组的最长递增子序列即可
    // - 对于任意一个数字n
    // - - 第三组中角标是n在第二组中的位置
    // - - 第三组中元素是n在第一组中的位置
    // - - 现在我们要找到二者的最长公共子序列
    // - 角标默认升序
    // - 如果找出元素的最长递增子序列
    // - 角标中一定可以找到对应的子序列
    // 那么该序列就是二者的最长公共子序列

    public static int compute() {
        for (int i = 0; i < n; i++) {
            where[a[i]] = i;
        }
        for (int i = 0; i < n; i++) {
            b[i] = where[b[i]];
        }
        return LIS();
    }

    // 单个序列的最长递增子序列
    public static int LIS() {
        int len = 0;
        for (int i = 0, find; i < n; i++) {
            find = find(len, b[i]);
            if (find == -1) {
                ends[len++] = b[i];
            } else {
                ends[find] = b[i];
            }
        }
        return len;
    }

    public static int find(int len, int num) {
        int l = 0, r = len - 1, mid, ans = -1;
        while (l <= r) {
            mid = (l + r) / 2;
            if (ends[mid] >= num) {
                ans = mid;
                r = mid - 1;
            } else {
                l = mid + 1;
            }
        }
        return ans;
    }
}
```



## [Leetcode【难】1187.使数组严格递增](https://leetcode.cn/problems/make-array-strictly-increasing/description/)



```java
import java.util.*;

public class Solution {
    // 给定两个整数arr1、arr2
    // - 1<=arr1.length,arr2.length<=2000
    // - 0<=arr1[i],arr2[i]<=10^9
    // 返回使得arr1严格递增的最小操作数（可能为0）
    // 每一步操作：
    // - 可以分别从arr1和arr2选取一个索引i、j
    // - 使得arr1[i]=arr[j]
    // 如果无法成功，返回-1

    public static int makeArrayIncreasing1(int[] arr1, int[] arr2) {
        Arrays.sort(arr2);
        // 数组arr2去重
        int m = 1;
        for (int i = 1; i < arr2.length; i++) {
            if (arr2[i] != arr2[m - 1]) {
                arr2[m++] = arr2[i];
            }
        }
        int n = arr1.length;
        int[] dp = new int[n];
        Arrays.fill(dp, -1);
        int ans = f1(arr1, arr2, n, m, 0, dp);
        return ans == Integer.MAX_VALUE ? -1 : ans;
    }

    // arr1长度为n，arr2长度为m
    // arr[0...i-1]严格递增
    // arr[i-1]一定没有被替换
    public static int f1(int[] arr1, int[] arr2, int n, int m, int i, int[] dp) {
        if (i == n) {
            // 我们从0位开始，长度为n，当前来到了n位，说明所有位都已经处理完毕
            return 0;
        }
        if (dp[i] != -1) {
            return dp[i];
        }
        // ans : 遍历所有的分支，所得到的最少的操作次数
        int ans = Integer.MAX_VALUE;
        // pre : 前一位的数字
        int pre = i == 0 ? Integer.MIN_VALUE : arr1[i - 1];
        // find : arr2有效长度m的范围上，找到首个比pre大的位置
        int find = find(arr2, m, pre);
        // 找到arr[i...]范围上，首个没有被替换的位置j
        for (int j = i, k = 0, next; j <= n; j++, k++) {
            if (j == n) {
                // 所有位置都被处理完毕
                ans = Math.min(ans, k);
            } else {
                // 当前i位置没有被替换
                if (pre < arr1[j]) {
                    next = f1(arr1, arr2, n, m, j + 1, dp);
                    if (next != Integer.MAX_VALUE) {
                        ans = Math.min(ans, k + next);
                    }
                }
                // 当前i位置被替换
                if (find != -1 && find < m) {
                    pre = arr2[find++];
                } else {
                    break;
                }
            }
        }
        dp[i] = ans;
        return ans;
    }

    // arr2[...]是严格递增的序列
    // 找到>num的最左位置
    public static int find(int[] arr2, int size, int num) {
        int l = 0, r = size - 1, mid;
        int ans = -1;
        while (l <= r) {
            mid = l + (r - l) / 2;
            if (arr2[mid] > num) {
                ans = mid;
                r = mid - 1;
            } else {
                l = mid + 1;
            }
        }
        return ans;
    }

    public static int makeArrayIncreasing2(int[] arr1, int[] arr2) {
        Arrays.sort(arr2);
        int m = 1;
        for (int i = 1; i < arr2.length; i++) {
            if (arr2[i] != arr2[m - 1]) {
                arr2[m++] = arr2[i];
            }
        }
        int n = arr1.length;
        int[] dp = new int[n + 1];
        for (int i = n - 1, ans, pre, find; i >= 0; i--) {
            ans = Integer.MAX_VALUE;
            pre = i == 0 ? Integer.MIN_VALUE : arr1[i - 1];
            find = find(arr2, m, pre);
            for (int j = i, k = 0, next; j <= n; j++, k++) {
                if (j == n) {
                    ans = Math.min(ans, k);
                } else {
                    if (pre < arr1[j]) {
                        next = f1(arr1, arr2, n, m, j + 1, dp);
                        if (next != Integer.MAX_VALUE) {
                            ans = Math.min(ans, k + next);
                        }
                    }
                    if (find != -1 && find < m) {
                        pre = arr2[find++];
                    } else {
                        break;
                    }
                }
            }
            dp[i] = ans;
        }
        return dp[0] == Integer.MAX_VALUE ? -1 : dp[0];
    }
}
```



***



# ✅088【必备】动态规划专题总结



***



# ✅089【必备】贪心经典题目专题 1



## [Leetcode【中】179.最大数](https://leetcode.cn/problems/largest-number/description/)



```java
import java.util.*;

public class Solution {
    // 给定一个字符串数组，每个元素存储这一个多位数的数字
    // 排列这些元素的顺序（每个元素不可拆分）
    // 获得最大的组合整数

    // 暴力
    public static String way1(String[] str) {
        ArrayList<String> ans = new ArrayList<>();
        f(str, 0, ans);
        // 升序排序
        ans.sort((a, b) -> a.compareTo(b));
        return ans.get(0);
    }

    // 给定一个字符串，获得它的所有排列可能
    // - strs：字符串数组
    // - i：当前处理到的位置
    // - ans：存储所有排列结果的列表
    public static void f(String[] strs, int i, ArrayList<String> ans) {
        if (i == strs.length) {
            StringBuilder path = new StringBuilder();
            for (String s : strs) {
                path.append(s);
            }
            ans.add(path.toString());
        } else {
            for (int j = i; j < strs.length; j++) {
                swap(strs, i, j);
                f(strs, i + 1, ans);
                swap(strs, i, j);
            }
        }
    }

    public static void swap(String[] strs, int i, int j) {
        String tmp = strs[i];
        strs[i] = strs[j];
        strs[j] = tmp;
    }

    // 贪心
    // - 对字符串数组进行排序，排序规则为：将两个字符串拼接起来，字典序更大的排在前面
    // - 拼接所有字符串，形成最大的组合整数
    public static String wasy2(String[] strs) {
        Arrays.sort(strs, (a, b) -> (a + b).compareTo(b + a));
        StringBuilder path = new StringBuilder();
        for (int i = 0; i < strs.length; i++) {
            path.append(strs[i]);
        }
        return path.toString();
    }

    public static String[] randStringArr(int n, int m, int v) {
        String[] ans = new String[(int) (Math.random() * n + 1)];
        for (int i = 0; i < ans.length; i++) {
            ans[i] = randString(m, v);
        }
        return ans;
    }

    public static String randString(int m, int v) {
        int len = (int) (Math.random() * m) + 1;
        char[] str = new char[len];
        for (int i = 0; i < len; i++) {
            str[i] = (char) ((int) (Math.random() * v) + '0');
        }
        return String.valueOf(str);
    }

    public static void main(String[] args) {
        // 字符串数组的最大长度
        int N = 10;
        // 每个字符串的最大长度
        int M = 5;
        // 每个字符的最大取值
        int V = 5;
        int testTimes = 10;
        // 测试
        System.out.println("测试开始");
        for (int i = 0; i < testTimes; i++) {
            String[] strs = randStringArr(N, M, V);
            String ans1 = way1(strs);
            String ans2 = wasy2(strs);
            if (!ans1.equals(ans2)) {
                System.out.println("Oops!");
            }
            System.out.println(ans1);
            System.out.println(ans2);
            System.out.println("====================");
        }
    }

    public static String largestNumber(int[] nums) {
        int n = nums.length;
        String[] strs = new String[n];
        for (int i = 0; i < n; i++) {
            strs[i] = String.valueOf(nums[i]);
        }
        Arrays.sort(strs, (a, b) -> (b + a).compareTo(a + b));
        if (strs[0].equals("0")) {
            return "0";
        }
        StringBuilder path = new StringBuilder();
        for (int i = 0; i < n; i++) {
            path.append(strs[i]);
        }
        return path.toString();
    }
}
```



## [Leetcode【中】1029.两地调度](https://leetcode.cn/problems/two-city-scheduling/description/)



```java
import java.util.*;

public class Solution {
    // 公司计划面试2n人
    // 给定一个数组costs
    // - costs[i]=[aCostI,bCostI]
    // - 表示i号人前往a地花费aCostI
    // - 表示i号人前往b地花费bCostI
    // 返回每个人选择前往一个地方，两地最终都有n人的最小费用

    public static int twoCitySchedCost(int[][] costs) {
        int n = costs.length;
        int sum = 0;
        int[] arr = new int[n];
        // 让所有人都去a地
        // 如果再去往b地，增加的费用是costs[i][1]-costs[i][0]
        for (int i = 0; i < n; i++) {
            arr[i] = costs[i][1] - costs[i][0];
            sum += costs[i][0];
        }
        Arrays.sort(arr);
        // 选择该去b地费用增加最少的n/2个人
        for (int i = 0; i < n / 2; i++) {
            sum += arr[i];
        }
        return sum;
    }
}
```



## [Leetcode【难】1553.吃掉 N 个橘子的最少天数](https://leetcode.cn/problems/minimum-number-of-days-to-eat-n-oranges/description/)



```java
import java.util.*;

public class Solution {
    // 一共有n个橘子，有三种吃法
    // - 吃掉1个
    // - 如果当前橘子个数可以被2整除，那么吃n/2个
    // - 如果当前橘子个数可以被3整除，那么迟2*(n/3)个
    // 每天选择一个吃法
    // 返回最少多少天可以吃完

    public static HashMap<Integer, Integer> dp = new HashMap<>();

    public static int minDays(int n) {
        if (n <= 1) {
            return n;
        }
        if (dp.containsKey(n)) {
            return dp.get(n);
        }
        // 因为我们需要的是最少天数，那么优先选择方案2或方案3
        // - 使用方案2：
        // - - 每天吃一个，n%2天
        // - - 花一天，吃n/2个
        // - - 还有n/2个
        // - 使用方案3：
        // - - 每天吃一个，n%3天
        // - - 花一天，吃2*(n/3)个
        // - - 还有n-2*(n/3)个
        int ans = Math.min(n % 2 + 1 + minDays(n / 2), n % 3 + 1 + minDays(n / 3));
        dp.put(n, ans);
        return ans;
    }
}
```



## [Leetcode【难】630.课程表 III](https://leetcode.cn/problems/course-schedule-iii/description/)



```java
import java.util.*;

public class Solution {
    // 有n门课程，编号1~n
    // 给定整数数组courses
    // - courses[i]=[durationI,lastDayI]
    // - 当前课程持续上durationI天
    // - 必须在lastDayI之前完成
    // 从第一天开始上课，一个时间只能修1门课，返回最多可以修的课程

    public static int scheduleCourse(int[][] courses) {
        // 按照截止时间升序排序
        Arrays.sort(courses, (a, b) -> a[1] == b[1] ? a[0] - b[0] : a[1] - b[1]);
        // 大根堆
        PriorityQueue<Integer> heap = new PriorityQueue<>((a, b) -> b - a);
        int time = 0;
        for (int[] cur : courses) {
            if (time + cur[0] <= cur[1]) {
                // 如果当前课程可以上，即算是时间不超限
                // 则直接上这门课，更新时间
                time += cur[0];
                heap.add(cur[0]);
            } else {
                // time + cur[0] > cur[1]
                // 如果当前课程不能上，即时间超限
                // 则判断是否有之前上的课程耗时更长
                // 如果当前课程耗时更短
                // 则用当前课程替换之前上的课程
                if (!heap.isEmpty() && heap.peek() > cur[0]) {
                    time += cur[0] - heap.poll();
                    heap.add(cur[0]);
                }
            }
        }
        return heap.size();
    }
}
```



## [洛谷【普及/提高-】P1090 \[NOIP 2004 提高组\] 合并果子](https://www.luogu.com.cn/problem/P1090)



```java
import java.io.*;
import java.util.*;

public class Solution {
    // 给定一个正整数赎罪sticks
    // - sticks[i]表示第i根棍子的长度
    // 每次连接
    // - 长度x和长度y的棍子连接花费x+y的代价
    // 知道连接剩下一根棍子，返回最小代价

    public static int MAXN = 10001;

    public static int[] nums = new int[MAXN];

    public static int n;

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            for (int i = 0; i < n; i++) {
                in.nextToken();
                nums[i] = (int) in.nval;
            }
            out.println(minCost1());
            out.println(minCost2());
            out.flush();
        }
        out.flush();
        out.close();
    }

    // 手搓小根堆
    public static int[] heap = new int[MAXN];

    public static int size;

    public static void add(int x) {
        heap[size] = x;
        int i = size++;
        while (heap[i] < heap[(i - 1) / 2]) {
            swap(i, (i - 1) / 2);
            i = (i - 1) / 2;
        }
    }

    public static int pop() {
        int ans = heap[0];
        swap(0, --size);
        int i = 0, l = 1, best;
        while (l < size) {
            best = l + 1 < size && heap[l + 1] < heap[l] ? l + 1 : l;
            best = heap[best] < heap[i] ? best : i;
            if (best == i) {
                break;
            }
            swap(i, best);
            i = best;
            l = i * 2 + 1;
        }
        return ans;
    }

    public static void swap(int i, int j) {
        int tmp = heap[i];
        heap[i] = heap[j];
        heap[j] = tmp;
    }

    public static int minCost1() {
        size = 0;
        for (int i = 0; i < n; i++) {
            add(nums[i]);
        }
        int sum = 0;
        int cur = 0;
        while (size > 1) {
            cur = pop() + pop();
            sum += cur;
            add(cur);
        }
        return sum;
    }

    public static int minCost2() {
        PriorityQueue<Integer> pq = new PriorityQueue<>();
        for (int i = 0; i < n; i++) {
            pq.add(nums[i]);
        }
        int sum = 0;
        int cur = 0;
        while (pq.size() > 1) {
            cur = pq.poll() + pq.poll();
            sum += cur;
            pq.add(cur);
        }
        return sum;
    }
}
```



***



# ✅090【必备】贪心经典题目专题 2



## [Leetcode【中】343.整数拆分](https://leetcode.cn/problems/integer-break/description/)



```java
public class Solution {
    // 将一段长为len的竹子砍为若干段
    // 每段长度均为正整数
    // 返回每段长度的最大乘积
    // 结果对1000000007取模

    public static int MOD = 1000000007;

    // 快速幂，求余数
    // x的n次方，最终得到的结果 % mod
    public static long power(long x, int n) {
        long ans = 1;
        while (n > 0) {
            if ((n & 1) == 1) {
                ans = (ans * x) % MOD;
            }
            x = (x * x) % MOD;
            n >>= 1;
        }
        return ans;
    }

    public static int integerBreak(int n) {
        if (n == 2) {
            return 1;
        }
        if (n == 3) {
            return 2;
        }
        // n=4 -> 2*2 n%3==1
        // n=5 -> 3*2 n%3==2
        // n=6 -> 3*3 n%3==0
        // n=7 -> 3*2*2 n%3==1
        // n=8 -> 3*3*2 n%3==2
        // n=9 -> 3*3*3 n%3==0
        // n=10-> 3*3*2*2 n%3==1
        // n=11-> 3*3*3*2 n%3==2
        // n=12-> 3*3*3*3 n%3==0
        // n=13-> 3*3*3*2*2 n%3==1
        int tail = n % 3 == 0 ? 1 : (n % 3 == 1 ? 4 : 2);
        int power = (tail == 1 ? n : (n - tail)) / 3;
        return (int) (power(3, power) * tail % MOD);
    }
}
```



## [Leetcode【中】LCR132.砍竹子 II](https://leetcode.cn/problems/jian-sheng-zi-ii-lcof/description/)



```java
public class Solution {
    // 将一段长为len的竹子砍为若干段
    // 每段长度均为正整数
    // 返回每段长度的最大乘积
    // 结果对1000000007取模

    public static int MOD = 1000000007;

    // 快速幂，求余数
    // x的n次方，最终得到的结果 % mod
    public static long power(long x, int n) {
        long ans = 1;
        while (n > 0) {
            if ((n & 1) == 1) {
                ans = (ans * x) % MOD;
            }
            x = (x * x) % MOD;
            n >>= 1;
        }
        return ans;
    }

    public static int cuttingBamboo(int n) {
        if (n == 2) {
            return 1;
        }
        if (n == 3) {
            return 2;
        }
        // n=4 -> 2*2 n%3==1
        // n=5 -> 3*2 n%3==2
        // n=6 -> 3*3 n%3==0
        // n=7 -> 3*2*2 n%3==1
        // n=8 -> 3*3*2 n%3==2
        // n=9 -> 3*3*3 n%3==0
        // n=10-> 3*3*2*2 n%3==1
        // n=11-> 3*3*3*2 n%3==2
        // n=12-> 3*3*3*3 n%3==0
        // n=13-> 3*3*3*2*2 n%3==1
        int tail = n % 3 == 0 ? 1 : (n % 3 == 1 ? 4 : 2);
        int power = (tail == 1 ? n : (n - tail)) / 3;
        return (int) (power(3, power) * tail % MOD);
    }
}
```



## [Leetcode【中】435.无重叠区间](https://leetcode.cn/problems/non-overlapping-intervals/description/)



```java
import java.util.*;

public class Solution {
    // 给定一个二维整数数组
    // meetings[i]=[ai,bi]
    // - ai是i号会议开始时间
    // - bi是i号会议结束时间
    // 返回可以参加最大会议数量，最少不需要参加多少个会议

    public static int eraseOverlapIntervals(int[][] meetings) {
        Arrays.sort(meetings, (a, b) -> a[1] - b[1]);
        int n = meetings.length;
        int ans = 0;
        for (int i = 0, cur = -50001; i < n; i++) {
            if (cur <= meetings[i][0]) {
                ans++;
                cur = meetings[i][1];
            }
        }
        return n - ans;
    }

    // 暴力
    public static int randomMeetings1(int[][] meetings) {
        return f(meetings, meetings.length, 0);
    }

    // 所有会议全排列
    // 找到能够安排会议次数最多的一种方案
    public static int f(int[][] meetings, int n, int i) {
        int ans = 0;
        if (i == n) {
            for (int j = 0, cur = -1; j < n; j++) {
                if (cur <= meetings[j][0]) {
                    ans++;
                    cur = meetings[j][1];
                }
            }
        } else {
            for (int j = i; j < n; j++) {
                swap(meetings, i, j);
                ans = Math.max(ans, f(meetings, n, i + 1));
                swap(meetings, i, j);
            }
        }
        return ans;
    }

    // 交换meetings[i]和meetings[j]
    public static void swap(int[][] meetings, int i, int j) {
        int[] tmp = meetings[i];
        meetings[i] = meetings[j];
        meetings[j] = tmp;
    }

    // 贪心
    public static int randomMeetings2(int[][] meetings) {
        Arrays.sort(meetings, (a, b) -> a[1] - b[1]);
        int n = meetings.length;
        int ans = 0;
        for (int i = 0, cur = -50001; i < n; i++) {
            if (cur <= meetings[i][0]) {
                ans++;
                cur = meetings[i][1];
            }
        }
        return ans;
    }

    public static int[][] randomMeeting(int N, int M) {
        int[][] meetings = new int[N][2];
        for (int i = 0; i < N; i++) {
            int a = (int) (Math.random() * M);
            int b = (int) (Math.random() * M);
            if (a == b) {
                meetings[i][0] = a;
                meetings[i][1] = b + 1;
            } else {
                meetings[i][0] = Math.min(a, b);
                meetings[i][1] = Math.max(a, b);
            }
        }
        return meetings;
    }

    public static void main(String[] args) {
        int testTimes = 100;
        int N = 10;
        int M = 100;
        for (int i = 0; i < testTimes; i++) {
            int n = (int) (Math.random() * N);
            int[][] meetings1 = randomMeeting(n, M);
            for (int j = 0; j < n; j++) {
                // System.out.print(meetings1[j][0] + " " + meetings1[j][1] + ";");
            }
            int ans1 = randomMeetings1(meetings1);
            int ans2 = randomMeetings2(meetings1);
            if (ans1 != ans2) {
                System.out.println("Oops!!!!!!!");
            }
            System.out.println("ans1=" + ans1);
            System.out.println("ans2=" + ans2);
            System.out.println("================");
        }
    }
}
```



## [洛谷【普及-】P1803 凌乱的 yyy / 线段覆盖](https://www.luogu.com.cn/problem/P1803)



```java
import java.io.*;
import java.util.*;

public class Solution {
    // 给定一个二维整数数组
    // meetings[i]=[ai,bi]
    // - ai是i号会议开始时间
    // - bi是i号会议结束时间
    // 返回可以参加最大会议数量

    public static int MAXN = 1000001;

    // latest[i]：同一个结束时间的会议，最晚开始的会议的时间为i
    public static int[] latest = new int[MAXN];

    // n：会议数量
    public static int n;

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            for (int i = 0; i < MAXN; i++) {
                latest[i] = -1;
            }
            for (int i = 0, start, end; i < n; i++) {
                in.nextToken();
                start = (int) in.nval;
                in.nextToken();
                end = (int) in.nval;
                if (latest[end] == -1) {
                    latest[end] = start;
                } else {
                    latest[end] = Math.max(latest[end], start);
                }
            }
            out.println(compute());
        }
        out.flush();
        out.close();
    }

    public static int compute() {
        int ans = 0;
        for (int cur = 0, end = 0; end < MAXN; end++) {
            if (cur <= latest[end]) {
                // 对于同一个结束时间的若干会议，我们只选择最晚开始的一个会议
                ans++;
                cur = end;
            }
        }
        return ans;
    }
}
```



## [Leetcode【中】1353.最多可以参加的会议数目](https://leetcode.cn/problems/maximum-number-of-events-that-can-be-attended/description/)



```java
import java.util.*;

public class Solution {
    // 给定一个二维整数数组events
    // events[i]=[ai,bi]
    // - ai:会议i开始时间
    // - bi:会议i结束时间
    // - 每个会议只需要花一天时间参加即可
    // 返回可以参加的最大会议数量

    public static int maxEvents(int[][] events) {
        int n = events.length;
        Arrays.sort(events, (a, b) -> (a[0] == b[0] ? (a[1] - b[1]) : (a[0] - b[0])));
        // 开始时间的最小值
        int min = events[0][0];
        // 结束时间的最大值
        int max = events[0][1];
        for (int i = 1; i < n; i++) {
            max = Math.max(max, events[i][1]);
        }
        // 小根堆:会议的结束时间
        PriorityQueue<Integer> heap = new PriorityQueue<>();
        int ans = 0;
        for (int i = 0, day = min; day <= max; day++) {
            while (i < n && events[i][0] == day) {
                heap.add(events[i++][1]);
            }
            while (!heap.isEmpty() && heap.peek() < day) {
                heap.poll();
            }
            if (!heap.isEmpty()) {
                heap.poll();
                ans++;
            }
        }
        return ans;
    }
}
```



## [Leetcode【难】502.IPO](https://leetcode.cn/problems/ipo/description/)



```java
import java.util.*;

public class Solution {
    // 给定两个一维整数数组
    // 对于项目i
    // - 纯利润profit[i]
    // - 至少启动资金capital[i]
    // 最初资本为w,随着项目的完成,会增加对应纯利润
    // 最多选择k个不同的项目
    // 返回最终最多的资本

    // 项目类
    public static class Project {
        // 项目纯利润
        public int p;
        // 项目启动资金
        public int c;

        public Project(int p, int c) {
            this.p = p;
            this.c = c;
        }
    }

    public static int findMaximizedCapital(int k, int w, int[] p, int[] c) {
        int n = p.length;
        // 启动资金小根堆
        PriorityQueue<Project> h1 = new PriorityQueue<>((a, b) -> (a.c - b.c));
        // 利润大根堆
        PriorityQueue<Project> h2 = new PriorityQueue<>((a, b) -> (b.p - a.p));
        // 所有项目进入启动资金小根堆
        for (int i = 0; i < n; i++) {
            h1.add(new Project(p[i], c[i]));
        }
        // 最多选择k个项目
        while (k > 0) {
            // 所有启动资金不超过当前资本的项目,都进入利润大根堆
            while (!h1.isEmpty() && h1.peek().c <= w) {
                h2.add(h1.poll());
            }
            // 如果利润大根堆为空,说明当前资本无法启动任何项目
            // 也就是无法再完成其余的任何项目,直接返回即可
            if (h2.isEmpty()) {
                break;
            }
            // 选择能够启动的利润最大的项目
            w += h2.poll().p;
            k--;
        }
        return w;
    }
}
```



***



# ✅091【必备】贪心经典题目专题 3



## [Leetcode【中】581.最短无序连续子数组](https://leetcode.cn/problems/shortest-unsorted-continuous-subarray/description/)



```java
public class Solution {
    // 给定一个整数数组nums
    // 找出一个连续子数组
    // - 对该子数组进行升序排序后，整体会有序
    // 返回该最短子数组的长度

    public static int findUnsortedSubarray(int[] num) {
        int n = num.length;
        // 从左往右升序
        // - 最右侧不达标的位置
        int right = -1, max = Integer.MIN_VALUE;
        for (int i = 0; i < n; i++) {
            // 如果当前位之前的最大值大于当前位
            // 说明当前位不达标，更新right
            if (max > num[i]) {
                right = i;
            }
            max = Math.max(max, num[i]);
        }
        // 从右往左降序
        // - 最左侧不达标的位置
        int left = n, min = Integer.MAX_VALUE;
        for (int i = n - 1; i >= 0; i--) {
            // 如果当前位之后的最小值小于当前位
            // 说明当前位不达标，更新left
            if (min < num[i]) {
                left = i;
            }
            min = Math.min(min, num[i]);
        }
        return Math.max(0, right - left + 1);
    }
}
```



## [Leetcode【难】632.最小区间](https://leetcode.cn/problems/smallest-range-covering-elements-from-k-lists/description/)



```java
import java.util.*;

public class Solution {
    // 给定k个非递减排列的整数列表
    // 找到一个最小区间，使得k个列表中的每个列表至少有一个数在其中
    // - 若有若干长度相同的区间，则选择开头最小的区间

    public static class Node {
        // 值
        public int val;
        // 当前值来自哪个数组
        public int i;
        // 当前值来自i号数组的什么位置
        public int j;

        public Node(int val, int i, int j) {
            this.val = val;
            this.i = i;
            this.j = j;
        }
    }

    public static int[] smallestRange(List<List<Integer>> nums) {
        // 数组个数
        int k = nums.size();
        // 有序表
        TreeSet<Node> set = new TreeSet<>((a, b) -> (a.val != b.val) ? (a.val - b.val) : (a.i - b.i));
        // - 初始化进入k个数组的头节点
        for (int i = 0; i < k; i++) {
            set.add(new Node(nums.get(i).get(0), i, 0));
        }
        // 最小区间的宽度
        int width = Integer.MAX_VALUE;
        // 最小区间的开头
        int start = 0;
        // 最小区间的结尾
        int end = 0;
        // 有序表中的最大值（结尾）、最小值（开头）
        Node max, min;
        // 有序表始终维持k个元素
        // - 因为每次弹出的元素就是维持的k个元素中的其中一个
        // - 如果弹出元素所在数组已经遍历到最后一个，却还弹出
        // - 就会导致有序表覆盖的数组为k-1个
        while (set.size() == k) {
            // 有序表的结尾
            max = set.last();
            // 有序表的开头（并弹出）
            min = set.pollFirst();
            // 更新区间
            // - 如果相等，则不更新。因为相等区间下，肯定是之前的值更小
            if (max.val - min.val < width) {
                width = max.val - min.val;
                start = min.val;
                end = max.val;
            }
            // 最小值弹出后，其数组还有元素，则加入有序表
            if (min.j + 1 < nums.get(min.i).size()) {
                // 最小值
                // - 所在数组编号：min.i
                // - 所在数组位置：min.j
                // - 入有序表的元素的位置：min.j + 1
                set.add(new Node(nums.get(min.i).get(min.j + 1), min.i, min.j + 1));
            }
        }
        return new int[] { start, end };
    }
}
```



## [洛谷【普及+/提高】P12331 \[蓝桥杯 2023 省 Java B\] 最大开支](https://www.luogu.com.cn/problem/P12331)



```java
import java.io.*;
import java.util.*;

public class Solution {
    // n个人、m个项目
    // - 每个人至多参加一个项目，可以不参加
    // 项目i的门票人越多，越便宜
    // - 超过阈值后，门票价格为0
    // 项目i有xi人参加
    // - 门票=max(bi+ki*xi,0)
    // - 1<=n,m,bi<=10^5
    // - -10^5<=ki<=0
    // 至少需要准备多少钱，可以应对所有情况

    public static class Game {
        // 原价
        public long ki;
        // 每多一个人门票单价需要减去的折扣
        public long bi;
        public int people;

        public Game(long k, long b) {
            ki = k;
            bi = b;
        }

        // 项目i来到第people+1个人时，相比于只有people个人时，游乐园是继续赚钱还是要亏钱
        // 或者说，当前我们来到people号人，如果继续有人选该项目，其是否还接着赚钱
        // - 继续赚钱：earn() > 0
        // - 亏钱：earn() <= 0
        // 初始化：
        // - people=0人
        // - earn=bi+ki-0=bi+ki
        // - 只有最开始earn>0的游戏才需要我们考虑，否则只要有一个人就是游乐场倒贴
        public long earn() {
            return cost(people + 1) - cost(people);
        }

        // 来p个人参加项目i，需要的花费
        public long cost(long p) {
            long price = bi + ki * p;
            if (price < 0) {
                price = 0;
            }
            return p * price;
        }
    }

    public static void main(String[] args) throws IOException {
        FastReader in = new FastReader(System.in);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        // n个人
        int n = in.nextInt();
        // m个项目
        int m = in.nextInt();
        // 大根堆
        PriorityQueue<Game> heap = new PriorityQueue<>((a, b) -> Long.compare(b.earn(), a.earn()));
        // 遍历m个项目
        for (int i = 0; i < m; i++) {
            Game cur = new Game(in.nextLong(), in.nextLong());
            // 我们只考虑游乐场能挣钱的项目
            if (cur.earn() > 0) {
                heap.add(cur);
            }
        }
        long ans = 0;
        // n个人，每个人都依据大根堆选择当前游乐场最挣钱的项目
        // - 如果当前项目挣钱，那么就选择当前活动
        // - 如果当前项目不挣钱，那么就直接结束，后续的人不再选择任何活动
        // 对于一个项目：
        // - 一个人一个人地参加
        // - 利润也一个人一个人地赚
        // 折扣我们可以理解为ki元
        // 来一个人时，他自己的票价-之前的0个人享受0个ki的折扣（多一个人，那么前边0个人各自多一个折扣）
        // 来两个人时，他自己的票价-之前的1个人享受1个ki的折扣（多一个人，那么前边1个人各自多一个折扣）
        // 来三个人时，他自己的票价-之前的2个人享受2个ki的折扣（多一个人，那么前边2个人各自多一个折扣）
        // ...如上就是来到i人时，游乐场的总利润
        // 从1到n遍历（一个一个人来）的话
        // 来到i人
        // - bi+ki*i+ki*(i-1)
        // - ki<=0
        for (int i = 0; i < n && !heap.isEmpty(); i++) {
            // 当前i号人选择堆顶
            Game cur = heap.poll();
            // 利润最大的项目
            long money = cur.earn();
            // 如果此时最大的利润已经小于0，还要倒贴，那么直接结束即可
            if (money <= 0) {
                break;
            }
            // 当前i号人选择堆顶弹出的项目，利润累加
            ans += money;
            // 对应项目人数+1
            cur.people++;
            // 如果此时还能赚钱，那么就继续加入堆中
            if (cur.earn() > 0) {
                heap.add(cur);
            }
        }
        out.println(ans);
        out.flush();
        out.close();
    }

    // 读写工具类
    static class FastReader {
        // 缓冲区，用于批量读取输入（64KB）
        private final byte[] buffer = new byte[1 << 16];
        // 指针
        // - 指向缓冲区下一个要读取的字节
        private int ptr = 0;
        // - 记录当前缓冲区已读取的字节数（有效数据长度）
        private int len = 0;
        // 输入流
        // - 一次性读取大量数据到内存中，减少系统调用次数
        private final InputStream in;

        FastReader(InputStream in) {
            this.in = in;
        }

        // 从缓冲区读取一个字节
        // - 如果缓冲区已无数据，那么就从输入流中读取数据填充缓冲区
        // - 如果输入流已无数据，返回-1
        private int readByte() throws IOException {
            if (ptr >= len) {
                len = in.read(buffer);
                ptr = 0;
                if (len <= 0) {
                    return -1;
                }
            }
            return buffer[ptr++];
        }

        // 从缓冲区读取一个整数
        // - 忽略前导空格
        // - 处理负号
        // - 处理多位数
        // - 处理溢出
        int nextInt() throws IOException {
            int c;
            do {
                c = readByte();
            } while (c <= ' ' && c != -1);
            boolean neg = false;
            if (c == '-') {
                neg = true;
                c = readByte();
            }
            int val = 0;
            while (c > ' ' && c != -1) {
                val = val * 10 + (c - '0');
                c = readByte();
            }
            return neg ? -val : val;
        }

        // 从缓冲区读取一个长整数
        // - 忽略前导空格
        // - 处理负号
        // - 处理多位数
        // - 处理溢出
        long nextLong() throws IOException {
            int c;
            do {
                c = readByte();
            } while (c <= ' ' && c != -1);
            boolean neg = false;
            if (c == '-') {
                neg = true;
                c = readByte();
            }
            long val = 0L;
            while (c > ' ' && c != -1) {
                val = val * 10 + (c - '0');
                c = readByte();
            }
            return neg ? -val : val;
        }
    }
}
```



## [Leetcode【难】1665.完成所有任务的最少初始能量](https://leetcode.cn/problems/minimum-initial-energy-to-finish-tasks/description/)



```java
import java.util.*;

public class Solution {
    // 给定一个二维整数数组task
    // - task[i][0]:耗费的电量，完成当前任务会减去对应电量
    // - task[i][1]:至少多少电量才可以开始当前任务
    // - task[i][0]<=task[i][1]
    // 至少多少初始电量，可以完成所有任务

    // 贪心
    public static int minimumEffort(int[][] tasks) {
        // 排序！！！
        // 按照消耗电量-门槛电量 从大到小排序
        // - 耗费越大越好
        // - 门槛越小越好
        // - 浪费的越少越好
        Arrays.sort(tasks, (a, b) -> (b[0] - b[1]) - (a[0] - a[1]));
        // 从电量耗光开始倒退
        // - 剩余电量+当前任务的耗费电量
        // - 当前任务开始的门槛电量
        // - 较大的
        int ans = 0;
        for (int[] job : tasks) {
            ans = Math.max(ans + job[0], job[1]);
        }
        return ans;
    }

    // 暴力验证
    // 获得所有排列，找到返回最小的电量

    public static int minimumEffort0(int[][] tasks) {
        return f0(tasks, tasks.length, 0);
    }

    public static int f0(int[][] t, int n, int i) {
        if (i == n) {
            int ans = 0;
            for (int[] task : t) {
                ans = Math.max(ans + task[0], task[1]);
            }
            return ans;
        } else {
            int ans = Integer.MAX_VALUE;
            for (int j = i; j < n; j++) {
                swap(t, i, j);
                ans = Math.min(ans, f0(t, n, i + 1));
                swap(t, i, j);
            }
            return ans;
        }
    }

    // 交换数组t中i和j位置的元素
    public static void swap(int[][] t, int i, int j) {
        int[] tmp = t[i];
        t[i] = t[j];
        t[j] = tmp;
    }

    // 随机数组
    public static int[][] randomTasks(int N, int V) {
        int[][] tasks = new int[N][2];
        for (int i = 0; i < N; i++) {
            tasks[i][0] = 1 + (int) (Math.random() * V);
            tasks[i][1] = tasks[i][0] + (int) (Math.random() * V);
        }
        return tasks;
    }

    public static void main(String[] args) {
        int N = 10;
        int V = 100;
        int testTimes = 100;
        for (int i = 0; i < testTimes; i++) {
            int n = (int) (Math.random() * N) + 1;
            int[][] tasks = randomTasks(n, V);
            int ans1 = minimumEffort(tasks);
            int ans2 = minimumEffort0(tasks);
            System.out.println(ans1);
            System.out.println(ans2);
            if (ans1 != ans2) {
                System.out.println("Oops!");
            }
            System.out.println("====================");
        }
    }
}
```



***



# ✅092【必备】贪心经典题目专题 4



## [Leetcode【难】1675.数组的最小偏移量](https://leetcode.cn/problems/minimize-deviation-in-array/description/)



```java
import java.util.*;

public class Solution {
    // 给定一个长度为n的正整数数组
    // 我们可以对其任意元素执行任意次数的两类操作
    // - 对于偶数元素，除以2
    // - 对于奇数元素，乘以2
    // 数组的偏移量是数组中任意两个元素之间的最大差值
    // 返回可以拥有的最小偏移量

    // 对于奇数，只有一次上升机会，然后就会下降，然后就是震荡
    // 对于偶数，也是先下降，直到变为奇数，然后进入震荡

    public static int minimumDeviation(int[] nums) {
        // 有序表：方便我们查询最大值和最小值
        TreeSet<Integer> set = new TreeSet<>();
        for (int num : nums) {
            if ((num % 2) == 0) {
                // 如果是偶数直接入队
                // - 因为偶数是该元素的最大可能值
                set.add(num);
            } else {
                // 如果是奇数，先乘以2，再入队
                // - 因为奇数乘以2，会变成偶数，偶数是该元素的最大可能值
                set.add(num * 2);
            }
        }
        // 当前有序队列的最大偏移量
        // - 偏移量一定大于等于0
        // - 当有序队列最大值为奇数时，我们就来到了结束
        // - - 因为如果此时我们跳过当前奇数，选择前边的偶数，当前的最小偏移量不会变小
        // - - 如果此时我们选择当前奇数乘2，当前的最小偏移量则会变大
        int ans = set.last() - set.first();
        while (ans > 0 && set.last() % 2 == 0) {
            // 有序队列的最大值（一定是偶数）
            int max = set.last();
            // 移除有序队列的最大值
            set.remove(max);
            // 最大值除以2，入队
            set.add(max / 2);
            // 更新有序队列的最大偏移量
            ans = Math.min(ans, set.last() - set.first());
        }
        return ans;
    }
}
```



## [Leetcode【中】781.森林中的兔子](https://leetcode.cn/problems/rabbits-in-forest/description/)



```java
import java.util.*;

public class Solution {
    // 有数量未知的兔子
    // 问第i只兔子：“其余有多少只兔子与你颜色一样”
    // - 得到answer[i]
    // - 每个兔子都不会说谎
    // - 我们可能没有收集到所有兔子的回答
    // 返回兔子最少的数量

    public static int numRabbits(int[] arr) {
        // 向上取整：a/b = (a+b-1)/b
        // 数量升序排列
        // - 相同数量的兔子，可以考虑为一组
        Arrays.sort(arr);
        int n = arr.length;
        int ans = 0;
        for (int i = 0, j = 1, x; i < n; j++) {
            // 记录每一组（相同数量的片段）的开始位置的词频
            x = arr[i];
            while (j < n && x == arr[j]) {
                j++;
            }
            // [i...j-1]都是一种答案
            // 3 3 3 3 3 3 3
            // 0 1 2 3 4 5 6 7
            // i             j
            // j-i/(x+1)向上取整，可得至少为n组
            // 组数*(x+1)（每组人数）
            // 至少需要的人数
            ans += (j - i + x) / (x + 1) * (x + 1);
            i = j;
            // j++，进入下一轮循环
        }
        return ans;
    }
}
```



## [Leetcode【难】2449.使数组相似的最少操作次数](https://leetcode.cn/problems/minimum-number-of-operations-to-make-arrays-similar/description/)



```java
import java.util.Arrays;

public class Solution {
    // 给定两个长度相等的正整数数组nums、target
    // 一次操作中：选择两个不同的下标i、j
    // - nums[i]=nums[i]+2
    // - nums[j]=nums[j]-2
    // - 如上两个计算算是一次操作
    // 使得最终nums中各元素出现次数和target一致
    // 返回最少操作次数

    public static long makeSimilar(int[] nums, int[] target) {
        int n = target.length;
        int oddSize = split(target, n);
        split(nums, n);
        Arrays.sort(nums, 0, oddSize);
        Arrays.sort(nums, oddSize, n);
        Arrays.sort(target, 0, oddSize);
        Arrays.sort(target, oddSize, n);
        long ans = 0;
        for (int i = 0; i < n; i++) {
            ans += Math.abs((long) nums[i] - target[i]);
        }
        return ans / 4;
    }

    // 将一个数组左侧划分为全部奇数、右侧划分为全部偶数
    public static int split(int[] arr, int n) {
        int oddSize = 0;
        for (int i = 0; i < n; i++) {
            if ((arr[i] & 1) == 1) {
                swap(arr, i, oddSize++);
            }
        }
        return oddSize;
    }

    public static void swap(int[] arr, int i, int j) {
        int tmp = arr[i];
        arr[i] = arr[j];
        arr[j] = tmp;
    }
}
```



## [牛客【】知识竞赛](https://www.nowcoder.com/practice/2a9089ea7e5b474fa8f688eae76bc050)



```java
import java.io.*;
import java.util.*;

public class Solution {
    // 给定一个二维整数数组p
    // - p[ai][0]表示推理能力
    // - p[ai][1]表示阅读能力
    // 如果选择两个人
    // - 二者的推理能力X=(p[ai][0]+p[bi][0])/2
    // - 二者的阅读能力Y=(p[ai][1]+p[bi][1])/2
    // 现在需要让min(X,Y)尽可能大
    // 返回最大是多少

    // ÷2可以放在最后一步再进行

    public static int MAXN = 200001;
    public static int[][] nums = new int[MAXN][2];
    public static int n;

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            for (int i = 0; i < n; i++) {
                in.nextToken();
                nums[i][0] = (int) in.nval;
                in.nextToken();
                nums[i][1] = (int) in.nval;
            }
            int ans = compute();
            out.println((double) ans / 2);
        }
        out.flush();
        out.close();
    }

    public static int compute() {
        // 先按照推理能力和阅读能力的差值升序排序
        // - 当我们遍历到i号人时，其较小的一门能力X
        // - 一定是当前人+前i-1号人两种能力和中较小的那个，暂定X
        // - 因为前边每个人的差值均小于i号人
        // - 也就是说，即使我们选择前i-1号人中X最大的那个
        // - 也会因为差值更小，提升不到与另外一种能力和相等的水平
        Arrays.sort(nums, 0, n, (a, b) -> Math.abs(a[0] - a[1]) - Math.abs(b[0] - b[1]));
        // 左侧最大的推理能力
        int maxX = nums[0][0];
        // 左侧最大的阅读能力
        int maxY = nums[0][1];
        int ans = 0;
        for (int i = 1; i < n; i++) {
            // 当前同志
            if (nums[i][0] <= nums[i][1]) {
                // 推理能力不行，选择左侧最大推理能力
                ans = Math.max(ans, maxX + nums[i][0]);
            } else {
                // 阅读能力不行，选择左侧最大阅读能力
                ans = Math.max(ans, maxY + nums[i][1]);
            }
            // 更新左侧最大推理能力
            maxX = Math.max(maxX, nums[i][0]);
            // 更新左侧最大阅读能力
            maxY = Math.max(maxY, nums[i][1]);
        }
        return ans;
    }
}
```



## [Leetcode【难】871.最低加油次数](https://leetcode.cn/problems/minimum-number-of-refueling-stops/description/)



```java
import java.util.*;

public class Solution {
    // 汽车从出发地去往目的地，距离target
    // 沿路有若干加油站stations
    // - stations[i]=[ai,bi]
    // - i号加油站距离出发点ai
    // - i号加油站有bi升汽油
    // 汽车油箱容量无限，起始有start升油
    // - 每行驶1公里消耗1升油
    // - 到达一个加油站
    // - - 可以停下来加油
    // 到达目的地，最低加油次数
    // - 0升油到达加油站可以加油
    // - 0升油到达目的地完成任务

    public static int minRefuelStops(int target, int start, int[][] s) {
        // 如果起始油量就已经足够
        if (start >= target) {
            return 0;
        }
        // 大根堆
        PriorityQueue<Integer> heap = new PriorityQueue<>((a, b) -> b - a);
        // 初始能到达的位置
        int to = start;
        // 加油次数
        int count = 0;
        // 遍历所有加油站
        for (int[] p : s) {
            // 当前加油站的位置
            int position = p[0];
            // 当前加油站的油量
            int fuel = p[1];
            // 如果此时我们能到达的地方还没到当前加油站的位置
            if (to < position) {
                // 要么加油站都使用完了
                // 要么挑油量多的加，可以到达当前加油站
                while (!heap.isEmpty() && to < position) {
                    // 更新能到达的位置
                    to += heap.poll();
                    count++;
                    // 如果更新后的位置已经到达或超过目标位置
                    if (to >= target) {
                        // 直接返回即可
                        return count;
                    }
                }
                // 此时如果能进入if语句
                // 说明：我们已经把能加的油全加了，还到不了当前的加油站
                // 直接返回-1即可
                if (to < position) {
                    return -1;
                }
            }
            // 如果能到达当前加油站
            // 直接把当前加油站的油量加入大根堆
            heap.add(fuel);
        }
        // 我们已经经过了所有加油站，但还没有到达目的地
        // - 因为如果之前能到达目的地，早就程序结束了
        // 那么此时我们依次把还能加的油加了，直到能到达目的地
        while (!heap.isEmpty()) {
            to += heap.poll();
            count++;
            if (to >= target) {
                return count;
            }
        }
        // 全部的加油站都使用了，还到不了目的地
        return -1;
    }
}
```



***



# ✅093【必备】贪心经典题目专题 5



## [Leetcode【中】45.跳跃游戏 II](https://leetcode.cn/problems/jump-game-ii/description/)



```java
public class Solution {
    // 给定一个长度为n的整数数组nums
    // - nums[i]：表示可以从i下标往右跳的最大距离
    // 返回到达n-1的最少次数

    public static int jump(int[] arr) {
        int n = arr.length;
        // 从0步开始，每一步最远可以到达的距离
        int cur = 0;
        // 如果再走一步，最远可以到达的距离
        int next = 0;
        // 最少需要跳几步
        int ans = 0;
        // 遍历n个位置
        for (int i = 0; i < n; i++) {
            // 如果当前步不能到达i下标
            if (cur < i) {
                // 需要往前跳一步
                ans++;
                // 更新新的步数最远可以到达的距离
                cur = next;
            }
            // 不往前跳
            // - 但是更新当前步最远距离以内每个位置再跳一步可以到达的最远距离
            next = Math.max(next, i + arr[i]);
        }
        return ans;
    }
}
```



## [Leetcode【难】1326.灌溉花园的最少水龙头数目](https://leetcode.cn/problems/minimum-number-of-taps-to-open-to-water-a-garden/description/)



```java
public class Solution {
    // x轴正半轴自0开始有n+1个点，长度为n，到n结束
    // 有n+1个水龙头，对应n+1个节点ranges
    // - ranges[i]：可以覆盖[i-ranges[i], i+ranges[i]]
    // 返回覆盖整个花园，最少水龙头数目，否则返回-1

    public static int minTaps(int n, int[] ranges) {
        // right[i]：
        // - 左边界在i位置的水龙头，右边界的位置
        int[] right = new int[n + 1];
        for (int i = 0; i <= n; i++) {
            int start = Math.max(0, i - ranges[i]);
            right[start] = Math.max(right[start], i + ranges[i]);
        }
        int ans = 0;
        // 当前数量的水龙头，覆盖的最右边界
        int cur = 0;
        // 如果再多打开一个水龙头，影响到的最右边界
        int next = 0;
        // 遍历n+1个节点
        for (int i = 0; i < n; i++) {
            // 来到i位置
            // - 假设我们再打开i处水龙头，可以覆盖的最右边界
            next = Math.max(next, right[i]);
            // 如果i位置，等于当前数量的水龙头，覆盖的最右边界
            // - 我们此时打开i处水龙头
            if (i == cur) {
                // 只有新的覆盖右边界>当前位置，我们才能接着继续
                if (next > i) {
                    cur = next;
                    ans++;
                } else {
                    // 新的覆盖右边界<=当前位置
                    // - 那么就覆盖不了[i,i+1]这一处位置
                    return -1;
                }
            } else {
                // i<cur
                // 更新next即可
            }
        }
        return ans;
    }
}
```



## [洛谷【普及+/提高】P1809 过河问题](https://www.luogu.com.cn/problem/P1809)



```java
import java.io.*;
import java.util.*;

public class Solution {
    // n个人要过河
    // - 每个人有一个渡河时间ti
    // 有一条船
    // - 如果1个人坐，渡河时间=ti
    // - - 一般是两个人去对岸，1个人回来的情况
    // - 如果2个人坐，渡河时间=max(ti1,ti2)
    // - - 去的时候一般都是2个人，要保证有1个人把船送回来
    // 返回最少多长时间，使所有人过河

    public static int MAXN = 100001;
    public static int[] nums = new int[MAXN];
    public static int[] dp = new int[MAXN];
    public static int n;

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            n = (int) in.nval;
            for (int i = 0; i < n; i++) {
                in.nextToken();
                nums[i] = (int) in.nval;
            }
            out.println(minCost());
        }
        out.flush();
        out.close();
    }

    public static int minCost() {
        // 升序处理
        Arrays.sort(nums, 0, n);
        if (n >= 1) {
            // 1个人过河，时间=t0
            dp[0] = nums[0];
        }
        if (n >= 2) {
            // 2个人过河，时间=t1
            dp[1] = nums[1];
        }
        if (n >= 3) {
            // 3个人过河，0、1过河；0回来；0、2过河
            dp[2] = nums[1] + nums[0] + nums[2];
        }
        for (int i = 3; i < n; i++) {
            // 过河策略：
            // 一、
            // - 0、i过河；0回来；
            // 二、
            // - 0、1先过河；1回来；i-1、i过河；0回来
            // - 0、1先过河；0回来；i-1、i过河；1回来
            dp[i] = Math.min(nums[i] + nums[0] + dp[i - 1], nums[1] + nums[i] + nums[0] + nums[1] + dp[i - 2]);
        }
        return dp[n - 1];
    }
}
```



## [Leetcode【难】517.超级洗衣机](https://leetcode.cn/problems/super-washing-machines/description/)



```java
public class Solution {
    // n个洗衣机
    // - 初始时：每个洗衣机中的衣服可能为0，可能不为0
    // 每一步操作中：
    // - 选择任意台洗衣机
    // - 将每台洗衣机的一件衣服送到相邻（左或右）的洗衣机中
    // 返回让所有洗衣机衣服数量相等的最少操作数，否则返回-1

    public static int findMinMoves(int[] arr) {
        int n = arr.length;
        int sum = 0;
        for (int i = 0; i < n; i++) {
            sum += arr[i];
        }
        if (sum % n != 0) {
            return -1;
        }
        int AVG = sum / n;
        // 当前洗衣机左侧累加和
        int leftSum = 0;
        // 当前洗衣机左侧还需要多少件衣服
        int leftNeed = 0;
        // 当前洗衣机右侧还需要多少件衣服
        int rightNeed = 0;
        // 当前洗衣机
        int bottleNeck = 0;
        // 步数
        int ans = 0;
        // 遍历n个洗衣机
        for (int i = 0; i < n; leftSum += arr[i], i++) {
            leftNeed = i * AVG - leftSum;
            rightNeed = (n - i - 1) * AVG - (sum - leftSum - arr[i]);
            if (leftNeed > 0 && rightNeed > 0) {
                // 左侧和右侧都需要衣服
                bottleNeck = leftNeed + rightNeed;
            } else {
                // 左侧或右侧需要衣服
                // - 左右两侧一正一负
                // - - 取绝对值较大的
                // - - 比如左侧需要的衣服更多，右侧需要吐出的衣服更少
                // - - 那么中间往左侧传递的次数就是左侧需要的衣服数量
                // - - 而右侧往中间传递的次数就是右侧需要吐出的衣服数量
                // - - 因为这两个可以同时进行，所以取较大的那个
                // 左右两侧都为负，即左侧和右侧都需要往中间吐衣服
                // - 因为左右两侧可以同时往中间吐，因此也是取较大的
                bottleNeck = Math.max(Math.abs(leftNeed), Math.abs(rightNeed));
            }
            ans = Math.max(ans, bottleNeck);
        }
        return ans;
    }
}
```



***



# ✅094【必备】贪心经典题目专题 6



## [Leetcode【中】1921.消灭怪物的最大数量](https://leetcode.cn/problems/eliminate-maximum-number-of-monsters/description/)



```java
import java.util.*;

public class Solution {
    // 给定两个大小为n的数组
    // - dist[i]：第i个怪物到城市的距离
    // - speed[i]：第i个怪兽的速度
    // 有一个武器，一旦充满电，可以消灭一个怪物，但是每充满一次电需要1单位的时间
    // - 初始是满电
    // - 怪兽从0时刻开始移动，到达城市，游戏结束
    // 返回在输掉游戏前可以消灭的最大数量

    public static int eliminateMaximum(int[] dist, int[] speed) {
        int n = dist.length;
        int[] time = new int[n];
        for (int i = 0; i < n; i++) {
            // 向上取整：a/b=(a+b-1)/b
            time[i] = (dist[i] + speed[i] - 1) / speed[i];
        }
        Arrays.sort(time);
        // 遍历0~n-1个时刻
        // - 每个时刻，消灭一个怪物，越早消灭越好
        for (int i = 0; i < n; i++) {
            // 如果来到i时刻，还有早就到达的怪兽没消灭，来不及了
            if (time[i] <= i) {
                return i;
            }
        }
        return n;
    }
}
```



## [Leetcode【中】2384.最大回文数字](https://leetcode.cn/problems/largest-palindromic-number/description/)



```java
public class Solution {
    // 仅由数字（0~9）组成的字符串num
    // 使用num中的数字组成不含前导零的最大回文整数
    // - 对于num中的数字最少使用一个
    // 返回字符串

    public static String largestPalindromic(String num) {
        int n = num.length();
        // '0'~'9'：对应ASCLL码为48~57
        int[] cnts = new int[58];
        for (char a : num.toCharArray()) {
            cnts[a]++;
        }
        char[] ans = new char[n];
        // 左半部分的字符数量=右半部分的字符数量
        int leftSize = 0;
        // 中间位置
        char mid = 0;
        // 遍历1~9
        for (char i = '9'; i >= '1'; i--) {
            // 首个出现次数为奇数的字符作为中间位置（最大）
            if ((cnts[i] & 1) == 1 && mid == 0) {
                mid = i;
            }
            // 出现次数为偶数的字符，一半作为左半部分
            for (int j = cnts[i] / 2; j > 0; j--) {
                ans[leftSize++] = i;
            }
        }
        if (leftSize == 0) {
            // "1"~"9"每个数字出现次数<=1
            if (mid == 0) {
                // "1"~"9"每个数字出现次数 == 0
                return "0";
            } else {
                // "1"~"9"有若干字符出现次数 == 1，其中最大的字符是mid
                return String.valueOf(mid);
            }
        }
        // 左半部分已经建立，现在考虑"0"，一半进入左半部分
        for (int i = cnts['0'] / 2; i > 0; i--) {
            ans[leftSize++] = '0';
        }
        // 当前左半部分的长度
        int len = leftSize;
        // 如果"0"出现次数为奇数，且"1"~"9"每个数字出现次数均为偶数
        // 则"0"可以作为中间位置
        if (mid == 0 && (cnts['0'] & 1) == 1) {
            mid = '0';
        }
        if (mid != 0) {
            // "1"~"9"有若干字符出现次数 == 1，其中最大的字符是mid
            ans[len++] = mid;
        }
        // 左半部分逆序拷贝给右半部分
        for (int i = leftSize - 1; i >= 0; i--) {
            ans[len++] = ans[i];
        }
        return new String(ans, 0, len);
    }
}
```



## [Leetcode【中】1792.最大平均通过率](https://leetcode.cn/problems/maximum-average-pass-ratio/description/)



```java
import java.util.*;

public class Solution {
    // n个班级
    // class[i]=[passI,totalI]
    // - i号班级有totalI人
    // - i号班级只有passI人可以通过考试
    // 给定一个整数stu，额外有sut个聪明娃，一定可以通过考试
    // 将这些人都安排一个班级，使得所有班级的平均通过率最大
    // - 通过率=通过人数/总人数
    // 返回最大通过率

    public static double maxAverageRatio(int[][] classes, int stu) {
        int n = classes.length;
        // 小根堆heap
        // double[] c={a,b,c}:
        // - a:c班级有多少人通过
        // - b:c班级总人数
        // - c:如果再来一人，c班级通过率提升多少，(a+1)/(b+1) - a/b
        PriorityQueue<double[]> heap = new PriorityQueue<>((c1, c2) -> c1[2] >= c2[2] ? -1 : 1);
        // 所有班级入小根堆
        for (int[] c : classes) {
            double a = c[0];
            double b = c[1];
            heap.add(new double[] { a, b, (a + 1) / (b + 1) - a / b });
        }
        // 所有天才分配班级
        while (stu-- > 0) {
            double[] cur = heap.poll();
            double a = cur[0] + 1;
            double b = cur[1] + 1;
            heap.add(new double[] { a, b, (a + 1) / (b + 1) - a / b });
        }
        // 最终通过率累加和
        double ans = 0;
        while (!heap.isEmpty()) {
            double[] cur = heap.poll();
            ans += cur[0] / cur[1];
        }
        // 返回最大平均通过率
        return ans / n;
    }
}
```



## [Leetcode【难】857.雇佣 K 名工人的最低成本](https://leetcode.cn/problems/minimum-cost-to-hire-k-workers/description/)



```java
import java.util.*;

public class Solution {
    // 给定两个长度为n的数组
    // - quality[i]：工人i的工作质量
    // - wage[i]：工人i期望的最低工资
    // 雇佣k人
    // - 对于每位员工，需要按照其工作质量与其他同组工人的工作质量的比例来支付工资
    // - 找到每个员工至少应得的最低期望工资
    // 返回总体最少金额

    public static class Employee {
        // 薪水 / 质量的比例
        // - 选择相同质量，薪水大的优先考虑，更可能满足要求
        public double ratio;
        // 工作质量
        public int quality;

        public Employee(double r, int q) {
            ratio = r;
            quality = q;
        }
    }

    public static double mincostToHireWorkers(int[] quality, int[] wage, int k) {
        int n = quality.length;
        Employee[] employee = new Employee[n];
        for (int i = 0; i < n; i++) {
            employee[i] = new Employee((double) wage[i] / quality[i], quality[i]);
        }
        // 升序排序
        Arrays.sort(employee, (a, b) -> a.ratio <= b.ratio ? -1 : 1);
        // 大根堆：维持[0...i]范围内前k个最小质量的数值
        PriorityQueue<Integer> heap = new PriorityQueue<Integer>((a, b) -> b - a);
        // 维持[0...i]范围内前k个最小质量的数值，总和是多少
        int qualitySum = 0;
        // 最终成本
        double ans = Double.MAX_VALUE;
        // 遍历每个员工，已经按照 薪水/质量 升序排序
        for (int i = 0, curQuality; i < n; i++) {
            // 当前员工的工作质量
            curQuality = employee[i].quality;
            if (heap.size() < k) {
                // 人数不满k,直接入堆
                qualitySum += curQuality;
                heap.add(curQuality);
                // 人数满k，更新成本
                if (heap.size() == k) {
                    // 直接比较
                    // - 之前ans
                    // - 当前员工的 薪水/质量 比*前k个最小质量的总和
                    // - - 因为之前排序的缘故，当前员工的 薪水/质量 比一定是最大的
                    ans = Math.min(ans, qualitySum * employee[i].ratio);
                }
            } else {
                // 如果当前员工的工作质量小于前k个最小质量的最大值，入堆
                if (heap.peek() > curQuality) {
                    qualitySum += curQuality - heap.poll();
                    heap.add(curQuality);
                    // 更新成本
                    // 直接比较
                    // - 之前ans
                    // - 当前员工的 薪水/质量 比*前k个最小质量的总和
                    // - - 因为之前排序的缘故，当前员工的 薪水/质量 比一定是最大的
                    ans = Math.min(ans, qualitySum * employee[i].ratio);
                }
            }
        }
        return ans;
    }
}
```



***



# ✅095【必备】博弈类问题详解-上



## [巴什博弈](https://baike.baidu.com/item/%E5%B7%B4%E4%BB%80%E5%8D%9A%E5%BC%88/1819345)



```java
import java.util.Arrays;

public class Solution {
    // 巴什博弈
    // 一共有n个石头，两个人轮流拿，每次可以拿1~m个石头
    // 拿到最后一个石头的人获胜，根据n、m返回谁赢

    // 如果n%(m+1)!=0，先手赢
    // - 先手第一次拿n%(m+1)个石头，为后手留下n%(m+1)==0个石头
    // - 因为每次只能拿m个石头，不可能超过m+1个石头
    // - 那么接下来后手和后边一轮的先手一定可以凑齐m+1个石头
    // - 最后一轮，也一定是以后手和后边一轮的先手最终凑齐m+1个石头结束
    // 如果n%(m+1)==0，后手赢
    // - 无论先手第一次拿几个
    // - 第一轮的后手必然可以凑齐m+1个
    // - 直到最后一轮，也必然是以当前轮的先手和后手最终凑齐m+1个石头结束
    public static String bashGame(int n, int m) {
        return n % (m + 1) != 0 ? "First wins!" : "Second wins!";
    }

    // SG函数求解
    // - 打表找规律
    public static String bashGameSG(int n, int m) {
        int[] SG = new int[n + 1];
        boolean[] appear = new boolean[m + 1];
        for (int i = 1; i <= n; i++) {
            Arrays.fill(appear, false);
            for (int j = 1; j <= m && i - j >= 0; j++) {
                appear[SG[i - j]] = true;
            }
            for (int s = 0; s <= m; s++) {
                if (!appear[s]) {
                    SG[i] = s;
                    break;
                }
            }
        }
        return SG[n] != 0 ? "First wins!" : "Second wins!";
    }

    // 动态规划进行所有尝试
    public static int MAXN = 1001;

    public static String[][] dp = new String[MAXN][MAXN];

    public static String bashGame0(int n, int m) {
        if (n == 0) {
            return "Second wins!";
        }
        if (dp[n][m] != null) {
            return dp[n][m];
        }
        String ans = "Second wins!";
        for (int pick = 1; pick <= m; pick++) {
            if (bashGame0(n - pick, m).equals("Second wins!")) {
                // 后续过程的赢家是后续过程的后手
                // 那就表示此时的先手，通过这个后续过程，能赢
                ans = "First wins!";
                break;
            }
        }
        dp[n][m] = ans;
        return ans;
    }

    public static void main(String[] args) {
        int N = 250;
        int M = 25;
        int testTimes = 10;
        for (int i = 0; i < testTimes; i++) {
            int n = (int) (Math.random() * N) + 1;
            int m = (int) (Math.random() * M) + 1;
            System.out.println(bashGame(n, m));
            System.out.println(bashGameSG(n, m));
            System.out.println(bashGame0(n, m));
            System.out.println("-----------------");
        }
    }
}
```



## [洛谷【普及/提高-】P4018 Roy\&October 之取石子](https://www.luogu.com.cn/problem/P4018)



```java
import java.io.*;

public class Solution {
    // 巴士博弈（扩展）
    // 一共有n个石头，两个人轮流拿
    // 每一轮当前选手可以拿p的k次方个石头
    // - p为质数（从2开始）、k是自然数（从0开始）
    // 拿到最后一个石头的人获胜
    // 返回最终谁获胜

    // 可以拿任意1、2、3、4、5个石头
    // 任意的6的整数倍，一定不是某一个自然数的若干次方
    // - 也就是必须要拿两次以上

    // n%6!=0时，先手必胜
    // - 先手第一次拿n%6个石头
    // - 而后
    // - 无论后手拿几个，下一轮的先手必然可以凑够6个
    // - 一直到最后
    // n%6==0时，后手必胜

    public static int t, n;

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        in.nextToken();
        t = (int) in.nval;
        for (int i = 0; i < t; i++) {
            in.nextToken();
            n = (int) in.nval;
            out.println(compute(n));
        }
        out.flush();
        out.close();
    }

    public static String compute(int n) {
        return n % 6 != 0 ? "October wins!" : "Roy wins!";
    }
}
```



## [洛谷【普及+/提高】P2197 【模板】Nim 游戏](https://www.luogu.com.cn/problem/P2197)



```java
import java.io.*;
import java.util.Arrays;

public class Solution {
    // 尼姆博弈(Nim Game)
    // n堆石头，两个人轮流进行
    // 每轮，玩家需要选择任意一个非空石头堆，从中移除任意正数的石头数量
    // 谁移走最后的石头就获胜，返回最终谁会获胜

    // 如果全数异或==0，那么先手必败
    // 如果全数异或!=0，那么先手必胜
    // - 先手通过移动特定的一堆的若干个，使得全数异或==0
    // - 后手无论移动哪一堆，都会使得全数异或!=0
    // - 先手再次通过移动特定的一堆，使得全数异或==0
    // - ......
    // - 最后，也必然是以先手移动最后一堆石头，使得全数异或==0，从而获胜

    public static int MAXN = 10001;

    public static int[] arr = new int[MAXN];

    public static int n;

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        in.nextToken();
        int t = (int) in.nval;
        for (int i = 0; i < t; i++) {
            in.nextToken();
            n = (int) in.nval;
            for (int j = 0; j < n; j++) {
                in.nextToken();
                arr[j] = (int) in.nval;
            }
            int eor = f1();
            // int eor = f2();
            if (eor != 0) {
                out.println("Yes");
            } else {
                out.println("No");
            }
        }
        out.flush();
        out.close();
    }

    public static int f1() {
        int eor = 0;
        for (int i = 0; i < n; i++) {
            eor ^= arr[i];
        }
        return eor;
    }

    // SG函数
    public static int f2() {
        int max = 0;
        for (int i = 0; i < n; i++) {
            max = Math.max(max, arr[i]);
        }
        int[] SG = new int[max + 1];
        boolean[] appear = new boolean[max + 1];
        for (int i = 1; i <= max; i++) {
            Arrays.fill(appear, false);
            for (int j = 0; j < i; j++) {
                appear[j] = true;
            }
            for (int s = 0; s <= max; s++) {
                if (!appear[s]) {
                    SG[i] = s;
                    break;
                }
            }
        }
        int eor = 0;
        for (int i = 0; i < n; i++) {
            eor ^= SG[arr[i]];
        }
        return eor;
    }
}
```



## [洛谷【提高+/省选-】P4279 \[SHOI2008\] 小约翰的游戏](https://www.luogu.com.cn/problem/P4279)



```java
import java.io.*;

public class Solution {
    // 反常尼姆博奕
    // n堆石头，两个人轮流拿
    // - 每次挑选任意非空的一堆，移走正数数量的石头
    // 谁拿走最后的石头，谁失败，返回谁获胜

    public static int MAXN = 51;
    public static int[] stones = new int[MAXN];
    public static int t, n;

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        in.nextToken();
        t = (int) in.nval;
        for (int i = 0; i < t; i++) {
            in.nextToken();
            n = (int) in.nval;
            for (int j = 0; j < n; j++) {
                in.nextToken();
                stones[j] = (int) in.nval;
            }
            out.println(compute());
        }
        out.flush();
        out.close();
    }

    public static String compute() {
        int eor = 0, sum = 0;
        for (int i = 0; i < n; i++) {
            eor ^= stones[i];
            sum += stones[i] == 1 ? 1 : 0;
        }
        if (sum == n) {
            // - 每堆都只有1个石头
            // - - 奇数堆：先手必胜
            // - - 偶数堆：后手必胜
            return (n & 1) == 1 ? "Brother" : "John";
        } else {
            // - n-1堆都是<=1个石头，余下一堆石头>=2（异或！=0）
            // - - 先手必胜
            // - 全数异或！=0
            // - - 先手必然可以通过操作，最终遇到上一种情况：
            // - - n-1堆都是<=1个石头，余下一堆石头>=2（异或！=0）
            return eor != 0 ? "John" : "Brother";
        }
    }
}
```



## [洛谷【NOI/NOI+/CTSC】P6487 \[COCI 2010/2011 #4\] HRPA](https://www.luogu.com.cn/problem/P6487)



```java
import java.io.*;

public class Solution {
    // 斐波那契博弈
    // n个石头
    // 首轮：先手拿走任意数量的石头
    // 从第二轮：
    // - 最少拿走1个石头，最多取走上一个玩家的2倍，且不能超过当前所有石头数量
    // 拿走最后一个石头的玩家，即为赢家
    // 可以观察出来，若先手首轮全部拿走，先手必胜
    // 那么如果不都拿走，第一轮先手至少拿走几个石头就可以保证一定获胜

    // 遇到斐波那契数，先拿的玩家必败

    // Zeckendorf定理
    // - 任意一个数
    // - 都可以拆分为若干个不相邻的斐波那契数
    // - 后者因子必定大于前边因子的两倍

    public static long MAXN = 1000000000000000L;
    public static int MAXM = 101;
    public static long[] f = new long[MAXM];
    public static int size;

    public static void build() {
        f[0] = 1;
        f[1] = 2;
        size = 1;
        while (f[size] <= MAXN) {
            f[size + 1] = f[size] + f[size - 1];
            size++;
        }
    }

    public static void main(String[] args) throws IOException {
        build();
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            out.println(compute((long) in.nval));
        }
        out.flush();
        out.close();
    }

    public static long compute(long n) {
        long ans = -1, find;
        while (n != 1 && n != 2) {
            // 先找到不大于n的最大斐波那契数
            find = bs(n);
            if (n == find) {
                // 如果找到的数等于n，那么n就是最小的斐波那契数因子
                ans = find;
                break;
            } else {
                // 否则，n减去找到的数，继续查找
                n -= find;
            }
        }
        if (ans != -1) {
            return ans;
        } else {
            return n;
        }
    }

    // 二分查找不大于n的最大斐波那契数
    public static long bs(long n) {
        int l = 0;
        int r = size;
        int m;
        long ans = -1;
        while (l <= r) {
            m = l + (r - l) / 2;
            if (f[m] <= n) {
                ans = f[m];
                l = m + 1;
            } else {
                r = m - 1;
            }
        }
        return ans;
    }
}
```



## [洛谷【省选/NOI-】P2252 【模板】威佐夫博弈 / \[SHOI2002\] 取石子游戏](https://www.luogu.com.cn/problem/P2252)



```java
import java.io.*;
import java.math.*;

public class Solution {
    // 威佐夫博弈
    // 两堆石头，数量任意，可以不同
    // 每轮有两种取法：
    // - 任意一堆石头取走任意多个石头
    // - 在两堆中同时取走相同数量的石头
    // 最后拿走全部的获胜
    // 返回先手是否能获胜

    public static BigDecimal split = new BigDecimal("1.61803398874989484");

    public static int a, b;

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            a = (int) in.nval;
            in.nextToken();
            b = (int) in.nval;
            out.println(compute());
            out.flush();
        }
        out.close();
    }

    public static int compute() {
        int min = Math.min(a, b);
        int max = Math.max(a, b);
        // 威佐夫博弈
        // 小 != (大 - 小) * 黄金分割比例，先手赢
        // 小 == (大 - 小) * 黄金分割比例，后手赢
        // 要向下取整
        // 这里用BigDecimal类型的multiply方法，乘完后再转成整型，可以支持高精度的乘
        if (min != split.multiply(new BigDecimal(max - min)).intValue()) {
            return 1;
        } else {
            return 0;
        }
    }
}
```



***



# ✅096【必备】博弈类问题详解-下



## [洛谷【提高+/省选-】P2148 \[SDOI2009\] E\&D](https://www.luogu.com.cn/problem/P2148)



```java
import java.io.*;

public class Solution {
    // 2n堆石头，编号1、2、3、4...2n
    // - 1、2为一组；3、4为一组；......
    // - 每组石头数量<=2*10^9
    // 每组可以进行分割操作：
    // - 任取一堆石头，将其移走（没了），然后分割同一组的另外一堆石头
    // - 从中取出若干石头放在被移走的位置，组成新的一堆
    // - 操作完成后，组内每堆石头的个数需要大于0
    // - 显然，非分割的一堆的石头至少2个
    // 两个人轮流进行，如果轮到某人时，所有堆的石头个数都为1，则该人输掉比赛
    // 返回先手是否能赢

    // 数据量太大————>打表
    // 两堆石头，数量a，b。
    // - 任取一堆石头移走，分割另外一堆
    // - 从中取若干个石头放在被移走的位置，组成新的一堆
    // - 操作需要保证新的一组石头数量大于0
    // - 显然，被分割的一堆的石头至少2个
    // 两人轮流进行，如果轮到某人开始操作时，两堆石头数量都为1，则该人输掉比赛
    // 返回先手是否能赢，找规律

    public static int MAXN = 1001;

    public static int[][] dp = new int[MAXN][MAXN];

    public static void build() {
        for (int a = 1; a < MAXN; a++) {
            for (int b = 1; b < MAXN; b++) {
                dp[a][b] = -1;
            }
        }
    }

    public static int SG(int a, int b) {
        if (a == 1 && b == 1) {
            return 0;
        }
        if (dp[a][b] != -1) {
            return dp[a][b];
        }
        boolean[] appear = new boolean[Math.max(a, b) + 1];
        if (a > 1) {
            for (int l = 1, r = a - 1; l <= a - 1; l++, r--) {
                appear[SG(l, r)] = true;
            }
        }
        if (b > 1) {
            for (int l = 1, r = b - 1; l <= b - 1; l++, r--) {
                appear[SG(l, r)] = true;
            }
        }
        int ans = 0;
        for (int s = 0; s <= Math.max(a, b); s++) {
            if (!appear[s]) {
                ans = s;
                break;
            }
        }
        return dp[a][b] = ans;
    }

    // 打表
    // (a,b):[(1~9)、(1~9)]
    public static void f1() {
        System.out.println("石子数9以内所有组合的sg值");
        System.out.println();
        System.out.print("    ");
        for (int i = 1; i <= 9; i++) {
            System.out.print(i + " ");
        }
        System.out.println();
        System.out.println();
        for (int a = 1; a <= 9; a++) {
            System.out.print(a + "   ");
            for (int b = 1; b < a; b++) {
                System.out.print("X ");
            }
            for (int b = a; b <= 9; b++) {
                int sg = SG(a, b);
                System.out.print(sg + " ");
            }
            System.out.println();
        }
    }

    // 打表
    // (a,b):[(0~8)、(0~8)]
    public static void f2() {
        System.out.println("石子数9以内所有组合的sg值，但是行列都-1");
        System.out.println();
        System.out.print("    ");
        for (int i = 0; i <= 8; i++) {
            System.out.print(i + " ");
        }
        System.out.println();
        System.out.println();
        for (int a = 1; a <= 9; a++) {
            System.out.print((a - 1) + "   ");
            for (int b = 1; b < a; b++) {
                System.out.print("X ");
            }
            for (int b = a; b <= 9; b++) {
                int sg = SG(a, b);
                System.out.print(sg + " ");
            }
            System.out.println();
        }
    }

    // 测试规律
    public static void f3() {
        for (int a = 1; a <= 9; a++) {
            for (int b = 1; b <= 9; b++) {
                int SG1 = SG(a, b);
                int SG2 = lowZero((a - 1) | (b - 1));
                System.out.println("a=" + a);
                System.out.println("b=" + b);
                System.out.println("SG1=" + SG1);
                System.out.println("SG2=" + SG2);
                System.out.println("-----------------");
            }
        }
    }

    // 返回一个数二进制最低位的0的位置
    public static int lowZero(int status) {
        int cnt = 0;
        while (status > 0) {
            if ((status & 1) == 0) {
                break;
            }
            status >>= 1;
            cnt++;
        }
        return cnt;
    }

    public static void main0(String[] args) {
        build();
        System.out.println("测试开始：");
        f1();
        System.out.println("测试f1结束");
        f2();
        System.out.println("测试f2结束");
        f3();
        System.out.println("测试f3结束");
    }

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        in.nextToken();
        int t = (int) in.nval;
        for (int i = 0; i < t; i++) {
            int SG = 0;
            in.nextToken();
            int n = (int) in.nval;
            for (int j = 1, a, b; j <= n; j += 2) {
                in.nextToken();
                a = (int) in.nval;
                in.nextToken();
                b = (int) in.nval;
                SG ^= lowZero((a - 1) | (b - 1));
            }
            if (SG != 0) {
                out.println("YES");
            } else {
                out.println("NO");
            }
        }
        out.flush();
        out.close();
    }
}
```



## [洛谷【省选/NOI-】P3185 \[HNOI2007\] 分裂游戏](https://www.luogu.com.cn/problem/P3185)



```java
import java.io.*;
import java.util.Arrays;

public class Solution {
    // n个瓶子，编号0~n-1，第i瓶中有nums[i]个糖豆
    // 两个玩家轮流取糖豆，每轮选三个编号i、j、k(i<j<=k)
    // - 当前玩家从i瓶中拿出一个，分裂成两个，往j、k瓶中各放入一个
    // - 要求i号瓶中一定要有糖豆，如果j==k，那么就相当于从i号瓶中拿出一个，往j（或k）瓶中放入两个
    // - 如果轮到某个玩家，发现所有糖豆都在n-1号瓶中，导致无法继续，则输掉比赛
    // 先手希望知道，第一步如何行动可以保证自己获胜，返回字典序（编号小的优先）最小的行动
    // - 否则返回"-1 -1 -1"
    // 先手还希望知道，自己有多少种第一步的方案，可以保证自己必胜，返回方案数

    // 所有糖豆可以看作独立的子游戏

    // 倒序：20————>0
    // 左 右
    public static int MAXN = 21;

    public static int[] nums = new int[MAXN];

    public static int[] SG = new int[MAXN];

    public static int MAXV = 101;

    public static boolean[] appear = new boolean[MAXV];

    public static int t, n;

    public static void build() {
        for (int i = 1; i < MAXN; i++) {
            Arrays.fill(appear, false);
            for (int j = i - 1; j >= 0; j--) {
                for (int k = j; k >= 0; k--) {
                    appear[SG[j] ^ SG[k]] = true;
                }
            }
            for (int s = 0; s < MAXV; s++) {
                if (!appear[s]) {
                    SG[i] = s;
                    break;
                }
            }
        }
    }

    public static void main(String[] args) throws IOException {
        build();
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        in.nextToken();
        t = (int) in.nval;
        for (int i = 0; i < t; i++) {
            in.nextToken();
            n = (int) in.nval;
            for (int j = n - 1; j >= 0; j--) {
                in.nextToken();
                nums[j] = (int) in.nval;
            }
            out.println(compute());
        }
        out.flush();
        out.close();
    }

    public static String compute() {
        int eor = 0;
        for (int i = n - 1; i >= 0; i--) {
            if (nums[i] % 2 == 1) {
                eor ^= SG[i];
            }
        }
        if (eor == 0) {
            return "-1 -1 -1\n" + "0";
        }
        int cnt = 0, a = -1, b = -1, c = -1, pos;
        for (int i = n - 1; i >= 1; i--) {
            if (nums[i] > 0) {
                for (int j = i - 1; j >= 0; j--) {
                    for (int k = j; k >= 0; k--) {
                        pos = eor ^ SG[i] ^ eor ^ SG[j] ^ eor ^ SG[k];
                        if (pos == 0) {
                            cnt++;
                            if (a == -1) {
                                a = i;
                                b = j;
                                c = k;
                            }
                        }
                    }
                }
            }
        }
        return String.valueOf((n - 1 - a) + " " + (n - 1 - b) + " " + (n - 1 - c) + "\n" + cnt);
    }
}
```



***



# ✅097【必备】质数判断、质因子分解、质数筛



## [洛谷【】U148828 素数判断（Miller-Rabin 模板）](https://www.luogu.com.cn/problem/U148828)



```java
import java.io.*;
import java.math.*;

public class Solution {
    // 判断一个较大的数是否是质数（x<=10^18）

    // 关于超大数的读入，推荐main02方法

    public static void main01(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StreamTokenizer in = new StreamTokenizer(br);
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        in.nextToken();
        // in.nval读取的实际上为double类型
        // - double类型64位
        // - long类型64位
        // 因为double类型会自动分配若干位去表达小数部分
        // 当我们需要读取的数据已经极其接近long的边界时
        // long类型需要使用全部64位去表达整数部分
        // 那么从double类型转换为long类型时，就会存在精度损耗
        long n = (long) in.nval;
        out.println(n);
    }

    public static void main02(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        // br.readLine()读取的是当前行的整个字符串
        // 然后将字符串转化为long类型
        // 就不存在精度损耗了
        String s = br.readLine();
        long n = Long.valueOf(s);
        out.println(n);
    }

    // Miller-Rabin测试

    public static void main11(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        int t = Integer.valueOf(br.readLine());
        for (int i = 0; i < t; i++) {
            long n = Long.valueOf(br.readLine());
            out.println(millerRabin(n) ? "Yes" : "No");
        }
        out.flush();
        out.close();
        br.close();
    }

    // 质数代表测试次数
    public static long[] p = { 2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37 };

    // 判断一个大数是否是质数
    public static boolean millerRabin(long n) {
        if (n <= 2) {
            // 小于等于2时
            return n == 2;
        }
        if ((n & 1) == 0) {
            // 偶数时
            return false;
        }
        // 从p数组中取出质数进行测试
        for (int i = 0; i < p.length && p[i] < n; i++) {
            if (witness(p[i], n)) {
                return false;
            }
        }
        return true;
    }

    // a：质数
    // n：待测试的数
    // 返回n是不是合数
    public static boolean witness(long a, long n) {
        // 将n-1分解为u*2^t
        long u = n - 1;
        int t = 0;
        while ((u & 1) == 0) {
            t++;
            u >>= 1;
        }
        // 计算a^u % n
        long x1 = power1(a, u, n), x2;
        for (int i = 1; i <= t; i++) {
            x2 = power1(x1, 2, n);
            if (x2 == 1 && x1 != 1 && x1 != n - 1) {
                return true;
            }
            x1 = x2;
        }
        if (x1 != 1) {
            return true;
        }
        return false;
    }

    // 乘法快速幂
    // 返回n的p次方 % mod
    public static long power1(long n, long p, long mod) {
        long ans = 1;
        while (p > 0) {
            if ((p & 1) == 1) {
                ans = (ans * n) % mod;
            }
            n = (n * n) % mod;
            p >>= 1;
        }
        return ans;
    }

    public static long power2(long n, long p, long mod) {
        long ans = 1;
        while (p > 0) {
            if ((p & 1) == 1) {
                ans = multiply(ans, n, mod);
            }
            n = multiply(n, n, mod);
            p >>= 1;
        }
        return ans;
    }

    // 龟速乘
    // a*b采用位运算实现，让每一个中间结果%mod
    public static long multiply(long a, long b, long mod) {
        a = (a % mod + mod) % mod;
        b = (b % mod + mod) % mod;
        long ans = 0;
        while (b != 0) {
            if ((b & 1) != 0) {
                ans = (ans + a) % mod;
            }
            a = (a + a) % mod;
            b >>= 1;
        }
        return ans;
    }

    public static void main12(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        int t = Integer.valueOf(br.readLine());
        for (int i = 0; i < t; i++) {
            BigInteger n = new BigInteger(br.readLine());
            out.println(n.isProbablePrime(20) ? "Yes" : "No");
        }
        out.flush();
        out.close();
        br.close();
    }
}
```



## [Leetcode【难】952.按公因数计算最大组件大小](https://leetcode.cn/problems/largest-component-size-by-common-factor/description/)



```java
import java.util.*;

public class Solution {
    // 数字n拆解质数因子

    public static void main(String[] args) {
        int n = 4012100;
        f(n);
    }

    public static void f(int n) {
        for (int i = 2; i * i < n; i++) {
            if (n % i == 0) {
                System.out.println(i);
                while (n % i == 0) {
                    n /= i;
                }
            }
        }
        if (n > 1) {
            System.out.println(n);
        }
    }

    // 给定一个由不同正整数组成的非空数组nums
    // - 如果nums[i]和nums[j]有一个大于1的公因子，那么这两个数之间有一个无向边
    // 返回nums中最大连通组件的大小

    public static int MAXV = 100001;

    // first[a]=b
    // - a这个质数因子，最早被nums中下标为b的数字拥有
    public static int[] first = new int[MAXV];

    // 并查集
    public static int MAXN = 20001;
    public static int[] father = new int[MAXN];
    public static int[] size = new int[MAXN];

    public static int n;

    public static void build() {
        for (int i = 0; i < n; i++) {
            father[i] = i;
            size[i] = 1;
        }
        Arrays.fill(first, -1);
    }

    public static int find(int i) {
        if (i != father[i]) {
            father[i] = find(father[i]);
        }
        return father[i];
    }

    public static void union(int x, int y) {
        int fx = find(x);
        int fy = find(y);
        if (fx != fy) {
            father[fx] = fy;
            size[fy] += size[fx];
        }
    }

    public static int maxSize() {
        int ans = 0;
        for (int i = 0; i < n; i++) {
            ans = Math.max(ans, size[find(i)]);
        }
        return ans;
    }

    public static int largestComponentSize(int[] arr) {
        n = arr.length;
        build();
        for (int i = 0, x; i < n; i++) {
            x = arr[i];
            for (int j = 2; j * j <= x; j++) {
                if (x % j == 0) {
                    if (first[j] == -1) {
                        first[j] = i;
                    } else {
                        union(i, first[j]);
                    }
                    while (x % j == 0) {
                        x /= j;
                    }
                }
            }
            if (x > 1) {
                if (first[x] == -1) {
                    first[x] = i;
                } else {
                    union(i, first[x]);
                }
            }
        }
        return maxSize();
    }
}
```



## [Leetcode【中】204.计算质数](https://leetcode.cn/problems/count-primes/description/)



```java
public class Solution {
    // 给定整数n，计算小于非负整数n的质数的数量

    public static int countPrimes(int n) {
        return ehrlich1(n - 1);
        // return euler(n - 1);
    }

    // 埃氏筛
    public static int ehrlich1(int n) {
        // visit[i]
        // - true：i是合数
        // - false：i是质数
        boolean[] visit = new boolean[n + 1];
        for (int i = 2; i * i <= n; i++) {
            if (!visit[i]) {
                for (int j = i * i; j <= n; j += i) {
                    visit[j] = true;
                }
            }
        }
        int count = 0;
        for (int i = 2; i <= n; i++) {
            if (!visit[i]) {
                count++;
            }
        }
        return count;
    }

    // 埃氏筛PLUS
    public static int ehrlich2(int n) {
        if (n <= 1) {
            return 0;
        }
        // visit[i]
        // - true：i是合数
        // - false：i是质数
        boolean[] visit = new boolean[n + 1];
        // 我们假设n个数都是质数，然后一步一步减
        // - 先把全部偶数去掉
        int cnt = (n + 1) / 2;
        for (int i = 3; i * i <= n; i += 2) {
            if (!visit[i]) {
                for (int j = i * i; j <= n; j += 2 * i) {
                    if (!visit[j]) {
                        visit[j] = true;
                        cnt--;
                    }
                }
            }
        }
        return cnt;
    }

    // 欧拉筛
    // - 每个合数只被自己的最小质数因子筛掉
    public static int euler(int n) {
        // visit[i]
        // - true：i是合数
        // - false：i是质数
        boolean[] visit = new boolean[n + 1];
        // 收集所有质数
        int[] prime = new int[n / 2 + 1];
        // 质数个数
        int count = 0;
        for (int i = 2; i <= n; i++) {
            if (!visit[i]) {
                prime[count++] = i;
            }
            for (int j = 0; j < count; j++) {
                if (i * prime[j] > n) {
                    break;
                }
                visit[i * prime[j]] = true;
                if (i % prime[j] == 0) {
                    break;
                }
            }
        }
        return count;
    }
}
```



***



# ✅098【必备】乘法快速幂、矩阵快速幂



## [洛谷【普及-】P1226 【模板】快速幂](https://www.luogu.com.cn/problem/P1226)



```java
import java.io.*;

public class Solution {
    // 乘法快速幂
    // a的b次方，并对p取模

    public static long a, b, p;

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        in.nextToken();
        a = (int) in.nval;
        in.nextToken();
        b = (int) in.nval;
        in.nextToken();
        p = (int) in.nval;
        out.println(a + "^" + b + " mod " + p + "=" + power());
        out.flush();
        out.close();
    }

    public static int power() {
        long ans = 1;
        while (b > 0) {
            if ((b & 1) == 1) {
                ans = (ans * a) % p;
            }
            a = (a * a) % p;
            b >>= 1;
        }
        return (int) ans;
    }
}
```



## [Leetcode【易】509.斐波那契数](https://leetcode.cn/problems/fibonacci-number/description/)



```java
public class Solution {
    // 矩阵快速幂（矩阵乘法）
    // 求解1维k阶有明确关系表达式的矩阵递推式

    // 求解斐波那契数列的第n项
    public static int fib(int n) {
        if (n == 0) {
            return 0;
        }
        if (n == 1) {
            return 1;
        }
        // 对于斐波那契的第n项
        // - 存在[F(n),F(n-1)]*base=[F(n+1),F(n)]
        // - 也就是start*base可以得到F(2)
        // - start*base^2可以得到F(3)
        // - 所以start*base^(n-1)可以得到F(n)
        int[][] start = { { 1, 0 } };
        int[][] base = {
                { 1, 1 },
                { 1, 0 }
        };
        // base理解
        // - start的迭代数组的首项都是上一组start的元素各自*1再累加
        // - start的迭代数组的第二项都是上一组start的首个元素
        // - 刚好往前进了1位
        int[][] ans = multiply(start, power(base, n - 1));
        return ans[0][0];
    }

    // 矩阵乘法
    public static int[][] multiply(int[][] a, int[][] b) {
        // a的列数=b的行数
        // 答案矩阵
        // - 行数等于a的行数a.length
        // - 列数等于b的列数b[0].length
        int[][] ans = new int[a.length][b[0].length];
        for (int i = 0; i < a.length; i++) {
            for (int j = 0; j < b[0].length; j++) {
                for (int k = 0; k < a[0].length; k++) {
                    ans[i][j] += a[i][k] * b[k][j];
                }
            }
        }
        return ans;
    }

    // 矩阵快速幂
    // - 矩阵需要是正方形
    public static int[][] power(int[][] m, int p) {
        // 单位矩阵
        // - 对角线为1
        // - 其余位置都为0
        // - 矩阵m*单位矩阵=m
        int[][] ans = new int[m.length][m[0].length];
        for (int i = 0; i < m.length; i++) {
            ans[i][i] = 1;
        }
        for (; p != 0; p >>= 1) {
            if ((p & 1) != 0) {
                ans = multiply(ans, m);
            }
            m = multiply(m, m);
        }
        return ans;
    }
}
```



## [Leetcode【易】70.爬楼梯](https://leetcode.cn/problems/climbing-stairs/description/)



```java
public class Solution {
    // 矩阵快速幂（矩阵乘法）
    // 求解1维k阶有明确关系表达式的矩阵递推式

    // 爬楼梯
    // - 每次爬1或2个台阶
    // 返回有多少种可以爬到n层的方法
    public static int climbStairs(int n) {
        if (n == 0) {
            return 1;
        }
        if (n == 1) {
            return 1;
        }
        if (n == 2) {
            return 2;
        }
        int[][] start = { { 1, 1 } };
        int[][] base = {
                { 1, 1 },
                { 1, 0 }
        };
        int[][] ans = multiply(start, power(base, n - 1));
        return ans[0][0];
    }

    // 矩阵乘法
    public static int[][] multiply(int[][] a, int[][] b) {
        // a的列数=b的行数
        // 答案矩阵
        // - 行数等于a的行数a.length
        // - 列数等于b的列数b[0].length
        int[][] ans = new int[a.length][b[0].length];
        for (int i = 0; i < a.length; i++) {
            for (int j = 0; j < b[0].length; j++) {
                for (int k = 0; k < a[0].length; k++) {
                    ans[i][j] += a[i][k] * b[k][j];
                }
            }
        }
        return ans;
    }

    // 矩阵快速幂
    // - 矩阵需要是正方形
    public static int[][] power(int[][] m, int p) {
        // 单位矩阵
        // - 对角线为1
        // - 其余位置都为0
        // - 矩阵m*单位矩阵=m
        int[][] ans = new int[m.length][m[0].length];
        for (int i = 0; i < m.length; i++) {
            ans[i][i] = 1;
        }
        for (; p != 0; p >>= 1) {
            if ((p & 1) != 0) {
                ans = multiply(ans, m);
            }
            m = multiply(m, m);
        }
        return ans;
    }
}
```



## [Leetcode【易】1137.第 N 个泰波那契数](https://leetcode.cn/problems/n-th-tribonacci-number/description/)



```java
public class Solution {
    // 矩阵快速幂（矩阵乘法）
    // 求解1维k阶有明确关系表达式的矩阵递推式

    // 第n个泰波那契数
    // - t(0)=0
    // - t(1)=1
    // - t(2)=1
    // - t(n)=t(n-1)+t(n-2)+t(n-3)
    public static int tribonacci(int n) {
        if (n == 0) {
            return 0;
        }
        if (n == 1) {
            return 1;
        }
        if (n == 2) {
            return 1;
        }
        int[][] start = { { 1, 1, 0 } };
        int[][] base = {
                { 1, 1, 0 },
                { 1, 0, 1 },
                { 1, 0, 0 }
        };
        int[][] ans = multiply(start, power(base, n - 2));
        return ans[0][0];
    }

    // 矩阵乘法
    public static int[][] multiply(int[][] a, int[][] b) {
        // a的列数=b的行数
        // 答案矩阵
        // - 行数等于a的行数a.length
        // - 列数等于b的列数b[0].length
        int[][] ans = new int[a.length][b[0].length];
        for (int i = 0; i < a.length; i++) {
            for (int j = 0; j < b[0].length; j++) {
                for (int k = 0; k < a[0].length; k++) {
                    ans[i][j] += a[i][k] * b[k][j];
                }
            }
        }
        return ans;
    }

    // 矩阵快速幂
    // - 矩阵需要是正方形
    public static int[][] power(int[][] m, int p) {
        // 单位矩阵
        // - 对角线为1
        // - 其余位置都为0
        // - 矩阵m*单位矩阵=m
        int[][] ans = new int[m.length][m[0].length];
        for (int i = 0; i < m.length; i++) {
            ans[i][i] = 1;
        }
        for (; p != 0; p >>= 1) {
            if ((p & 1) != 0) {
                ans = multiply(ans, m);
            }
            m = multiply(m, m);
        }
        return ans;
    }
}
```



## [Leetcode【中】790.多米诺和托米诺平铺](https://leetcode.cn/problems/domino-and-tromino-tiling/description/)



```java
public class Solution {
    // 矩阵快速幂（矩阵乘法）
    // 求解1维k阶有明确关系表达式的矩阵递推式

    // 多米诺和托米诺平铺
    // 两种形状的瓷砖
    // - 2*1的
    // - "L"型的
    // - 两种形状都可以旋转
    // 给定整数n，返回平铺铺满2*n的方法数
    // - 结果对1000000007取模

    public static int MOD = 1000000007;

    // f(1)=1
    // f(2)=2
    // f(3)=5
    // f(4)=11 f(3)*2+f(1)
    // f(5)=24 f(4)*2+f(2)
    // f(n)=f(n-1)*2+f(n-3)

    // 暴力
    // - h==0：返回2*n铺满的方法数
    // - h==1：返回2*n+1（左侧或右侧多一块）铺满的方法数
    public static int f0(int n, int h) {
        if (n == 0) {
            return h == 0 ? 1 : 0;
        }
        if (n == 1) {
            return 1;
        }
        if (h == 1) {
            // - 使用一个2*1的
            // - 使用一个"L"型的
            return (f0(n - 1, 0) + f0(n - 1, 1)) % MOD;
        } else {
            // - 使用一个2*1的
            // - 使用一个"L"型的
            // - 使用2个2*1的（两个上下横着放）
            return (f0(n - 1, 0) + 2 * f0(n - 2, 1) + f0(n - 2, 0)) % MOD;
        }
    }

    public static void main(String[] args) {
        for (int i = 1; i < 10; i++) {
            System.out.println(f0(i, 0));
        }
    }

    // 矩阵快速幂
    public static int f(int n) {
        if (n == 0) {
            return 1;
        }
        if (n == 1) {
            return 2;
        }
        if (n == 2) {
            return 5;
        }
        int[][] start = { { 5, 2, 1 } };
        int[][] base = {
                { 2, 1, 0 },
                { 0, 0, 1 },
                { 1, 0, 0 }
        };
        int[][] ans = multiply(start, power(base, n - 2));
        return ans[0][0];
    }

    public static int numTilings(int n) {
        // return f(n - 1);
        return f0(n, 0);
    }

    // 矩阵乘法
    public static int[][] multiply(int[][] a, int[][] b) {
        // a的列数=b的行数
        // 答案矩阵
        // - 行数等于a的行数a.length
        // - 列数等于b的列数b[0].length
        int[][] ans = new int[a.length][b[0].length];
        for (int i = 0; i < a.length; i++) {
            for (int j = 0; j < b[0].length; j++) {
                for (int k = 0; k < a[0].length; k++) {
                    ans[i][j] = (int) (((long) a[i][k] * b[k][j] + ans[i][j]) % MOD);
                }
            }
        }
        return ans;
    }

    // 矩阵快速幂
    // - 矩阵需要是正方形
    public static int[][] power(int[][] m, int p) {
        // 单位矩阵
        // - 对角线为1
        // - 其余位置都为0
        // - 矩阵m*单位矩阵=m
        int[][] ans = new int[m.length][m[0].length];
        for (int i = 0; i < m.length; i++) {
            ans[i][i] = 1;
        }
        for (; p != 0; p >>= 1) {
            if ((p & 1) != 0) {
                ans = multiply(ans, m);
            }
            m = multiply(m, m);
        }
        return ans;
    }
}
```



## [Leetcode【难】1220.统计元音字母序列的数目](https://leetcode.cn/problems/count-vowels-permutation/description/)



```java
public class Solution {
    // 矩阵快速幂（矩阵乘法）
    // 求解1维k阶有明确关系表达式的矩阵递推式

    // 给定一个整数n，我们使用五个小写元音字母按规则排成成字符串
    // - a后边只能跟着e
    // - e后边只能跟着a或i
    // - i后边只能跟着a、e、o或u，不能还是i
    // - o后边只能跟着i或u
    // - u后边只能跟着a
    // 返回有多少种符合规则的字符串
    // - 结果对10^9+7取模

    public static int MOD = 1000000007;

    // f(1)=5
    // - a
    // - e
    // - i
    // - o
    // - u
    // f(2)=10
    // - ea
    // - ia
    // - ua
    // - ae
    // - ie
    // - ei
    // - oi
    // - io
    // - iu
    // - ou
    // 以当前字母结尾，前边可以接的字母
    // - a:e,i,u
    // - dp[i][a]=dp[i-1][e,i,u]
    // - e:a,i
    // - dp[i][e]=dp[i-1][a,i]
    // - i:e,o
    // - dp[i][i]=dp[i-1][e,o]
    // - o:i
    // - dp[i][o]=dp[i-1][i]
    // - u:i,o
    // - dp[i][u]=dp[i-1][i,o]

    public static int countVowelPermutation(int n) {
        int[][] start = { { 1, 1, 1, 1, 1 } };
        int[][] base = {
                { 0, 1, 0, 0, 0 }, // a
                { 1, 0, 1, 0, 0 }, // e
                { 1, 1, 0, 1, 1 }, // i
                { 0, 0, 1, 0, 1 }, // o
                { 1, 0, 0, 0, 0 } // u
        };
        int[][] ans = multiply(start, power(base, n - 1));
        int res = 0;
        for (int a : ans[0]) {
            res = (res + a) % MOD;
        }
        return res;
    }

    // 矩阵乘法
    public static int[][] multiply(int[][] a, int[][] b) {
        // a的列数=b的行数
        // 答案矩阵
        // - 行数等于a的行数a.length
        // - 列数等于b的列数b[0].length
        int[][] ans = new int[a.length][b[0].length];
        for (int i = 0; i < a.length; i++) {
            for (int j = 0; j < b[0].length; j++) {
                for (int k = 0; k < a[0].length; k++) {
                    ans[i][j] = (int) (((long) a[i][k] * b[k][j] + ans[i][j]) % MOD);
                }
            }
        }
        return ans;
    }

    // 矩阵快速幂
    // - 矩阵需要是正方形
    public static int[][] power(int[][] m, int p) {
        // 单位矩阵
        // - 对角线为1
        // - 其余位置都为0
        // - 矩阵m*单位矩阵=m
        int[][] ans = new int[m.length][m[0].length];
        for (int i = 0; i < m.length; i++) {
            ans[i][i] = 1;
        }
        for (; p != 0; p >>= 1) {
            if ((p & 1) != 0) {
                ans = multiply(ans, m);
            }
            m = multiply(m, m);
        }
        return ans;
    }
}
```



## [Leetcode【难】552.学生出勤记录 II](https://leetcode.cn/problems/student-attendance-record-ii/description/)



```java
public class Solution {
    // 矩阵快速幂（矩阵乘法）
    // 求解1维k阶有明确关系表达式的矩阵递推式

    // 用一个字符串记录一个学生的出勤记录，其中每个字符表示当天的出勤情况
    // - 'A':缺勤
    // - 'L':迟到
    // - 'P':到场
    // 能否获得出勤奖励需要满足如下要求
    // - 总出勤'A'严格少于2天
    // - 不存在连续3天或3天以上的迟到'L'
    // 给定一个长度为n的字符串，记录出勤
    // 返回所有可以获得出勤奖励的字符串的数量
    // - 结果对10^9+7取模

    public static int MOD = 1000000007;

    // dp[i][j][k]
    // - 前i天
    // - 有j天缺勤(0<=j<=1)
    // - 以"L"结尾的连续迟到的天数k(0<=k<=2)
    // dp[i][0][0]->dp[i][0]
    // dp[i][0][1]->dp[i][1]
    // dp[i][0][2]->dp[i][2]
    // dp[i][1][0]->dp[i][3]
    // dp[i][1][1]->dp[i][4]
    // dp[i][1][2]->dp[i][5]
    // dp[i][j][k]->dp[i][j*3+k]
    // - dp[i][0]=dp[i-1][0,1,2]
    // - dp[i][1]=dp[i-1][0]
    // - dp[i][2]=dp[i-1][1]
    // - dp[i][3]=dp[i-1][0,1,2,3,4,5]
    // - dp[i][4]=dp[i-1][3]
    // - dp[i][5]=dp[i-1][4]

    public static int checkRecord(int n) {
        int[][] start = { { 1, 1, 0, 1, 0, 0 } };
        int[][] base = {
                { 1, 1, 0, 1, 0, 0 },
                { 1, 0, 1, 1, 0, 0 },
                { 1, 0, 0, 1, 0, 0 },
                { 0, 0, 0, 1, 1, 0 },
                { 0, 0, 0, 1, 0, 1 },
                { 0, 0, 0, 1, 0, 0 }
        };
        int[][] ans = multiply(start, power(base, n - 1));
        int res = 0;
        for (int a : ans[0]) {
            res = (res + a) % MOD;
        }
        return res;
    }

    // 矩阵乘法
    public static int[][] multiply(int[][] a, int[][] b) {
        // a的列数=b的行数
        // 答案矩阵
        // - 行数等于a的行数a.length
        // - 列数等于b的列数b[0].length
        int[][] ans = new int[a.length][b[0].length];
        for (int i = 0; i < a.length; i++) {
            for (int j = 0; j < b[0].length; j++) {
                for (int k = 0; k < a[0].length; k++) {
                    ans[i][j] = (int) (((long) a[i][k] * b[k][j] + ans[i][j]) % MOD);
                }
            }
        }
        return ans;
    }

    // 矩阵快速幂
    // - 矩阵需要是正方形
    public static int[][] power(int[][] m, int p) {
        // 单位矩阵
        // - 对角线为1
        // - 其余位置都为0
        // - 矩阵m*单位矩阵=m
        int[][] ans = new int[m.length][m[0].length];
        for (int i = 0; i < m.length; i++) {
            ans[i][i] = 1;
        }
        for (; p != 0; p >>= 1) {
            if ((p & 1) != 0) {
                ans = multiply(ans, m);
            }
            m = multiply(m, m);
        }
        return ans;
    }
}
```

***

