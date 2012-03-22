#
# Cookbook Name:: memcache
# Recipe:: default
#
# Copyright 2009, Example Com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "nova::nova-common"

# Distribution specific settings go here
if platform?(%w{fedora})
  # Fedora
  nova_network_package = "openstack-nova"
  nova_network_service = "openstack-nova-network"
  nova_network_package_options = ""
else
  # All Others (right now Debian and Ubuntu)
  nova_network_package = "nova-network"
  nova_network_service = nova_network_package
  nova_network_package_options = "-o Dpkg::Options::='--force-confold' --force-yes"
end

package nova_network_package do
  action :upgrade
  options nova_network_package_options
end

service nova_network_service do
  supports :status => true, :restart => true
  action :enable
  subscribes :restart, resources(:template => "/etc/nova/nova.conf"), :delayed
end
