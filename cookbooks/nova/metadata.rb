maintainer        "Rackspace Hosting, Inc."
license           "Apache 2.0"
description       "Installs and configures Openstack"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.0.0"
# recipe            "mysql", "Includes the client recipe to configure a client"
# recipe            "mysql::client", "Installs packages required for mysql clients using run_action magic"

%w{ ubuntu fedora }.each do |os|
  supports os
end

%w{ apt database glance keystone mysql openssh rabbitmq }.each do |dep|
  depends dep
end
