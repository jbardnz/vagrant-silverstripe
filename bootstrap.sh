
# Updating packages
sudo apt-get update

# Installing Packages
sudo apt-get install -y apache2


# Add ServerName to httpd.conf
#echo -e "ServerName localhost" | sudo tee -a /etc/apache2/httpd.conf

#delete current config
##sudo rm /etc/apache2/sites-enabled/000-default.conf

# Setup hosts file
#VHOST='<VirtualHost *:80>
#  DocumentRoot "/var/www/html"
#  ServerName localhost

#  <Directory "/var/www/html">
#    Options Indexes FollowSymLinks MultiViews
#    AllowOverride None
#    Order allow,deny
#    allow from all
#  </Directory>
#</VirtualHost>'
#echo -e $VHOST | sudo tee /etc/apache2/sites-enabled/000-default.conf

# Loading needed modules to make apache work
sudo a2enmod rewrite
sudo service apache2 reload

# ---------------------------------------
#          PHP Setup
# ---------------------------------------

# Installing packages
sudo apt-get install -y php5 libapache2-mod-php5 php5-cli curl php5-curl php5-mcrypt php5-xdebug php5-tidy php5-gd

sudo service apache2 reload

# ---------------------------------------
#          MySQL Setup
# ---------------------------------------

# Setting MySQL root user password root/root
debconf-set-selections <<< 'mysql-server mysql-server/root_password password root'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'

# Installing packages
sudo apt-get install -y mysql-server mysql-client php5-mysql

# ---------------------------------------
#          PHPMyAdmin setup
# ---------------------------------------

# Default PHPMyAdmin Settings
debconf-set-selections <<< 'phpmyadmin phpmyadmin/dbconfig-install boolean true'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/app-password-confirm password root'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/admin-pass password root'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/mysql/app-pass password root'
debconf-set-selections <<< 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2'

# Install PHPMyAdmin
sudo apt-get install -y phpmyadmin

# Make Composer available globally
sudo ln -s /etc/phpmyadmin/apache.conf /etc/apache2/sites-enabled/phpmyadmin.conf

# Restarting apache to make changes
sudo service apache2 restart



# ---------------------------------------
#       Tools Setup
# ---------------------------------------

# Installing GIT
sudo apt-get install -y git

# Install Composer
curl -s https://getcomposer.org/installer | php

# Make Composer available globally
sudo mv composer.phar /usr/local/bin/composer



#Set file permissions
sudo chmod -R 755 /var/www/html/
sudo chmod -R 777 /var/www/html/assets/

# Set timezone
sudo sed -i "s/;date.timezone =/date.timezone = Pacific\/Auckland/" /etc/php5/apache2/php.ini


#update default page
sudo sed -i "s/index.html/index.php index.html/" /etc/apache2/mods-enabled/dir.conf


# Install Mailcatcher
if [ ! -f /var/log/mailcatchersetup ];
then
    sudo /opt/vagrant_ruby/bin/gem install mailcatcher

    sudo touch /var/log/mailcatchersetup
fi


# Configure PHP
if [ ! -f /var/log/phpsetup ];
then
    sudo sed -i '/;sendmail_path =/c sendmail_path = "/opt/vagrant_ruby/bin/catchmail"' /etc/php5/apache2/php.ini
    sudo sed -i '/display_errors = Off/c display_errors = On' /etc/php5/apache2/php.ini
    sudo sed -i '/error_reporting = E_ALL & ~E_DEPRECATED/c error_reporting = E_ALL | E_STRICT' /etc/php5/apache2/php.ini
    sudo sed -i '/html_errors = Off/c html_errors = On' /etc/php5/apache2/php.ini
    #echo "zend_extension='$XDEBUG_LOCATION'" | sudo tee -a /etc/php5/apache2/php.ini > /dev/null

    sudo touch /var/log/phpsetup
fi



sudo service apache2 restart