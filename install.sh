#!/usr/bin/env bash
if [[ $1 == "" ]]
 then
 echo "No args with Control-Agent Metadata!"
 exit 0
fi
decrypted=$(echo "$1" | base64 --decode)
IFS=';' read control_agent_settings SOCKD_USER_NAME SOCKD_USER_PASSWORD <<< $decrypted

printf "CONTROL_AGENT_SETTINGS=$control_agent_settings\nSOCKD_USER_NAME=$SOCKD_USER_NAME\nSOCKD_USER_PASSWORD=$SOCKD_USER_PASSWORD\n" > .env

# https://docs.docker.com/engine/install/ubuntu/
sudo apt update \
    && sudo apt install --no-install-recommends --no-install-suggests -y apt-transport-https ca-certificates curl gnupg lsb-release \
    && apt autoremove --purge -y apache2 nginx

sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

sudo echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update && sudo apt install -y docker-ce docker-ce-cli containerd.io \
   && sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose \
   && sudo chmod +x /usr/local/bin/docker-compose

# create shared volume data directory for containers
sudo mkdir -p /srv/data/{nginx,letsencrypt} \
      &&  mkdir -p  /srv/data/nginx/{ssl,upstreams,conf.d} \
      && chmod -R 1000 /srv/data/

docker-compose up -d --build