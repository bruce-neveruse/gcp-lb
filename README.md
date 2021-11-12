# gcp-lb
scripts to create gcp load balancer


## CHANGE PROJECT NAME AND SERVICE ACCOUNT IN web-svr-install.sh SCRIPT AND RUN IN CLOUD CONSOLE GCLOUD

## SSH TO WEB SERVER VM AND INSTALL APACHE2
sudo apt-get update

sudo apt-get install apache2 openssl

sudo a2enmod ssl

sudo a2enmod rewrite
 
sudo nano /etc/apache2/apache2.conf

 <Directory /var/www/html>

	AllowOverride All
    
 </Directory>


## CREATE CERT
sudo mkdir /etc/apache2/certificate

cd /etc/apache2/certificate

sudo openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out apache-certificate.crt -keyout apache.key

sudo nano /etc/apache2/sites-enabled/000-default.conf

## ADD THIS AND COMMENT WHATS THERE

<VirtualHost *:443>

        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined
        SSLEngine on
        SSLCertificateFile /etc/apache2/certificate/apache-certificate.crt
        SSLCertificateKeyFile /etc/apache2/certificate/apache.key
</VirtualHost>

sudo service apache2 restart

## FIREWALL RULES
gcloud compute --project=playground-s-11-823a116c firewall-rules create allow-https-ssh-ingress --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:443,tcp:22 --source-ranges=0.0.0.0/0 --target-tags=https-server

## SHOULD BE ABLE TO TEST WITHOUT LB NOW
## CREATE LB
## CHANGE DNS IN my.noip.com  -- FQDN HAS TO MATCH BETWEEN LB CERT AND WEB SERVER CERT
hmlb.ddns.net

## CHANGE PROJECT NAME IN cloud-armour-install.sh SCRIPT AND RUN IN CLOUD CONSOLE GCLOUD

