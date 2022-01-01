#!/bin/bash

export PROJECT=$(gcloud projects list --filter playground | grep 'PROJECT_ID: playground' | cut -d ":" -f2 2> /dev/null)
export PROJECTNUM=$(gcloud projects list --filter playground | grep PROJECT_NUMBER: | cut -d ":" -f2 2> /dev/null)

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
