#!/bin/sh
# ==================================================
# GitHub App 安装 Token 获取脚本（sh 兼容，无 jq）
# ==================================================

### ========== GitHub App 配置 ==========
APP_ID="2318802"
INSTALLATION_ID="95511862"

# 多行私钥，原样粘贴
read -r -d '' PRIVATE_KEY <<'EOF'
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAzWGGrNq4xWnlEGEgIhqnl/7XkCyRv+T2q4cIySIVE7cYBDg6
zue70ykuClbv6xquvlsuLrmBgTcK/BhqnW0VcJlln8GpwyUddH3yoDD/XNZFUUfM
a3pTUy/JhxxTllEuBGeROnd/7keghruHwvo2c1KTLTaibVsFsOw9UMgtcyBd+q/7
vxNJXgDAkEa+jMUSgnwBdGa4WE5qDEpYK3y+2X/VjXv6GECzh8LtUM694L5rLe3P
r1f3imYXCBUYnOfNQwO09+rcIlx1vTTWzo8xiG+Z7I6Wse2ClJrdTQxLSfXigBeD
zACR4yWwLdtwU1S3GW09XwDf3xPh3P33ZMe9sQIDAQABAoIBABZg6xDIoFt6Z2g6
fQraRqqsLQbbpGH5a9tS0mVAHnXQfIBxNA85duDSWt7rjCbc+G9rdgPHWNIgkkTX
0D4pFa34OPeIXZwS3jvEQXys+hY+jr0FisOnR48H5Pig4Ia/f7khI9TwEnN/QIGN
y4Q2SVqVg83oZxhtU5hslV3JAhLKIRTAdI4JjZs5ykVfheoXDIdJddjVIVwP9v57
i+qGJd1mVTZiJqJju0ayKJ9cpOq4gjIMAoReADu7UlIdQ+xebc+EvY2UeIjnPViY
mcyL3slT2Z+dptMoL225GXfByAI1y9BlOdYueHVvtpJVomSTwtR+Stuowv0I5ch0
ITKMWUECgYEA7J1cJTEqyuFSVS9FvxMgflmzSMxI5spZt+OFUoB/tdXXVv//9G/n
bQRnTLF0qJ4Ynl2XthWM7ZmfIT040afpkXhObwGhd6fQIwkeHOHxtVebDVbncpE3
7gkp7j9/TLYQyjAlZV0g5a3FNALIs10QPZtZCIrzBKiKRv8L5HPu45kCgYEA3jUV
1/h7/bA3621FkUCboU3RGvHuWOD4oyh/0ZOKaTbYC2EErdffL0R2bmotgylJdIhq
TH5HMwiPrbg70HPHjpHd/tyCmpkHNKG8Xy8zAC5MSaMfU/5UVf2si1xyOTEQuQSW
zWYmvSsnV0cQau5gBzIcHdCXIs+5ywABbhTR+dkCgYEAoHMg3hOWOhdLNnqk6Co3
OZboLXBh6ybCaiE98jEy6QJGUTetwHr1ywZWajpXqlPyy8kZrJ62fxRSRT73vawI
hd24Cixn6vT//hIbumg4+MicWxJYRmdVLvRF28pxL3qyrfiyEydwvG72sAtHP+HW
toAWguV+X+VOR1CCJvu6vdkCgYAr71cYUrtBV7xWwk5E//9Fj3tO1pMH48OFjxZm
u8NcNknVRiOEs/AfCmxYPIovKtSpQ+ewpC8zufeeo5TADIRifhjksXjpVGSGVYxH
Ta/J012mGaiyFNFcB0I8c9Tp1fe2fV/L0OzL7mJi8VwfqG44PgItKvcXHPdhWeju
eRNjUQKBgQC8W3P3xN23POr4FCuzc4mmzWhY78HiS0tFxXZz9Yl7VZ3g+IT4q7hI
l94OXb+QXEKs2hOBzT1pD56qzHXyJWemcrrUUS1R18kepH1UIwUhjSaUcPr7p/qK
Q/l4Yg7kBov0WDGLROe1o12gG7n6nXU30UJktIJJ5ma7asJY3gAJeA==
-----END RSA PRIVATE KEY-----
EOF

### =================================================
### 函数：自动获取 Installation Token
### =================================================
get_github_app_token() {
	# --- 生成 JWT ---
	iat=$(date +%s)
	exp=$(($iat + 540))

	header='{"alg":"RS256","typ":"JWT"}'
	payload="{\"iat\":$iat,\"exp\":$exp,\"iss\":\"$APP_ID\"}"

	# Base64 URL safe
	b64() {
		openssl base64 -e | tr -d '\n=' | tr '/+' '_-'
	}

	header_b64=$(printf "%s" "$header" | b64)
	payload_b64=$(printf "%s" "$payload" | b64)
	unsigned="${header_b64}.${payload_b64}"

	# 临时写私钥
	tmpkey=$(mktemp)
	printf "%s" "$PRIVATE_KEY" >"$tmpkey"

	# 签名
	signature=$(printf "%s" "$unsigned" | openssl dgst -sha256 -sign "$tmpkey" | b64)
	rm -f "$tmpkey"

	jwt="${unsigned}.${signature}"

	# --- 获取 Installation Token ---
	resp=$(curl -sX POST \
		-H "Authorization: Bearer $jwt" \
		-H "Accept: application/vnd.github+json" \
		https://api.github.com/app/installations/$INSTALLATION_ID/access_tokens)

	# --- 解析 token（无 jq 版） ---
	# 从 JSON 中提取 "token":"xxxx"
	token=$(echo "$resp" | sed -n 's/.*"token":[ ]*"\([^"]*\)".*/\1/p')

	# 如果找不到 token，返回空
	if [ -z "$token" ]; then
		echo ""
	else
		echo "$token"
	fi
}
