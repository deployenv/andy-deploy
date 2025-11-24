#!/bin/bash

###################################################

Sh_Name="$1"            # sh 名字
GitHub_User="$2"        # GitHub 用户名或组织名
GitHub_Repo_Name="$3"   # 仓库名
GitHub_Path="$4"        # 仓库子目录
GitHub_Repo_Branch="$5" # 分支名，例如 main 或 master

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

# ------------------ 数组定义菜单项 ------------------
Memu_Items=(
	"退出"
	"部署"
	"Docker工具"
)

Rand_Str=$(openssl rand -base64 12 | tr -dc 'a-zA-Z0-9' | cut -c1-16)

# 每个编号对应一个函数（index 对齐 MENU_ITEMS）
Mennu_Actions=(
	"exit 0"
	"bash <(curl -sL andydeploy.hdyauto.top/deploy.sh?$Rand_Str) $Sh_Name $GitHub_User $GitHub_Repo_Name $GitHub_Path $GitHub_Repo_Branch"
	"bash <(curl -sL tool.hdyauto.qzz.io/fun_docker.sh) linux_docker"
)

main() {

	# ------------------ 主循环 ------------------
	while true; do
		clear
		echo_content "skyBlue" "============================"
		echo_content "red" "🚀 安装选择"
		echo_content "red" "仓库: andy-deploy/deploy-gitlab (main)"
		echo_content "skyBlue" "============================"
		for i in "${!Memu_Items[@]}"; do
			((i == 0)) && continue
			echo_content "white" " $((i))) " -n
			echo_content "green" "${Memu_Items[$i]}"
		done
		echo ""
		echo_content "white" " 0) " -n
		echo_content "green" "${Memu_Items[0]}"
		echo_content "skyBlue" "============================"
		echo_content "skyBlue" "请选择操作: " -n
		read -r choice

		# 转为下标（减 1）
		if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 0 ] && [ "$choice" -le "${#Memu_Items[@]}" ]; then
			index=$((choice))
			echo_content "skyBlue" ">> 执行: ${Memu_Items[$index]}"
			eval "${Mennu_Actions[$index]}"
		else
			echo_content "skyBlue" "无效选择。"
		fi

		echo_content "yellow" "按任意键继续..." -n
		read -n 1 -s -r
		echo # 输入后换行（可选）
	done
}

# ======= 启动程序 =======
main
