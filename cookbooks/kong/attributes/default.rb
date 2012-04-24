default[:controller_ipaddress] = node[:ipaddress]
# default[:keystone][:host] = "127.0.0.1"
default[:keystone][:service_port] = "5000"
default[:keystone][:admin_port] = "35357"
default[:keystone][:api_version] = "v2.0"
default[:keystone][:user] = "admin"
default[:keystone][:password] = "secrete"
default[:keystone][:tenantid] = "admin"
default[:keystone][:region] = "RegionOne"

default[:nova][:network_label] = "public"

# default[:rabbitmq][:host] = "127.0.0.1"
default[:rabbitmq][:user] = "guest"

# default[:swift][:auth_host] = "127.0.0.1"
default[:swift][:auth_port] = "443"
default[:swift][:auth_prefix] = "/auth/"
default[:swift][:auth_ssl] = "yes"
default[:swift][:account] = "system"
default[:swift][:username] = "root"
default[:swift][:password] = "password"

default[:kong][:branch] = "master"
