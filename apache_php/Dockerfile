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
	-e 's~^DirectoryIndex \(.*\)$~DirectoryIndex \1 index.php~g' \
	-e 's~^Group apache$~Group app~g' \
	-e 's~^IndexOptions \(.*\)$~#IndexOptions \1~g' \
	-e 's~^IndexIgnore \(.*\)$~#IndexIgnore \1~g' \
	-e 's~^AddIconByEncoding \(.*\)$~#AddIconByEncoding \1~g' \
	-e 's~^AddIconByType \(.*\)$~#AddIconByType \1~g' \
	-e 's~^AddIcon \(.*\)$~#AddIcon \1~g' \
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
	-e '/#<Location \/server-status>/,/#<\/Location>/ s~^#~~' \
	-e '/<Location \/server-status>/,/<\/Location>/ s~Allow from .example.com~Allow from localhost 127.0.0.1~' \
	-e 's~^StartServers \(.*\)$~StartServers 3~g' \
	-e 's~^MinSpareServers \(.*\)$~MinSpareServers 3~g' \
	-e 's~^MaxSpareServers \(.*\)$~MaxSpareServers 3~g' \
	-e 's~^ServerLimit \(.*\)$~ServerLimit 10~g' \
	-e 's~^MaxClients \(.*\)$~MaxClients 10~g' \
	-e 's~^MaxRequestsPerChild \(.*\)$~MaxRequestsPerChild 1000~g' \
	/etc/httpd/conf/httpd.conf



