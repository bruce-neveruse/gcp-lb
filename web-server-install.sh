#!/bin/bash

export PROJECT=playground-s-11-3846de14
export PROJECTNUM=368678975455

# CREATE INSTANCE TEMPLATE
gcloud beta compute --project=$PROJECT instance-templates create web-server-instance-template --machine-type=f1-micro --network=projects/$PROJECT/global/networks/default --network-tier=PREMIUM --maintenance-policy=MIGRATE --service-account=$PROJECTNUM-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=http-server,https-server --image=debian-10-buster-v20211105 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-balanced --boot-disk-device-name=web-server-instance-template --no-shielded-secure-boot --no-shielded-vtpm --no-shielded-integrity-monitoring --reservation-affinity=any

# CREATE HEALTHCHECK
gcloud compute --project $PROJECT health-checks create https "https-healthcheck" --timeout "5" --check-interval "10" --unhealthy-threshold "3" --healthy-threshold "2" --port "443" --request-path "/"

# CREATE INSTANCE GROUP
gcloud beta compute --project=$PROJECT instance-groups managed create web-server-instance-group-use4 --base-instance-name=web-server-instance-group-use4 --template=web-server-instance-template --size=1 --zone=us-east4-c --health-check=https-healthcheck --initial-delay=300
gcloud beta compute --project $PROJECT instance-groups managed set-autoscaling "web-server-instance-group-use4" --zone "us-east4-c" --cool-down-period "60" --max-num-replicas "2" --min-num-replicas "1" --target-cpu-utilization "0.6" --mode "on"

#CLOUD ARMOUR POLICY
gcloud compute --project=$PROJECT security-policies create hm-access --description="only allow 157.154.3.140, 167.164.3.140, and lab proxy 157.154.3.241"                                                 
gcloud compute --project=$PROJECT security-policies rules create 0 --action=allow --security-policy=hm-access --src-ip-ranges=157.154.3.140,167.164.3.140,157.154.3.241                                   
gcloud compute --project=$PROJECT security-policies rules create 2147483647 --action=deny\(403\) --security-policy=hm-access --description="Default rule, higher priority overrides it" --src-ip-ranges=\*
gcloud compute --project=$PROJECT backend-services update backend --security-policy=hm-access
