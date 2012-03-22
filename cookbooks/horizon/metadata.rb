maintainer       "Rackspace Hosting, Inc."
license          "Apache 2.0"
description      "Installs/Configures horizon"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

%w{ ubuntu }.each do |os|
  supports os
end

%w{ apache2 database mysql }.each do |dep|
  depends dep
end
