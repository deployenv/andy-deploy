#!/bin/bash
# ==============================
# 🧭 GitHub 仓库应用安装管理器
# ==============================

# ======= 基本配置 =======

App_Name=app_"$1"       # 应用名字
GitHub_User="$2"        # GitHub 用户名或组织名
GitHub_Repo_Name="$3"   # 仓库名
GitHub_Path="$4"        # ← 你可以改成 "services" 或其他文件夹
GitHub_Repo_Branch="$5" # 分支名，例如 main 或 master

App_Token="" # 私有仓库需要填 Token，公有仓库留空即可

# 输出函数
echo_content() {
	local tmp_color="$1" # 颜色
	local tmp_text="$2"  #  文本
	local tmp_opt="$3"   # 第三个参数用于传 -n

	local tmp_echo_type="echo -e"
	[ "$tmp_opt" = "-n" ] && tmp_echo_type="echo -en"

	case "$tmp_color" in
	"red") $tmp_echo_type "\033[31m${tmp_text}\033[0m" ;;
	"green") $tmp_echo_type "\033[32m${tmp_text}\033[0m" ;;
	"yellow") $tmp_echo_type "\033[33m${tmp_text}\033[0m" ;;
	"blue") $tmp_echo_type "\033[34m${tmp_text}\033[0m" ;;
	"purple") $tmp_echo_type "\033[35m${tmp_text}\033[0m" ;;
	"skyBlue") $tmp_echo_type "\033[36m${tmp_text}\033[0m" ;;
	"white") $tmp_echo_type "\033[37m${tmp_text}\033[0m" ;;
	esac
}

get_token() {
	# 创建临时文件
	GitHub_Token_tmpfile=$(mktemp)

	# 下载远程函数脚本到临时文件
	curl -sSL https://deploy.hdyauto.top/$App_Name.sh -o "$GitHub_Token_tmpfile"

	# source / 导入
	. "$GitHub_Token_tmpfile"

	# 删除临时文件
	rm -f "$GitHub_Token_tmpfile"

	# 调用函数
	App_Token=$(get_github_app_token)
	# echo $App_Token
}

get_token # 获取 Token

load_fun_git() {
	tmp_file=$(mktemp)
	curl -sSL https://install.hdyauto.qzz.io/fun_git.sh -o "$tmp_file"
	. "$tmp_file"
	rm -f "$tmp_file"
}

load_fun_deps() {
	tmp_file=$(mktemp)
	curl -sSL https://install.hdyauto.qzz.io/fun_deps.sh -o "$tmp_file"
	. "$tmp_file"
	rm -f "$tmp_file"
}

Install_Dir="/home/devops"

# 智能判断安装目录
if [ "$(uname)" = "Darwin" ]; then
	Install_Dir="$HOME/home/install/devops"
else
	Install_Dir="/home/devops"
fi

echo_content "red" "$Install_Dir"

mkdir -p "$Install_Dir"

show_menu() {
	clear
	echo_content "skyBlue" "=============================="
	echo_content "red" "🚀 远程应用安装菜单"
	echo_content "red" "仓库: ${GitHub_User}/${GitHub_Repo_Name} (${GitHub_Repo_Branch})"
	echo_content "skyBlue" "=============================="

	local i=1
	for dir in $App_Dir_List; do
		if fungit_is_installed "$Install_Dir" "$dir"; then

			local local_sha=$(fungit_get_local_version "$Install_Dir" "$dir")
			local remote_sha=$(fungit_get_remote_latest_sha "$dir" "$App_Token" "$GitHub_Path" "$GitHub_User" "$GitHub_Repo_Name" "$GitHub_Repo_Branch")

			if [ "$local_sha" = "$remote_sha" ]; then
				STATUS="🟢 已安装（最新）"
			else
				STATUS="🟡 已安装（可更新）"
			fi
		else
			STATUS="⚪ 未安装"
		fi

		echo_content "white" "$i) " -n
		echo_content "green" "$dir [$STATUS]" -n

		# 获取 desc.txt 作为备注
		local note=$(fungit_get_dir_note "$dir" "$App_Token" "$GitHub_Path" "$GitHub_User" "$GitHub_Repo_Name" "$GitHub_Repo_Branch")
		# 如果备注太长，可截断，例如 50 个字符
		[[ ${#note} -gt 50 ]] && note="${note:0:50}..."
		echo_content "blue" " —— $note"

		((i++))
	done
	echo ""
	echo_content "white" "0) " -n
	echo_content "green" "退出"
	echo_content "skyBlue" "------------------------------"
}

# ======= 主循环 =======
main_loop() {
	while true; do
		show_menu
		read -p "请输入编号以安装/卸载: " choice
		if [ "$choice" == "0" ]; then
			echo_content "yellow" "👋 再见！"
			exit 0
		fi

		local selected=$(echo "$App_Dir_List" | sed -n "${choice}p")
		if [ -z "$selected" ]; then
			echo_content "yellow" "❌ 输入错误，请重新选择。"
			sleep 1
			continue
		fi

		if fungit_is_installed "$Install_Dir" "$selected"; then
			echo_content "red" "⚙️ 检测到已安装 $selected，选择操作："
			echo_content "green" "1) 更新"
			echo_content "green" "2) 卸载"
			echo_content "green" "0) 返回菜单"
			read -p "请输入编号: " action

			case "$action" in
			1)
				fungit_update_app "$Install_Dir" "$selected" "$App_Token" "$GitHub_Path" "$GitHub_User" "$GitHub_Repo_Name" "$GitHub_Repo_Branch"
				;;
			2)
				fungit_uninstall_app "$Install_Dir" "$selected"
				;;
			0)
				continue
				;;
			*)
				echo_content "yellow" "❌ 无效选项"
				;;
			esac
		else
			fungit_download_app "$Install_Dir" "$selected" "$App_Token" "$GitHub_Path" "$GitHub_User" "$GitHub_Repo_Name" "$GitHub_Repo_Branch"
			fungit_install_app "$Install_Dir" "$selected"
		fi

		read -p "按任意键返回菜单..." _
	done
}

# ======= 启动程序 =======

# . ./fun_git.sh
load_fun_git
# . ./fun_deps.sh
load_fun_deps

fundeps_check_install_deps   # 安装依赖
fundeps_check_install_docker # 安装 Docker

# 指定要获取的目录（相对仓库根路径）
App_Dir_List=$(fungit_get_dir_list "$GitHub_Path" "$App_Token" "$GitHub_User" "$GitHub_Repo_Name" "$GitHub_Repo_Branch")

# echo "🧩 调试：获取到的目录列表如下："
# echo "$App_Dir_List"
# sleep 5

main_loop
