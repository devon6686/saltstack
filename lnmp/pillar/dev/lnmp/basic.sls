basic:
  nginx:
    user: nginx
    group: nginx
    prefix: /opt/nginx
    conf_file: /etc/nginx/nginx.conf
    sbin_file: /usr/sbin/nginx
    log_path: /var/log/nginx
    parameters: --with-http_ssl_module --with-http_realip_module --with-http_image_filter_module --with-http_addition_module --with-http_sub_module --with-http_dav_module --with-http_flv_module --with-http_mp4_module --with-http_gunzip_module --with-http_gzip_static_module --with-http_random_index_module --with-http_secure_link_module --with-http_stub_status_module --with-http_auth_request_module --with-threads --with-file-aio --with-pcre 
    pid_file: /var/run/nginx.pid
    lock_file: /var/run/nginx.lock
    temp_path: /var/cache/nginx
  mysql:
    user: mysql
    group: mysql
    basepath: /usr/local
    basedir: /usr/local/mysql
    datadir: /data/mysql
  php:
    prefix: /usr/local/php5
    fpm-user: nginx
    fpm_pid: /var/run/php-fpm.pid
    fpm_socket: /var/run/php-fpm.sock
    mysql_host: localhost
    mysql_socket: /var/lib/mysql/mysql.sock
    parameter: --with-config-file-path=/etc --with-config-file-scan-dir=/etc/php.d --with-openssl --with-freetype-dir --with-jpeg-dir --with-png-dir --with-zlib --with-libxml-dir=/usr --with-mcrypt --with-bz2 --with-mhash --with-pear --with-curl --with-gd --enable-fpm --enable-xml --enable-bcmath --enable-gd-native-ttf --enable-opcache --enable-sockets --enable-zip --enable-maintainer-zts --enable-mbstring --enable-session --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd
   
