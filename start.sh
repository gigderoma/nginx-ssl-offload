#!/bin/bash

cd /etc/nginx/cert
openssl ecparam -engine grep11 -name prime256v1 -out prime256v1-param.pem
openssl req -engine grep11 -x509 -sha256 -nodes -days 3650 -subj '/CN=localhost/' -newkey EC:prime256v1-param.pem -keyout nginx-server-prikey-prime256v1-my.pem -out nginx-server-cert-prime256v1.pem

nginx -g 'daemon off;'