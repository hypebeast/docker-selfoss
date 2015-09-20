#!/bin/bash
set -e

CONFIG_FILE=/usr/share/nginx/html/config.ini

DOMAIN=${DOMAIN:=example.com}
DB_TYPE=${DB_TYPE:=sqlite}
DB_HOST=${DB_HOST:=}
DB_FILE=${DB_FILE:=data/sqlite/selfoss.db}
DB_DATABASE=${DB_DATABASE:=}
DB_USERNAME=${DB_USERNAME:=}
DB_PASSWORD=${DB_PASSWORD:=}
DB_PORT=${DB_PORT:=}
DB_TABLES_PREFIX=${DB_TABLES_PREFIX:=}

# Common config edit function
set_config() {
    key="$1"
    value="$2"

    sed -ri "s|\S*($key\s*=).*|\1 $value|g" $CONFIG_FILE
}

set_config 'db_type' "${DB_TYPE}"
set_config 'db_host' "${DB_HOST}"
set_config 'db_file' "${DB_FILE}"
set_config 'db_database' "${DB_DATABASE}"
set_config 'db_username' "${DB_USERNAME}"
set_config 'db_password' "${DB_PASSWORD}"
set_config 'db_port' "${DB_PORT}"
set_config 'db_prefix' "${DB_TABLES_PREFIX}"

# set the domain name
sed 's|{{DOMAIN}}|'"${DOMAIN}"'|' -i /etc/nginx/sites-available/default
sed 's|{{DOMAIN}}|'"${DOMAIN}"'|' -i /etc/cron.d/selfoss-cron
