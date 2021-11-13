## gcp-lb Instructions
scripts to create gcp load balancer


### CHANGE PROJECT NAME AND SERVICE ACCOUNT IN web-svr-install.sh SCRIPT AND RUN IN CLOUD CONSOLE GCLOUD

### SSH TO WEB SERVER VM AND INSTALL APACHE2
```
sudo nano /etc/apache2/apache2.conf
```
```
<Directory /var/www/html>
	AllowOverride All
</Directory>
```

### CREATE CERT
```
sudo mkdir /etc/apache2/certificate
cd /etc/apache2/certificate
sudo openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out apache-certificate.crt -keyout apache.key
```

### ADD HTTPS CAPABILITY TO WEB SERVER
```
sudo nano /etc/apache2/sites-enabled/000-default.conf
```
### ADD THIS AND YOU CAN REMOVE OR COMMENT WHATS THERE
```
<VirtualHost *:443>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
        SSLEngine on
        SSLCertificateFile /etc/apache2/certificate/apache-certificate.crt
        SSLCertificateKeyFile /etc/apache2/certificate/apache.key
</VirtualHost>
```
```
sudo service apache2 restart
```
** SHOULD BE ABLE TO TEST WITHOUT LB NOW 

### FROM CLOUD SHELL, RUN lb-install.sh

```
./lb-install.sh
```
or

### MANUALLY CREATE LB IN [GOOGLE CLOUD CONSOLE](https://console.cloud.google.com/net-services/loadbalancing/add/https?:target="_blank")

### CHANGE DNS IN my.noip.com  -- FQDN HAS TO MATCH BETWEEN LB CERT AND WEB SERVER CERT
hmlb.ddns.net

### CHANGE PROJECT NAME IN cloud-armour-install.sh SCRIPT AND RUN IN CLOUD CONSOLE GCLOUD

