#!/usr/bin/bash
set -e

TIMEOUT_SECONDS=60

wait_for_service_mesh(){
  echo "Checking status of all service_mesh pre-reqs"

  SERVICEMESH_RESOURCES=(
    crd/knativeservings.operator.knative.dev:condition=established
    crd/servicemeshcontrolplanes.maistra.io:condition=established
  )

  for crd in "${SERVICEMESH_RESOURCES[@]}"
  do
    RESOURCE=$(echo "$crd" | cut -d ":" -f 1 | cut -d "/" -f 2- )
    while [[ $(oc get crd) != *"$RESOURCE"* ]]
    do
      echo "Waiting for ${RESOURCE} to be created"
      sleep 5
    done
  done

  for crd in "${SERVICEMESH_RESOURCES[@]}"
  do
    RESOURCE=$(echo "$crd" | cut -d ":" -f 1)
    CONDITION=$(echo "$crd" | cut -d ":" -f 2)

    echo "Waiting for ${RESOURCE} state to be ${CONDITION}..."
    oc wait --for="${CONDITION}" "${RESOURCE}" --timeout="${TIMEOUT_SECONDS}s"
  done
}

wait_for_openshift_ai(){
  echo "Checking status of all service_mesh pre-reqs"

  SERVICEMESH_RESOURCES=(
    datascienceclusters.datasciencecluster.opendatahub.io
  )

  for crd in "${SERVICEMESH_RESOURCES[@]}"
  do
    RESOURCE=$(echo "$crd")
    while [[ $(oc get crd) != *"$RESOURCE"* ]]
    do
      echo "Waiting for ${RESOURCE} to be created"
      sleep 5
    done
  done
}

oc apply -f scripts/dependency-manifests/
wait_for_service_mesh

oc apply -f scripts/openshift-ai/
wait_for_openshift_ai

oc apply -f scripts/datasciencecluster/