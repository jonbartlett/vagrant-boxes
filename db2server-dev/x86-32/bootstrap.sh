#!/bin/bash

## DB2 Server provisioning
##  based on https://github.com/angoca/db2unit/blob/master/.travis.yml

## core packages
sudo apt-get update
sudo apt-get install -y wget
sudo apt-get install -y aria2

sudo apt-get install libaio1 lib32stdc++6 -y
sudo apt-get install -qq libpam-ldap:i386

# Retrieves and extracts the DB2 binaries
# If it does not work, change the wiki https://github.com/angoca/db2unit/wiki/DB2-Download-link
LINK=$(curl --url https://raw.githubusercontent.com/jonbartlett/vagrant-boxes/master/db2server-dev/x86-32/README.md -s | tail -1)
echo ${LINK}
cd /tmp ; aria2c -x 16 ${LINK} ; tar zxvf *.tar.gz

# Retrieves and extract log4db2
cd ; wget https://github.com/angoca/log4db2/releases/download/log4db2-1-Beta-A/log4db2.tar.gz ; tar zxvf log4db2.tar.gz

# Retrieves and extract db2unit
cd ; wget https://github.com/angoca/db2unit/releases/download/db2unit-1/db2unit.tar.gz ; tar zxvf db2unit.tar.gz

# INSTALL
sudo ln -s /lib/i386-linux-gnu/libpam.so.0 /lib/libpam.so.0

# Checks the prerequisites
cd /tmp/server_t ; ./db2prereqcheck -l

# Install DB2 and creates an instance (Response file)
cd /tmp ; wget https://raw.githubusercontent.com/jonbartlett/vagrant-boxes/master/db2server-dev/x86-32/db2/db2.rsp
cd /tmp/server_t ; sudo ./db2setup -r /tmp/db2.rsp || cat /tmp/db2setup.log

# Changes the security
sudo usermod -a -G db2iadm1 $USER
sudo chsh -s /bin/bash db2inst1
sudo su - db2inst1 -c "db2 update dbm cfg using SYSADM_GROUP db2iadm1 ; db2stop ; db2start"

# Creates the database
sudo su - db2inst1 -c "db2 create db db2unit ; db2 connect to db2unit ; db2 grant dbadm on database to user $USER"
. ~db2inst1/sqllib/db2profile ; db2 connect to db2unit

# Install log4db2
cd ; cd log4db2 ; . ./install

# Install db2unit
cd ; cd db2unit ; . ./install

# Install your code

