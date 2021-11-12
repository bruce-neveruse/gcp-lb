# gcp-lb
scripts to create gap load balancer




=================================================================================================================================================================================================================================================================

## CHANGE PROJECT NAME IN web-svr-install.sh SCRIPT AND RUN IN CLOUD CONSOLE GCLOUD

## INSTANCE TEMPLATE
--------gcloud beta compute --project=playground-s-11-823a116c instance-templates create web-server-instance-template --machine-type=f1-micro --network=projects/playground-s-11-823a116c/global/networks/default --network-tier=PREMIUM --maintenance-policy=MIGRATE --service-account=822951814305-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=http-server,https-server --image=debian-10-buster-v20211105 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-balanced --boot-disk-device-name=web-server-instance-template --no-shielded-secure-boot --no-shielded-vtpm --no-shielded-integrity-monitoring --reservation-affinity=any
--------
--------
## HEALTHCHECK 
--------gcloud compute --project "playground-s-11-823a116c" health-checks create https "https-healthcheck" --timeout "5" --check-interval "10" --unhealthy-threshold "3" --healthy-threshold "2" --port "443" --request-path "/"
--------
--------INSTANCE GROUP
--------gcloud beta compute --project=playground-s-11-823a116c instance-groups managed create web-server-instance-group-use4 --base-instance-name=web-server-instance-group-use4 --template=web-server-instance-template --size=1 --zone=us-east4-c --health-check=https-healthcheck --initial-delay=300
--------
--------gcloud beta compute --project "playground-s-11-823a116c" instance-groups managed set-autoscaling "web-server-instance-group-use4" --zone "us-east4-c" --cool-down-period "60" --max-num-replicas "2" --min-num-replicas "1" --target-cpu-utilization "0.6" --mode "on"
--------

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

## CLOUD ARMOUR POLICY
---------- gcloud compute --project=playground-s-11-823a116c security-policies create hm-access --description="only allow 157.154.3.140, 167.164.3.140, and lab proxy 157.154.3.241"                                                 
---------- gcloud compute --project=playground-s-11-823a116c security-policies rules create 0 --action=allow --security-policy=hm-access --src-ip-ranges=157.154.3.140,167.164.3.140,157.154.3.241                                   
---------- gcloud compute --project=playground-s-11-823a116c security-policies rules create 2147483647 --action=deny\(403\) --security-policy=hm-access --description="Default rule, higher priority overrides it" --src-ip-ranges=\*
---------- gcloud compute --project=playground-s-11-823a116c backend-services update backend --security-policy=hm-access                                                                                                             
