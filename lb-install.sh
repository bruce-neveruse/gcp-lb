#!/bin/bash

gcloud compute --project=$PROJECT backend-services create backend \
    --protocol=HTTPS \
    --port-name=https \
    --health-checks=healthcheck \
    --global

gcloud compute --project=$PROJECT backend-services add-backend backend \
    --instance-group=web-server-instance-group-use4 \
    --instance-group-zone=us-east4-c \
    --global

gcloud compute --project=$PROJECT url-maps create web-map-https \
    --default-service backend

# Create Cert
gcloud compute --project=$PROJECT ssl-certificates create hmlb-cert \
    --domains=hmlb.ddns.net \
    --global

gcloud compute --project=$PROJECT target-https-proxies create https-lb-proxy \
    --url-map=web-map-https \
    --ssl-certificates=hmlb-cert    

gcloud compute --project=$PROJECT forwarding-rules create https-content-rule \
    --address=lb-ipv4-1 \
    --global \
    --target-https-proxy=https-lb-proxy \
    --ports=443
