# Identity Specifics
default[:identity][:service_port] = "5000"
default[:identity][:admin_port] = "35357"
default[:identity][:admin_token] = "999888777666"

# Horizon Specifics
default[:horizon][:db_user] = "dash"
default[:horizon][:db_passwd] = "dash"
default[:horizon][:db] = "dash"

# Compute Information (probably better with node search later)
default[:compute][:controller_ipaddress] = node[:ipaddress]
