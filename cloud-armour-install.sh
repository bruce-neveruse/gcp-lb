#!/bin/bash

## RUN AFTER LB IS CREATED

export PROJECT=playground-s-11-823a116c

#CLOUD ARMOUR POLICY
gcloud compute --$PROJECT security-policies create hm-access --description="only allow 157.154.3.140, 167.164.3.140, and lab proxy 157.154.3.241"
gcloud compute --$PROJECT security-policies rules create 0 --action=allow --security-policy=hm-access --src-ip-ranges=157.154.3.140,167.164.3.140,157.154.3.241
gcloud compute --$PROJECT security-policies rules create 2147483647 --action=deny\(403\) --security-policy=hm-access --description="Default rule, higher priority overrides it" --src-ip-ranges=\*
gcloud compute --$PROJECT backend-services update backend --security-policy=hm-access