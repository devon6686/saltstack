mysql-python:
  pkg.installed:
    - name: MySQL-python
    - unless: rpm -q MySQL-python
    
mysql-client:
  cmd.run:
    - name: source /etc/profile.d/mysql.sh

{% for HOST in ['localhost','%'] %}
mysql-grants-{{ HOST }}-repl:
  mysql_user.present:
    - name: {{ salt['pillar.get']('mysql:global:repl_user') }}
    - host: '{{ HOST }}'
    - password: {{ salt['pillar.get']('mysql:global:repl_pass') }}
    - connection_user: root
    - connection_pass: ''
    - allow_passwordless: True
    - unix_socket: False
    - require:
      - cmd: mysql-client
      - pkg: mysql-python

  mysql_grants.present:
    - grant: all privileges
    - database: '*.*'
    - user: {{ salt['pillar.get']('mysql:global:repl_user') }}
    - host: '{{ HOST }}'
    - require:
      - mysql_user: {{ salt['pillar.get']('mysql:global:repl_user') }}
{% endfor %}
   
