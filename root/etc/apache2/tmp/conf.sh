#!/bin/sh

sed -i -e "\
s|^DocumentRoot\s.*|DocumentRoot \"${DOCUMENT_ROOT}\"|g; \
s|AllowOverride none|AllowOverride All|; \
s|^ServerRoot .*|ServerRoot /web|g; \
s|^#ServerName.*|ServerName webproxy|; \
s|^IncludeOptional /etc/apache2/conf|IncludeOptional /web/config/conf|g; \
s|Directory \"/var/www/localhost/htdocs.*|Directory \"${DOCUMENT_ROOT}\" >|g; \
s|Directory \"/var/www/localhost/cgi-bin.*|Directory \"/web/cgi-bin\" >|g;
s|Options Indexes|Options |g; \
/session_module/s|^#||; /rewrite_module/s|^#||" /etc/apache2/httpd.conf