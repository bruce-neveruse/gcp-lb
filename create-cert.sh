#!/bin/bash

sudo mkdir /etc/apache2/certificate
cd /etc/apache2/certificate
sudo openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out apache-certificate.crt -keyout apache.key
