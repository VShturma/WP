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

yum -y update
yum install -y httpd mariadb amazon-efs-utils
amazon-linux-extras install -y php7.2
systemctl start httpd
systemctl enable httpd
#mkdir /var/www/html/blog
#mount -t efs fs.wp.local:/ /var/www/html
mount -t efs $FS_PATH:/ $WP_PATH
usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;
#num=$( grep -m1 -ao '[0-9]' /dev/urandom | sed s/0/10/ | head -n1 )
#echo -e '<html xmlns="http://www.w3.org/1999/xhtml" >\n<head>\n\t<title>My Website Home Page</title>\n</head>\n<body>\n\t<h1>Welcome to my website</h1>\n\t<p>NODE '$num'</p>\n</body>\n</html>\n' > /var/www/html/index.html

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp
cd $WP_PATH

wp core download
wp core config --dbname=$WP_DB_NAME --dbuser=$WP_DB_USERNAME --dbpass=$MYSQL_ROOT_PASSWORD --dbhost=$MYSQL_HOST
wp core install --url=$WP_DOMAIN --title=$WP_TITLE --admin_user=$WP_ADMIN_USERNAME --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL

