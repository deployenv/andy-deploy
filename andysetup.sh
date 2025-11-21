#!/bin/bash
RAND_STR=$(openssl rand -base64 12 | tr -dc 'a-zA-Z0-9' | cut -c1-16)
bash <(curl -sL i.hdyauto.top/deploy.sh?$RAND_STR) andydeployapp andy-deploy deploy-gitlab docker main
