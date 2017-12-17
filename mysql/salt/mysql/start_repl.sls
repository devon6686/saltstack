{% from 'mysql/init.sls' import HOSTNAME with context %}
{% from 'mysql/init.sls' import MASTER with context %}
{% from 'mysql/init.sls' import SLAVES with context %}

include:
  - mysql.repl

{% if HOSTNAME not in MASTER.keys() %}
{% set HOST = salt['pillar.get']('mysql:global:repl_host') %}
mysql_replication:
  cmd.script:
    - source: salt://mysql/scripts/replicate.sh
    - template: jinja
    - defaults:
      BASEDIR: {{ salt['pillar.get']('mysql:global:basedir') }}
      MASTER_USER: {{ salt['pillar.get']('mysql:global:repl_user') }}
      MASTER_PASSWD: {{ salt['pillar.get']('mysql:global:repl_pass') }}
      MASTER_HOST: {{ MASTER.get(HOST) }}
    - env:
      - BATCH: 'yes'
{% endif %}
