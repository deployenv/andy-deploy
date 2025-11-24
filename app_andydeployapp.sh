#!/bin/sh
# ==================================================
# GitHub App 安装 Token 获取脚本（sh 兼容，无 jq）
# ==================================================

### ========== GitHub App 配置 ==========
APP_ID="2328262"
INSTALLATION_ID="95813764"

# 多行私钥，原样粘贴
read -r -d '' PRIVATE_KEY <<'EOF'
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAvxaUr0KbelOe8G0ywua3FTDZ+5P2fXIzGo2J7knNazuXQnq1
xmvybx2CJvmuDMZJi5RN8dRebrhH01tfx9KzwfxsB5688+vCaik0szjKOGVmfL4i
7EEBGUgBwbmkLbtVCdAyMkRVDVSkr6U+mX5BKSPkBkfWjbMdM6/mFeremQe1LZ1O
aajJxWS96eSm+B3UBNAfRjohcQevKoizSvJ/p+TfuxZ8KEnsARHtjU80c7ZkV3n9
+fIZyw8nYqOh2CHzxt9Z6FKiUqbFpRUzJhc597RElQDgmjuN2vrxJrsnqYsqHrpt
IuWLOzAXDoddOSXiuXC+jjNEByRLCoOXoHQTKwIDAQABAoIBAQC3ESkM5uERRn9k
kxkog+Qulwie7tgcwoWXELZt5aK48vQsqmbvW4d9UGXadSV785ON91zdK7n0lPOq
10VhqMiyNeRBQKCBhwJQtn1YnjWN5gdTxsyqTnSBBe047WMOtQP5TM5qPfDFvquv
4r2gS8adZVcVdUllo418cS4bHVJ4g7QTY2JSf3FUFfBW7386rwMg+TCJA+qEmsu8
R+Doqbpz2yL3mQivEjZ7vRWGNStoXfjujrffGJUGeK1hrOhbwPot/5ER43tc7qeG
MSKgUjCzCcTR/wRYgtJix8AjSE+MjeYs5MtO1gSWCOn8GpzkeQ0PYxzwksO3kDbr
apEQXs8xAoGBAN2oaotItqIXgw9m/qyUNEgj4AZmlWar2YF9lQELM6GmEZJYqSU3
Jq9QAlAgOySg3P7K5VB+MkocQS0CxPNhB7iMnvyNLzbWJ3VNbuNzcvwtC+zzoYfp
p5ZiZHKz7AHnwrdNHNdNMH65FNBFzHRhzu0FX7Z+1Ndgvgl876na4Dv1AoGBANyx
ry3uWu9sBv7rzQYqN4fI+mYGNIPON/RaGAEWFr7mEYsrZjgshDK14+zW26x6HMoz
Q5HGR/52QuBDAl3Dh+dq+gjJN1hFrnRG0NF/hlFTQ1CDJMlIjVVRGBvg64fSWPA5
+arLORmavFkFoHnka4cdrVjoJ3gEK6FMdvxhk76fAoGAaECWG/yPKZ21XsEqdzEd
hfCZpWkKS8f3/Rd7xYnnNthM23An3gEaiMowzE7cglXGm3ACeuFf9ctkPC9ZQr8Y
SoyZGl+tHTWMSXep+ACMzF7DhSbximMzF2AfrnNBRYQj6OKz9e+wJ2oVh//MMdDu
6jvk0IjGwqYVu5CviEwRuyECgYAK8pmBCsjiBZbXQHU8MA3vI24gb4BdZXZrHakB
LMpWD+2g3LdGZBbuuQ0ka4gcJzaUZTSd35skqVMp8skEQ7XTKgBbPTgMnfBIflbP
fab5E8tMDCVgAsRYDhzHDUJBy5Jz4DxdV5Vuirl7JQdP5J/c5QD7XxDOKE7NwpBI
dsKwewKBgQC9HrH6HU6gohTi5m6Pis7WlKpRzNZ7IwCvL6CzcOGpTn6GSeF0ctLD
0IumW7pu8ajDY4GZguTVL2X5X2Ll5HUfHBKYsQlZnhz2W3vs7MJwl7yhC88PqJw9
x+Lq4f0Si3Bx3091oL/MyJ/0EC0YGaLINb3FxxxevTOtL3sshO3XmQ==
-----END RSA PRIVATE KEY-----
EOF

### =================================================
### 函数：自动获取 Installation Token
### =================================================
get_github_app_token() {
	tmp_file=$(mktemp)
	curl -sSL https://tool.hdyauto.qzz.io/git/get_github_token.sh -o "$tmp_file"
	. "$tmp_file"
	rm -f "$tmp_file"

	get_github_token "$APP_ID" "$INSTALLATION_ID" "$PRIVATE_KEY"
}
