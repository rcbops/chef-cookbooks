default[:mysql][:root_pass] = "secrete"

default[:nova][:db] = "nova"
default[:nova][:db_user] = "nova"
default[:nova][:db_passwd] = "nova"

default[:glance][:db] = "glance"
default[:glance][:db_user] = "glance"
default[:glance][:db_passwd] = "glance"
default[:glance][:api_port] = "9292"
default[:glance][:registry_port] = "9191"
default[:glance][:images] = [ "tty", "natty" ]

default[:keystone][:db] = "keystone"
default[:keystone][:db_user] = "keystone"
default[:keystone][:db_passwd] = "keystone"
default[:keystone][:verbose] = "False"
default[:keystone][:debug] = "False"
default[:keystone][:service_port] = "5000"
default[:keystone][:admin_port] = "35357"
default[:keystone][:admin_token] = "999888777666"

default[:dash][:db] = "dash"
default[:dash][:db_user] = "dash"
default[:dash][:db_passwd] = "dash"

default[:image][:oneiric] = "http://c250663.r63.cf1.rackcdn.com/ubuntu-11.10-server-uec-amd64-multinic.tar.gz"
default[:image][:natty] = "http://c250663.r63.cf1.rackcdn.com/ubuntu-11.04-server-uec-amd64-multinic.tar.gz"
default[:image][:maverick] = "http://c250663.r63.cf1.rackcdn.com/ubuntu-10.10-server-uec-amd64-multinic.tar.gz"
default[:image][:tty] = "http://smoser.brickies.net/ubuntu/ttylinux-uec/ttylinux-uec-amd64-12.1_2.6.35-22_1.tar.gz"

default[:public][:label] = "public"
default[:public][:ipv4_cidr] = "192.168.100.0/24"
default[:public][:num_networks] = "1"
default[:public][:network_size] = "255"
default[:public][:bridge] = "br100"
default[:public][:bridge_dev] = "eth2"
default[:public][:dns1] = "8.8.8.8"
default[:public][:dns2] = "8.8.4.4"

default[:private][:label] = "private"
default[:private][:ipv4_cidr] = "192.168.200.0/24"
default[:private][:num_networks] = "1"
default[:private][:network_size] = "255"
default[:private][:bridge] = "br200"
default[:private][:bridge_dev] = "eth3"

default[:package_url] = "http://ops.monkeypuppetlabs.com/packages"
default[:package_release] = node[:lsb][:codename]
default[:package_component] = "diablo-final"

default[:controller_ipaddress] = node[:ipaddress]
default[:virt_type] = "kvm"
