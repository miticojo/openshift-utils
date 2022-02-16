#!/usr/bin/env bash

EXPORT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
EXPORT_DIR_WITH_DATE=${EXPORT_DIR}/ocp_export_$(date +%Y%m%d%H%M)

### Setup
mkdir -p "$EXPORT_DIR_WITH_DATE"

echo -n "Exporting cluster conf"
mkdir -p "$EXPORT_DIR_WITH_DATE/cluster"

declare -a clsObjs=(
 "clusternetwork" 
 "clusterpolicy" 
 "clusterpolicybinding" 
 "clusterresourcequota" 
 "clusterrole" 
 "clusterrolebinding" 
 "egressnetworkpolicy" 
 "group" 
 "hostsubnet" 
 "identity" 
 "netnamespace" 
 "networkpolicy" 
 "node" 
 "persistentvolumes" 
 "securitycontextconstraints" 
 "thirdpartyresource" 
 "thirdpartyresourcedata" 
 "user" 
 "useridentitymapping"
 "storageclasses"
 "podpreset"
)

declare -a prjObjs=(
 "namespace"
 "project"
 "pods" 
 "replicationcontrollers" 
 "deploymentconfigs" 
 "buildconfigs" 
 "services" 
 "routes" 
 "pvc" 
 "quota" 
 "hpa" 
 "configmaps" 
 "daemonsets" 
 "deployments" 
 "endpoints" 
 "imagestreams" 
 "ingress" 
 "scheduledjobs" 
 "jobs" 
 "limitranges" 
 "policies" 
 "policybindings" 
 "roles" 
 "rolebindings" 
 "resourcequotas" 
 "replicasets" 
 "serviceaccounts" 
 "templates" 
 "oauthclients" 
 "statefulset"
)

# Export cluster resources 
for OBJ in "${clsObjs[@]}"; do
  oc get "${OBJ}" -o yaml --export=true > "${EXPORT_DIR_WITH_DATE}/cluster/${OBJ}.yaml" 2>/dev/null
  echo -n "."
done
echo -n -e "done\n"

# Export all resources of every project
for project in $(oc get projects --no-headers | awk '{print $1}'); do
    echo -n "Exporting up project $project"
    mkdir -p "${EXPORT_DIR_WITH_DATE}/projects/${project}"
    for OBJ in "${prjObjs[@]}"; do
      oc get "${OBJ}" -n "${project}" -o yaml --export=true > "${EXPORT_DIR_WITH_DATE}/projects/${project}/${OBJ}.yaml" 2>/dev/null
      echo -n "."
    done
    echo -n -e "done\n"
done

echo "Export completed"
exit 0
