#!/bin/bash

Sh_Name=andydevopsapp           # sh 名字
GitHub_User=andy-devops         # GitHub 用户名或组织名
GitHub_Repo_Name=devops-desktop # 仓库名
GitHub_Path=pod                 # 仓库子目录
GitHub_Repo_Branch=main         # 分支名，例如 main 或 master

load_fun_common() {
	tmp_file=$(mktemp)
	curl -sSL https://tool.hdyauto.qzz.io/common/common?$(openssl rand -base64 12 | tr -dc 'a-zA-Z0-9' | cut -c1-16) -o "$tmp_file"
	. "$tmp_file"
	rm -f "$tmp_file"
}

load_fun_common

# . ../../devopstool/common/common

Install_Dir=$(prepare_install_dir "/home/wkdesktop") # 安装目录

echo "最终安装目录是：$Install_Dir"

# --------------- 远程测试调用 --------------- #
remote_deploy() {

	Rand_Str=$(openssl rand -base64 12 | tr -dc 'a-zA-Z0-9' | cut -c1-16)
	# 下载脚本到变量
	local script_content=$(curl -sSL devopsandy.hdyauto.qzz.io/devops/fun_devops.sh?$Rand_Str)

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
# remote_deploy

# --------------- 			 --------------- #

# # --------------- 本地测试调用 --------------- #
# local_deploy() {

# 	# 导入脚本到当前 shell
# 	source ./fun_devops.sh

# 	# 假设远程脚本里定义了函数叫 deploy
# 	# 现在就可以直接调用：
# 	if declare -f deploy >/dev/null 2>&1; then
# 		deploy "$Sh_Name" "$GitHub_User" "$GitHub_Repo_Name" "$GitHub_Path" "$GitHub_Repo_Branch" "$Install_Dir"
# 	else
# 		echo "❌ 远程脚本中没有定义 deploy"
# 	fi
# }

# local_deploy

# # --------------- 			 --------------- #
