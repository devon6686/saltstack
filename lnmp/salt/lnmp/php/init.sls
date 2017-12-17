php-env:
  pkg.installed:
    - pkgs:
      - openssl-devel
      - zlib-devel
      - libxml2-devel
      - bzip2-devel
      - libcurl-devel
      - libmcrypt-devel

php-package:
  file.managed:
    - name: /tmp/php-5.6.22.tar.bz2
    - source: salt://lnmp/php/template/php-5.6.22.tar.bz2
    - unless: test -e /tmp/php-5.6.22.tar.bz2

php-install:
  cmd.script:
    - source: salt://lnmp/php/template/php-install.sh.template
    - template: jinja
    - defaults:
      PREFIX: {{ salt['pillar.get']('basic:php:prefix') }}
      BASEDIR: {{ salt['pillar.get']('basic:mysql:basedir') }}
      USER: {{ salt['pillar.get']('basic:php:fpm-user') }}
      GROUP: {{ salt['pillar.get']('basic:php:fpm-user') }}
      PARAMETER: {{ salt['pillar.get']('basic:php:parameter') }}
    - require:
      - pkg: php-env
      - file: php-package
    - unless: test -e /usr/local/php
    - env:
      - BATCH: 'yes'

fpm-file:
  file.managed:
    - name: /usr/lib/systemd/system/php-fpm.service
    - source: salt://lnmp/php/template/php-fpm.service.template
    - mode: 0755
    - template: jinja
    - defaults:
      PREFIX: {{ salt['pillar.get']('basic:php:prefix') }}
      FPM_PID: {{ salt['pillar.get']('basic:php:fpm_pid') }}

php-fpm.conf:
  file.managed:
    - name: /usr/local/php5/etc/php-fpm.conf
    - source: salt://lnmp/php/template/php-fpm.conf.template
    - template: jinja
    - defaults:
      USER: {{ salt['pillar.get']('basic:php:fpm-user') }}
      GROUP: {{ salt['pillar.get']('basic:php:fpm-user') }}
      FPM_PID: {{ salt['pillar.get']('basic:php:fpm_pid') }}
      FPM_SOCKET: {{ salt['pillar.get']('basic:php:fpm_socket') }}

php.ini:
  file.managed:
    - name: /etc/php.ini
    - source: salt://lnmp/php/template/php.ini.template
    - template: jinja
    - defaults:
      MYSQL_HOST: {{ salt['pillar.get']('basic:php:mysql_host') }}
      MYSQL_SOCKET: {{ salt['pillar.get']('basic:php:mysql_socket') }}

php.sh:
  file.managed:
    - name: /etc/profile.d/php.sh
    - source: salt://lnmp/php/template/php.sh.template
    - template: jinja
    - mode: 0755
    - defaults:
      PREFIX: {{ salt['pillar.get']('basic:php:prefix') }}

php-path:
  cmd.run:
    - name: source /etc/profile.d/php.sh
    - require: 
      - file: php.sh

daemon-reload:
  cmd.run:
    - name: systemctl daemon-reload
    - require:
      - file: php-fpm.conf
      - file: php.ini
      - cmd: php-install
      
php-fpm:
  service.running:
    - enable: True
    - require:
      - cmd: daemon-reload
    - watch:
      - file: fpm-file 

