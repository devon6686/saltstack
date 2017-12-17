# mysql5.6
salt configure for mysql5.6.31 master-slaves

2016-06-23 ISSUES:
1. NOT solve the different values of SERVER_ID in slaves configure file(my.cnf)

2. NOT determine which master and slaves in salt configure file

2016-06-28:
Solve ALL issues before and modify my.cnf to solve the parameter of mysql's client socket 

#USAGE:
1. mysql5.6.31 install:
//define mysql nodegroup in salt-master

  salt -N 'mysql' state.sls -l debug > /root/log

2. mysql replication:
//use mysql gtid replication and MASTER-2-SLAVES

  salt -N 'mysql' state.sls mysql.start_repl -l debug > /root/log


