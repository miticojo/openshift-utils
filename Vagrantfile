# -*- mode: ruby -*-
# vi: set ft=ruby :

OCP_MASTER_HOSTS = 1
OCP_NODES_HOSTS = 2
OCP_INFRA_HOSTS = 2
OCP_INFRA = true
USE_LOCAL_REPO = true
LOCAL_REPO_URL = "http://#{ENV['local_yum_repo']}:8000"
RHN_USER = ENV['rh_user']
RHN_PASS = ENV['rh_pass']
RHN_POOL_ID = ENV['rh_pool']
PRIVATE_NET = "192.167.33."
OCP_VERSION = '3.9'
OCP_DOCKER_VER = '1.13.1'
OCP_DOMAIN = 'example.loc'
OCP_PUBLIC_DOMAIN = 'example.com'
OCP_MASTER_SUBDOMAIN = 'apps.example.com'
OCP_LOGGING = false
OCP_METRICS = false
OCP_SVC_CATALOG = false
OCP_ASB = false
OCP_NET_PLUGIN = 'redhat/openshift-ovs-multitenant'
OCP_CONTAINER_RUNTIME_STORAGE = 'overlay2'
RHEL_VERSION = '7.5'
# vagrant plugins to install
plugins = ["vagrant-sshfs", "vagrant-registration"]

plugins.each do |plugin|
  unless Vagrant.has_plugin?(plugin)
    system("vagrant plugin install #{plugin}")
    abort("Plugin installed - run 'vagrant up' again")
  end
end

if ARGV[1] and \
   (ARGV[1].split('=')[0] == "--provider" or ARGV[2])
  provider = (ARGV[1].split('=')[1] || ARGV[2])
else
  provider = (ENV['VAGRANT_DEFAULT_PROVIDER'] || :virtualbox).to_sym
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
      node.vm.box = "rhel/#{RHEL_VERSION}"
      node.vm.hostname = "ocp-master#{i}.#{OCP_DOMAIN}"
      node.vm.network "private_network", ip: "#{PRIVATE_NET}1#{i}"

      if i == 1
        node.vm.network "forwarded_port", guest: 8443, host: 8443
      end

      node.vm.provider :vmware_fusion do |vb, override|
        vb.memory = "2048"
        vb.cpus = 2
      end

      node.vm.provider :virtualbox do |vb, override|
        vb.linked_clone = true
        vb.memory = "2048"
        vb.cpus = 2
      end

      node.vm.provider :libvirt do |vb, override|
        vb.cpus = 2
        vb.memory = "2048"
      end
    end
  end


  (1..OCP_NODES_HOSTS).each do |i|
    config.vm.define "ocp-node#{i}" do |node|
      node.vm.box = "rhel/#{RHEL_VERSION}"
      node.vm.hostname = "ocp-node#{i}.#{OCP_DOMAIN}"
      node.vm.network "private_network", ip: "#{PRIVATE_NET}2#{i}"

      node.vm.provider :vmware_fusion do |vb, override|
        vb.memory = "2048"
        vb.cpus = 2
      end

      node.vm.provider :virtualbox do |vb, override|
        vb.linked_clone = true
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
	  if OCP_INFRA
            ansible.groups = {
             "masters" => ["ocp-master[1:#{OCP_MASTER_HOSTS}]"],
             "etcd" => ["ocp-master[1:#{OCP_MASTER_HOSTS}]"],
             "nodes" => ["ocp-node[1:#{OCP_NODES_HOSTS}]", "ocp-master[1:#{OCP_MASTER_HOSTS}]", "ocp-infra[1:#{OCP_INFRA_HOSTS}]"],
	     "infra" => ["ocp-infra[1:#{OCP_INFRA_HOSTS}]"],
             "OSEv3:children" => ["masters", "nodes"],
             }
          else
            ansible.groups = {
             "masters" => ["ocp-master[1:#{OCP_MASTER_HOSTS}]"],
             "etcd" => ["ocp-master[1:#{OCP_MASTER_HOSTS}]"],
             "nodes" => ["ocp-node[1:#{OCP_NODES_HOSTS}]", "ocp-master[1:#{OCP_MASTER_HOSTS}]"],
             "OSEv3:children" => ["masters", "nodes"],
             }
	   end
           ansible.limit = "ocp-*"
           ansible.become = true
           ansible.extra_vars = {
             "ocp_rhn_user": RHN_USER,
             "ocp_rhn_pass": RHN_PASS,
             "ocp_rhn_pool_ids": RHN_POOL_ID,
             "ocp_internal_domain": OCP_DOMAIN,
             "ocp_public_domain": OCP_PUBLIC_DOMAIN,
             "ocp_master_default_subdomain": OCP_MASTER_SUBDOMAIN,
             "ocp_version": OCP_VERSION,
             "ocp_hosted_metrics_deploy": OCP_METRICS,
             "ocp_hosted_logging_deploy": OCP_LOGGING,
             "ocp_enable_service_catalog": OCP_SVC_CATALOG,
             "ocp_net_plugin": OCP_NET_PLUGIN,
             "ocp_docker_ver": OCP_DOCKER_VER,
             "ocp_vagrant_provider": provider,
	     "ocp_container_runtime_docker_storage_type": OCP_CONTAINER_RUNTIME_STORAGE
           }
           if USE_LOCAL_REPO
             ansible.extra_vars["ocp_local_package_repository_url"] = LOCAL_REPO_URL
             ansible.extra_vars["ocp_local_package_repository"] = true
           end
        end
      end
    end
  end
  if OCP_INFRA
      (1..OCP_INFRA_HOSTS).each do |i|
        config.vm.define "ocp-infra#{i}" do |node|
          node.vm.box = "rhel/#{RHEL_VERSION}"
          node.vm.hostname = "ocp-infra#{i}.#{OCP_DOMAIN}"
          node.vm.network "private_network", ip: "#{PRIVATE_NET}3#{i}"

	  node.vm.provider :vmware_fusion do |vb, override|
            vb.memory = "2048"
            vb.cpus = 2
          end

	  node.vm.provider :virtualbox do |vb, override|
            vb.linked_clone = true
            vb.memory = "2048"
            vb.cpus = 2
          end

	  node.vm.provider :libvirt do |vb, override|
            vb.memory = "8192"
            vb.cpus = 4
          end
	end
      end
  end
end
