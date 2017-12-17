include:
  - lnmp.mariadb.DBuser
  - lnmp.mariadb.pkg

mysql-package:
  file.managed:
    - name: /tmp/mariadb-10.1.16-glibc.tar.gz
    - source: salt://lnmp/mariadb/template/mariadb-10.1.16-glibc.tar.gz
    - unless: test -e /tmp/mariadb-10.1.16-glibc.tar.gz

mysql_install:
  cmd.script:
    - source: salt://lnmp/mariadb/template/mysql-install.sh.template
    - template: jinja
    - mode: 0755
    - require: 
      - file: mysql-package
    - unless: test -e /usr/local/mysql
    - defaults:
      USER: {{ salt['pillar.get']('basic:mysql:user') }}
      GROUP: {{ salt['pillar.get']('basic:mysql:group') }}
      BASEPATH: {{ salt['pillar.get']('basic:mysql:basepath') }}
      BASEDIR: {{ salt['pillar.get']('basic:mysql:basedir') }}
      DATADIR: {{ salt['pillar.get']('basic:mysql:datadir') }}

/etc/my.cnf:
  file.managed:
    - source: salt://lnmp/mariadb/template/my.cnf.template
    - template: jinja
    - defaults:
      BASEDIR: {{ salt['pillar.get']('basic:mysql:basedir') }}
      DATADIR: {{ salt['pillar.get']('basic:mysql:datadir') }}

/etc/init.d/mysqld:
  file.managed:
    - source: salt://lnmp/mariadb/template/mysqld.template
    - template: jinja
    - mode: 0755
    - defaults:
      BASEDIR: {{ salt['pillar.get']('basic:mysql:basedir') }}
      DATADIR: {{ salt['pillar.get']('basic:mysql:datadir') }}
      
/etc/profile.d/mysqld.sh:
  file.managed:
    - source: salt://lnmp/mariadb/template/mysqld.sh.template
    - template: jinja
    - mode: 0755
    - defaults:
      BASEDIR: {{ salt['pillar.get']('basic:mysql:basedir') }}

mysql_path:
  cmd.run:
    - name: source /etc/profile.d/mysqld.sh
    - require:
      - file: /etc/profile.d/mysqld.sh
       
/etc/ld.so.conf.d/mysql.conf:
  file.managed:
    - source: salt://lnmp/mariadb/template/mysql.conf.template
    - template: jinja
    - mode: 0755
    - defaults:
      BASEDIR: {{ salt['pillar.get']('basic:mysql:basedir') }}
      
mysql_lib:
  cmd.run:
    - name: ldconfig -pv
    - require:
      - file: /etc/ld.so.conf.d/mysql.conf

mysql_head:
  file.symlink:
    - name: /usr/include/mysql
    - target: {{ salt['pillar.get']('basic:mysql:basedir') }}/include
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


