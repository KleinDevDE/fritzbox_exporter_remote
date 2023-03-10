#!/bin/bash
echo "Checking root privileges..."
if [ $(id -u) != 0 ]; then
    echo "You must run this script with root privileges!"
    exit 1
fi

echo "First, the script needs some information about the IPv4 address of the FRITZ!Box, the Pi and the remote server."
echo "----"
echo "The IPv4 of the FRITZ!Box is normally 192.168.178.1"
read -p 'Please enter the IPv4 address of your FRITZ!Box: ' fritzIPv4
echo "----"
read -p 'Please enter the IPv4 address of your raspberry pi: ' raspiIPv4
echo "----"
read -p 'Please enter the IPv4 address of your remote server: ' remoteIPv4
echo "----"
echo "Thank you"
echo ""
echo ""
echo "This script will install and configure nginx, if you don't want that, you can cancel this script now."
echo "An example of an Apache2 configuration can be found in the apache2_example.conf file."
read -p 'CTRL^C or type "exit" to abort. ENTER to continue:  ' shouldExit
shouldExit=${shouldExit:-no}
if [ $shouldExit = "exit" ]; then
    echo "Cancelling script..."
    exit 0
fi


echo "---------------"
echo "Updating current apt indexes..."
echo "---------------"
apt update

echo "---------------"
echo "Installing nginx, if its not already installed..."
echo "---------------"
apt install -y nginx

echo "---------------"
echo "Saving the reverse proxy configuration..."
echo "---------------"
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

echo "---------------"
echo "Enabling the new reverse proxy configuration..."
echo "---------------"
ln -s /etc/nginx/sites-available/fritzbox_exporter.conf /etc/nginx/sites-enabled/fritzbox_exporter.conf

echo "---------------"
echo "Restarting nginx..."
echo "---------------"
service nginx restart

echo "---------------"
echo "---------------"
echo "RaspberryPi installation DONE!"
echo "---------------"
echo "You can test the reverse proxy by visting following urls:"
echo "http://$raspiIPv4:7001"
echo "http://$raspiIPv4:7002"
echo "---"
echo "http://$(hostname):7001"
echo "http://$(hostname):7002"
