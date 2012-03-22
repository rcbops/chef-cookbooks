maintainer        "Rackspace Hosting, Inc."
license           "Apache 2.0"
description       "Installs and configures the Glance Image Registry and Delivery Service"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.0.0"
recipe            "glance::api", "Installs packages required for a glance api server"
recipe            "glance::registry", "Installs packages required for a glance registry server"

%w{ ubuntu fedora }.each do |os|
  supports os
end

%w{ database keystone mysql }.each do |dep|
  depends dep
end
