#!/bin/sh

# Update Package List
apt-get update -q

# Install some PPAs
apt-get install -y software-properties-common curl

apt-add-repository ppa:nginx/stable -y

# Update Package Lists
apt-get update -q

# Install Nginx & PHP-FPM
apt-get install -q -y nginx php5-fpm php5-curl 

service nginx restart

# Setup PHP-FPM Options
sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini


# Copy fastcgi_params to Nginx because they broke it on the PPA
cat > /etc/nginx/fastcgi_params << EOF
fastcgi_param	QUERY_STRING		\$query_string;
fastcgi_param	REQUEST_METHOD		\$request_method;
fastcgi_param	CONTENT_TYPE		\$content_type;
fastcgi_param	CONTENT_LENGTH		\$content_length;
fastcgi_param	SCRIPT_FILENAME		\$request_filename;
fastcgi_param	SCRIPT_NAME		\$fastcgi_script_name;
fastcgi_param	REQUEST_URI		\$request_uri;
fastcgi_param	DOCUMENT_URI		\$document_uri;
fastcgi_param	DOCUMENT_ROOT		\$document_root;
fastcgi_param	SERVER_PROTOCOL		\$server_protocol;
fastcgi_param	GATEWAY_INTERFACE	CGI/1.1;
fastcgi_param	SERVER_SOFTWARE		nginx/\$nginx_version;
fastcgi_param	REMOTE_ADDR		\$remote_addr;
fastcgi_param	REMOTE_PORT		\$remote_port;
fastcgi_param	SERVER_ADDR		\$server_addr;
fastcgi_param	SERVER_PORT		\$server_port;
fastcgi_param	SERVER_NAME		\$server_name;
fastcgi_param	HTTPS			\$https if_not_empty;
fastcgi_param	REDIRECT_STATUS		200;
EOF


#Configure nginx
rm /etc/nginx/sites-enabled/default
rm /etc/nginx/sites-available/default

cat >my_default << EOF
server {
        listen 80 default_server;
        listen [::]:80 default_server;
        root /usr/share/nginx/html; # <-- Document root

        index index.php index.html index.htm;

        server_name localhost;

        location / {
                # Root should be build-folder
                root /usr/share/nginx/html/i-bog/build;

                # Fallback to index.php if not found
                try_files $uri $uri/ /index.php?$query_string;

                # Configure PHP FPM
                location ~ \.php$ {
                        try_files $uri =404;
                        fastcgi_split_path_info ^(.+\.php)(/.+)$;
                        fastcgi_pass unix:/var/run/php5-fpm.sock;
                        fastcgi_index index.php;
                        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_sc$
                        include fastcgi_params;
                }
        }
}

EOF

cp my_default /etc/nginx/sites-available/my_default
rm my_default
ln -s /etc/nginx/sites-available/my_default /etc/nginx/sites-enabled/my_default

# service nginx restart
# service php5-fpm restart
