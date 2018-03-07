# -*- mode: ruby -*-
# vi: set ft=ruby :

OCP_MASTER_HOSTS = 1
OCP_NODES_HOSTS = 4
USE_LOCAL_REPO = false
LOCAL_REPO_URL = "http://#{ENV['local_yum_repo']}:8000"
RHN_USER = ENV['rh_user']
RHN_PASS = ENV['rh_pass']
RHN_POOL_ID = ENV['rh_pool']
PRIVATE_NET = "192.168.33."
OCP_VERSION = 3.6
OCP_DOMAIN = 'example.loc'
OCP_PUBLIC_DOMAIN = 'example.com'

# vagrant plugins to install
plugins = ["vagrant-sshfs", "vagrant-registration"]

plugins.each do |plugin|
  unless Vagrant.has_plugin?(plugin)
    system("vagrant plugin install #{plugin}")
    abort("Plugin installed - run 'vagrant up' again")
  end
end

Vagrant.configure("2") do |config|
  config.vm.synced_folder '.', '/vagrant', disabled: true

  if Vagrant.has_plugin?('vagrant-registration')
    if USE_LOCAL_REPO
      config.registration.skip = true
    end
    config.registration.username = "#{RHN_USER}"
    config.registration.password = "#{RHN_PASS}"
    config.registration.auto_attach = false
    config.registration.pools = ["#{RHN_POOL_ID}"]
  end

  (1..OCP_MASTER_HOSTS).each do |i|
    config.vm.define "ocp-master#{i}" do |node|
      node.vm.box = "rhel/7.4"
      node.vm.hostname = "ocp-master#{i}.#{OCP_DOMAIN}"
      node.vm.network "private_network", ip: "#{PRIVATE_NET}1#{i}"

      node.vm.provider :vmware_fusion do |vb, override|
        vb.memory = "2048"
        vb.cpus = 1
      end

      node.vm.provider :virtualbox do |vb, override|
        vb.memory = "2048"
        vb.cpus = 1
      end

      node.vm.provider :libvirt do |vb, override|
        vb.cpus = 1
        vb.memory = "2048"
      end
    end
  end


  (1..OCP_NODES_HOSTS).each do |i|
    config.vm.define "ocp-node#{i}" do |node|
      node.vm.box = "rhel/7.4"
      node.vm.hostname = "ocp-node#{i}.#{OCP_DOMAIN}"
      node.vm.network "private_network", ip: "#{PRIVATE_NET}2#{i}"

      node.vm.provider :vmware_fusion do |vb, override|
        vb.memory = "2048"
        vb.cpus = 2
      end

      node.vm.provider :virtualbox do |vb, override|
        vb.memory = "2048"
        vb.cpus = 2
      end

      node.vm.provider :libvirt do |vb, override|
        vb.memory = 2048
        vb.cpus = 2
      end

      if i == OCP_NODES_HOSTS
        node.vm.provision :ansible do |ansible|
          ansible.playbook = "vagrant.yml"
          ansible.become = true
          ansible.groups = {
           "masters" => ["ocp-master[1:#{OCP_MASTER_HOSTS}]"],
           "etcd" => ["ocp-master[1:#{OCP_MASTER_HOSTS}]"],
           "nodes" => ["ocp-node[1:#{OCP_NODES_HOSTS}]", "ocp-master[1:#{OCP_MASTER_HOSTS}]"],
           "OSEv3:children" => ["masters", "nodes"],
           }
           ansible.limit = "ocp-*"
           ansible.become = true
           ansible.extra_vars = {
             "ocp_rhn_user": RHN_USER,
             "ocp_rhn_pass": RHN_PASS,
             "ocp_rhn_pool_ids": RHN_POOL_ID,
             "domain": OCP_DOMAIN,
             "public_domain": OCP_PUBLIC_DOMAIN,
             "ocp_version": OCP_VERSION
           }
           if USE_LOCAL_REPO
             ansible.extra_vars["ocp_local_package_repository_url"] = LOCAL_REPO_URL
             ansible.extra_vars["ocp_local_package_repository"] = true
           end
        end
      end
    end
  end
end
