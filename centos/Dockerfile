FROM scratch

MAINTAINER The CentOS Project <cloud-ops@centos.org> - ami_creator

ADD centos-6-docker.tar.xz /

CMD ["/bin/bash"]

RUN yum -y update \
	&& yum --setopt=tsflags=nodocs -y install \
	gcc.x86_64 \
	gcc-c++.x86_64 \
	httpd.x86_64 \
	mod_ssl.x86_64 \


