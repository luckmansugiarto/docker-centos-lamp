FROM luckmanqusol/local-dev:centos_6

ARG uid=1000
ARG user
ARG server_name

# -----------------------------------------------------------------------------
# Apache + PHP
# -----------------------------------------------------------------------------
RUN yum -y update \
	&& yum --setopt=tsflags=nodocs -y install \
	gcc.x86_64 \
	gcc-c++.x86_64 \
	httpd.x86_64 \
	mod_ssl.x86_64 \	
	php.x86_64 \
	php-mysql.x86_64 \
	php-cli.x86_64 \
	php-devel.x86_64 \
	php-pdo.x86_64 \
	php-mbstring.x86_64 \
	php-soap.x86_64 \
	php-gd.x86_64 \
	php-xml.x86_64 \
	php-pecl-apc.x86_64 \
	unzip.x86_64 \
	&& rm -rf /var/cache/yum/* \
	yum clean all

# -----------------------------------------------------------------------------
# Add default service users
# -----------------------------------------------------------------------------
RUN useradd -u ${uid} -d /var/www/$user -m $user \
	&& usermod -a -G $user apache

# -----------------------------------------------------------------------------
# Create the initial directory structure
# -----------------------------------------------------------------------------
RUN mkdir -p /var/www/$user/{public_html,var/{log,session}}

# -----------------------------------------------------------------------------
# Global Apache configuration changes
# Disable Apache directory indexes
# Disable Apache language based content negotiation
# Disable all Apache modules and enable the minimum
# Enable ServerStatus access via /_httpdstatus to local client
# Apache tuning
# -----------------------------------------------------------------------------
RUN sed -i \
	-e 's~^ServerSignature On$~ServerSignature Off~g' \
	-e 's~^ServerTokens OS$~ServerTokens Prod~g' \
	-e 's~^DirectoryIndex \(.*\)$~DirectoryIndex index.php \1~g' \
	-e 's~^Group apache$~Group app~g' \
	-e "s/^#ServerName \(.*\)/ServerName ${server_name}/g" \
	-e 's~^IndexOptions \(.*\)$~#IndexOptions \1~g' \
	-e 's~^IndexIgnore \(.*\)$~#IndexIgnore \1~g' \
	-e 's~^AddIconByEncoding \(.*\)$~#AddIconByEncoding \1~g' \
	-e 's~^AddIconByType \(.*\)$~#AddIconByType \1~g' \
	-e 's~^AddIcon \(.*\)$~#AddIcon \1~g' \
	-e "s/^DocumentRoot \(.*\)/DocumentRoot \/var\/www\/${user}\/public_html/g" \
	-e 's~^DefaultIcon \(.*\)$~#DefaultIcon \1~g' \
	-e 's~^ReadmeName \(.*\)$~#ReadmeName \1~g' \
	-e 's~^HeaderName \(.*\)$~#HeaderName \1~g' \
	-e 's~^LanguagePriority \(.*\)$~#LanguagePriority \1~g' \
	-e 's~^ForceLanguagePriority \(.*\)$~#ForceLanguagePriority \1~g' \
	-e 's~^AddLanguage \(.*\)$~#AddLanguage \1~g' \
	-e 's~^\(LoadModule .*\)$~#\1~g' \
	-e 's~^\(#LoadModule version_module modules/mod_version.so\)$~\1\n#LoadModule reqtimeout_module modules/mod_reqtimeout.so~g' \
	-e 's~^#LoadModule mime_module ~LoadModule mime_module ~g' \
	-e 's~^#LoadModule log_config_module ~LoadModule log_config_module ~g' \
	-e 's~^#LoadModule setenvif_module ~LoadModule setenvif_module ~g' \
	-e 's~^#LoadModule status_module ~LoadModule status_module ~g' \
	-e 's~^#LoadModule authz_host_module ~LoadModule authz_host_module ~g' \
	-e 's~^#LoadModule dir_module ~LoadModule dir_module ~g' \
	-e 's~^#LoadModule alias_module ~LoadModule alias_module ~g' \
	-e 's~^#LoadModule rewrite_module ~LoadModule rewrite_module ~g' \
	-e 's~^#LoadModule expires_module ~LoadModule expires_module ~g' \
	-e 's~^#LoadModule deflate_module ~LoadModule deflate_module ~g' \
	-e 's~^#LoadModule headers_module ~LoadModule headers_module ~g' \
	-e 's~^#LoadModule alias_module ~LoadModule alias_module ~g' \
	-e 's~^#LoadModule proxy_module ~LoadModule proxy_module ~g' \
	-e 's~^#LoadModule proxy_balancer ~LoadModule proxy_balancer ~g' \
	-e 's~^#LoadModule proxy_http_module ~LoadModule proxy_http_module ~g' \
	#-e '/LoadModule .*mod_speling.so/aLoadModule ssl_module modules/mod_ssl.so' \
	-e '/#<Location \/server-status>/,/#<\/Location>/ s~^#~~' \
	-e '/<Location \/server-status>/,/<\/Location>/ s~Allow from .example.com~Allow from localhost 127.0.0.1~' \
	-e 's~^StartServers \(.*\)$~StartServers 3~g' \
	-e 's~^MinSpareServers \(.*\)$~MinSpareServers 3~g' \
	-e 's~^MaxSpareServers \(.*\)$~MaxSpareServers 3~g' \
	-e 's~^ServerLimit \(.*\)$~ServerLimit 10~g' \
	-e 's~^MaxClients \(.*\)$~MaxClients 10~g' \
	-e 's~^MaxRequestsPerChild \(.*\)$~MaxRequestsPerChild 1000~g' \
	/etc/httpd/conf/httpd.conf

# -----------------------------------------------------------------------------
# Global PHP configuration changes
# -----------------------------------------------------------------------------
RUN sed -i \
	-e '/^;date.timezone =/cdate.timezone = UTC' \
	-e '/^;user_ini.filename =/cuser_ini.filename =' \
	-e '/^;always_populate_raw_post_data = -1/calways_populate_raw_post_data = -1' \
	-e '/^;user_ini.filename =/cuser_ini.filename =' \
	-e '/^register_globals =/cregister_globals = On' \
	-e '/^short_open_tag =/cshort_open_tag = On' \
	-e '/^memory_limit =/cmemory_limit = 256M' \
	-e '/^display_startup_errors =/cdisplay_startup_errors = On' \
	-e '/^register_argc_argv =/cregister_argc_argv = On' \
	-e '/^upload_max_filesize =/cupload_max_filesize = 512M' \
	-e '/^\(extension .*\)/c;\1' \
	-e '/^;extension=php_bz2.dll/cextension=php_bz2.dll' \
	-e '/^;extension=php_curl.dll/cextension=php_curl.dll' \
	-e '/^;extension=php_gd2.dll/cextension=php_gd2.dll' \
	-e '/^;extension=php_gettext.dll/cextension=php_gettext.dll' \
	-e '/^;extension=php_mbstring.dll/cextension=php_mbstring.dll' \
	-e '/^;extension=php_mysql.dll/cextension=php_mysql.dll' \
	-e '/^;extension=php_mysqli.dll/cextension=php_mysqli.dll' \
	-e '/^;extension=php_openssl.dll/cextension=php_openssl.dll' \
	-e '/^;extension=php_pdo_mysql.dll/cextension=php_pdo_mysql.dll' \
	-e '/^;extension=php_soap.dll/cextension=php_soap.dll' \
	-e '/^;extension=php_xmlrpc.dll/cextension=php_xmlrpc.dll' \
	/etc/php.ini

# -----------------------------------------------------------------------------
# Set permissions
# -----------------------------------------------------------------------------
RUN chown -R $user:$user /var/www/$user \
	&& chmod 770 /var/www/$user \
	&& chmod -R g+w /var/www/$user/var

# -----------------------------------------------------------------------------
# Remove packages
# -----------------------------------------------------------------------------
RUN yum -y remove \
	gcc \
	gcc-c++ \
	&& rm -rf /var/cache/yum/* \
	&& yum clean all

# -----------------------------------------------------------------------------
# Set default environment variables used to identify the service container
# -----------------------------------------------------------------------------
ENV SERVICE_UNIT_APP_GROUP $user-1 
ENV	SERVICE_UNIT_LOCAL_ID 1
ENV	SERVICE_UNIT_INSTANCE 1

# -----------------------------------------------------------------------------
# Set default environment variables used to configure the service container
# -----------------------------------------------------------------------------
ENV APACHE_SERVER_ALIAS "" 
ENV	APACHE_SERVER_NAME $user-1.local 
ENV	APP_HOME_DIR /var/www/$user
ENV	DATE_TIMEZONE UTC 
ENV	HTTPD /usr/sbin/httpd 
ENV	SERVICE_USER $user 
ENV	SERVICE_USER_GROUP $user 
ENV	SERVICE_USER_PASSWORD "" 
ENV	SUEXECUSERGROUP false 
ENV	TERM xterm
ENV DB_MYSQL_PORT_3306_TCP_ADDR ""
ENV DB_MYSQL_PORT_3306_TCP_PORT ""

# -----------------------------------------------------------------------------
# Set ports
# -----------------------------------------------------------------------------
EXPOSE 80 443

CMD ["/usr/sbin/httpd", "-DFOREGROUND"]