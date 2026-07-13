#!/bin/bash

set -e

if [ -d "/home/frappe/frappe-bench/apps/frappe" ]; then
    echo "Bench already exists, skipping init"
    cd frappe-bench
    bench start
    exit 0
fi

echo "Creating new bench with local LMS app..."

export PATH="${NVM_DIR}/versions/node/v${NODE_VERSION_DEVELOP}/bin/:${PATH}"

bench init --skip-redis-config-generation frappe-bench

cd frappe-bench

# Use containers instead of localhost
bench set-mariadb-host mariadb
bench set-redis-cache-host redis://redis:6379
bench set-redis-queue-host redis://redis:6379
bench set-redis-socketio-host redis://redis:6379

# Remove redis and watch from Procfile because redis is provided by Docker.
sed -i '/redis/d' ./Procfile
sed -i '/watch/d' ./Procfile

bench get-app payments

# Use the checked-out repository mounted from the host instead of downloading LMS.
ln -s /workspace apps/lms
grep -qxF lms sites/apps.txt || printf '\nlms\n' >> sites/apps.txt
npm_config_ignore_scripts=true ./env/bin/python -m pip install -e apps/lms
sudo ln -s /home/frappe/frappe-bench/sites /sites
bench build --app lms

bench new-site lms.localhost \
--force \
--mariadb-root-password 123 \
--admin-password admin \
--no-mariadb-socket

bench --site lms.localhost install-app payments
bench --site lms.localhost install-app lms
bench --site lms.localhost execute frappe.db.set_value --args "['Language', 'bg', 'enabled', 1]"
bench --site lms.localhost set-config developer_mode 1
bench --site lms.localhost clear-cache
bench use lms.localhost

bench start
