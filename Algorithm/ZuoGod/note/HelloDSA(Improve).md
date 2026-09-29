***

* [左神](https://space.bilibili.com/8888480)

* [力扣 （LeetCode） 全球极客挚爱的技术成长平台](https://leetcode.cn/)

* [牛客网 - 找工作神器|笔试题库|面试经验|实习招聘内推，求职就业一站解决](https://www.nowcoder.com/)

* [首页 - 洛谷 | 计算机科学教育新生态](https://www.luogu.com.cn/)

***

# ✅099【扩展】逆元、除法同余和容斥原理

`(a/b)%mod`

```java
public class Solution {

    // (a/b)%mod
    // =(a%mod)*(1/b)%mod
    // =(a%mod)*(b^(mod-2))%mod
    // 也就是说：(1/b)%mod=[b^(mod-2)]%mod
    // 条件如下：
    // - a/b可以整除
    // - mod是质数
    // - b和mod的最大公约数为1

    public static void main(String[] args) {
        int mod = 41;
        long b = 3671613L;
        long a = 67312L * b;
        System.out.println(compute1(a, b, mod));
        System.out.println(compute2(a, b, mod));
    }

    public static int compute1(long a, long b, int mod) {
        return (int) ((a / b) % mod);
    }

    public static int compute2(long a, long b, int mod) {
        long inv = power(b, mod - 2, mod);
        return (int) (((a % mod) * inv) % mod);
    }

    // 乘法快速幂（结果对mod取余）
    public static long power(long b, int n, int mod) {
        long ans = 1;
        while (n > 0) {
            if ((n & 1) == 1) {
                ans = (ans * b) % mod;
            }
            b = (b * b) % mod;
            n >>= 1;
        }
        return ans;
    }
}
```

## [洛谷【普及/提高-】P3811 【模板】模意义下的乘法逆元](https://www.luogu.com.cn/problem/P3811)

```java
import java.io.*;
import java.util.*;

public class Solution {
    // 给定两个整数n、p
    // 求1∼n中所有整数在模p意义下的乘法逆元
    // 也就是输出n行结果
    // 每行结果=(1/i)%p
    // - inv[1]=1
    // - inv[i]=(int)(p-(long)inv[p%i]*(p/i)%p)

    public static int MAXN = 3000001;

    public static int[] inv = new int[MAXN];

    public static int n, p;

    public static void build(int n) {
        inv[1] = 1;
        for (int i = 2; i <= n; i++) {
            inv[i] = (int) (p - (long) inv[p % i] * (p / i) % p);
        }
    }

    public static void main(String[] args) {
        FastReader fr = new FastReader(System.in);
        FastWriter fw = new FastWriter(System.out);
        n = fr.readInt();
        p = fr.readInt();
        build(n);
        for (int i = 1; i <= n; i++) {
            fw.println(inv[i]);
        }
        fw.close();
    }

    // 快读
    public static class FastReader {
        InputStream is;
        private byte[] inbuf = new byte[1024];
        public int lenbuf = 0;
        public int ptrbuf = 0;

        public FastReader(final InputStream is) {
            this.is = is;
        }

        public int readByte() {
            if (lenbuf == -1) {
                throw new InputMismatchException();
            }
            if (ptrbuf >= lenbuf) {
                ptrbuf = 0;
                try {
                    lenbuf = is.read(inbuf);
                } catch (IOException e) {
                    throw new InputMismatchException();
                }
                if (lenbuf <= 0) {
                    return -1;
                }
            }
            return inbuf[ptrbuf++];
        }

        public int readInt() {
            return (int) readLong();
        }

        public long readLong() {
            long num = 0;
            int b;
            boolean minus = false;
            while ((b = readByte()) != -1 && !((b >= '0' && b <= '9') || b == '-'))
                ;
            if (b == '-') {
                minus = true;
                b = readByte();
            }

            while (true) {
                if (b >= '0' && b <= '9') {
                    num = num * 10 + (b - '0');
                } else {
                    return minus ? -num : num;
                }
                b = readByte();
            }
        }
    }

    // 快写
    public static class FastWriter {
        private static final int BUF_SIZE = 1 << 13;
        private final byte[] buf = new byte[BUF_SIZE];
        private OutputStream out;
        private Writer writer;
        private int ptr = 0;

        public FastWriter(Writer writer) {
            this.writer = new BufferedWriter(writer);
            out = new ByteArrayOutputStream();
        }

        public FastWriter(OutputStream os) {
            this.out = os;
        }

        public FastWriter(String path) {
            try {
                this.out = new FileOutputStream(path);
            } catch (FileNotFoundException e) {
                throw new RuntimeException("FastWriter");
            }
        }

        public FastWriter write(byte b) {
            buf[ptr++] = b;
            if (ptr == BUF_SIZE) {
                innerflush();
            }
            return this;
        }

        public FastWriter write(String s) {
            s.chars().forEach(c -> {
                buf[ptr++] = (byte) c;
                if (ptr == BUF_SIZE) {
                    innerflush();
                }
            });
            return this;
        }

        private static int countDigits(long l) {
            if (l >= 1000000000000000000L) {
                return 19;
            }
            if (l >= 100000000000000000L) {
                return 18;
            }
            if (l >= 10000000000000000L) {
                return 17;
            }
            if (l >= 1000000000000000L) {
                return 16;
            }
            if (l >= 100000000000000L) {
                return 15;
            }
            if (l >= 10000000000000L) {
                return 14;
            }
            if (l >= 1000000000000L) {
                return 13;
            }
            if (l >= 100000000000L) {
                return 12;
            }
            if (l >= 10000000000L) {
                return 11;
            }
            if (l >= 1000000000L) {
                return 10;
            }
            if (l >= 100000000L) {
                return 9;
            }
            if (l >= 10000000L) {
                return 8;
            }
            if (l >= 1000000L) {
                return 7;
            }
            if (l >= 100000L) {
                return 6;
            }
            if (l >= 10000L) {
                return 5;
            }
            if (l >= 1000L) {
                return 4;
            }
            if (l >= 100L) {
                return 3;
            }
            if (l >= 10L) {
                return 2;
            }
            return 1;
        }

        public FastWriter write(long x) {
            if (x == Long.MIN_VALUE) {
                return write("" + x);
            }
            if (ptr + 21 >= BUF_SIZE) {
                innerflush();
            }
            if (x < 0) {
                write((byte) '-');
                x = -x;
            }
            int d = countDigits(x);
            for (int i = ptr + d - 1; i >= ptr; i--) {
                buf[i] = (byte) ('0' + x % 10);
                x /= 10;
            }
            ptr += d;
            return this;
        }

        public FastWriter writeln(long x) {
            return write(x).writeln();
        }

        public FastWriter writeln() {
            return write((byte) '\n');
        }

        private void innerflush() {
            try {
                out.write(buf, 0, ptr);
                ptr = 0;
            } catch (IOException e) {
                throw new RuntimeException("innerflush");
            }
        }

        public void flush() {
            innerflush();
            try {
                if (writer != null) {
                    writer.write(((ByteArrayOutputStream) out).toString());
                    out = new ByteArrayOutputStream();
                    writer.flush();
                } else {
                    out.flush();
                }
            } catch (IOException e) {
                throw new RuntimeException("flush");
            }
        }

        public FastWriter println(long x) {
            return writeln(x);
        }

        public void close() {
            flush();
            try {
                out.close();
            } catch (Exception e) {
            }
        }

    }
}
```

`C(m,n)=[n!/(m!(n-m)!)]%MOD`

```java
import java.math.BigInteger;

public class Solution {
    // 连续阶乘逆元的线性递推
    // inv[i]
    // - (1/i!)%mod
    // - inv[i]=((long)(i+1)*inv[i+1])%mod

    public static int MOD = 1000000007;

    public static int LIMIT = 1000;

    // 阶乘表
    public static long[] fac = new long[LIMIT + 1];

    // 阶乘逆元表
    public static long[] inv1 = new long[LIMIT + 1];
    public static long[] inv2 = new long[LIMIT + 1];

    public static void build() {
        // 阶乘表（从左往右）
        fac[1] = 1;
        for (int i = 2; i <= LIMIT; i++) {
            fac[i] = ((long) i * fac[i - 1]) % MOD;
        }
        // 单个阶乘的逆元
        // - 0!=1
        inv1[0] = 1;
        for (int i = 1; i <= LIMIT; i++) {
            inv1[i] = power(fac[i], MOD - 2);
        }
        // 连续阶乘逆元的线性递推
        // - 一个数x的逆元：(1/x)%MOD=[x^(MOD-2)]%MOD
        // - (1/i!)%MOD=[(i!%MOD)^(MOD-2)]%MOD
        // - (1/i-1!)%MOD=(1*i/i!)%MOD=(i%MOD)*[(1/i!)%MOD]
        inv2[LIMIT] = power(fac[LIMIT], MOD - 2);
        for (int i = LIMIT - 1; i >= 0; i--) {
            inv2[i] = ((long) (i + 1) * inv2[i + 1]) % MOD;
        }
    }

    // 快速幂
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

    // 组合公式：C(m,n)=n!/(m!(n-m)!)
    // - 暴力求解
    public static int c01(int n, int m) {
        BigInteger a = new BigInteger("1");
        BigInteger b = new BigInteger("1");
        BigInteger c = new BigInteger("1");
        for (int i = 1; i <= n; i++) {
            String cur = String.valueOf(i);
            a = a.multiply(new BigInteger(cur));
            if (i <= m) {
                b = b.multiply(new BigInteger(cur));
            }
            if (i <= n - m) {
                c = c.multiply(new BigInteger(cur));
            }
        }
        BigInteger ans = a.divide(b.multiply(c)).mod(new BigInteger(String.valueOf(MOD)));
        return ans.intValue();
    }

    // - 线性递推
    public static int c21(int n, int m) {
        long ans = fac[n];
        ans = (ans * inv1[m]) % MOD;
        ans = (ans * inv1[n - m]) % MOD;
        return (int) ans;
    }

    // - 线性递推（优化）
    public static int c22(int n, int m) {
        long ans = fac[n];
        ans = (ans * inv2[m]) % MOD;
        ans = (ans * inv2[n - m]) % MOD;
        return (int) ans;
    }

    public static void main(String[] args) {
        build();
        System.out.println("计算C(537,367)");
        System.out.println("c01=" + c01(537, 367));
        System.out.println("c21=" + c21(537, 367));
        System.out.println("c22=" + c22(537, 367));
    }
}
```

## [洛谷【普及+/提高】CF803F Coprime Subsequences](https://www.luogu.com.cn/problem/CF803F)

## [Codeforces【\*2000】F. Coprime Subsequences](https://codeforces.com/problemset/problem/803/F)

```java
import java.io.*;

public class Solution {
    // 给定一个数组（存在重复元素，但不同位置认为不一样）
    // 返回最大公约数为1的子序列的数量

    public static int MOD = 1000000007;
    public static int LIMIT = 100000;

    public static long[] dp = new long[LIMIT + 1];
    public static long[] cnt = new long[LIMIT + 1];
    public static long[] pow = new long[LIMIT + 1];

    // 2从0到LIMIT的所有幂次（对MOD取余）
    public static void build() {
        pow[0] = 1;
        for (int i = 1; i <= LIMIT; i++) {
            pow[i] = (pow[i - 1] * 2) % MOD;
        }
    }

    public static void main(String[] args) throws IOException {
        build();
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            int n = (int) in.nval;
            for (int i = 1; i <= n; i++) {
                in.nextToken();
                cnt[(int) in.nval]++;
            }
            out.println(compute());
        }
        out.flush();
        out.close();
    }

    public static long compute() {
        // 每轮确定最大公约数为i的子序列的数量
        for (int i = LIMIT; i >= 1; i--) {
            long counts = 0;
            for (int j = i; j <= LIMIT; j += i) {
                counts += cnt[j];
            }
            // 此时的dp[i]是子序列最大公约数为i/2i/3i/...的数量
            // - 2^k-1：不能一个元素都没有，因此-1
            dp[i] = (pow[(int) counts] - 1 + MOD) % MOD;
            // 减去子序列最大公约数为2i/3i/...的数量
            for (int j = 2 * i; j <= LIMIT; j += i) {
                dp[i] = (dp[i] - dp[j] + MOD) % MOD;
            }
        }
        return dp[1];
    }
}
```

## [洛谷【提高+/省选-】P1450 HAOI2008 硬币购物](https://www.luogu.com.cn/problem/P1450)

```java
import java.io.*;

public class Solution {
    // 4种硬币，面值分别是v0、v1、v2、v3
    // 每次购物都是一次查询
    // - arr[0]=v0硬币数量
    // - arr[1]=v1硬币数量
    // - arr[2]=v2硬币数量
    // - arr[3]=v3硬币数量
    // - arr[4]=本次购物一定要花多少钱
    // 返回每次有多少种花钱方式

    public static int LIMIT = 100000;

    public static long[] dp = new long[LIMIT + 1];
    public static int[] value = new int[4];
    public static int[] cnt = new int[4];

    public static int n, s;

    public static void main(String[] args) throws IOException {
        StreamTokenizer in = new StreamTokenizer(new BufferedReader(new InputStreamReader(System.in)));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        while (in.nextToken() != StreamTokenizer.TT_EOF) {
            value[0] = (int) in.nval;
            in.nextToken();
            value[1] = (int) in.nval;
            in.nextToken();
            value[2] = (int) in.nval;
            in.nextToken();
            value[3] = (int) in.nval;
            in.nextToken();
            n = (int) in.nval;
            build();
            for (int i = 1; i <= n; i++) {
                in.nextToken();
                cnt[0] = (int) in.nval;
                in.nextToken();
                cnt[1] = (int) in.nval;
                in.nextToken();
                cnt[2] = (int) in.nval;
                in.nextToken();
                cnt[3] = (int) in.nval;
                in.nextToken();
                s = (int) in.nval;
                out.println(compute());
            }
        }
        out.flush();
        out.close();
    }

    // 每种面值的硬币不限数量，花费目标金额的方案数：完全背包问题
    public static void build() {
        // 达成0元有一种方案
        dp[0] = 1;
        for (int i = 0; i < 4; i++) {
            for (int j = value[i]; j <= LIMIT; j++) {
                dp[j] += dp[j - value[i]];
            }
        }
    }

    // 硬币数量限制下的方案数=无限制下方案数-违规方案数
    public static long compute() {
        long illegal = 0;
        // 0000：全部不违规
        // 0001：v3违规
        // ......
        // 1000：v0违规
        // 0011：v2、v3违规
        // ......
        // 1100：v0、v1违规
        // 0111：v1、v2、v3违规
        // ......
        // 1110：v0、v1、v2违规
        // 1111：v0、v1、v2、v3违规
        for (int status = 1; status < 16; status++) {
            // 目标总钱数
            long total = s;
            // 容斥原理
            // - 奇数个1,1
            // - 偶数个1,-1
            int sign = -1;
            // 统计第几种硬币导致的违规
            for (int j = 0; j <= 3; j++) {
                if (((status >> j) & 1) == 1) {
                    // 减去当前违规硬币的总金额
                    total -= value[j] * (cnt[j] + 1);
                    sign = -sign;
                }
            }
            // 统计当前违规情况的种类数
            if (total >= 0) {
                illegal += sign * dp[(int) total];
            }
        }
        return dp[s] - illegal;
    }
}
```

## [Leetcode【难】920.播放列表的数量](https://leetcode.cn/problems/number-of-music-playlists/description/)

```java
public class Solution {
    // n首歌、想听l首歌、
    // - 允许歌曲重复播放
    // - 每首歌至少播放一次
    // - 每首歌只有在其余k首歌播放之后才能再次播放
    // - 0<=k<n<=l<=100
    // 返回满足要求的播放序列的数量
    // 结果对10^9+7取模

    // 我们首先忽略每首歌至少播放一次，其余条件不变的情况
    // 此时就是一个组合问题：
    // 1、2......k+1、k+2......
    // - 1位置的歌可以放在k+2的位置（中间间隔了k首）
    // - 从k+2位置往后，每个位置都有n-k种选择
    // 所以此时f(n,l,k)=A(k+1,n)*(n-k)^(l-k-1)
    // - n首中挑选出k+1首，后续每个位置都可以选n-k首（有l-k-1个位置）

    // 根据容斥原理，我们减去有若干首歌没有的情况，就可以得到所有歌都参与的参考
    // - -f(n-1,l,k)
    // - +f(n-2,l,k)
    // - -f(n-3,l,k)
    // - +f(n-4,l,k)
    // - ...
    // - 注意：n-i>k

    public static int MOD = 1000000007;
    public static int LIMIT = 100;

    public static long[] fac = new long[LIMIT + 1];
    public static long[] inv = new long[LIMIT + 1];

    static {
        fac[0] = 1;
        for (int i = 1; i <= LIMIT; i++) {
            fac[i] = ((long) fac[i - 1] * i) % MOD;
        }
        inv[LIMIT] = pow(fac[LIMIT], MOD - 2);
        for (int i = LIMIT - 1; i >= 0; i--) {
            inv[i] = ((long) (i + 1) * inv[i + 1]) % MOD;
        }
    }

    public static int numMusicPlaylists(int n, int l, int k) {
        long ans = 0, cur, sign = 1;
        for (int i = 0; i < n - k; i++, sign = sign == 1 ? (MOD - 1) : 1) {
            cur = (sign * pow(n - i - k, l - k)) % MOD;
            cur = (cur * fac[n]) % MOD;
            cur = (cur * inv[i]) % MOD;
            cur = (cur * inv[n - i - k]) % MOD;
            ans = (ans + cur) % MOD;
        }
        return (int) ans;
    }

    // 快速幂
    public static long pow(long x, long n) {
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
}
```

***

# ✅100【扩展】KMP算法

## [Leetcode【易】28. 找出字符串中第一个匹配项的下标](https://leetcode.cn/problems/find-the-index-of-the-first-occurrence-in-a-string/)

```java
public class Solution {
    // KMP模板算法
    // - O(n+m)

    public static int strStr(String s1, String s2) {
        // return s1.indexOf(s2);
        return KMP(s1.toCharArray(), s2.toCharArray());
    }

    // KMP
    public static int KMP(char[] s1, char[] s2) {
        int n = s1.length, m = s2.length, x = 0, y = 0;
        // O(m)
        int[] next = nextArray(s2, m);
        // O(n)
        while (x < n && y < m) {
            if (s1[x] == s2[y]) {
                // 当前两个字符串各自匹配的位置一致
                x++;
                y++;
            } else if (y == 0) {
                // s2的字符串已经到了开头，却仍然匹配不了，s1的当前位置后移一位
                x++;
            } else {
                // s2的字符串没有到开头，但是匹配失败，根据next数组，将s2的匹配位置左移
                y = next[y];
            }
        }
        // 如果s2的字符串匹配到了结尾，说明s1中存在s2的子字符串
        // - 并且s1中存在s2的子字符串的起始位置为x-y
        // 否则，s1中不存在s2的子字符串
        return y == m ? x - y : -1;
    }

    // next数组
    public static int[] nextArray(char[] s, int m) {
        if (m == 1) {
            return new int[] { -1 };
        }
        if (m == 2) {
            return new int[] { -1, 0 };
        }
        int[] next = new int[m];
        next[0] = -1;
        next[1] = 0;
        // - i表示当前要求next值的位置
        // - cn表示当前要和i-1也就是前一个字符比对的下标
        int i = 2, cn = 0;
        // 每次往左跳，直到跳无可跳或者跳出来的位置匹配成功
        while (i < m) {
            if (s[i - 1] == s[cn]) {
                // 当前两个位置一致
                // - i位置的next值更新
                // - i右移
                next[i++] = ++cn;
            } else if (cn > 0) {
                // 如果cn位置到没到0，并且没匹配，就往左移
                // - 直到跳无可跳或者跳出来的位置匹配成功
                cn = next[cn];
            } else {
                // 如果cn位置到0了，并且没匹配，就直接赋值0
                next[i++] = 0;
            }
        }
        return next;
    }
}
```

## [Leetcode【易】572. 另一棵树的子树](https://leetcode.cn/problems/subtree-of-another-tree/)

```java
import java.util.ArrayList;

public class Solution {
    // 给定两个树，检验前者是否包含后者完整结构的子树
    // - 有返回true
    // - 无返回false

    // 不要提交这个类
    class TreeNode {
        int val;
        TreeNode left;
        TreeNode right;
    }

    // 暴力
    public static boolean isSubtree1(TreeNode t1, TreeNode t2) {
        if (t1 != null && t2 != null) {
            return same(t1, t2) || isSubtree1(t1.left, t2) || isSubtree1(t1.right, t2);
        }
        return t2 == null;
    }

    // 给定两个树的根节点，判断是否一致
    public static boolean same(TreeNode a, TreeNode b) {
        if (a == null && b == null) {
            return true;
        }
        if (a != null && b != null) {
            return a.val == b.val && same(a.left, b.left) && same(a.right, b.right);
        }
        return false;
    }

    // 二叉树序列化+KMP
    public static boolean isSubtree2(TreeNode t1, TreeNode t2) {
        if (t1 != null && t2 != null) {
            ArrayList<String> s1 = new ArrayList<>();
            ArrayList<String> s2 = new ArrayList<>();
            serial(t1, s1);
            serial(t2, s2);
            return kmp(s1, s2) != -1;
        }
        return t2 == null;
    }

    // 二叉树先序序列化
    public static void serial(TreeNode head, ArrayList<String> path) {
        if (head == null) {
            path.add(null);
        } else {
            path.add(String.valueOf(head.val));
            serial(head.left, path);
            serial(head.right, path);
        }
    }

    // KMP算法
    public static int kmp(ArrayList<String> s1, ArrayList<String> s2) {
        int n = s1.size(), m = s2.size(), x = 0, y = 0;
        int[] next = nextArray(s2, m);
        while (x < n && y < m) {
            if (isEqual(s1.get(x), s2.get(y))) {
                x++;
                y++;
            } else if (y == 0) {
                x++;
            } else {
                y = next[y];
            }
        }
        return y == m ? x - y : -1;
    }

    // 生成next数组
    public static int[] nextArray(ArrayList<String> s, int m) {
        if (m == 1) {
            return new int[] { -1 };
        }
        int[] next = new int[m];
        next[0] = -1;
        next[1] = 0;
        int i = 2, cn = 0;
        while (i < next.length) {
            if (isEqual(s.get(i - 1), s.get(cn))) {
                next[i++] = ++cn;
            } else if (cn > 0) {
                cn = next[cn];
            } else {
                next[i++] = 0;
            }
        }
        return next;
    }

    // 判断两个字符串是否相等
    public static boolean isEqual(String s1, String s2) {
        if (s1 == null && s2 == null) {
            return true;
        }
        if (s1 != null && s2 != null) {
            return s1.equals(s2);
        }
        return false;
    }
}
```

***

# ✅101【扩展】KMP算法相关题目

## [洛谷【普及+/提高】P4391 \[BalticOI 2009\] Radio Transmission 无线传输](https://www.luogu.com.cn/problem/P4391)

```java
import java.io.*;

public class Solution {
    // 给定一个目标字符串s（abb）
    // 字符串str（abbabbab）是由s至少重复两次+一次不一定完整的重复片段组成的
    // 返回循环节s最短长度

    public static int MAXN = 1000001;

    public static int n;
    public static char[] s;
    public static int[] next = new int[MAXN];

    public static void main(String[] args) throws IOException {
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        n = Integer.valueOf(in.readLine());
        s = in.readLine().toCharArray();
        out.println(compute());
        out.flush();
        out.close();
        in.close();
    }

    // 长度为n的字符串str由 k个s + 一个s的片段 组成
    // 我们求str最后一个字符右侧一个位置的next值
    // 因为next[n]表示的是str中前缀和后缀的最大匹配长度
    // - 并且不能取str本身，也就是 k个s + 1个片段
    // 要想继续找最大的匹配长度
    // - 一定是 k-1个s + 1个片段
    // - 前缀 = 前k-1个s + 第k个s中的一个片段
    // - 后缀 = 第2~k个s + 最后一个结尾的s片段
    // 所以最大循环节的长度 = n - next[n]

    public static int compute() {
        nextArray();
        return n - next[n];
    }

    public static void nextArray() {
        next[0] = -1;
        next[1] = 0;
        int i = 2, cn = 0;
        while (i <= n) {
            if (s[i - 1] == s[cn]) {
                next[i++] = ++cn;
            } else if (cn > 0) {
                cn = next[cn];
            } else {
                next[i++] = 0;
            }
        }
    }
}
```

## [洛谷【提高+/省选−】P4824 \[USACO15FEB\] Censoring S](https://www.luogu.com.cn/problem/P4824)

```java
import java.io.*;

public class Solution {
    // 给定两个字符串s1、s2
    // 删除是s1中最左出现的s2，剩余的拼接在一块
    // 继续删除新字符串中最左出现的s2，剩余的拼接在一块
    // 直到不能再删除，返回剩余字符串

    public static int MAXN = 1000001;

    public static char[] s1, s2;

    public static int[] next = new int[MAXN];
    public static int[] stack1 = new int[MAXN];
    public static int[] stack2 = new int[MAXN];

    public static int size;

    public static void main(String[] args) throws IOException {
        BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
        PrintWriter out = new PrintWriter(new OutputStreamWriter(System.out));
        s1 = in.readLine().toCharArray();
        s2 = in.readLine().toCharArray();
        compute();
        for (int i = 0; i < size; i++) {
            out.print(s1[stack1[i]]);
        }
        out.flush();
        out.close();
        in.close();
    }

    public static void compute() {
        size = 0;
        int n = s1.length;
        int m = s2.length;
        int x = 0, y = 0;
        nextArray();
        while (x < n) {
            if (s1[x] == s2[y]) {
                // 如果当前两个字符一致，就都往右移动，栈大小+1
                stack1[size] = x++;
                stack2[size] = y++;
                size++;
            } else if (y == 0) {
                // 如果当前两个字符不一样
                // 并且小字符串位于左边界
                // 当前大字符串字符不匹配，分配-1
                stack1[size] = x++;
                stack2[size] = -1;
                size++;
            } else {
                // 如果当前两个字符不一样
                // 但是小字符串还没有到左边界
                // 就根据next数组，跳转到前一个字符匹配的位置
                y = next[y];
            }
            if (y == m) {
                // 成功匹配一次小字符串
                size -= m;
                y = size > 0 ? (stack2[size - 1] + 1) : 0;
            }
        }
    }

    public static void nextArray() {
        next[0] = -1;
        next[1] = 0;
        int i = 2, cn = 0;
        while (i <= s2.length) {
            if (s2[i - 1] == s2[cn]) {
                next[i++] = ++cn;
            } else if (cn > 0) {
                cn = next[cn];
            } else {
                next[i++] = 0;
            }
        }
    }
}
```

## [Leetcode【中】1367. 二叉树中的链表](https://leetcode.cn/problems/linked-list-in-binary-tree/)

```java
public class Solution {
    // 给定一个root为根的二叉树、一个head为头的链表
    // 二叉树中有很多一直向下的路径
    // 若二叉树中存在如此链表的路径
    // - 则返回true
    // - 否则返回false

    // 不要提交这个类
    class ListNode {
        int val;
        ListNode next;
    }

    // 不要提交这个类
    class TreeNode {
        int val;
        TreeNode left;
        TreeNode right;
    }

    public static boolean isSubPath(ListNode head, TreeNode root) {
        int m = 0;
        ListNode tmp = head;
        while (tmp != null) {
            m++;
            tmp = tmp.next;
        }
        int[] s2 = new int[m];
        m = 0;
        while (head != null) {
            s2[m++] = head.val;
            head = head.next;
        }
        int[] next = nextArray(s2, m);
        return find(s2, next, root, 0);
    }

    public static boolean find(int[] s2, int[] next, TreeNode cur, int i) {
        if (i == s2.length) {
            return true;
        }
        if (cur == null) {
            return false;
        }
        while (i >= 0 && cur.val != s2[i]) {
            i = next[i];
        }
        return find(s2, next, cur.left, i + 1) || find(s2, next, cur.right, i + 1);
    }

    public static int[] nextArray(int[] s, int m) {
        if (m == 1) {
            return new int[] { -1 };
        }
        if (m == 2) {
            return new int[] { -1, 0 };
        }
        int[] next = new int[m];
        next[0] = -1;
        next[1] = 0;
        int i = 2, cn = 0;
        while (i < m) {
            if (s[i - 1] == s[cn]) {
                next[i++] = ++cn;
            } else if (cn > 0) {
                cn = next[cn];
            } else {
                next[i++] = 0;
            }
        }
        return next;
    }
}
```

## [Leetcode【难】1397. 找到所有好字符串](https://leetcode.cn/problems/find-all-good-strings/)

```java
public class Solution {
    // 给定两个长度为n的字符串s1和s2，以及一个字符串evil
    // 好字符串
    // - 字典序大于等于s1
    // - 字典序小于等于s2
    // - 且不含有evil字符串
    // 返回好字符串数量，结果对1000000007取模

    public static int MOD = 1000000007;

    public static int MAXN = 501;

    public static int MAXM = 51;

    public static int[][][] dp = new int[MAXN][MAXM][2];

    public static int[] next = new int[MAXM];

    public static void clear(int n, int m) {
        for (int i = 0; i < n; i++) {
            for (int j = 0; j < m; j++) {
                dp[i][j][0] = -1;
                dp[i][j][1] = -1;
            }
        }
    }

    public static int findGoodStrings(int n, String str1, String str2, String evil) {
        char[] s1 = str1.toCharArray();
        char[] s2 = str2.toCharArray();
        char[] e = evil.toCharArray();
        nextArray(e, e.length);
        clear(n, e.length);
        int ans = f(s2, e, n, e.length, 0, 0, 0);
        clear(n, e.length);
        ans = (ans - f(s1, e, n, e.length, 0, 0, 0) + MOD) % MOD;
        if (kmp(s1, e, n, e.length) == -1) {
            ans = (ans + 1) % MOD;
        }
        return ans;
    }

    public static int kmp(char[] s, char[] e, int n, int m) {
        int x = 0, y = 0;
        while (x < n && y < m) {
            if (s[x] == e[y]) {
                x++;
                y++;
            } else if (y == 0) {
                x++;
            } else {
                y = next[y];
            }
        }
        return y == m ? x - y : -1;
    }

    public static void nextArray(char[] e, int m) {
        next[0] = -1;
        next[1] = 0;
        int i = 2, cn = 0;
        while (i < m) {
            if (e[i - 1] == e[cn]) {
                next[i++] = ++cn;
            } else if (cn > 0) {
                cn = next[cn];
            } else {
                next[i++] = 0;
            }
        }
    }

    // s,e,n,m固定参数
    // 当前0...i-1已经做出了决策，并且匹配了e[0...j-1]这部分
    // 当前来到s[i]，需要考虑匹配e[j]
    // 如果之前的决策以及比s小了，那么free=1
    // 如果之前的决策和s一致，那么free=0
    public static int f(char[] s, char[] e, int n, int m, int i, int j, int free) {
        if (j == m) {
            // 匹配出了evil
            return 0;
        }
        // 还没有匹配出evil
        if (i == n) {
            // 做完了所有决策
            // 不含有evil
            // 长度为n
            return 1;
        }
        if (dp[i][j][free] != -1) {
            return dp[i][j][free];
        }
        char cur = s[i];
        int ans = 0;
        if (free == 0) {
            // 之前的决策和s一致
            // 尝试比cur小的字符
            for (char pick = 'a'; pick < cur; pick++) {
                ans = (ans + f(s, e, n, m, i + 1, jump(pick, e, j) + 1, 1)) % MOD;
            }
            // 当前字符=cur
            ans = (ans + f(s, e, n, m, i + 1, jump(cur, e, j) + 1, 0)) % MOD;
        } else {
            // 之前的决策已经比s小了
            // 尝试所有字符
            for (char pick = 'a'; pick <= 'z'; pick++) {
                ans = (ans + f(s, e, n, m, i + 1, jump(pick, e, j) + 1, 1)) % MOD;
            }
        }
        dp[i][j][free] = ans;
        return ans;
    }

    // 当前需要匹配的字符pick，去匹配e[j]
    // 使用next数组加速匹配，返回匹配出来的位置
    public static int jump(char pick, char[] e, int j) {
        while (j >= 0 && pick != e[j]) {
            j = next[j];
        }
        // 如果匹配不出来，返回-1
        // 否则返回匹配出来的位置
        return j;
    }
}
```

***

