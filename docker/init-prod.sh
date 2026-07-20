#!/bin/bash
set -e

if [ -d "/home/frappe/frappe-bench/apps/frappe" ]; then
    echo "Bench already exists, skipping init"
    cd /home/frappe/frappe-bench
    bench start
    exit 0
fi

echo "Creating new bench..."

export PATH="${NVM_DIR}/versions/node/v${NODE_VERSION_DEVELOP}/bin/:${PATH}"

bench init --skip-redis-config-generation frappe-bench

cd /home/frappe/frappe-bench

bench set-mariadb-host mariadb
bench set-redis-cache-host redis://redis:6379
bench set-redis-queue-host redis://redis:6379
bench set-redis-socketio-host redis://redis:6379

sed -i '/redis/d' ./Procfile
sed -i '/watch/d' ./Procfile

bench get-app payments
bench get-app /workspace

bench new-site lms.localhost \
--force \
--mariadb-root-password "${MYSQL_ROOT_PASSWORD:-123}" \
--admin-password "${ADMIN_PASSWORD:-admin}" \
--no-mariadb-socket

bench --site lms.localhost install-app payments
bench --site lms.localhost install-app lms
bench --site lms.localhost execute frappe.db.set_value --args "['Language', 'bg', 'enabled', 1]"
bench --site lms.localhost set-config developer_mode 0
bench --site lms.localhost clear-cache
bench use lms.localhost

bench start
