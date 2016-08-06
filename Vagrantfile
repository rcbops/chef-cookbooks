# -*- mode: ruby -*-
# vi: set ft=ruby :

require "vagrant"

if Vagrant::VERSION < "1.2.1"
  raise "Use a newer version of Vagrant (1.2.1+)"
end

##### You Can Modify the BOX_NAME/URI to use a different OS #####

BOX_NAME = ENV['BOX_NAME'] || "precise64"
BOX_URI = ENV['BOX_URI'] || "https://opscode-vm.s3.amazonaws.com/vagrant/boxes/opscode-ubuntu-12.04.box"

# We'll mount the Chef::Config[:file_cache_path] so it persists between
# Vagrant VMs
host_cache_path = File.expand_path("../.cache", __FILE__)
guest_cache_path = "/tmp/vagrant-cache"

#### set the Env Variable to 'NO' to disable berkshelf for non-chef servers.
#### Used to allow chef client provisioner without berkshelf getting in the way.
ALLOW_BERKS = ENV['ALLOW_BERKS'] || true

Vagrant.configure("2") do |config|

  # Map .chef dir to /root/.chef to help knife etc.
  config.vm.synced_folder ".chef", "/root/.chef"
  config.vm.synced_folder ".berkshelf", "/root/.berkshelf"

  # Enable Vagrant Cachier for faster build times
  config.cache.auto_detect = true

  # Enable the berkshelf-vagrant plugin
  config.berkshelf.enabled = false
  if ALLOW_BERKS == true
    config.berkshelf.enabled = true
    # The path to the Berksfile to use with Vagrant Berkshelf
    config.berkshelf.berksfile_path = "./Berksfile-vagrant"
  end

  # Ensure Chef is installed for provisioning
  config.omnibus.chef_version = :latest

##### Common Provision Statements #####

  config.vm.provision :chef_solo do |chef|
    chef.provisioning_path = guest_cache_path
    chef.json = {
      "chef-server" => {
          "version" => :latest
      },
      "languages" => {
        "ruby" => {
          "default_version" => "1.9.1"
        }
      }
    }
    chef.run_list = [
      "recipe[apt::default]",
      "recipe[ruby::default]",
      "recipe[build-essential::default]",
      "recipe[git::default]",
      "recipe[curl::default]"
    ]
  end

  config.vm.provision :shell, :inline => <<-SCRIPT
    apt-get -y install libxslt-dev libxml2-dev # stupid Nokogiri!
    gem install chef --no-ri --no-rdo
    gem install spiceweasel --no-ri --no-rdo
  SCRIPT

##### Chef Server #####

  config.vm.define :chef do |config|
    config.vm.box = BOX_NAME
    config.vm.box_url = BOX_URI
    config.vm.hostname = "chef"
    config.vm.network :private_network, ip: "33.33.33.50"
    config.ssh.max_tries = 40
    config.ssh.timeout   = 120
    config.ssh.forward_agent = true

    config.vm.provision :chef_solo do |chef|
      chef.provisioning_path = guest_cache_path
      chef.json = { 
        "chef-server" => {
          "version" => :latest
        }
      }
      chef.run_list = [
        "recipe[chef-server::default]",
      ]
    end

    config.vm.provision :shell, :inline => <<-SCRIPT
      mkdir -p /vagrant/.chef
      cp /etc/chef-server/admin.pem /vagrant/.chef/
      cp /etc/chef-server/chef-validator.pem /vagrant/.chef/
      chown vagrant /vagrant/.chef/*
      echo "Chef server installed!!\nNow let us slurp up the cookbooks."
      cd /vagrant
      spiceweasel --execute /vagrant/infrastructure.yml
      cd /vagrant/nodes/; for i in $(ls *.json); do knife node from file $i; done
    SCRIPT

    config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--cpus", 1]
        vb.customize ["modifyvm", :id, "--memory", 1048] 
    end
  end

##### all-in-one node ######
  config.vm.define :allinone do |config|
    config.vm.hostname = "allinone"
    config.vm.box = BOX_NAME
    config.vm.box_url = BOX_URI
    config.vm.network :private_network, ip: "33.33.33.60"
    config.vm.network :private_network, ip: "172.16.101.60"
    config.ssh.max_tries = 40
    config.ssh.timeout   = 120
    config.ssh.forward_agent = true

    config.vm.provision :shell, :inline => <<-SCRIPT
      ifconfig eth2 promisc
      echo 33.33.33.50 chef >> /etc/hosts
      apt-get -y links
      dd if=/dev/zero of=/tmp/cinder-volumes bs=1 count=0 seek=2G
      losetup /dev/loop2 /tmp/cinder-volumes
      pvcreate /dev/loop2
      vgcreate cinder-volumes /dev/loop2
      mkdir -p /etc/chef
      cp /vagrant/.chef/chef-validator.pem /etc/chef/validation.pem
      cp /vagrant/.chef/client.rb /etc/chef/client.rb
      chef-client
      source /root/openrc
      cp /root/openrc /vagrant/openrc
      /usr/bin/nova keypair-add --pub_key /root/.ssh/id_rsa.pub vagrant-root
      echo "restart all the services for shits n giggles..."
      cd /etc/init.d/; for i in $(ls nova-*); do service $i restart; done
      sleep 10
      sudo nova-manage service list
      echo "##################################"
      echo "#     Openstack Installed        #"
      echo "#   visit https://33.33.33.60    #"
      echo "#   default username: admin      #"
      echo "#   default password: vagrant    #"
      echo "##################################"
    SCRIPT
    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--cpus", 2]
      vb.customize ["modifyvm", :id, "--memory", 2048] 
      vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
    end
  end

##### Single Controller Node #####
  config.vm.define :single_controller do |config|
    config.vm.hostname = "single-controller"
    config.vm.box = BOX_NAME
    config.vm.box_url = BOX_URI
    config.vm.network :private_network, ip: "33.33.33.60"
    config.ssh.max_tries = 40
    config.ssh.timeout   = 120
    config.ssh.forward_agent = true

    config.vm.provision :shell, :inline => <<-SCRIPT
      echo 33.33.33.50 chef >> /etc/hosts
      apt-get -y links
      mkdir -p /etc/chef
      cp /vagrant/.chef/chef-validator.pem /etc/chef/validation.pem
      cp /vagrant/.chef/client.rb /etc/chef/client.rb
      chef-client
      source /root/openrc
      cp /root/openrc /vagrant/openrc
      /usr/bin/nova keypair-add --pub_key /root/.ssh/id_rsa.pub vagrant-root
      echo "restart all the services for shits n giggles..."
      cd /etc/init.d/; for i in $(ls nova-*); do service $i restart; done
      sleep 10
      sudo nova-manage service list
      echo "##################################"
      echo "#     Openstack Controller       #"
      echo "#   visit https://33.33.33.60    #"
      echo "#   default username: admin      #"
      echo "#   default password: vagrant    #"
      echo "#   Provision A Compute Node ... #"
      echo "##################################"
    SCRIPT
    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--cpus", 1]
      vb.customize ["modifyvm", :id, "--memory", 512] 
    end
  end

##### HA Controller Node 1 #####
  config.vm.define :ha_controller1 do |config|
    config.vm.hostname = "ha-controller1"
    config.vm.box = BOX_NAME
    config.vm.box_url = BOX_URI
    config.vm.network :private_network, ip: "33.33.33.60"
    config.ssh.max_tries = 40
    config.ssh.timeout   = 120
    config.ssh.forward_agent = true

    config.vm.provision :shell, :inline => <<-SCRIPT
      echo 33.33.33.50 chef >> /etc/hosts
      apt-get -y links
      mkdir -p /etc/chef
      cp /vagrant/.chef/chef-validator.pem /etc/chef/validation.pem
      cp /vagrant/.chef/client.rb /etc/chef/client.rb
      chef-client
      source /root/openrc
      cp /root/openrc /vagrant/openrc
      /usr/bin/nova keypair-add --pub_key /root/.ssh/id_rsa.pub vagrant-root
      echo "restart all the services for shits n giggles..."
      cd /etc/init.d/; for i in $(ls nova-*); do service $i restart; done
      sleep 10
      sudo nova-manage service list
      echo "##################################"
      echo "#   Openstack HA Controller 1    #"
      echo "#   visit https://33.33.33.61    #"
      echo "#   default username: admin      #"
      echo "#   default password: vagrant    #"
      echo "#   Provision A Compute Node ... #"
      echo "##################################"
    SCRIPT
    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--cpus", 1]
      vb.customize ["modifyvm", :id, "--memory", 1024] 
    end
  end

##### HA Controller Node 2 #####
  config.vm.define :ha_controller2 do |config|
    config.vm.hostname = "ha-controller2"
    config.vm.box = BOX_NAME
    config.vm.box_url = BOX_URI
    config.vm.network :private_network, ip: "33.33.33.59"
    config.ssh.max_tries = 40
    config.ssh.timeout   = 120
    config.ssh.forward_agent = true

    config.vm.provision :shell, :inline => <<-SCRIPT
      echo 33.33.33.50 chef >> /etc/hosts
      apt-get -y links
      mkdir -p /etc/chef
      cp /vagrant/.chef/chef-validator.pem /etc/chef/validation.pem
      cp /vagrant/.chef/client.rb /etc/chef/client.rb
      chef-client
      echo "restart all the services for shits n giggles..."
      cd /etc/init.d/; for i in $(ls nova-*); do service $i restart; done
      sleep 10
      sudo nova-manage service list
      echo "##################################"
      echo "#   Openstack HA Controller 2    #"
      echo "#   visit https://33.33.33.61    #"
      echo "#   default username: admin      #"
      echo "#   default password: vagrant    #"
      echo "#   Provision A Compute Node ... #"
      echo "##################################"
    SCRIPT
    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--cpus", 1]
      vb.customize ["modifyvm", :id, "--memory", 1024] 
    end
  end


##### Single Compute Node #####
 config.vm.define :single_compute do |config|
    config.vm.hostname = "single-compute"
    config.vm.box = BOX_NAME
    config.vm.box_url = BOX_URI
    config.vm.network :private_network, ip: "33.33.33.71"
    config.vm.network :private_network, ip: "172.16.101.71"
    config.ssh.max_tries = 40
    config.ssh.timeout   = 120
    config.ssh.forward_agent = true

    config.vm.provision :shell, :inline => <<-SCRIPT
      ifconfig eth2 promisc
      echo 33.33.33.50 chef >> /etc/hosts
      apt-get -y links
      mkdir -p /etc/chef
      cp /vagrant/.chef/chef-validator.pem /etc/chef/validation.pem
      cp /vagrant/.chef/client.rb /etc/chef/client.rb
      chef-client
      echo "restart all the services for shits n giggles..."
      cd /etc/init.d/; for i in $(ls nova-*); do service $i restart; done
      sleep 10
      sudo nova-manage service list
      echo "##################################"
      echo "#     Openstack Compute Node     #"
      echo "#            INSTALLED           #"
      echo "##################################"
    SCRIPT
    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--cpus", 2]
      vb.customize ["modifyvm", :id, "--memory", 2048] 
      vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
    end
  end

##### Cinder Node #####
  config.vm.define :cinder do |config|
    config.vm.hostname = "cinder"
    config.vm.box = BOX_NAME
    config.vm.box_url = BOX_URI
    config.vm.network :private_network, ip: "33.33.33.55"
    config.ssh.max_tries = 40
    config.ssh.timeout   = 120
    config.ssh.forward_agent = true

    config.vm.provision :shell, :inline => <<-SCRIPT
      echo 33.33.33.50 chef >> /etc/hosts
      dd if=/dev/zero of=/tmp/cinder-volumes bs=1 count=0 seek=2G
      losetup /dev/loop2 /tmp/cinder-volumes
      pvcreate /dev/loop2
      vgcreate cinder-volumes /dev/loop2
      mkdir -p /etc/chef
      cp /vagrant/.chef/chef-validator.pem /etc/chef/validation.pem
      cp /vagrant/.chef/client.rb /etc/chef/client.rb
      chef-client
      cd /etc/init.d/; for i in $(ls cinder-*); do service $i restart; done
      sleep 10
      echo "##################################"
      echo "#     Openstack Cinder Node      #"
      echo "#        Installed               #"
      echo "##################################"
    SCRIPT
    config.vm.provider :virtualbox do |vb|
      vb.customize ["modifyvm", :id, "--cpus", 1]
      vb.customize ["modifyvm", :id, "--memory", 512] 
    end
  end

end
