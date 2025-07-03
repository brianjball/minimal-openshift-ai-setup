# Minimal Openshift AI Setup

If you want to run multiple components simultaneously, you can install the Serverless Operator and Service Mesh 2 at the same time. These must be installed before OpenShift AI to prevent feature resolution errors.

Be sure to run this out of band to create all of the namespaces required:
```
oc apply -f namespaces.yaml
```

If you want to run this project locally, be sure you are in the project root directory such that you kick of the script by calling `scripts/setup.sh`