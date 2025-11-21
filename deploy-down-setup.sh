#!/bin/bash
# 自动生成一个示例脚本 setup.sh

set -e

App_Name="$1"
GitHub_User="$2"        # GitHub 用户名或组织名
GitHub_Repo_Name="$3"   # 仓库名
GitHub_Path="$4"        # 仓库子目录
GitHub_Repo_Branch="$5" # 分支名，例如 main 或 master

SCRIPT_NAME="andysetup.sh"

echo "👉 正在创建 $SCRIPT_NAME ..."

# 生成脚本时直接展开变量
cat >$SCRIPT_NAME <<EOF
#!/bin/bash
RAND_STR=\$(openssl rand -base64 12 | tr -dc 'a-zA-Z0-9' | cut -c1-16)
bash <(curl -sL i.hdyauto.top/deploy-down-install.sh?\$RAND_STR) $App_Name $GitHub_User $GitHub_Repo_Name $GitHub_Path $GitHub_Repo_Branch
EOF

# 添加执行权限
chmod +x $SCRIPT_NAME

echo "✅ 已生成并赋予执行权限，现在可以运行： ./$SCRIPT_NAME"
