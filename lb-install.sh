#!/bin/bash

gcloud compute backend-services create backend \
    --protocol=HTTPS \
    --port-name=https \
    --health-checks=healthcheck \
    --global

gcloud compute backend-services add-backend backend \
    --instance-group=web-server-instance-group-use4 \
    --instance-group-zone=us-east4-c \
    --global

gcloud compute url-maps create web-map-https \
    --default-service backend
