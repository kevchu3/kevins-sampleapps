# Configure Quay Enterprise operator

Refer to this [documentation] for instructions on configuring the Quay Enterprise operator available from OperatorHub.

### Sample files included

Create the quay.io pull secret with: `oc create -f redhat-quay-pull-secret`

Create the ephemeral QuayEcosystem with: `oc create -f example-quayecosystem.yml`

### Optional: Configure persistence

Configure persistence for Quay Enterprise via the local storage operator.  I followed these steps to configure the [local storage operator]

Then, create the persistent QuayEcosystem with: `oc create -f example-quayecosystem-persistent.yml`

[documentation]: https://github.com/redhat-cop/quay-operator
[local storage operator]: https://github.com/kevchu3/openshift4-upi-homelab/tree/master/operator/local-storage
