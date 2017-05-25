FROM ubuntu:trusty

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
ARG POSTGRES_VERSION
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

# install dev tools
RUN apt-get update
RUN apt-get install -y curl wget tar openssh-server openssh-client rsync python-software-properties apt-file apache2

# for running sshd in ubuntu trusty. https://github.com/docker/docker/issues/5704
RUN mkdir /var/run/sshd
RUN echo 'root:secretpasswd' | chpasswd
RUN sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN sed -i 's/Listen 80/Listen 9999/g' /etc/apache2/ports.conf

# passwordless ssh
RUN yes | ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_dsa_key
RUN yes | ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key
RUN yes | ssh-keygen -q -N "" -t rsa -f /root/.ssh/id_rsa
RUN cp /root/.ssh/id_rsa.pub /root/.ssh/authorized_keys

# SSH login fix. Otherwise user is kicked off after login
# RUN sed 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' -i /etc/pam.d/sshd
# RUN /usr/sbin/sshd

# fix the 254 error code
RUN sed  -i "/^[^#]*UsePAM/ s/.*/#&/"  /etc/ssh/sshd_config
RUN echo "UsePAM no" >> /etc/ssh/sshd_config
RUN echo "Port 2122" >> /etc/ssh/sshd_config
RUN /usr/sbin/sshd

# ssh client config
ADD conf/ssh_config /root/.ssh/config
RUN chmod 600 /root/.ssh/config
RUN chown root:root /root/.ssh/config

# oracle jdk 8
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update

# to accept license agreement automatically
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
RUN apt-get install -y oracle-java8-installer

# java env setup
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle
ENV PATH $PATH:$JAVA_HOME/bin
ENV TILAK tilak
# set permissions for bootstrap file
ADD scripts/bootstrap.sh /etc/ubuntu-bootstrap.sh
RUN chown root:root /etc/ubuntu-bootstrap.sh
RUN chmod 700 /etc/ubuntu-bootstrap.sh

EXPOSE 22
ADD

#start
ENTRYPOINT ["/etc/ubuntu-bootstrap.sh", "-d"]