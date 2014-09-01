#!/bin/bash
#
# Rails Ready
#
# Author: Josh Frye <joshfng@gmail.com>
# Licence: MIT
#
# Contributions from: Wayne E. Seguin <wayneeseguin@gmail.com>
# Contributions from: Ryan McGeary <ryan@mcgeary.org>
#
# http://ftp.ruby-lang.org/pub/ruby/2.0/ruby-2.0.0-p0.tar.gz
shopt -s nocaseglob
set -e

ruby_version="2.1.2"
ruby_version_string="2.1.2"
ruby_source_url="http://cache.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz"
ruby_source_tar_name="ruby-2.1.2.tar.gz"
ruby_source_dir_name="ruby-2.1.2"
script_runner=$(whoami)
railsready_path=$(cd && pwd)/railsready
log_file="$railsready_path/install.log"
system_os=`uname | env LANG=C LC_ALL=C LC_CTYPE=C tr '[:upper:]' '[:lower:]'`

control_c()
{
  echo -en "\n\n*** Exiting ***\n\n"
  exit 1
}

# trap keyboard interrupt (control-c)
trap control_c SIGINT

clear

echo "#################################"
echo "########## Rails Ready ##########"
echo "#################################"

#determine the distro
if [[ $system_os = *linux* ]] ; then
  distro_sig=$(cat /etc/issue)
  redhat_release='/etc/redhat-release'
  if [[ $distro_sig =~ ubuntu ]] ; then
    distro="ubuntu"
  else
      if [ -e $redhat_release ] ; then
          distro="centos"
      fi
  fi
elif [[ $system_os = *darwin* ]] ; then
  distro="osx"
    if [[ ! -f $(which gcc) ]]; then
      echo -e "\nXCode/GCC must be installed in order to build required software. Note that XCode does not automatically do this, but you may have to go to the Preferences menu and install command line tools manually.\n"
      exit 1
    fi
else
  echo -e "\nRails Ready currently only supports Ubuntu, CentOS and OSX\n"
  exit 1
fi

echo -e "\n\n"
echo "run tail -f $log_file in a new terminal to watch the install"

echo -e "\n"
echo "What this script gets you:"
echo " * Ruby $ruby_version_string"
echo " * libs needed to run Rails (sqlite, mysql, etc)"
echo " * Bundler, Passenger, and Rails gems"
echo " * Git"


# Check if the user has sudo privileges.
sudo -v >/dev/null 2>&1 || { echo $script_runner has no sudo privileges ; exit 1; }


echo -e "\n=> Creating install dir..."
cd && mkdir -p railsready/src && cd railsready && touch install.log
echo "==> done..."

echo -e "\n=> Downloading and running recipe for $distro...\n"
#Download the distro specific recipe and run it, passing along all the variables as args
if [[ $system_os = *linux* ]] ; then
  wget --no-check-certificate -O $railsready_path/src/$distro.sh https://raw.githubusercontent.com/bemyeyes/railsready/master/recipes/$distro.sh && cd $railsready_path/src && bash $distro.sh $ruby_version $ruby_version_string $ruby_source_url $ruby_source_tar_name $ruby_source_dir_name $whichRuby $railsready_path $log_file
else
  cd $railsready_path/src && curl -O https://raw.githubusercontent.com/bemyeyes/railsready/master/recipes/$distro.sh && bash $distro.sh $ruby_version $ruby_version_string $ruby_source_url $ruby_source_tar_name $ruby_source_dir_name $whichRuby $railsready_path $log_file
fi
echo -e "\n==> done running $distro specific commands..."

#now that all the distro specific packages are installed lets get Ruby
  echo -e "\n=> Installing rbenv https://github.com/sstephenson/rbenv \n"
  git clone git://github.com/sstephenson/rbenv.git ~/.rbenv
  echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bash_profile
  echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
  if [ -f ~/.profile ] ; then
    source ~/.profile
  fi
  if [ -f ~/.bashrc ] ; then
    source ~/.bashrc
  fi
  if [ -f ~/.bash_profile ] ; then
    source ~/.bash_profile
  fi
  echo -e "\n=> Installing ruby-build  \n"
  git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
  echo -e "\n=> Installing ruby \n"
  rbenv install $ruby_version_string >> $log_file 2>&1
  rbenv rehash
  rbenv global $ruby_version_string
  echo "===> done..."

# Reload bash
echo -e "\n=> Reloading shell so ruby and rubygems are available..."
if [ -f ~/.bashrc ] ; then
  source ~/.bashrc
fi
echo "==> done..."

echo -e "\n=> Updating Rubygems..."
  gem update --system --no-ri --no-rdoc >> $log_file 2>&1
echo "==> done..."

echo -e "\n=> Installing Bundler, Passenger and Rails..."
 gem install bundler passenger rails --no-ri --no-rdoc -f >> $log_file 2>&1
echo "==> done..."

echo -e "\n#################################"
echo    "### Installation is complete! ###"
echo -e "#################################\n"

echo -e "\n !!! logout and back in to access Ruby !!!\n"

echo -e "\n Thanks!\n-Josh\n"
