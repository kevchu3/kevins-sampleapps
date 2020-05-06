# Docker Nexus Repo Manager 3
------------

Refer to the [Sonatype GitHub repository] for the upstream project.  The resources in this project are an addendum intended to deploy the project to OpenShift.

### 1. Determine your OpenShift internal registry name

To push to your OpenShift internal registry, you will need to determine your registry route:

#### OpenShift 3

Locate your registry service with: `oc get svc docker-registry -n default`
This should return `docker-registry.default.svc:5000`

Or locate your route with: ``oc get route docker-registry -n default`
This should return `docker-registry-default.kechung-lab.redhat.com`

#### OpenShift 4

Follow the documentation to [enable the default registry route].  Then, Locate your registry route with: `oc get route -n openshift-image-registry`
This should return `default-route-openshift-image-registry.apps.<your-cluster-domain>`

### 2. Build from Dockerfile

Build and upload the Docker image to the OpenShift nexus namespace as follows

#### Using docker

```
git clone https://github.com/sonatype/docker-nexus3
cd docker-nexus3
docker build --rm=true --tag=<openshift-internal-registry:port>/nexus/docker-nexus3:latest .
docker login <your credentials here> <openshift-internal-registry:port>
oc new-project nexus
docker push <openshift-internal-registry:port>/nexus/docker-nexus3:latest
```

#### Using buildah

```
git clone https://github.com/sonatype/docker-nexus3
cd docker-nexus3
buildah bud -t <openshift-internal-registry:port>/nexus/docker-nexus3:latest .
podman login <your credentials here> <openshift-internal-registry:port>
oc new-project nexus
podman push <openshift-internal-registry:port>/nexus/docker-nexus3:latest

### 3. Create persistent storage

Create a persistent volume and an associated persistent volume claim named nexus-data with RWX access mode.
The storage allocated should be at least 5 GB to meet minimum requirements: `storage.diskCache.diskFreeSpaceLimit=4096`

### 4. Configure and create Openshift resources

```
./runas-setup.sh
oc create -f deployment-config.yml
oc create -f service.yml
oc expose service docker-nexus3
```

[Sonatype Github repository]: https://github.com/sonatype/docker-nexus3
[enable the default registry route]: https://docs.openshift.com/container-platform/latest/registry/configuring-registry-operator.html#registry-operator-default-crd_configuring-registry-operator
