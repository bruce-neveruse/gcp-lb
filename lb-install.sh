#!/bin/bash
export PROJECT=$(gcloud projects list --filter playground | grep 'PROJECT_ID: playground' | cut -d ":" -f2 2> /dev/null)
export PROJECTNUM=$(gcloud projects list --filter playground | grep PROJECT_NUMBER: | cut -d ":" -f2 2> /dev/null)
#export PROJECT="gcp-network-x-p-transit-n9l2"
#export PROJECTNUM="253741784104"

gcloud config set project $PROJECT

gcloud compute backend-services create backend \
    --protocol=HTTPS \
    --port-name=https \
    --health-checks=https-healthcheck \
    --global

gcloud compute backend-services add-backend backend \
    --instance-group=web-server-instance-group-use4 \
    --instance-group-zone=us-east4-c \
    --global

gcloud compute url-maps create hmlb \
    --default-service backend

# Create Cert
gcloud compute ssl-certificates create hmlb-cert \
    --domains=hmlb.ddns.net \
    --global

gcloud compute target-https-proxies create https-lb-proxy \
    --url-map=hmlb \
    --ssl-certificates=hmlb-cert

gcloud compute addresses create lb-ipv4-1 \
    --ip-version=IPV4 \
    --global

gcloud compute forwarding-rules create https-content-rule \
    --address=lb-ipv4-1 \
    --global \
    --target-https-proxy=https-lb-proxy \
    --ports=443

#########################################################################
gcloud compute backend-services create backend-app1 \
    --protocol=HTTPS \
    --port-name=https \
    --health-checks=https-healthcheck \
    --global

gcloud compute backend-services add-backend backend-app1 \
    --instance-group=web-server-instance-group-app1 \
    --instance-group-zone=us-east4-c \
    --global

gcloud compute url-maps create hmlb-app1 \
    --default-service backend-app1

# Create Cert
gcloud compute ssl-certificates create hmlb-cert-app1 \
    --domains=hmlb-app1.ddns.net \
    --global

gcloud compute target-https-proxies create https-lb-proxy-app1 \
    --url-map=hmlb-app1 \
    --ssl-certificates=hmlb-cert-app1

gcloud compute addresses create lb-ipv4-app1 \
    --ip-version=IPV4 \
    --global

gcloud compute forwarding-rules create https-content-rule-app1 \
    --address=lb-ipv4-app1 \
    --global \
    --target-https-proxy=https-lb-proxy-app1 \
    --ports=443


#########################################################################
gcloud compute backend-services create backend-app2 \
    --protocol=HTTPS \
    --port-name=https \
    --health-checks=https-healthcheck \
    --global

gcloud compute backend-services add-backend backend-app2 \
    --instance-group=web-server-instance-group-app2 \
    --instance-group-zone=us-east4-c \
    --global

gcloud compute url-maps create hmlb-app2 \
    --default-service backend-app2

# Create Cert
gcloud compute ssl-certificates create hmlb-cert-app2 \
    --domains=hmlb-app2.ddns.net \
    --global

gcloud compute target-https-proxies create https-lb-proxy-app2 \
    --url-map=hmlb-app2 \
    --ssl-certificates=hmlb-cert-app2

gcloud compute addresses create lb-ipv4-app2 \
    --ip-version=IPV4 \
    --global

gcloud compute forwarding-rules create https-content-rule-app2 \
    --address=lb-ipv4-app2 \
    --global \
    --target-https-proxy=https-lb-proxy-app2 \
    --ports=443


