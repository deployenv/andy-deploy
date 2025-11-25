#!/bin/bash

get_token() {
	# 下载脚本内容到变量
	local script_content=$(curl -sSL https://andydeploy.hdyauto.top/app/$App_Name.sh)
	# 使用 eval 执行脚本内容（等同于 source）
	eval "$script_content"
	# 调用函数
	# App_Token=$(get_github_app_token)
	echo $(get_github_app_token)
}

setup() {
	Sh_Name="$1"            # sh 名字
	GitHub_User="$2"        # GitHub 用户名或组织名
	GitHub_Repo_Name="$3"   # 仓库名
	GitHub_Path="$4"        # 仓库子目录
	GitHub_Repo_Branch="$5" # 分支名，例如 main 或 master
	Setup_Name="$6"         # "andy.sh"

	echo "👉 正在创建 $Setup_Name ..."

	# 生成脚本时直接展开变量
	cat >$Setup_Name <<EOF
#!/bin/bash
Rand_Str=\$(openssl rand -base64 12 | tr -dc 'a-zA-Z0-9' | cut -c1-16)
bash <(curl -sL andydeploy.hdyauto.top/setup-menu.sh?\$Rand_Str) $Sh_Name $GitHub_User $GitHub_Repo_Name $GitHub_Path $GitHub_Repo_Branch
EOF

	# 添加执行权限
	chmod +x $Setup_Name

	echo "✅ 已生成并赋予执行权限，现在可以运行： ./$Setup_Name"

}

deploy() {

	App_Name="$1"           # 应用名字
	GitHub_User="$2"        # GitHub 用户名或组织名
	GitHub_Repo_Name="$3"   # 仓库名
	GitHub_Path="$4"        # ← 你可以改成 "services" 或其他文件夹
	GitHub_Repo_Branch="$5" # 分支名，例如 main 或 master
	Install_Dir="$6"        # 安装目录

	App_Token="" # 私有仓库需要填 Token，公有仓库留空即可

	# 下载脚本到变量
	local script_content=$(curl -sSL https://tool.hdyauto.qzz.io/github/deploy_menu.sh)

	# 写入临时文件
	local tmp_script=$(mktemp)
	echo "$script_content" >"$tmp_script"
	chmod +x "$tmp_script"

	App_Token=$(get_github_app_token)

	# 正确传参
	"$tmp_script" "$App_Name" "$GitHub_User" "$GitHub_Repo_Name" "$GitHub_Path" "$GitHub_Repo_Branch" "$App_Token" "$Install_Dir"

	rm -f "$tmp_script"
}
