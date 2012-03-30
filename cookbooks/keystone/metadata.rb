maintainer        "Rackspace Hosting, Inc."
license           "Apache 2.0"
description       "Installs and configures the Keystone Identity Service"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.0.0"
recipe            "keystone::server", "Installs packages required for a keystone server"

%w{ ubuntu }.each do |os|
  supports os
end

%w{ database mysql }.each do |dep|
  depends dep
end
