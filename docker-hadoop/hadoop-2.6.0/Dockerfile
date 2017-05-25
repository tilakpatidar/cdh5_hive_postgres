# Creates pseudo distributed hadoop 2.6.0 in ubuntu
FROM ubuntu
MAINTAINER Tilak Patidar

USER root
#expected build args
ARG JAVA_HOME
ARG HIVE_HOME
ARG HIVE_CONF
ARG HIVE_VERSION
ARG HADOOP_VERSION
ARG CDH_VERSION
ARG CDH_EXACT_VERSION
ARG POSTGRESQL_MAIN
ARG POSTGRESQL_CONFIG_FILE
ARG POSTGRESQL_BIN
ARG PGPASSWORD
ARG HADOOP_HOME
ARG HADOOP_PREFIX
ARG HADOOP_COMMON_HOME
ARG HADOOP_HDFS_HOME
ARG HADOOP_MAPRED_HOME
ARG HADOOP_YARN_HOME
ARG HADOOP_CONF_DIR

ENV PATH $PATH:$JAVA_HOME/bin:$HIVE_HOME/bin:$HADOOP_HOME:$HADOOP_HOME/bin

ADD ./deps/hadoop-${HADOOP_VERSION}-cdh${CDH_EXACT_VERSION}.tar.gz /usr/local
RUN cd /usr/local && ln -s ./hadoop-${HADOOP_VERSION}-cdh${CDH_EXACT_VERSION} hadoop

RUN sed -i '/^export JAVA_HOME/ s:.*:export JAVA_HOME=/usr/lib/jvm/java-8-oracle\nexport HADOOP_PREFIX=/usr/local/hadoop\nexport HADOOP_HOME=/usr/local/hadoop\n:' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh
RUN sed -i '/^export HADOOP_CONF_DIR/ s:.*:export HADOOP_CONF_DIR=/usr/local/hadoop/etc/hadoop/:' $HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

# copy hadoop site xml files
RUN mkdir $HADOOP_PREFIX/input
RUN cp $HADOOP_PREFIX/etc/hadoop/*.xml $HADOOP_PREFIX/input

# pseudo distributed configurations
ADD templates/core-site.xml.template $HADOOP_PREFIX/etc/hadoop/core-site.xml.template
RUN sed s/HOSTNAME/localhost/ /usr/local/hadoop/etc/hadoop/core-site.xml.template > /usr/local/hadoop/etc/hadoop/core-site.xml
ADD conf/hdfs-site.xml $HADOOP_PREFIX/etc/hadoop/hdfs-site.xml
ADD conf/mapred-site.xml $HADOOP_PREFIX/etc/hadoop/mapred-site.xml
ADD conf/yarn-site.xml $HADOOP_PREFIX/etc/hadoop/yarn-site.xml

# format namenode
RUN $HADOOP_PREFIX/bin/hdfs namenode -format

# fixing the libhadoop.so
RUN rm -rf /usr/local/hadoop/lib/native/*
ADD ./deps/hadoop-native-64-2.6.0.tar /usr/local/hadoop/lib/native/

# add and set permissions for bootstrap script
ADD scripts/bootstrap.sh /etc/hadoop-bootstrap.sh
RUN chown root:root /etc/hadoop-bootstrap.sh
RUN chmod 700 /etc/hadoop-bootstrap.sh

RUN chmod +x /usr/local/hadoop/etc/hadoop/*-env.sh

# run bootstrap script
ENTRYPOINT ["/etc/hadoop-bootstrap.sh", "-d"]

#for exposed ports refer
#https://www.cloudera.com/documentation/enterprise/5-4-x/topics/cdh_ig_ports_cdh5.html

EXPOSE 50010 50020 50070 50075 50090 8020 9000 10020 19888 8030 8031 8032 8033 8040 8042 8088