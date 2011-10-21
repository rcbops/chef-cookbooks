default[:nova][:db] = "nova"
default[:nova][:db_user] = "nova"
default[:nova][:db_passwd] = "nova"

default[:glance][:db] = "glance"
default[:glance][:db_user] = "glance"
default[:glance][:db_passwd] = "glance"
default[:glance][:api_port] = "9292"
default[:glance][:registry_port] = "9191"

default[:keystone][:db] = "keystone"
default[:keystone][:db_user] = "keystone"
default[:keystone][:db_passwd] = "keystone"

default[:dash][:db] = "dash"
default[:dash][:db_user] = "dash"
default[:dash][:db_passwd] = "dash"

default[:image][:natty] = "http://c250663.r63.cf1.rackcdn.com/ubuntu-11.04-server-uec-amd64.tar.gz"
default[:image][:maverick] = "http://c250663.r63.cf1.rackcdn.com/ubuntu-10.10-server-uec-amd64.tar.gz"

default[:controller][:ipaddress] = node[:ipaddress]
