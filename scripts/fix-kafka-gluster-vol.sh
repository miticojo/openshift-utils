#!/bin/bash

set -e

ns=application
ssh_cmd="ssh gluster.example.loc"

for i in $(oc get pv -o custom-columns="name:.spec.glusterfs.path,namespace:.spec.claimRef.namespace" | grep $ns | awk '{print $1}'); do
    echo -ne "Setting gluster volume $i:\t"
    $ssh_cmd gluster volume set $i performance.quick-read off > /dev/null 2>&1
    $ssh_cmd gluster volume set $i performance.io-cache off > /dev/null 2>&1
    $ssh_cmd gluster volume set $i performance.write-behind off > /dev/null 2>&1
    $ssh_cmd gluster volume set $i performance.stat-prefetch off > /dev/null 2>&1
    $ssh_cmd gluster volume set $i performance.read-ahead off > /dev/null 2>&1
    $ssh_cmd gluster volume set $i performance.readdir-ahead off  > /dev/null 2>&1
    $ssh_cmd gluster volume set $i performance.open-behind off  > /dev/null 2>&1
    $ssh_cmd gluster volume set $i performance.client-io-threads off  > /dev/null 2>&1
    echo "OK"
done
