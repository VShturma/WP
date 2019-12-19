#! /bin/bash

MYSQL_HOST="${mysql_host}"
MYSQL_ROOT_PASSWORD="${mysql_root_password}"
WP_DB_USERNAME="${wp_db_username}"
WP_DB_NAME="${wp_db_name}"
WP_PATH="${wp_path}"
WP_DOMAIN="${wp_domain}"
WP_TITLE="${wp_title}"
WP_ADMIN_USERNAME="${wp_admin_username}"
WP_ADMIN_EMAIL="${wp_admin_email}"
WP_ADMIN_PASSWORD="${wp_admin_password}"
FS_PATH="${fs_path}"
INSTANCE_NAME="wordpress"

yum -y update
yum install -y amazon-efs-utils
amazon-linux-extras install -y docker=18.06.1
usermod -a -G docker ec2-user
systemctl enable --now docker

mount -t efs $FS_PATH:/ $WP_PATH

docker run --name $INSTANCE_NAME -p 80:80 -v $WP_PATH:/var/www/html -e WORDPRESS_DB_HOST="$MYSQL_HOST" -e WORDPRESS_DB_USER="$WP_DB_USERNAME" -e WORDPRESS_DB_PASSWORD="$MYSQL_ROOT_PASSWORD" -e WORDPRESS_DB_NAME="$WP_DB_NAME" -d wordpress:5.2.2-php7.1-apache

docker run --rm --volumes-from $INSTANCE_NAME wordpress:cli wp core install --url="$WP_DOMAIN" --title="$WP_TITLE" --admin_user="$WP_ADMIN_USERNAME" --admin_password="$WP_ADMIN_PASSWORD" --admin_email="$WP_ADMIN_EMAIL"

docker rmi wordpress:cli

