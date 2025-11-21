#!/bin/sh

# 导入函数
. ./app_andydeployapp.sh

# 获取 token
token=$(get_github_app_token)
echo "Token: $token"

# 使用 token 调 API
# curl -H "Authorization: token $token" https://api.github.com/installation/repositories
