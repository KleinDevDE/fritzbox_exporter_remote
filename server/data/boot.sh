#!/bin/sh
echo "init.sh Script called";

gateway_address=$(echo $GATEWAY_URL | awk -F[/:] '{print $4}')

cat > /tmp/log_format_settings << END

        log_format postdata escape=json '$remote_addr - $remote_user [$time_local] '
                       '"$request" $status $bytes_sent '
                       ', Referer: "$http_referer", Agent: "$http_user_agent", Body: "$request_body"';
        access_log /app/nginx.log postdata;
        error_log /app/nginx.log;
END

cat > /tmp/reverse_proxy_conf << END
server {
  listen 127.0.0.1:80;
  location / {
    proxy_pass $gateway_address:7001;
  }
}


server {
  listen 127.0.0.1:49000;
  location / {
    proxy_pass $gateway_address:7002;
  }
}
END


if ! command -v nginx &> /dev/null; then
  echo "Nginx is not installed!";
  echo "Updating apk database...";
  apk update
  echo "Installing nginx...";
  apk add nginx

  echo "Manipulating nginx config...";
  match='access_log \/var\/log\/nginx\/access.log main;'
  sed "/$match/r /tmp/log_format_settings" /etc/nginx/nginx.conf
  rm /tmp/log_format_settings 

  echo "Generating nginx reverse proxy...";
  cat /tmp/reverse_proxy_conf > /etc/nginx/http.d/reverse_proxy.conf
  rm -f /etc/nginx/http.d/default.conf;
  rm /tmp/reverse_proxy_conf 
fi


if [ -e /var/run/nginx.pid ]; then
  echo "Nginx is already running, skipping...";
else
  echo "No running nginx detected, starting it...";
  nohup nginx
fi


echo "Starting fritzbox exporter...";
/app/fritzbox_exporter -username $USERNAME -password $PASSWORD -gateway-url $GATEWAY_URL -listen-address $LISTEN_ADDRESS