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
gem install bundler passenger rails --no-ri --no-rdoc -f
sudo locale-gen en_GB.UTF-8
passenger-install-apache2-module --auto

#install mongo
sudo apt-get -y install mongodb
sudo apt-get -y install mongodb-clients

#/usr/local/lib/ruby/gems/2.0.0/gems/passenger-4.0.50
sudo -i
echo "LoadModule passenger_module /usr/local/lib/ruby/gems/2.0.0/gems/passenger-4.0.50/gems/passenger-3.0.12/ext/apache2/mod_passenger.so" >> /etc/apache2/apache2.conf
echo "  PassengerRoot /usr/local/lib/ruby/gems/2.0.0/gems/passenger-4.0.50/gems/passenger-3.0.12" >> /etc/apache2/apache2.conf
echo "  PassengerRuby  /usr/local/bin/ruby" >> /etc/apache2/apache2.conf
