#!/bin/bash

Sh_Name=andydeployapp           # sh 名字
GitHub_User=andy-deploy         # GitHub 用户名或组织名
GitHub_Repo_Name=deploy-desktop # 仓库名
GitHub_Path=docker              # 仓库子目录
GitHub_Repo_Branch=main         # 分支名，例如 main 或 master
Install_Dir=/home/deploy        # 安装名字

# ======= 安装目录处理 =======
# 如果 Install_Dir 是绝对路径且不可写，改成用户目录
if [[ "$Install_Dir" == /* ]]; then
	# 如果无法写入根目录
	if [ ! -w "$Install_Dir" ]; then
		Install_Dir="$HOME/$(basename "$Install_Dir")"
	fi
else
	Install_Dir="$HOME/$Install_Dir"
fi

# --------------- 远程测试调用 --------------- #
remote_deploy() {

	Rand_Str=$(openssl rand -base64 12 | tr -dc 'a-zA-Z0-9' | cut -c1-16)
	# 下载脚本到变量
	local script_content=$(curl -sSL andydeploy.hdyauto.top/deploy/fun_deploy.sh?$Rand_Str)

	# 写入临时文件
	local tmp_script=$(mktemp)
	echo "$script_content" >"$tmp_script"
	chmod +x "$tmp_script"

	# # 正确传参
	# "$tmp_script" "$Sh_Name" "$GitHub_User" "$GitHub_Repo_Name" "$GitHub_Path" "$GitHub_Repo_Branch" "$Install_Dir"

	# -----------------------------
	# 方式 1：source 后调用函数
	# -----------------------------
	# 导入脚本到当前 shell
	source "$tmp_script"

	# 假设远程脚本里定义了函数叫 my_setup_function
	# 现在就可以直接调用：
	if declare -f deploy >/dev/null 2>&1; then
		deploy "$Sh_Name" "$GitHub_User" "$GitHub_Repo_Name" "$GitHub_Path" "$GitHub_Repo_Branch" "$Install_Dir"
	else
		echo "❌ 远程脚本中没有定义 deploy"
	fi

	rm -f "$tmp_script"

}
remote_deploy

# --------------- 			 --------------- #

# # --------------- 本地测试调用 --------------- #
# local_deploy() {

# 	# 导入脚本到当前 shell
# 	source ./fun_deploy.sh

# 	# 假设远程脚本里定义了函数叫 deploy
# 	# 现在就可以直接调用：
# 	if declare -f deploy >/dev/null 2>&1; then
# 		deploy "$Sh_Name" "$GitHub_User" "$GitHub_Repo_Name" "$GitHub_Path" "$GitHub_Repo_Branch" "$Install_Dir"
# 	else
# 		echo "❌ 远程脚本中没有定义 deploy"
# 	fi
# }

# local_deploy

# --------------- 			 --------------- #
