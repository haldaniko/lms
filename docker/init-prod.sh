#!/bin/bash
set -e

SITE_NAME="${SITE_NAME:-lms.localhost}"

if [ -d "/home/frappe/frappe-bench/apps/frappe" ] && [ -f "/home/frappe/frappe-bench/sites/${SITE_NAME}/site_config.json" ]; then
    echo "Bench already exists, skipping init"
    cd /home/frappe/frappe-bench
    bench start
    exit 0
fi

if [ -d "/home/frappe/frappe-bench/apps/frappe" ]; then
    echo "Incomplete bench found, recreating it"
    rm -rf /home/frappe/frappe-bench
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

# Use the checked-out repository mounted from the host instead of cloning /workspace.
ln -s /workspace apps/lms
grep -qxF lms sites/apps.txt || printf '\nlms\n' >> sites/apps.txt
npm_config_ignore_scripts=true ./env/bin/python -m pip install -e apps/lms
bench build --app lms

bench new-site "${SITE_NAME}" \
--force \
--mariadb-root-password "${MYSQL_ROOT_PASSWORD:-123}" \
--admin-password "${ADMIN_PASSWORD:-admin}" \
--no-mariadb-socket

bench --site "${SITE_NAME}" install-app payments
bench --site "${SITE_NAME}" install-app lms
bench --site "${SITE_NAME}" execute frappe.db.set_value --args "['Language', 'bg', 'enabled', 1]"
bench --site "${SITE_NAME}" set-config developer_mode 0
bench --site "${SITE_NAME}" clear-cache
bench use "${SITE_NAME}"

bench start
