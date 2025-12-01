#!/bin/bash

# 导入函数
. ./andydevopsapp

# 获取 token
token=$(get_github_app_token)
echo "Token: $token"
