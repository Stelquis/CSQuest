class Solution {

    public static int ans;

    public int maxPathSum(TreeNode root) {
        if(root==null)return 0;
        if(root.left==null&&root.right==null)return root.val;
        ans=Integer.MIN_VALUE;
        dfs(root);
        return ans;
    }

    public static int dfs(TreeNode root){
        if(root==null)return 0;
        int l=dfs(root.left);
        int r=dfs(root.right);
        ans=Math.max(ans,l+r+root.val);
        return Math.max(0,Math.max(l,r)+root.val);
    }
}

class TreeNode {
    int val;
    TreeNode left;
    TreeNode right;
    TreeNode() {}
    TreeNode(int val) { this.val = val; }
    TreeNode(int val, TreeNode left, TreeNode right) {
        this.val = val;
        this.left = left;
        this.right = right;
    }
}
