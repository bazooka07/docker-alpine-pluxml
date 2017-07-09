# For ALPINE_VERSION you can choose between latest and 3.6
# Take care that php5-xdebug isn't present in latest
ARG	ALPINE_VERSION=latest

FROM	nimmis/alpine-micro:${ALPINE_VERSION}

LABEL	description="Intégration de PluXml dans Docker" \
		maintainer="J.P. Pourrez <kazimentou@gmail.com>" \
		version="2017-07-09"

COPY root/. /

ARG PHP_VERSION=php7
# ENV	PHP_VERSION php7
ENV PLUXML_URL http://telechargements.pluxml.org/download.php
ENV DOCUMENT_ROOT /web/PluXml

ENV TIMEZONE Europe/Paris

	# Make info file about this build
RUN	printf "Build of bazooka07/docker-apache-pluxml, date: %s\n" "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" >> /etc/BUILD

RUN apk update && apk upgrade && \

	apk add unzip ${PHP_VERSION}-apache2 \
	    ${PHP_VERSION}-gd ${PHP_VERSION}-xml ${PHP_VERSION}-zip apache2-utils \
	    ${PHP_VERSION}-curl

RUN	[ ${PHP_VERSION} != 'php7' ] || apk add ${PHP_VERSION}-session

RUN	apk add ${PHP_VERSION}-xdebug

RUN	sed -i 's#PidFile "/run/.*#Pidfile "/web/run/httpd.pid"#g'  /etc/apache2/conf.d/mpm.conf && \
    sed -i 's|/var/log/apache2/|/web/logs/|g' /etc/logrotate.d/apache2

RUN	sh /etc/apache2/tmp/conf.sh

# php-xdebug
RUN	sed -i '/zend_extension/s/^;//' /etc/${PHP_VERSION}/conf.d/xdebug.ini && \
	cat /etc/apache2/tmp/xdebug.conf >> /etc/${PHP_VERSION}/conf.d/xdebug.ini

RUN rm -rf /etc/apache2/tmp && \
	rm -rf /var/cache/apk/*

VOLUME /web

EXPOSE 80 443