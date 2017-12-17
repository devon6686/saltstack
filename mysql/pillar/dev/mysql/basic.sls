mysql:
  global:
    user: mysql
    repl_user: repl
    repl_pass: redhat
    repl_host: node11
    basedir: /usr/local/mysql
    datadir: /mydata/data
  master:
    server_id: 1
    host:
      node11: 10.0.0.11
  slaves:
    hosts:
      server_id:
        node8: 12
        node9: 13
        node12: 14
