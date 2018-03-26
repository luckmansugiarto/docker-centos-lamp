FROM 509566356991.dkr.ecr.ap-southeast-2.amazonaws.com/centos_6:latest

MAINTAINER Luckman Sugiarto <luckman.sugiarto@qusol.com.au>

ARG mysqld_user
ARG mysqld_group
ENV MY_USER $mysqld_user
ENV MY_GROUP $mysqld_group
ENV MARIADB_MAJOR 5.5
ENV MARIADB_VERSION 5.5.59

# Files
ENV MYSQL_BASE_INCL="/etc/my.cnf.d"
ENV MYSQL_CUST_INCL1="/etc/mysql/conf.d"
ENV MYSQL_CUST_INCL2="/etc/mysql/docker-default.d"
ENV MYSQL_DEF_DAT="/var/lib/mysql"
ENV MYSQL_DEF_LOG="/var/log/mysql"
ENV MYSQL_DEF_PID="/var/run/mysqld"
ENV MYSQL_DEF_SCK="/var/sock/mysqld"

ENV MYSQL_LOG_SLOW="${MYSQL_DEF_LOG}/slow.log"
ENV MYSQL_LOG_ERROR="${MYSQL_DEF_LOG}/error.log"
ENV MYSQL_LOG_QUERY="${MYSQL_DEF_LOG}/query.log"

# create a new user (non-root) to run the mysqld service later. 
# by default, maria DB prohibit the execution of mysqld service on root user
# (see: https://mariadb.com/kb/en/library/running-mysqld-as-root/)
RUN groupadd -r $mysqld_group && useradd -r -g $mysqld_user $mysqld_group

RUN rm -f /etc/yum.repos.d/MariaDB55.repo

RUN touch /etc/yum.repos.d/MariaDB55.repo

RUN echo "[mariadb]" >> /etc/yum.repos.d/MariaDB55.repo

RUN sed -i \
	-e "$ a name=MariaDB" \
	-e "$ a baseurl=http://yum.mariadb.org/5.5.59/centos6-x86" \
	-e "$ a gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB" \
	-e "$ a gpgcheck=1" \
	/etc/yum.repos.d/MariaDB55.repo && \
	yum clean all

RUN yum -y update && \
	yum -y install MariaDB

RUN \
	rm -rf ${MYSQL_BASE_INCL} && \
	rm -rf ${MYSQL_CUST_INCL1} && \
	rm -rf ${MYSQL_CUST_INCL2} && \
	rm -rf ${MYSQL_DEF_DAT} && \
	rm -rf ${MYSQL_DEF_SCK} && \
	rm -rf ${MYSQL_DEF_PID} && \
	rm -rf ${MYSQL_DEF_LOG} && \
	\
	mkdir -p ${MYSQL_BASE_INCL} && \
	mkdir -p ${MYSQL_CUST_INCL1} && \
	mkdir -p ${MYSQL_CUST_INCL2} && \
	mkdir -p ${MYSQL_DEF_DAT} && \
	mkdir -p ${MYSQL_DEF_SCK} && \
	mkdir -p ${MYSQL_DEF_PID} && \
	mkdir -p ${MYSQL_DEF_LOG} && \
	\
	chown -R $mysqld_user:$mysqld_group ${MYSQL_BASE_INCL} && \
	chown -R $mysqld_user:$mysqld_group ${MYSQL_CUST_INCL1} && \
	chown -R $mysqld_user:$mysqld_group ${MYSQL_CUST_INCL2} && \
	chown -R $mysqld_user:$mysqld_group ${MYSQL_DEF_DAT} && \
	chown -R $mysqld_user:$mysqld_group ${MYSQL_DEF_SCK} && \
	chown -R $mysqld_user:$mysqld_group ${MYSQL_DEF_PID} && \
	chown -R $mysqld_user:$mysqld_group ${MYSQL_DEF_LOG} && \
	\
	chmod 0775 ${MYSQL_BASE_INCL} && \
	chmod 0775 ${MYSQL_CUST_INCL1} && \
	chmod 0775 ${MYSQL_CUST_INCL2} && \
	chmod 0775 ${MYSQL_DEF_DAT} && \
	chmod 0775 ${MYSQL_DEF_SCK} && \
	chmod 0775 ${MYSQL_DEF_PID} && \
	chmod 0775 ${MYSQL_DEF_LOG}

RUN \
	echo "[client]" > /etc/my.cnf && \
	echo "socket = ${MYSQL_DEF_SCK}/mysqld.sock" >> /etc/my.cnf && \
	\
	echo "[mysql]" >> /etc/my.cnf && \
	echo "socket = ${MYSQL_DEF_SCK}/mysqld.sock" >> /etc/my.cnf && \
	\
	echo "[mysqld]" >> /etc/my.cnf && \
	echo "skip-host-cache" >> /etc/my.cnf && \
	echo "skip-name-resolve" >> /etc/my.cnf && \
	echo "user = $mysqld_user" >> /etc/my.cnf && \
	echo "bind-address = 0.0.0.0" >> /etc/my.cnf && \
	echo "socket = ${MYSQL_DEF_SCK}/mysqld.sock" >> /etc/my.cnf && \
	echo "pid-file = ${MYSQL_DEF_PID}/mysqld.pid" >> /etc/my.cnf && \
	echo "general_log_file = ${MYSQL_LOG_QUERY}" >> /etc/my.cnf && \
	echo "slow_query_log_file = ${MYSQL_LOG_SLOW}" >> /etc/my.cnf && \
	echo "log-error = ${MYSQL_LOG_ERROR}" >> /etc/my.cnf && \
	echo "!includedir ${MYSQL_BASE_INCL}/" >> /etc/my.cnf && \
	echo "!includedir ${MYSQL_CUST_INCL1}/" >> /etc/my.cnf && \
	echo "!includedir ${MYSQL_CUST_INCL2}/" >> /etc/my.cnf

#RUN echo "NETWORKING=yes" > /etc/sysconfig/network

COPY ./docker-entrypoint.sh /

EXPOSE 3306

##
## Volumes
##
VOLUME /var/lib/mysql
VOLUME /var/log/mysql
VOLUME /var/sock/mysqld
VOLUME /etc/mysql/conf.d
VOLUME /etc/mysql/docker-default.d

#CMD ["/bin/sh"]
ENTRYPOINT ["/docker-entrypoint.sh"]

#CMD ["mysqld"]

#CMD ["/etc/init.d/mysql start && tail -F /var/log/mysql.log"]