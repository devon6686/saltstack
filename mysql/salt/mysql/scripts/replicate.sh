#!/bin/bash

{{ BASEDIR }}/bin/mysql -e "CHANGE MASTER TO MASTER_HOST='{{ MASTER_HOST }}',MASTER_USER='{{MASTER_USER}}',MASTER_PASSWORD='{{MASTER_PASSWD}}',MASTER_AUTO_POSITION=1;"
{{ BASEDIR }}/bin/mysql -e "start slave;"
{{ BASEDIR }}/bin/mysql -e "show slave status\G;"

