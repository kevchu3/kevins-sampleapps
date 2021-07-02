#!/bin/bash

# Reference link: https://helm.sh/docs/topics/registries/

htpasswd -cB -b auth.htpasswd admin admin123

# In /etc/containers/registries.conf, update the following to add our registry to the insecure registries:
# [registries.insecure]
# registries = ['10.0.0.1:5000']

cp /etc/containers/registries.conf /etc/containers/registries.conf.bkp
sed -e '/\[registries.insecure\]/{ n; c\' -e 'registries = \["10.0.0.1:5000"\]' -e '}' /etc/containers/registries.conf.bkp > /etc/containers/registries.conf
rm /etc/containers/registries.conf.bkp

# Then restart podman
systemctl restart podman

podman run -dp 5000:5000 --restart=always --name registry \
  -v $(pwd)/auth.htpasswd:/etc/docker/registry/auth.htpasswd:z \
  -e REGISTRY_AUTH="{htpasswd: {realm: localhost, path: /etc/docker/registry/auth.htpasswd}}" \
  registry
rm auth.htpasswd
