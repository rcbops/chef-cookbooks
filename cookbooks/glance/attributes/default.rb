default[:glance][:db] = "glance"
default[:glance][:db_user] = "glance"
default[:glance][:db_passwd] = "glance"
default[:glance][:db_host] = node[:controller_ipaddress]
default[:glance][:api_port] = "9292"
default[:glance][:registry_port] = "9191"
default[:glance][:images] = [ "tty", "natty" ]

default[:glance][:service_tenant_name] = "service"
default[:glance][:service_user] = "glance"
default[:glance][:service_pass] = "vARxre7K"
default[:glance][:service_role] = "admin"

default[:image][:oneiric] = "http://c250663.r63.cf1.rackcdn.com/ubuntu-11.10-server-uec-amd64-multinic.tar.gz"
default[:image][:natty] = "http://c250663.r63.cf1.rackcdn.com/ubuntu-11.04-server-uec-amd64-multinic.tar.gz"
default[:image][:maverick] = "http://c250663.r63.cf1.rackcdn.com/ubuntu-10.10-server-uec-amd64-multinic.tar.gz"
default[:image][:tty] = "http://smoser.brickies.net/ubuntu/ttylinux-uec/ttylinux-uec-amd64-12.1_2.6.35-22_1.tar.gz"

default[:controller_ipaddress] = node[:ipaddress]
