#!/bin/bash
# ==============================
# 🧭 GitHub 仓库应用安装管理器
# ==============================

# ======= 基本配置 =======

App_Name=app_"$1"          # 应用名字
GitHub_User="$2"           # GitHub 用户名或组织名
GitHub_Repo_Name="$3"      # 仓库名
GitHub_Path="$4"           # ← 你可以改成 "services" 或其他文件夹
GitHub_Repo_Branch="$5"    # 分支名，例如 main 或 master
App_Token=""               # 私有仓库需要填 Token，公有仓库留空即可
Install_Dir="/home/deploy" # 安装目录

get_token() {
	# 下载脚本内容到变量
	local script_content=$(curl -sSL https://andydeploy.hdyauto.top/$App_Name.sh)
	# 使用 eval 执行脚本内容（等同于 source）
	eval "$script_content"
	# 调用函数
	App_Token=$(get_github_app_token)
}

get_token # 获取 Token
# deploy() {
# 	# 下载脚本内容到变量
# 	local script_content=$(curl -sSL https://tool.hdyauto.qzz.io/github/deploy.sh)
# 	# 使用 eval 执行脚本内容（等同于 source）
# 	eval "$script_content" "$App_Name" "$GitHub_User" "$GitHub_Repo_Name" "$GitHub_Path" "$GitHub_Repo_Branch" "$App_Token" "$Install_Dir"
# 	# token=$(get_github_token "$APP_ID" "$INSTALLATION_ID" "$PRIVATE_KEY")

# 	# ./deploy.sh "$App_Name" "$GitHub_User" "$GitHub_Repo_Name" "$GitHub_Path" "$GitHub_Repo_Branch" "$App_Token" "$Install_Dir"
# }

deploy() {
    # 下载脚本到变量
    local script_content=$(curl -sSL https://tool.hdyauto.qzz.io/github/deploy.sh)

    # 写入临时文件
    local tmp_script=$(mktemp)
    echo "$script_content" > "$tmp_script"
    chmod +x "$tmp_script"

    # 正确传参
    "$tmp_script" "$App_Name" "$GitHub_User" "$GitHub_Repo_Name" "$GitHub_Path" "$GitHub_Repo_Branch" "$App_Token" "$Install_Dir"

    rm -f "$tmp_script"
}

deploy
