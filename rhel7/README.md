Sample rhel7
------------

This application assumes the rhel7 image exists in the openshift namespace.  If necessary, import the image:

```
oc import-image rhel7 --from=registry.redhat.io/rhel7/rhel --confirm
```

The following commands will perform a Docker build to deploy a sample basic rhel7 pod along with OpenShift resources to manage it.

```
# select working project
$ oc project sample-sandbox

# create a build config, deployment config, and imagestream
$ oc create -f build-config.yml
$ oc create -f deployment-config.yml
$ oc create imagestream sample-rhel7

# start the build process, which triggers a deployment
$ oc start-build sample-rhel7 --from-dir=.
```
