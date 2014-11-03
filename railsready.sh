sudo apt-get -y update
sudo apt-get -y install zlib1g-dev libreadline6-dev libyaml-dev ruby-dev
sudo apt-get -y install wget curl build-essential clang bison openssl zlib1g libxslt1.1 libssl-dev libxslt1-dev libxml2 libffi-dev libyaml-dev libxslt-dev autoconf libc6-dev libreadline6-dev zlib1g-dev libcurl4-openssl-dev libtool
apt-get -y install apache2-mpm-worker
apt-get -y install apache2-threaded-dev
apt-get -y install libapr1-dev
apt-get -y install libaprutil1-dev
cd /tmp
wget http://cache.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p353.tar.gz
tar -xvzf ruby-2.0.0-p353.tar.gz
cd ruby-2.0.0-p353/
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
#sudo apt-get install mongodb-10gen
sudo apt-get install mongodb-10gen=2.4.12
echo "mongodb-10gen hold" | sudo dpkg --set-selections
sudo service mongodb start
sudo apt-get -y install mongodb-clients

sudo -i
echo "LoadModule passenger_module /usr/local/lib/ruby/gems/2.0.0/gems/passenger-4.0.50/buildout/apache2/mod_passenger.so" >> /etc/apache2/apache2.conf
echo "  PassengerRoot /usr/local/lib/ruby/gems/2.0.0/gems/passenger-4.0.50" >> /etc/apache2/apache2.conf
echo "  PassengerRuby  /usr/local/bin/ruby" >> /etc/apache2/apache2.conf


touch /etc/apache2/sites-enabled/bemyeyes

echo "<VirtualHost *:3000>" >> /etc/apache2/sites-enabled/bemyeyes
echo "    DocumentRoot /vagrant/public" >> /etc/apache2/sites-enabled/bemyeyes
echo "    <Directory /vagrant/public>" >> /etc/apache2/sites-enabled/bemyeyes
echo "        Allow from all" >> /etc/apache2/sites-enabled/bemyeyes
echo "        Options -MultiViews" >> /etc/apache2/sites-enabled/bemyeyes
echo "    </Directory>" >> /etc/apache2/sites-enabled/bemyeyes
echo "</VirtualHost>" >> /etc/apache2/sites-enabled/bemyeyes

echo "Listen 3000" >>/etc/apache2/ports.conf

cd /vagrant 
bundle install

apachectl -k restart
