#!/bin/sh

# Please execute this script as root privilege.
# Automatically install Zabbix 3.2 with Raspbian (Jessie).
# All necessary packages etc are also installed automatically.
# MariaDB is used for DB, nginx1.10.3 for Web, 7.0 for PHP.
# Password is defaulted, so please modify it if necessary.
# Please note that older versions such as php 5 will be uninstalled.

# Perform package update and upgrade.
apt-get update -y && apt-get upgrade -y

# Store the current current directory in the environment variable.
dir=$(pwd)

# Save nginx.service under /etc/init.d/.
mv nginx /etc/init.d/ && chmod +x /etc/init.d/nginx

# Install the package necessary for nginx compilation.
apt-get install -y gcc checkinstall libpcre3-dev zlib1g-dev libssl-dev geoip-bin libfontconfig1-dev libgd-dev libgeoip-dev libice-dev libjbig-dev libjpeg-dev libjpeg62-turbo-dev liblzma-dev libpthread-stubs0-dev libsm-dev libtiff5-dev libtiffxx5 libvpx-dev libx11-dev libx11-doc libxau-dev libxcb1-dev libxdmcp-dev libxpm-dev libxslt1-dev libxt-dev x11proto-core-dev x11proto-input-dev x11proto-kb-dev xorg-sgml-doctools xtrans-dev expect tcl-expect

# Save source of nginx1.10.3 with wget.
wget https://nginx.org/download/nginx-1.10.3.tar.gz

# After expanding and changing the directory name, delete the acquired file and move to the nginx directory.
tar zxvf nginx-1.10.3.tar.gz && mv nginx-1.10.3 nginx && rm nginx-1.10.3.tar.gz && cd nginx

# Compile.
./configure --group=nginx --user=nginx --prefix=/etc/nginx --sbin-path=/usr/sbin/nginx --conf-path=/etc/nginx/nginx.conf --lock-path=/var/run/nginx.lock --http-client-body-temp-path=/var/cache/nginx/client_temp --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp --http-proxy-temp-path=/var/cache/nginx/proxy_temp --http-scgi-temp-path=/var/cache/nginx/scgi_temp --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp --http-log-path=/var/log/nginx/access.log --error-log-path=/var/log/nginx/error.log --pid-path=/var/run/nginx.pid
make && cd ../

mv nginx_comp.exp nginx/ && cd nginx

# Create dpkg. Create a package with expect to save manual input.
expect nginx_comp.exp

# Install it in / etc / nginx with dpkg, remove the garbage
dpkg -i nginx_1.10.3-1_armhf.deb && cd && rm -rf ${dir}

# Create a directory to store log.
mkdir /var/log/nginx

# Register the service.
systemctl enable nginx.service

exit
