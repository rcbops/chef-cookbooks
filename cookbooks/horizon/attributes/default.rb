# Identity Specifics
default[:identity][:service_port] = "5000"
default[:identity][:admin_port] = "35357"
default[:identity][:admin_token] = "999888777666"

# Horizon Specifics
default[:horizon][:db_user] = "dash"
default[:horizon][:db_passwd] = "dash"
default[:horizon][:db] = "dash"
default[:horizon][:db_host] = node[:controller_ipaddress]

# Compute Information (probably better with node search later)
default[:compute][:controller_ipaddress] = node[:ipaddress]

# Account for the moving target that is the dashboard path....
default[:horizon][:dash_path] = "/usr/share/openstack-dashboard/openstack_dashboard"
default[:horizon][:wsgi_path] = node[:horizon][:dash_path] + "/wsgi"
