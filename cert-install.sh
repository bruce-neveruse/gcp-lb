#!/bin/bash

gcloud compute ssl-certificates create hmlb-cert \
    --domains=hmlb.ddns.net \
    --global
