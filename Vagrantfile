# -*- mode: ruby -*-
# vi: set ft=ruby :

require "vagrant"

if Vagrant::VERSION < "1.2.1"
  raise "Use a newer version of Vagrant (1.2.1+)"
end

BOX_NAME = ENV['BOX_NAME'] || "precise64"
BOX_URI = ENV['BOX_URI'] || "https://opscode-vm.s3.amazonaws.com/vagrant/boxes/opscode-ubuntu-12.04.box"

LXC_BOX_NAME = ENV['BOX_NAME'] || "precise64_lxc"
LXC_BOX_URI = ENV['BOX_URI'] || "http://dl.dropbox.com/u/13510779/lxc-precise-amd64-2013-05-08.box"

# We'll mount the Chef::Config[:file_cache_path] so it persists between
# Vagrant VMs
host_cache_path = File.expand_path("../.cache", __FILE__)
guest_cache_path = "/tmp/vagrant-cache"


Vagrant.configure("2") do |config|

    # Enable the berkshelf-vagrant plugin
    config.berkshelf.enabled = true
    # The path to the Berksfile to use with Vagrant Berkshelf
    config.berkshelf.berksfile_path = "./Berksfile-vagrant"
    # Ensure Chef is installed for provisioning
    config.omnibus.chef_version = :latest

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
          },
          "languages" => {
            "ruby" => {
              "default_version" => "1.9.1"
            }
          }
      }
      chef.run_list = [
        "recipe[apt::default]",
        "recipe[chef-server::default]",
        "recipe[ruby::default]",
        "recipe[build-essential::default]",
        "recipe[git::default]"
      ]
    end

    config.vm.provision :shell, :inline => <<-SCRIPT
        mkdir -p /vagrant/.chef
        cp /etc/chef-server/admin.pem /vagrant/.chef/
        cp /etc/chef-server/chef-validator.pem /vagrant/.chef/
        cp /vagrant/extras/knife.rb /vagrant/.chef/knife.rb
        chown vagrant /vagrant/.chef/*
        apt-get -y install libxslt-dev libxml2-dev # stupid Nokogiri!
        gem install spiceweasel --no-ri --no-rdo
        cp /vagrant/extras/client-chef.rb /vagrant/extras/client.rb
        echo "Chef server installed!!\nNow let us configure up the cookbooks."
        mkdir -p ~/.berkshelf
        echo '{  "ssl": {    "verify": false  } }' > ~/.berkshelf/config.json
        cd /vagrant
        spiceweasel --execute /vagrant/infrastructure.yml
        knife node from file /vagrant/nodes/allinone_node.json
        knife node from file /vagrant/nodes/single_controller_node.json
        knife node from file /vagrant/nodes/single_compute_node.json        
    SCRIPT
    config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--cpus", 2]
        vb.customize ["modifyvm", :id, "--memory", 1500] 
    end
  end

  # experimental ..  currently breaks...  think search issue.
  config.vm.define :chef_zero do |config|
    config.vm.hostname = "chef"
    config.vm.box = BOX_NAME
    config.vm.box_url = BOX_URI
    config.vm.network :private_network, ip: "33.33.33.50"
    config.ssh.max_tries = 40
    config.ssh.timeout   = 120
    config.ssh.forward_agent = true
    config.vm.provision :chef_solo do |chef|
      chef.provisioning_path = guest_cache_path
      chef.json = {
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
        gem install chef-zero
        mkdir -p /vagrant/.chef
        cp /vagrant/extras/chef-zero.pem /vagrant/.chef/admin.pem
        cp /vagrant/extras/chef-zero.pem /vagrant/.chef/chef-validator.pem
        cp /vagrant/extras/knife-zero.rb /vagrant/.chef/knife.rb
        /vagrant/extras/chef-zero.sh
        cp /vagrant/extras/client-zero.rb /vagrant/extras/client.rb
        chown vagrant /vagrant/.chef/*
        apt-get -y install libxslt-dev libxml2-dev # stupid Nokogiri!
        gem install spiceweasel --no-ri --no-rdo
        echo "Chef server installed!!\nNow let us configure up the cookbooks."
        mkdir -p ~/.berkshelf
        echo '{  "ssl": {    "verify": false  } }' > ~/.berkshelf/config.json
        cd /vagrant
        spiceweasel --execute /vagrant/infrastructure.yml
        knife node from file /vagrant/nodes/allinone_node.json
        knife node from file /vagrant/nodes/single_controller_node.json
        knife node from file /vagrant/nodes/single_compute_node.json        
    SCRIPT
    config.vm.provider :lxc do |lxc, override|
      # Same effect as as 'customize ["modifyvm", :id, "--memory", "1024"]' for VirtualBox
      lxc.customize 'cgroup.memory.limit_in_bytes', '512M'
      override.vm.box = LXC_BOX_NAME
      override.vm.box_url = LXC_BOX_URI
    end
  end


  config.vm.define :allinone do |config|
    config.vm.hostname = "allinone"
    config.vm.box = BOX_NAME
    config.vm.box_url = BOX_URI
    config.vm.network :private_network, ip: "33.33.33.60"
    config.vm.network :private_network, ip: "10.10.100.60"
    config.vm.network :private_network, ip: "172.16.101.60"
    config.ssh.max_tries = 40
    config.ssh.timeout   = 120
    config.ssh.forward_agent = true

    config.vm.provision :chef_solo do |chef|
      chef.provisioning_path = guest_cache_path
      chef.json = {
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
        ifconfig eth2 promisc
        echo 33.33.33.50 chef >> /etc/hosts
        apt-get -y links
        mkdir -p /etc/chef
        cp /vagrant/.chef/chef-validator.pem /etc/chef/validation.pem
        cp /vagrant/extras/client.rb /etc/chef/client.rb
        chef-client
        echo "restart all the services for shits n giggles..."
        cd /etc/init.d/; for i in $(ls nova-*); do sudo service $i restart; done
        sudo nova-manage service list
        echo "##################################"
        echo "#     Openstack Installed        #"
        echo "#   visit https://33.33.33.60    #"
        echo "#   default username: admin      #"
        echo "#   default password: secrete    #"
        echo "##################################"
    SCRIPT
    config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--cpus", 2]
        vb.customize ["modifyvm", :id, "--memory", 2048] 
        vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
        vb.customize ["modifyvm", :id, "--nicpromisc4", "allow-all"]
    end
  end

  config.vm.define :single_controller do |config|
    config.vm.hostname = "single-controller"
    config.vm.box = BOX_NAME
    config.vm.box_url = BOX_URI
    config.vm.network :private_network, ip: "33.33.33.60"
    config.ssh.max_tries = 40
    config.ssh.timeout   = 120
    config.ssh.forward_agent = true

    config.vm.provision :chef_solo do |chef|
      chef.provisioning_path = guest_cache_path
      chef.json = {
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
        echo 33.33.33.50 chef >> /etc/hosts
        apt-get -y links
        mkdir -p /etc/chef
        cp /vagrant/.chef/chef-validator.pem /etc/chef/validation.pem
        cp /vagrant/extras/client.rb /etc/chef/client.rb
        chef-client
        echo "restart all the services for shits n giggles..."
        cd /etc/init.d/; for i in $(ls nova-*); do sudo service $i restart; done
        sudo nova-manage service list
        echo "##################################"
        echo "#     Openstack Installed        #"
        echo "#   visit https://33.33.33.60    #"
        echo "#   default username: admin      #"
        echo "#   default password: secrete    #"
        echo "##################################"
    SCRIPT
    config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--cpus", 1]
        vb.customize ["modifyvm", :id, "--memory", 1024] 
    end
  end

  config.vm.define :single_compute do |config|
    config.vm.hostname = "single-compute"
    config.vm.box = BOX_NAME
    config.vm.box_url = BOX_URI
    config.vm.network :private_network, ip: "33.33.33.61"
    config.vm.network :private_network, ip: "10.10.100.60"
    config.vm.network :private_network, ip: "172.16.101.60"
    config.ssh.max_tries = 40
    config.ssh.timeout   = 120
    config.ssh.forward_agent = true

    config.vm.provision :chef_solo do |chef|
      chef.provisioning_path = guest_cache_path
      chef.json = {
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
        ifconfig eth2 promisc
        echo 33.33.33.50 chef >> /etc/hosts
        mkdir -p /etc/chef
        cp /vagrant/.chef/chef-validator.pem /etc/chef/validation.pem
        cp /vagrant/extras/client.rb /etc/chef/client.rb
        chef-client
        echo "restart all the services for shits n giggles..."
        cd /etc/init.d/; for i in $(ls nova-*); do sudo service $i restart; done
        sudo nova-manage service list
        echo "##################################"
        echo "#     Openstack Installed        #"
        echo "#   visit https://33.33.33.60    #"
        echo "#   default username: admin      #"
        echo "#   default password: secrete    #"
        echo "##################################"
    SCRIPT
    config.vm.provider :virtualbox do |vb|
        vb.customize ["modifyvm", :id, "--cpus", 2]
        vb.customize ["modifyvm", :id, "--memory", 2048] 
        vb.customize ["modifyvm", :id, "--nicpromisc3", "allow-all"]
        vb.customize ["modifyvm", :id, "--nicpromisc4", "allow-all"]
    end
  end

end

