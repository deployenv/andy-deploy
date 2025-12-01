#!/bin/bash

# sh_name=andydevopsapp   # sh 名字
# github_user=andy-devops # GitHub 用户名或组织名

load_fun_common() {
	tmp_file=$(mktemp)
	curl -sSL https://tool.hdyauto.qzz.io/common/common?$(openssl rand -base64 12 | tr -dc 'a-zA-Z0-9' | cut -c1-16) -o "$tmp_file"
	. "$tmp_file"
	rm -f "$tmp_file"
}

load_fun_common

# --------------- 远程部署调用 --------------- #
remote_deploy() {
	sh_name="$1"   # sh 名字
	github_user="$2" # GitHub 用户名或组织名	
	github_repo_name="$3"   # 仓库名
	github_repo_branch="$4" # 分支名，例如 main 或 master
	github_path="$5"        # 仓库子目录
	install_dir="$6"        # 安装目录
	echo "最终安装目录是：$install_dir"

	# 下载脚本到变量
	local script_content=$(curl -sSL tool.hdyauto.qzz.io/common/fun_devops.sh?$(openssl rand -base64 12 | tr -dc 'a-zA-Z0-9' | cut -c1-16))

	# 写入临时文件
	local tmp_script=$(mktemp)
	echo "$script_content" >"$tmp_script"
	chmod +x "$tmp_script"

	# 导入脚本到当前 shell
	source "$tmp_script"

	if declare -f deploy >/dev/null 2>&1; then
		deploy "$sh_name" "$github_user" "$github_repo_name" "$github_path" "$github_repo_branch" "$install_dir"
	else
		echo "❌ 远程脚本中没有定义 deploy"
	fi

	rm -f "$tmp_script"

}

# --------------- 本地部署测试调用 --------------- #
local_deploy() {
	sh_name="$1"   # sh 名字
	github_user="$2" # GitHub 用户名或组织名	
	github_repo_name="$3"   # 仓库名
	github_repo_branch="$4" # 分支名，例如 main 或 master
	github_path="$5"        # 仓库子目录
	install_dir="$6"        # 安装目录
	echo "最终安装目录是：$install_dir"

	# 导入脚本到当前 shell
	source ../devopstool/common/fun_devops.sh

	# 假设远程脚本里定义了函数叫 deploy
	# 现在就可以直接调用：
	if declare -f deploy >/dev/null 2>&1; then
		deploy "$sh_name" "$github_user" "$github_repo_name" "$github_path" "$github_repo_branch" "$install_dir"
	else
		echo "❌ 远程脚本中没有定义 deploy"
	fi
}
# --------------- 			 --------------- #

# --------------- 远程安装调用 --------------- #
remote_setup() {
	sh_name="$1"   # sh 名字
	github_user="$2" # GitHub 用户名或组织名	
	github_repo_name="$3"   # 仓库名
	github_repo_branch="$4" # 分支名，例如 main 或 master
	github_path="$5"        # 仓库子目录
	install_dir="$6"        # 安装目录
	setup_name="$7"         # 安装名字
	setup_url="$8"          # 安装地址
	echo "最终安装目录是：$install_dir"

	# 下载脚本到变量
	local script_content=$(curl -sSL https://tool.hdyauto.qzz.io/common/fun_devops.sh?$(openssl rand -base64 12 | tr -dc 'a-zA-Z0-9' | cut -c1-16))

	# 写入临时文件
	local tmp_script=$(mktemp)
	echo "$script_content" >"$tmp_script"
	chmod +x "$tmp_script"

	# 导入脚本到当前 shell
	source "$tmp_script"

	if declare -f setup >/dev/null 2>&1; then
		setup "$Sh_Name" "$GitHub_User" "$GitHub_Repo_Name" "$GitHub_Path" "$GitHub_Repo_Branch" "$Install_Dir" "$setup_name" "$setup_url"
	else
		echo "❌ 远程脚本中没有定义 setup"
	fi

	rm -f "$tmp_script"

}

# --------------- 本地安装测试调用 --------------- #
local_setup() {
	sh_name="$1"   # sh 名字
	github_user="$2" # GitHub 用户名或组织名	
	github_repo_name="$3"   # 仓库名
	github_repo_branch="$4" # 分支名，例如 main 或 master
	github_path="$5"        # 仓库子目录
	install_dir="$6"        # 安装目录
	setup_name="$7"         # 安装名字
	setup_url="$8"          # 安装地址
	echo "最终安装目录是：$install_dir"

	# 导入脚本到当前 shell
	source ../devopstool/common/fun_devops.sh

	if declare -f setup >/dev/null 2>&1; then
		setup "$Sh_Name" "$GitHub_User" "$GitHub_Repo_Name" "$GitHub_Path" "$GitHub_Repo_Branch" "$Install_Dir" "$setup_name" "$setup_url"
	else
		echo "❌ 远程脚本中没有定义 setup"
	fi

}

#--------------- 			 --------------- #

devops_desktop() {
	echo "开始部署 DevOps 桌面版..."
	sh_name=andydevopsapp   # sh 名字
	github_user=andy-devops # GitHub 用户名或组织名
	github_repo_name=devops-desktop                      # 仓库名
	github_repo_branch=main                              # 分支名，例如 main 或 master
	github_path=pod                                      # 仓库子目录
	install_dir=$(prepare_install_dir "/home/wkdesktop") # 安装目录

	# remote_deploy "$sh_name" "$github_user" "$github_repo_name" "$github_repo_branch" "$github_path" "$install_dir"
	local_deploy "$sh_name" "$github_user" "$github_repo_name" "$github_repo_branch" "$github_path" "$install_dir"
}

setup_desktop() {
	sh_name=andydevopsapp   # sh 名字
	github_user=andy-devops # GitHub 用户名或组织名
	github_repo_name=devops-desktop                      # 仓库名
	github_path=pod                                      # 仓库子目录
	github_repo_branch=main                              # 分支名，例如 main 或 master
	install_dir=$(prepare_install_dir "/home/wkdesktop") # 安装目录
	setup_file_name="andy.sh"                            # 安装文件名
	setup_url="devopsandy.hdyauto.qzz.io/setup"

	remote_setup "$sh_name" "$github_user" "$github_repo_name" "$github_repo_branch" "$github_path" "$install_dir" "$setup_file_name" "$setup_url"
	# local_setup "$sh_name" "$github_user" "$github_repo_name" "$github_repo_branch" "$github_path" "$install_dir" "$setup_file_name" "$setup_url"
}

devops_gitlab() {
	sh_name=andydevopsapp   # sh 名字
	github_user=andy-devops # GitHub 用户名或组织名
	github_repo_name=devops-gitlab                      # 仓库名
	github_repo_branch=main                             # 分支名，例如 main 或 master
	github_path=pod                                     # 仓库子目录
	install_dir=$(prepare_install_dir "/home/wkgitlab") # 安装目录

	remote_deploy "$sh_name" "$github_user" "$github_repo_name" "$github_repo_branch" "$github_path" "$install_dir"
	# local_deploy "$sh_name" "$github_user" "$github_repo_name" "$github_repo_branch" "$github_path" "$install_dir"
}

setup_gitlab() {
	sh_name=andydevopsapp   # sh 名字
	github_user=andy-devops # GitHub 用户名或组织名
	github_repo_name=devops-gitlab                      # 仓库名
	github_path=pod                                     # 仓库子目录
	github_repo_branch=main                             # 分支名，例如 main 或 master
	install_dir=$(prepare_install_dir "/home/wkgitlab") # 安装目录
	setup_file_name="andy.sh"                           # 安装文件名
	setup_url="devopsandy.hdyauto.qzz.io/setup"

	remote_setup "$sh_name" "$github_user" "$github_repo_name" "$github_repo_branch" "$github_path" "$install_dir" "$setup_file_name" "$setup_url"
	# local_setup "$sh_name" "$github_user" "$github_repo_name" "$github_repo_branch" "$github_path" "$install_dir" "$setup_file_name" "$setup_url"	
}
