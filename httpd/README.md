Sample httpd
------------

This application assumes the rhel7 image exists in the openshift namespace.  If necessary, import the image:

```
oc import-image rhel7 --from=registry.redhat.io/rhel7/rhel --confirm
```

The following commands will perform a Docker build to deploy a sample httpd application along with OpenShift resources to manage it.

```
# select working project
$ oc project sample-sandbox

# create a build config, deployment config, and imagestream
$ oc create -f build-config.yml
$ oc create -f deployment-config.yml
$ oc create imagestream sample-httpd

# start the build process, which triggers a deployment
$ oc start-build sample-httpd --from-dir=.

# Create a service and expose the route
$ oc create -f service.yml
$ oc expose service httpd

# Create a horizontal pod autoscaler
$ oc autoscale dc/sample-httpd --min 2 --max 5 --cpu-percent=60
```
