













wipe:
	@echo "[+] stop running container, delete all stopped containers, data, logs"
	docker-compose down && docker system prune --all --force --volumes && truncate -s 0 /var/lib/docker/containers/*/*-json.log;