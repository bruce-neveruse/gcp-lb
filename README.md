# gcp-lb Instructions
See steps below to create a gcp load balancer and cloud armour policy.  Feel free to edit any of the shell scripts to match your specific needs.

### CONNECT TO CLOUD SHELL AND CLONE THE REPO
```
git clone https://github.com/bruce-neveruse/gcp-lb.git
cd gcp-lb
sudo chmod 757 *.sh
gcloud projects list
```

### IN CLOUD SHELL EXECUTE web-svr-install.sh
```
./web-server-install.sh
```

###  SSH TO WEB SERVER VM FROM [COMPUTE INSTANCES](https://console.cloud.google.com/compute/instances?:target="_blank") AND UPDATE APACHE2.CONF
```
sudo nano /etc/apache2/apache2.conf
```
```
<Directory /var/www/html>
	AllowOverride All
</Directory>
```

### RUN CREATE CERT SCRIPT
```
./create-cert.sh
```
### OR COPY PASTE THESE COMMANDS
```
sudo mkdir /etc/apache2/certificate
cd /etc/apache2/certificate
sudo openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out apache-certificate.crt -keyout apache.key
```

### ADD HTTPS CAPABILITY TO WEB SERVER
```
sudo nano /etc/apache2/sites-enabled/000-default.conf
```
### PASTE THE FOLLOWING AND REMOVE OR COMMENT THE EXISTING LINES
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

### RETURN TO CLOUD SHELL AND RUN lb-install.sh

```
./lb-install.sh
```
or

### IF SCRIPT FAILS, MANUALLY CREATE LB IN [GOOGLE CLOUD CONSOLE](https://console.cloud.google.com/net-services/loadbalancing/add/https?:target="_blank")

### CHANGE DNS IN my.noip.com  -- FQDN HAS TO MATCH BETWEEN LB CERT AND WEB SERVER CERT
hmlb.ddns.net

### RETURN TO CLOUD SHELL AND RUN cloud-armour-install.sh
```
./cloud-armour-install.sh
```



