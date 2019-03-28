Sample rhel7
------------

The following commands will perform a Docker build to deploy a sample basic rhel7 pod along with OpenShift resources to manage it.  This sample assumes the user has the rhel7 image in the openshift namespace.


    # select working project
    $ oc project sample-sandbox

    # create a build config, deployment config, and imagestream
    $ oc create -f build-config.yml
    $ oc create -f deployment-config.yml
    $ oc create imagestream sample-rhel7

    # start the build process, which triggers a deployment
    $ oc start-build sample-rhel7 --from-dir=.