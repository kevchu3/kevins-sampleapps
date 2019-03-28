Sample httpd
------------

The following commands will perform a Docker build to deploy a sample httpd application along with OpenShift resources to manage it.  This sample assumes the user has the rhel7 image in the openshift namespace.

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