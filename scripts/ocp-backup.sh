#!/bin/bash

BACKUP_DIR="/root/openshift_backup"
BACKUP_DIR_WITH_DATE=${BACKUP_DIR}_$(date +%Y%m%d%H%M)

### Setup
mkdir -p $BACKUP_DIR_WITH_DATE

echo -n "Backing cluster conf"
mkdir -p $BACKUP_DIR_WITH_DATE/cluster

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
 "pods" 
 "replicationcontrollers" 
 "deploymentconfigs" 
 "buildconfigs" 
 "services" 
 "routes" 
 "pvc" 
 "quota" 
 "hpa" 
 "secrets" 
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

for OBJ in "${clsObjs[@]}"; do
  oc get ${OBJ} -o json --export=true > "${BACKUP_DIR_WITH_DATE}/cluster/${OBJ}.json" 2>/dev/null
  echo -n "."
done
echo -n -e "done\n"

# Backup all resources of every project
for project in $(oc get projects --no-headers | awk '{print $1}'); do
    echo -n "Backing up project $project"
    mkdir -p ${BACKUP_DIR_WITH_DATE}/projects/${project}
    for OBJ in "${prjObjs[@]}"; do
      oc get ${OBJ} -n ${project} -o json --export=true > "${BACKUP_DIR_WITH_DATE}/projects/${project}/${OBJ}.json" 2>/dev/null
      echo -n "."
    done
    echo -n -e "done\n"
done
