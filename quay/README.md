# Configure Quay Enterprise operator

Refer to this [documentation] for instructions on configuring the Quay Enterprise operator available from OperatorHub.

### Sample files included

Create the quay.io pull secret:
```
oc create -f redhat-quay-pull-secret
```

### Configure SSL certificate

Create an SSL certificate as follows:
```
$ openssl req -newkey rsa:2048 -nodes -keyout quay.key -x509 -days 365 -out quay.crt
$ oc create secret tls custom-quay-ssl --key=quay.key --cert=quay.crt
```

### Deploy QuayEcosystem CR with storage

Create the QuayEcosystem CR with persistent storage:
```
oc create -f example-quayecosystem-persistent.yaml
```

[documentation]: https://access.redhat.com/documentation/en-us/red_hat_quay/3.3/html/deploy_red_hat_quay_on_openshift_with_quay_operator
