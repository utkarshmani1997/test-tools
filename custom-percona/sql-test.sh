#!/bin/bash

DB_PREFIX="Inventory"
DB_SUFFIX=`echo $(mktemp) | cut -d '.' -f 2`
DB_NAME="${DB_PREFIX}_${DB_SUFFIX}"


echo -e "\nWaiting for mysql server to start accepting connections.."
retries=10;wait_retry=60
for i in `seq 1 $retries`; do
  mysql -uroot -pk8sDem0 -e 'status' > /dev/null 2>&1
  rc=$?
  [ $rc -eq 0 ] && break
  sleep $wait_retry
done

if [ $rc -ne 0 ];
then
  echo -e "\nFailed to connect to db server after trying for $(($retries * $wait_retry))s, exiting\n"
  exit 1
fi
mysql -uroot -pk8sDem0 -e "CREATE DATABASE $DB_NAME;"
mysql -uroot -pk8sDem0 -e "CREATE TABLE Hardware (id INTEGER, name VARCHAR(20), owner VARCHAR(20),description VARCHAR(20));" $DB_NAME
mysql -uroot -pk8sDem0 -e "INSERT INTO Hardware (id, name, owner, description) values (1, "dellserver", "basavaraj", "controller");" $DB_NAME
mysql -uroot -pk8sDem0 -e "DROP DATABASE $DB_NAME;"
