maintainer        "Rackspace Hosting, Inc."
license           "Apache 2.0"
description       "Package update selection for installable OS"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           "1.0.0"

%w{ ubuntu fedora }.each do |os|
  supports os
end

%w{ apt yum }.each do |dep|
  depends dep
end
