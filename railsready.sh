sudo -i
sudo apt-get -y update
sudo apt-get -y install zlib1g-dev libreadline6-dev libyaml-dev ruby-dev
sudo apt-get -y install wget curl build-essential clang bison openssl zlib1g libxslt1.1 libssl-dev libxslt1-dev libxml2 libffi-dev libyaml-dev libxslt-dev autoconf libc6-dev libreadline6-dev zlib1g-dev libcurl4-openssl-dev libtool
#remove original ruby
sudo apt-get -y remove ruby
apt-get -y install apache2-mpm-worker
apt-get -y install apache2-threaded-dev
apt-get -y install libapr1-dev
apt-get -y install libaprutil1-dev
cd /tmp
wget http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz
tar -xvzf ruby-2.1.2.tar.gz
cd ruby-2.1.2/
./configure --prefix=/usr/local
make
sudo make install
gem update --system --no-ri --no-rdoc
gem install bundler passenger sinatra --no-ri --no-rdoc -f
sudo locale-gen en_GB.UTF-8
passenger-install-apache2-module --auto

#install mongo
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list
sudo apt-get update
sudo apt-get install mongodb-10gen
echo "mongodb-10gen hold" | sudo dpkg --set-selections
sudo service mongodb start
#sudo apt-get -y install mongodb-clients

rm  /etc/apache2/sites-enabled/000-default.conf

chown www-data /vagrant/
ln -s /vagrant /var/www/api.bemyeyes.org
chown www-data /var/www/api.bemyeyes.org

echo "LoadModule passenger_module /usr/local/lib/ruby/gems/2.1.0/gems/passenger-4.0.53/buildout/apache2/mod_passenger.so" >> /etc/apache2/apache2.conf
echo "  PassengerRoot /usr/local/lib/ruby/gems/2.1.0/gems/passenger-4.0.53" >> /etc/apache2/apache2.conf
echo "  PassengerRuby  /usr/local/bin/ruby" >> /etc/apache2/apache2.conf
echo "ServerName \"localhost\"" >> /etc/apache2/apache2.conf

touch /etc/apache2/sites-enabled/bemyeyes
echo "<VirtualHost *:3000>
    DocumentRoot /var/www/api.bemyeyes.org/public
    <Directory /var/www/api.bemyeyes.org/public>
      Options Indexes FollowSymLinks
      AllowOverride None
      Require all granted
    </Directory>
</VirtualHost>" >> /etc/apache2/sites-enabled/bemyeyes.conf


echo "Listen 3000" >>/etc/apache2/ports.conf

cd /vagrant 
bundle install

apachectl -k restart

