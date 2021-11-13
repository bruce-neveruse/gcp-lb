#!/bin/bash

export PROJECT=playground-s-11-ee6d964f
export PROJECTNUM=168982013313

gcloud config set project $PROJECT

# CREATE INSTANCE TEMPLATE
gcloud beta compute --project=$PROJECT instance-templates create web-server-instance-template --machine-type=f1-micro --network=projects/$PROJECT/global/networks/default --network-tier=PREMIUM --maintenance-policy=MIGRATE --service-account=$PROJECTNUM-compute@developer.gserviceaccount.com --scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append --tags=http-server,https-server --image=debian-10-buster-v20211105 --image-project=debian-cloud --boot-disk-size=10GB --boot-disk-type=pd-balanced --boot-disk-device-name=web-server-instance-template --no-shielded-secure-boot --no-shielded-vtpm --no-shielded-integrity-monitoring --reservation-affinity=any

# CREATE HEALTHCHECK
gcloud compute --project $PROJECT health-checks create https "https-healthcheck" --timeout "5" --check-interval "10" --unhealthy-threshold "3" --healthy-threshold "2" --port "443" --request-path "/"

# CREATE INSTANCE GROUP
gcloud beta compute --project=$PROJECT instance-groups managed create web-server-instance-group-use4 --base-instance-name=web-server-instance-group-use4 --template=web-server-instance-template --size=1 --zone=us-east4-c --health-check=https-healthcheck --initial-delay=300
gcloud beta compute --project $PROJECT instance-groups managed set-autoscaling "web-server-instance-group-use4" --zone "us-east4-c" --cool-down-period "60" --max-num-replicas "2" --min-num-replicas "1" --target-cpu-utilization "0.6" --mode "on"

# CREATE FW RULES
gcloud compute --project=$PROJECT firewall-rules create allow-https-ssh-ingress --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:443,tcp:22 --source-ranges=0.0.0.0/0 --target-tags=https-server


