#!/bin/bash

get_token() {
	app_name="$1" # App名字

	# 下载脚本内容到变量
	local script_content=$(curl -sSL https://devopsandy.hdyauto.qzz.io/app/$app_name.sh)
	# 使用 eval 执行脚本内容（等同于 source）
	eval "$script_content"

	# 调用函数
	echo $(get_github_app_token)
}

setup() {
	sh_name="$1"            # sh 名字
	gitHub_user="$2"        # GitHub 用户名或组织名
	gitHub_repo_name="$3"   # 仓库名
	gitHub_path="$4"        # 仓库子目录
	gitHub_repo_branch="$5" # 分支名，例如 main 或 master
	install_dir="$6"        # 安装目录
	setup_file_name="$7"    # "andy.sh"

	echo "👉 正在创建 $setup_file_name ..."

	# 生成脚本时直接展开变量
	cat >$setup_file_name <<EOF
#!/bin/bash
Rand_Str=\$(openssl rand -base64 12 | tr -dc 'a-zA-Z0-9' | cut -c1-16)
bash <(curl -sL devopsandy.hdyauto.qzz.io/menu/setup?\$Rand_Str) $sh_name $gitHub_user $gitHub_repo_name $gitHub_path $gitHub_repo_branch $install_dir
EOF

	# 添加执行权限
	chmod +x $setup_file_name

	echo "✅ 已生成并赋予执行权限，现在可以运行： ./$setup_file_name"

}

deploy() {

	app_name="$1"           # 应用名字
	gitHub_user="$2"        # GitHub 用户名或组织名
	gitHub_repo_name="$3"   # 仓库名
	gitHub_path="$4"        # ← 你可以改成 "services" 或其他文件夹
	gitHub_repo_branch="$5" # 分支名，例如 main 或 master
	install_dir="$6"        # 安装目录

	app_token="" # 私有仓库需要填 Token，公有仓库留空即可

	# 下载脚本到变量
	local script_content=$(curl -sSL https://tool.hdyauto.qzz.io/github/devops_menu.sh)

	# 写入临时文件
	local tmp_script=$(mktemp)
	echo "$script_content" >"$tmp_script"
	chmod +x "$tmp_script"

	app_token=$(get_token "$app_name") # 获取 GitHub App Token

	# 正确传参
	"$tmp_script" "$app_name" "$gitHub_user" "$gitHub_repo_name" "$gitHub_path" "$gitHub_repo_branch" "$app_token" "$install_dir"

	rm -f "$tmp_script"
}
