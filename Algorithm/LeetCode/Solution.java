class Solution {
    public int numIslands(char[][] grid) {
        int n=grid.length;
        int m=grid[0].length;
        int count=0;
        for(int i=0;i<n;i++){
            for(int j=0;j<m;j++){
                if(grid[i][j]=='1'){
                    count++;
                    dfs(grid,n,m,i,j);
                }
            }
        }
        return count;
    }

    public static void dfs(char[][] s,int n,int m,int i,int j){
        if(i<0||i==n||j<0||j==m||s[i][j]!='1'){
            return;
        }
        s[i][j]='2';
        dfs(s,n,m,i-1,j);
        dfs(s,n,m,i+1,j);
        dfs(s,n,m,i,j-1);
        dfs(s,n,m,i,j+1);
    }
}