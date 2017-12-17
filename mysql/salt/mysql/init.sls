include:
  - mysql.os_user
  - mysql.pkg

mysql-package:
  file.managed:
    - name: /tmp/mysql-5.6.31.tar.gz
    - source: salt://mysql/files/mysql-5.6.31.tar.gz

mysql_install:
  cmd.run:
    - name: tar -xf /tmp/mysql-5.6.31.tar.gz -C /usr/local/ && mkdir /var/lib/mysql && chown -R mysql.mysql /var/lib/mysql && cd /usr/local && ln -s ./mysql-5.6.31-linux-glibc2.5-x86_64 ./mysql && chown -R mysql.mysql /usr/local/mysql && mkdir /mydata/data && chown -R mysql.mysql /mydata/data && cd mysql/ && ./scripts/mysql_install_db --user=mysql --datadir=/mydata/data/  && rm -f /usr/local/mysql/my.cnf
    - require: 
      - file: mysql-package
    - unless: test -L /usr/local/mysql

{% set HOSTNAME = grains['host'] %}
{% set MASTER = salt['pillar.get']('mysql:master:host') %}
{% set SLAVES = salt['pillar.get']('mysql:slaves:hosts:server_id') %}
/etc/my.cnf:
  file.managed:
    - template: jinja
    - user: mysql
    - group: mysql
{% if HOSTNAME in MASTER.keys() %}
    - source: salt://mysql/files/my.cnf.master.template
    - defaults:
      SERVER_ID: {{ salt['pillar.get']('mysql:master:server_id') }}
{% else %}
    - source: salt://mysql/files/my.cnf.slave.template
    - defaults:
      SERVER_ID: {{ SLAVES.get(HOSTNAME,11) }}
{% endif %}
      BASEDIR: {{ salt['pillar.get']('mysql:global:basedir') }}
      DATADIR: {{ salt['pillar.get']('mysql:global:datadir') }}

/etc/init.d/mysqld:
  file.managed:
    - source: salt://mysql/files/mysqld.template
    - template: jinja
    - mode: 0755
    - defaults:
      BASEDIR: {{ salt['pillar.get']('mysql:global:basedir') }}
      DATADIR: {{ salt['pillar.get']('mysql:global:datadir') }}
      
/etc/profile.d/mysql.sh:
  file.managed:
    - source: salt://mysql/files/mysql.sh.template
    - template: jinja
    - mode: 0755
    - defaults:
      BASEDIR: {{ salt['pillar.get']('mysql:global:basedir') }}

mysql_path:
  cmd.run:
    - name: source /etc/profile.d/mysql.sh
    - require:
      - file: /etc/profile.d/mysql.sh
       
/etc/ld.so.conf.d/mysql.conf:
  file.managed:
    - source: salt://mysql/files/mysql.conf.template
    - template: jinja
    - mode: 0755
    - defaults:
      BASEDIR: {{ salt['pillar.get']('mysql:global:basedir') }}
      
mysql_lib:
  cmd.run:
    - name: ldconfig -v
    - require:
      - file: /etc/ld.so.conf.d/mysql.conf

mysql_head:
  file.symlink:
    - name: {{salt['pillar.get']('mysql:global:basedir')}}/include
    - target: /usr/include/mysql
    - mode: 0755  
    - force: True
    - unless: test -L /usr/include/mysql
    
  
mysqld:
  service.running:
    - enable: True
    - require:
      - file: /etc/my.cnf
      - file: /etc/init.d/mysqld
      - cmd: mysql_install


#mysql_socket:
#  file.symlink:
#    - name: {{salt['pillar.get']('mysql:global:datadir')}}/mysql.sock
#    - target: /var/lib/mysql/mysql.sock
#    - mode: 4777
#    - user: mysql
#    - group: mysql
#    - require:
#      - cmd: mysql_prelink

