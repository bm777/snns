#! /bin/bash

#Mise a jour du systeme
sudo apt-get update
sudo apt-get upgrade
#---------------creation du repertoire de travail---------------------------
cd ~
mkdir repo && cd repo
#---------------telechargement et installation de nessus-------------------
wget -O nessus.deb https://www.tenable.com/downloads/api/v1/public/pages/nessus/downloads/10204/download?i_agree_to_tenable_license_agreement=true
sudo dpsk -i nessus.deb
sudo systemctl start nessusd
sudo systemctl enable nessusd.service
sudo ufw allow 8834/tcp
#--------------telechargement et installation de nagios-------------------
sudo apt-get install -y wget build-essential unzip openssl libssl-dev
sudo apt-get install -y apache2 php libapache2-mod-php php-gd libgd-dev
sudo service apache2 start
sudo useradd nagios
sudo groupadd nagios
wget https://liquidtelecom.dl.sourceforge.net/project/nagios/nagios-3.x/nagios-3.2.3/nagios-3.2.3.tar.gz
tar xzf nagios-3.2.3.tar.gz
cd nagios-3.2.3
make all
sudo make install
if [ `sudo make install-webconf` ]
then
    echo "OK nagios installed"
else
    sudo mkdir /etc/httpd
    sudo mkdir /etc/httpd/conf.d
    sudo mkdir /etc/httpd/conf.d/nagios.conf
fi
sudo make install-webconf
if [ `sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin` ]
then
    echo "OK nagiosadmin installed"
else
    sudo mkdir /usr/local/nagios/etc
	sudo chmod -R nagios:nagios /usr/local/nagios/etc
fi
sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin
cd ..
wget https://nagios-plugins.org/download/nagios-plugins-1.4.16.tar.gz
tar -xvzf nagios-plugins-1.4.16.tar.gz
cd nagios-plugins-1.4.16
sudo ./configure --with-nagios-user=nagios --with-nagios-group=nagios
if [ `sudo /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg` ]
then
    echo "OK nagio plugin installed"
else
    sudo apt-get install -y nagios3 nagios-plugins
fi
#---------------------------------Installation de snort-------------------
sudo apt-get install -y build-essential
sudo apt-get install -y libpcap-dev libpcre3-dev libdumbnet-dev
sudo apt-get install -y zlib1g-dev liblzma-dev openssl libssl-dev
sudo apt-get install -y bison flex
# ----------------------------installation de rsyslog et syslog-ng--------
sudo apt-get install -y snort
sudo apt-get install -y rsyslog
sudo apt-get install -y syslog-ng

