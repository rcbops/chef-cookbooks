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

include_recipe "openstack::apt"
include_recipe "openstack::mysql"

package "python-mysqldb" do
  action :install
end

package "keystone" do
  action :upgrade
  options "-o Dpkg::Options::='--force-confold' --force-yes"
end

service "keystone" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

file "/var/lib/keystone/keystone.db" do
  action :delete
end

execute "Keystone: sleep" do
  command "sleep 10s"
  action :nothing
end

template "/etc/keystone/keystone.conf" do
  source "keystone.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
            :debug => node[:keystone][:debug],
            :verbose => node[:keystone][:verbose],
            :user => node[:keystone][:db_user],
            :passwd => node[:keystone][:db_passwd],
            :ip_address => node[:controller_ipaddress],
            :db_name => node[:keystone][:db],
            :service_port => node[:keystone][:service_port],
            :admin_port => node[:keystone][:admin_port]
            )
  notifies :restart, resources(:service => "keystone"), :immediately
  notifies :run, resources(:execute => "Keystone: sleep"), :immediately
end

execute "Keystone: add openstack tenant" do
  command "keystone-manage create_tenant --name openstack --id openstack"
  action :run
  not_if "keystone-manage list_tenants|grep openstack"
end

execute "Keystone: add admin user" do
  command "keystone-manage create_user --id admin --name admin --password secrete --tenant-id openstack"
  action :run
  not_if "keystone-manage list_users |grep admin"
end

execute "Keystone: add admin user token" do
  command "keystone-manage create_token --id #{node[:keystone][:admin_token]} --user-id admin --tenant-id openstack --expires 2015-02-05T00:0"
  action :run
  not_if "keystone-manage list_tokens |grep #{node[:keystone][:admin_token]}"
end

# THIS COMMAND RETURNS AN AUTO-INC INTEGER: e.g. 1
execute "Keystone: add Admin role" do
  command "keystone-manage create_role --name Admin"
  action :run
  not_if "keystone-manage list_roles |grep Admin"
end

# THIS COMMAND RETURNS AN AUTO-INC INTEGER: e.g. 2
execute "Keystone: add Member role" do
  command "keystone-manage create_role --name Member"
  action :run
  not_if "keystone-manage list_roles grep Member"
end

# I CANT SEEM TO FIND ANY LIST_GRANT COMMAND
execute "Keystone: grant ServiceAdmin role to admin user" do
  # command syntax: role grant 'role' 'user' 'tenant (optional)'
  command "keystone-manage grant_role --role-id 1 --user-id admin && touch /var/lib/keystone/keystone_why_you_so_broken.semaphore"
  not_if "test -f /var/lib/keystone/keystone_why_you_so_broken.semaphore"
  action :run
end

# I CANT SEEM TO FIND ANY LIST_GRANT COMMAND
execute "Keystone: grant Admin role to admin user for openstack tenant" do
  # command syntax: role grant 'role' 'user' 'tenant (optional)'
  command "keystone-manage grant_role --role-id 1 --user-id admin --tenant-id openstack && touch /var/lib/keystone/nice_to_see_we_are_still_not_testing_the_cli.semaphore"
  action :run
  not_if "test -f /var/lib/keystone/nice_to_see_we_are_still_not_testing_the_cli.semaphore"
end

# THIS COMMAND RETURNS AN AUTO-INC INTEGER: e.g. 1
execute "Keystone: service add keystone identity" do
  command "keystone-manage create_service --name keystone --type identity"
  action :run
  not_if "keystone-manage list_services |grep keystone"
end

execute "Keystone: add identity endpointTemplates" do
  # command syntax: endpointTemplates add 'region' 'service' 'publicURL' 'adminURL' 'internalURL' 'enabled' 'global'
  node.set[:keystone][:adminURL] = "http://#{node[:controller_ipaddress]}:#{node[:keystone][:admin_port]}/v2.0"
  node.set[:keystone][:internalURL] = "http://#{node[:controller_ipaddress]}:#{node[:keystone][:service_port]}/v2.0"
  node.set[:keystone][:publicURL] = node[:keystone][:internalURL]
  command "keystone-manage create_endpoint_template --region RegionOne --service-id 1 --public-url #{node[:keystone][:publicURL]} --admin-url #{node[:keystone][:adminURL]} --internal-url #{node[:keystone][:internalURL]} --global"
  action :run
  not_if "keystone-manage list_endpoint_template |grep '1'"
end

# THIS COMMAND RETURNS AN AUTO-INC INTEGER: e.g. 2
execute "Keystone: service add nova compute" do
  command "keystone-manage create_service --name nova --type compute"
  action :run
  not_if "keystone-manage list_services |grep nova"
end

execute "Keystone: add nova endpointTemplates" do
  # command syntax: endpointTemplates add 'region' 'service' 'publicURL' 'adminURL' 'internalURL' 'enabled' 'global'
  node.set[:nova][:adminURL] = "http://#{node[:controller_ipaddress]}:8774/v1.1/%tenant_id%"
  node.set[:nova][:internalURL] = node[:nova][:adminURL]
  node.set[:nova][:publicURL] = node[:nova][:adminURL]
  command "keystone-manage create_endpoint_template --region RegionOne --service-id 2 --public-url #{node[:nova][:publicURL]} --admin-url #{node[:nova][:adminURL]} --internal-url #{node[:nova][:internalURL]} --global"
  action :run
  not_if "keystone-manage list_endpoint_templates |grep '2'"
end

# THIS COMMAND RETURNS AN AUTO-INC INTEGER: e.g. 3
execute "Keystone: service add glance image" do
  command "keystone-manage create_service --name glance --type image"
  action :run
  not_if "keystone-manage list_services |grep glance"
end

execute "Keystone: add glance endpointTemplates" do
  # command syntax: endpointTemplates add 'region' 'service' 'publicURL' 'adminURL' 'internalURL' 'enabled' 'global'
  node.set[:glance][:adminURL] = "http://#{node[:controller_ipaddress]}:#{node[:glance][:api_port]}/v1"
  node.set[:glance][:internalURL] = node[:glance][:adminURL]
  node.set[:glance][:publicURL] = node[:glance][:adminURL]
  command "keystone-manage create_endpoint_template --region RegionOne --service-id 3 --public-url #{node[:glance][:publicURL]} --admin-url #{node[:glance][:adminURL]} --internal-url #{node[:glance][:internalURL]} --global"
  action :run
  not_if "keystone-manage list_endpoint_templates |grep '3'"
end

execute "Keystone: add ec2 credentials" do
  # command syntax: keystone-manage credentials add 'role? (admin)' EC2 'user' 'secret' 'project'
  command "keystone-manage credentials add admin EC2 admin secrete openstack"
  action :run
  not_if "keystone-manage credentials list | grep 'admin'"
end
