#!/bin/sh
yum -y install wget
wget http://download.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
rpm -ivh epel-release-6-8.noarch.rpm
yum update
sed -i \
-e 's/^#baseurl=/baseurl=/g' \
-e 's/^mirrorlist=/#mirrorlist=/g' \
/etc/yum.repos.d/epel.repo
yum -y install php-mcrypt