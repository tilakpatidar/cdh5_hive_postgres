#!/bin/bash
set -x
#save all env vars .bashrc for ssh sessions
printenv | cat >> /root/.bashrc

#restart postgresql
sudo /etc/init.d/postgresql restart

# create hdfs directories
/usr/sbin/sshd && $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh &&\
 $HADOOP_PREFIX/sbin/start-dfs.sh &&\
 $HADOOP_PREFIX/bin/hdfs dfs -mkdir -p /user/root &&\
 $HADOOP_PREFIX/bin/hdfs dfs -mkdir -p /apps/hive/warehouse


# start hive metastore server
$HIVE_HOME/bin/hive --service metastore &

sleep 20

# start hive server
$HIVE_HOME/bin/hive --service hiveserver2 &


if [[ $1 == "-bash" ]]; then
  /bin/bash
fi

if [[ $1 == "-d" ]]; then
  while true; do sleep 1000;echo $PATH; done
fi
