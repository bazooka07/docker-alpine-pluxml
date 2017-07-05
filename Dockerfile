FROM nimmis/alpine-micro:3.6

MAINTAINER nimmis <kjell.havneskold@gmail.com>

COPY root/. /

ENV PHP_VERSION php7
ENV PLUXML_URL http://telechargements.pluxml.org/download.php
ENV DOCUMENT_ROOT /web/PluXml

ENV TIMEZONE Europe/Paris

RUN apk update && apk upgrade && \

	# cp /etc/localtime /etc/timezone /usr/local/etc && \

    # Make info file about this build
    printf "Build of bazooka07/docker-apache-pluxml, date: %s\n" "$(date -u +"%Y-%m-%dT%H:%M:%SZ")" >> /etc/BUILD && \

#   apk add apache2 apache2-utils \
	apk add unzip ${PHP_VERSION}-apache2 ${PHP_VERSION}-session \
	    ${PHP_VERSION}-gd ${PHP_VERSION}-xml ${PHP_VERSION}-zip apache2-utils \
	    ${PHP_VERSION}-curl ${PHP_VERSION}-xdebug && \
#    mkdir /web/ && chown -R apache.www-data /web && \

    sed -i 's#PidFile "/run/.*#Pidfile "/web/run/httpd.pid"#g'  /etc/apache2/conf.d/mpm.conf && \
    sed -i 's|/var/log/apache2/|/web/logs/|g' /etc/logrotate.d/apache2

RUN	sh /etc/apache2/tmp/conf.sh && \
	sed -i '/zend_extension/s/^;//' /etc/${PHP_VERSION}/conf.d/xdebug.ini && \
	cat /etc/apache2/tmp/xdebug.conf >> /etc/${PHP_VERSION}/conf.d/xdebug.ini

RUN rm -rf /etc/apache2/tmp && \
	rm -rf /var/cache/apk/*

VOLUME /web

EXPOSE 80 443