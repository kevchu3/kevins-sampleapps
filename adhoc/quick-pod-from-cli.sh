#!/bin/bash
# The following are meant to be to be executed from the oc cli to quickly spin up a pod/application

# create a rhel7 image that prints 'date' every minute
oc run test --image=rhel7:latest -- bash -c 'while true; do date; sleep 60; done'

# create a sleep pod from a Pod definition file
oc create -f sleep-pod.yml 
