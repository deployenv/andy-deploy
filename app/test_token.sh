#!/bin/sh

# 导入函数
. ./andydeployapp.sh

# 获取 token
token=$(get_github_app_token)
echo "Token: $token"
