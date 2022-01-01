#!/bin/bash

## RUN AFTER LB IS CREATED

export PROJECT=$(gcloud projects list --filter playground | grep 'PROJECT_ID: playground' | cut -d ":" -f2 2> /dev/null)
export PROJECTNUM=$(gcloud projects list --filter playground | grep PROJECT_NUMBER: | cut -d ":" -f2 2> /dev/null)

#CLOUD ARMOUR POLICY
gcloud compute --project=$PROJECT security-policies create hm-access --description="only allow 157.154.3.140, 167.164.3.140, lab proxy 157.154.3.241, and home network"
gcloud compute --project=$PROJECT security-policies rules create 0 --action=allow --security-policy=hm-access --src-ip-ranges=157.154.3.140,167.164.3.140,157.154.3.241,152.208.2.117
gcloud compute --project=$PROJECT security-policies rules update 2147483647 --action=deny-403 --security-policy=hm-access --description="Default rule, higher priority overrides it" --src-ip-ranges=\*
gcloud compute --project=$PROJECT backend-services update backend --security-policy=hm-access
