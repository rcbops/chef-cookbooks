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
  nova_api_package = "openstack-nova"
  nova_api_service = "openstack-nova-api"
  nova_api_package_options = ""
else
  # All Others (right now Debian and Ubuntu)
  nova_api_package = "nova-api"
  nova_api_service = nova_api_package
  nova_api_package_options = "-o Dpkg::Options::='--force-confold' --force-yes"
end

directory "/var/lock/nova" do
    owner "nova"
    group "nova"
    mode "0755"
    action :create
end

package "python-keystone" do
  action :upgrade
end

package nova_api_package do
  action :upgrade
  options nova_api_package_options
end

service nova_api_service do
  supports :status => true, :restart => true
  action :enable
  subscribes :restart, resources(:template => "/etc/nova/nova.conf"), :delayed
end

template "/etc/nova/api-paste.ini" do
  source "api-paste.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :ip_address => node[:controller_ipaddress],
    :component  => node[:package_component],
    :service_port => node[:keystone][:service_port],
    :admin_port => node[:keystone][:admin_port],
    :admin_token => node[:keystone][:admin_token]
  )
  notifies :restart, resources(:service => nova_api_service), :immediately
end
