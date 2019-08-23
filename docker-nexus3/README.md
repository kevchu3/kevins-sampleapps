Docker Nexus Repo Manager 3
------------

Refer to the GitHub repository at https://github.com/sonatype/docker-nexus3 for the base Docker project.  The resources in this project are an addendum intended to deploy the project to OpenShift.

1. Build and upload the Docker image to the OpenShift nexus namespace as follows:
```
git clone https://github.com/sonatype/docker-nexus3
cd docker-nexus3
docker build --rm=true --tag=docker-registry.default.svc:5000/nexus/docker-nexus3:latest .
docker login <your credentials here> docker-registry.default.svc:5000
oc new-project nexus
docker push docker-registry.default.svc:5000/nexus/docker-nexus3:latest
```

2. Create a persistent volume claim named nexus-data with RWX access mode.
The storage allocated should be at least 5 GB to meet minimum requirements:
storage.diskCache.diskFreeSpaceLimit=4096

3. Configure and create OpenShift resources:
```
./runas-setup.sh
oc create -f deployment-config.yml
oc create -f service.yml
oc expose service docker-nexus3
```
