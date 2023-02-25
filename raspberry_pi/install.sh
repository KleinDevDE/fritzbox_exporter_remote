#!/bin/bash
echo "Checking root privileges..."
if [ $(id -u) != 0 ]; then
	echo "You must run this script with root!"
    exit 1
fi

echo "At first, the script needs some informations about the IPv4 address of the FRITZ!Box, the pi and the remote server."
echo "----"
echo "The IPv4 of the FRITZ!Box is normally 192.168.178.1"
read -p 'Please enter the IPv4 address of your FRITZ!Box: ' fritzIPv4
echo "==="
read -p 'Please enter the IPv4 address of your raspberry pi: ' raspiIPv4
echo "==="
read -p 'Please enter the IPv4 address of your remote server: ' remoteIPv4

echo "Updating current apt indexes..."
apt update

echo "Installing nginx, if its not already installed..."
apt install -y nginx

echo "Saving the reverse proxy configuration..."
cat > /etc/nginx/sites-available/fritzbox_exporter.conf << END
server {
  listen 7001;
  allow $remoteIPv4;
  deny all;

  location / {
    proxy_pass http://$fritzIPv4:80;
  }
}

server {
  listen 7002;
  allow $remoteIPv4;
  deny all;

  location / {
    proxy_pass http://$fritzIPv4:49000;
  }
}
END

echo "Enabling the new reverse proxy configuration..."
ln -s /etc/nginx/sites-available/fritzbox_exporter.conf /etc/nginx/sites-enabled/fritzbox_exporter.conf

echo "Restarting nginx..."
service nginx restart

echo "RaspberryPi installation DONE!"

echo "You can test the reverse proxy by visting following urls:"
echo "http://$raspiIPv4:7001"
echo "http://$raspiIPv4:7002"
echo "---"
echo "http://$(hostname):7001"
echo "http://$(hostname):7002"