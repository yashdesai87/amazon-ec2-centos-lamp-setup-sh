# -------------- script for setup for AMI ID : ami-750f7645 ---------------

# ------------- setting up the epel repositories -------------------------

sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
sudo rpm -Uvh https://mirror.webtatic.com/yum/el6/latest.rpm

# ------------ installing mysql 5.5 -------------------------------------------

# first remove old mysql-libs
sudo yum remove mysql-libs -y
sudo yum install mysql55w mysql55w-server -y
sudo service mysqld start
sudo mysql_upgrade -u root

# ------------- install php 5.6 --------------------------------------------

sudo yum remove php* -y
sudo yum install php56w php56w-opcache php56w-cli php56w-common php56w-devel php56w-gd php56w-mbstring php56w-mcrypt php56w-mysql php56w-pear php56w-xml -y

# -------------- other configurations --------------------------------------------

# TODO change php settings error_reporting, display_errors, maxfile post size, max uploaded size

sudo rm -f /etc/httpd/conf.d/ganglia-web.conf

echo "Enter the domain you want to add (without www) : "
read domain

sudo sed -i 's/\#NameVirtualHost\s\*\:80/NameVirtualHost \*\:80/g' /etc/httpd/conf/httpd.conf

sudo mkdir /var/www/html/$domain

echo "

<VirtualHost *:80>
	DocumentRoot /var/www/html/$domain
	ServerName $domain
	ServerAlias www.$domain
	<Directory /var/www/html/$domain>
		AllowOverride All
		Options -Indexes
	</Directory>
</VirtualHost>" >> /etc/httpd/conf/httpd.conf

sudo service httpd start
sudo service mysqld start
sudo chkconfig httpd on
sudo chkconfig mysqld on

cd /var/www/html/$domain
wget https://files.phpmyadmin.net/phpMyAdmin/4.6.2/phpMyAdmin-4.6.2-english.tar.gz --no-check-certificate
tar zxvf phpMyAdmin-4.6.2-english.tar.gz
mv phpMyAdmin-4.6.2-english pma
rm phpMyAdmin-4.6.2-english.tar.gz