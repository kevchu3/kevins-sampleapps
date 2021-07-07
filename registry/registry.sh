#!/bin/bash

# Reference link: https://helm.sh/docs/topics/registries/

htpasswd -cB -b /opt/registry/auth/htpasswd admin admin123

# Set up TLS for registry
mkdir -p /opt/registry/certs
openssl req -newkey rsa:4096 -nodes -sha256 -keyout /opt/registry/certs/myregistry.key -x509 -days 365 -out /opt/registry/certs/myregistry.crt
cp /opt/registry/certs/myregistry.crt /etc/pki/ca-trust/source/anchors/
update-ca-trust

mkdir -p /opt/registry/data
mkdir -p /opt/registry/auth

# Then restart podman
systemctl restart podman

podman run --name myregistry \
-p 5000:5000 \
-v /opt/registry/data:/var/lib/registry:z \
-v /opt/registry/auth:/auth:z \
-e "REGISTRY_AUTH=htpasswd" \
-e "REGISTRY_AUTH_HTPASSWD_REALM=Registry Realm" \
-e REGISTRY_AUTH_HTPASSWD_PATH=/auth/htpasswd \
-v /opt/registry/certs:/certs:z \
-e "REGISTRY_HTTP_TLS_CERTIFICATE=/certs/myregistry.crt" \
-e "REGISTRY_HTTP_TLS_KEY=/certs/myregistry.key" \
-e REGISTRY_COMPATIBILITY_SCHEMA1_ENABLED=true \
-d \
docker.io/library/registry:latest
