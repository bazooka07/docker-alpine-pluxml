# For ALPINE_VERSION you can choose between latest and 3.6
# Take care that php5-xdebug isn't present in latest

# For buiding this image :
# docker build -t XXXX:YYYY .

# For running :
# docker run -v /full-path-for-local-folder-on-disk:/web XXXX:YYYY
# or with an active terminal
# docker run -t -v /full-path-for-local-folder-on-disk:/web XXXX:YYYY /bin/sh

ARG	ALPINE_VERSION=latest

FROM	nimmis/alpine-micro:${ALPINE_VERSION}

# Important pour utiliser ${ALPINE_VERSION}
ARG	ALPINE_VERSION

LABEL	description="Intégration de PluXml dans Docker" \
		maintainer="J.P. Pourrez <kazimentou@gmail.com>" \
		version="2019-10-20"

COPY root/. /

ARG PHP_VERSION=php7

ENV PLUXML_URL https://www.pluxml.org/download/pluxml-latest.zip
ENV PLUGINS_REPO https://kazimentou.fr/pluxml-plugins2/index.php
ENV DOCUMENT_ROOT /web/PluXml

ENV TIMEZONE Europe/Paris

RUN	date -u +"Build of https://github.com/bazooka07/docker-alpine-pluxml on %Y-%m-%dT%H:%M:%S %Z" >> /etc/BUILDS/alpine-micro && \
	echo "PHP version ${PHP_VERSION}" && \
	apk update && apk upgrade && \
	apk add tzdata unzip ${PHP_VERSION}-apache2 \
	    ${PHP_VERSION}-gd ${PHP_VERSION}-xml ${PHP_VERSION}-json ${PHP_VERSION}-zip apache2-utils \
	    ${PHP_VERSION}-curl ${PHP_VERSION}

RUN	[ "${PHP_VERSION}" != 'php7' ] || apk add ${PHP_VERSION}-session

RUN	sed -i 's#PidFile "/run/.*#Pidfile "/web/run/httpd.pid"#g'  /etc/apache2/conf.d/mpm.conf && \
    sed -i 's|/var/log/apache2/|/web/logs/|g' /etc/logrotate.d/apache2

RUN	sh /etc/apache2/tmp/conf.sh

# php-xdebug
RUN echo -e "\e[33mAlpine version: ${ALPINE_VERSION}\e[0m" && \
	echo -e "\e[33mPHP version: ${PHP_VERSION}\e[0m" && \
	if [ "${ALPINE_VERSION}" != '3.6' ] || [ "${PHP_VERSION}" = 'php7' ]; then \
		echo -e "\e[32mInstallation de Xdebug\e[0m"; \
		apk add ${PHP_VERSION}-xdebug && \
		sed -i '/zend_extension/s/^;//' /etc/${PHP_VERSION}/conf.d/xdebug.ini && \
		cat /etc/apache2/tmp/xdebug.conf >> /etc/${PHP_VERSION}/conf.d/xdebug.ini; \
	else \
		echo -e "\e[31mPas de Xdebug pour ces versions\e[0m"; \
	fi

# RUN sh /etc/apache2/tmp/set_xdebug.sh

RUN rm -rf /etc/apache2/tmp && \
	rm -rf /var/cache/apk/*

VOLUME /web

EXPOSE 80 443
