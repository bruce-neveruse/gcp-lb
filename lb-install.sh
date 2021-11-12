#!/bin/bash

gcloud compute backend-services create backend \
    --protocol=HTTPS \
    --port-name=https \
    --health-checks=healthcheck \
    --global

gcloud compute backend-services add-backend backend \
    --instance-group=lb-backend-example \
    --instance-group-zone=us-east4-c \
    --global
