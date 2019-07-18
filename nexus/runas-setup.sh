# Docker image runs as nexus user with UID 200, so set namespace permissions to allow it
oc patch namespace nexus -p '{"metadata":{"annotations":{"openshift.io/sa.scc.uid-range":"200/10000"}}}'
