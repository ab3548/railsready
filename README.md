#Sinatra Ready
###Ruby and sinatra setup script for Ubuntu

#
###To run:

  * `wget --no-check-certificate https://raw.githubusercontent.com/bemyeyes/railsready/master/railsready.sh && bash railsready.sh`



  * Ruby 2.0.0p481 
  * libs needed to run Rails and sinatra (sqlite, etc)
  * Bundler, Passenger, and Rails gems
  * Git

Please note: If you are running on a super slow connection your sudo session may timeout and you'll have to enter your password again. If you're running this on an EC2 or RS instance it shouldn't be problem.

It will install Apache, and then run  `passenger-install-apache2-module`

