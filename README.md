# openshift-utils
Some utils for Openshift admin operations

## Vagrant lab
Tested with Vagrant 2.x and provider libvirt/virtualbox/vmware_fusion

### Requirements
* vagrant >= 2.0
* hypervisor: libvirt(KVM) or virtualbox or/and vmware_fusion
* vagrant box rhel 7.4 for your hypervisor
* vagrant plugins:
  * vagrant-sshfs
  * vagrant-registration
  * vagrant-libvirt-plugin (if you use libvirt)
  * vagrant-vmware-plugin (if you use vmware - need license)
* env variables:
  * RHN_USER - Red Hat Network username
  * RHN_PASS - Red Hat Network username
  * RHN_POOL_ID - Red Hat Network pool for Openshift Container Platform

### Run your lab
Adjust following variables into Vagrantfile
‘’‘
OCP_MASTER_HOSTS = 1
OCP_NODES_HOSTS = 4
OCP_VERSION = 3.6
‘’‘
then call ‘vagrant up’

**NOTE:** 
During box rising vagrant-registration plugin will register automatically your machine to RHN.
