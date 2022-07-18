
start:
		@echo "[+] Start All Container"
		docker-compose up -d --build

stop:
		@echo "[+] Stop All Container"
		docker-compose down
vacuum:
		@echo "[+] Clean logs, journalctl, apt"
		sudo apt-get autoclean
		sudo journalctl --vacuum-time=3d
		sudo truncate -s 0 /var/lib/docker/containers/*/*-json.log;
		sudo truncate -s 0 /var/log/**/*.log
wipe:
	@echo "[+] stop running container, delete all stopped containers, data, logs"
	docker stop $(docker ps -q) && cd /srv/ && docker system prune --all --force --volumes && truncate -s 0 /var/lib/docker/containers/*/*-json.log;

upgrade:
	@echo "[+] Upgrading control-agent"
	git submodule update --recursive --remote --merge && docker-compose down && docker system prune --all --force --volumes && docker-compose up -d --build