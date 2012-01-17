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

#execute "Fix Bug lp:865448" do
#  command "sed -i 's/path.abspath(sys.argv\[0\])/path.dirname(__file__)/g' /usr/share/pyshared/keystone/controllers/version.py"
#  action :run
#end

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
  command "keystone-manage tenant add openstack"
  action :run
  not_if "keystone-manage tenant list|grep openstack"
end

execute "Keystone: add admin user" do
  command "keystone-manage user add admin secrete openstack"
  action :run
  not_if "keystone-manage user list|grep admin"
end

execute "Keystone: add admin user token" do
  command "keystone-manage token add #{node[:keystone][:admin_token]} admin openstack 2015-02-05T00:0"
  action :run
  not_if "keystone-manage token list | grep #{node[:keystone][:admin_token]}"
end

execute "Keystone: add Admin role" do
  command "keystone-manage role add Admin"
  action :run
  not_if "keystone-manage role list|grep Admin"
end

execute "Keystone: add Member role" do
  command "keystone-manage role add Member"
  action :run
  not_if "keystone-manage role list|grep Member"
end

execute "Keystone: grant ServiceAdmin role to admin user" do
  # command syntax: role grant 'role' 'user' 'tenant (optional)'
  command "keystone-manage role grant Admin admin && touch /var/lib/keystone/keystone_why_you_so_broken.semaphore"
  not_if "test -f /var/lib/keystone/keystone_why_you_so_broken.semaphore"
  action :run
end

execute "Keystone: grant Admin role to admin user for openstack tenant" do
  # command syntax: role grant 'role' 'user' 'tenant (optional)'
  command "keystone-manage role grant Admin admin openstack"
  action :run
  not_if "keystone-manage role list openstack|grep Admin"
end

execute "Keystone: service add keystone identity" do
  command "keystone-manage service add keystone identity"
  action :run
  not_if "keystone-manage service list|grep keystone"
end

execute "Keystone: add identity endpointTemplates" do
  # command syntax: endpointTemplates add 'region' 'service' 'publicURL' 'adminURL' 'internalURL' 'enabled' 'global'
  node.set[:keystone][:adminURL] = "http://#{node[:controller_ipaddress]}:#{node[:keystone][:admin_port]}/v2.0"
  node.set[:keystone][:internalURL] = "http://#{node[:controller_ipaddress]}:#{node[:keystone][:service_port]}/v2.0"
  node.set[:keystone][:publicURL] = node[:keystone][:internalURL]
  command "keystone-manage endpointTemplates add RegionOne keystone #{node[:keystone][:publicURL]} #{node[:keystone][:adminURL]} #{node[:keystone][:internalURL]} 1 1"
  action :run
  not_if "keystone-manage endpointTemplates list|grep 'keystone'"
end

execute "Keystone: service add nova compute" do
  command "keystone-manage service add nova compute"
  action :run
  not_if "keystone-manage service list|grep nova"
end

execute "Keystone: add nova endpointTemplates" do
  # command syntax: endpointTemplates add 'region' 'service' 'publicURL' 'adminURL' 'internalURL' 'enabled' 'global'
  node.set[:nova][:adminURL] = "http://#{node[:controller_ipaddress]}:8774/v1.1/%tenant_id%"
  node.set[:nova][:internalURL] = node[:nova][:adminURL]
  node.set[:nova][:publicURL] = node[:nova][:adminURL]
  command "keystone-manage endpointTemplates add RegionOne nova #{node[:nova][:publicURL]} #{node[:nova][:adminURL]} #{node[:nova][:internalURL]} 1 1"
  action :run
  not_if "keystone-manage endpointTemplates list|grep 'nova'"
end

execute "Keystone: service add glance image" do
  command "keystone-manage service add glance image"
  action :run
  not_if "keystone-manage service list|grep glance"
end

execute "Keystone: add glance endpointTemplates" do
  # command syntax: endpointTemplates add 'region' 'service' 'publicURL' 'adminURL' 'internalURL' 'enabled' 'global'
  node.set[:glance][:adminURL] = "http://#{node[:controller_ipaddress]}:#{node[:glance][:api_port]}/v1"
  node.set[:glance][:internalURL] = node[:glance][:adminURL]
  node.set[:glance][:publicURL] = node[:glance][:adminURL]
  command "keystone-manage endpointTemplates add RegionOne glance #{node[:glance][:publicURL]} #{node[:glance][:adminURL]} #{node[:glance][:internalURL]} 1 1"
  action :run
  not_if "keystone-manage endpointTemplates list|grep 'glance'"
end

execute "Keystone: add ec2 credentials" do
  # command syntax: keystone-manage credentials add 'role? (admin)' EC2 'user' 'secret' 'project'
  command "keystone-manage credentials add admin EC2 admin secrete openstack"
  action :run
  not_if "keystone-manage credentials list | grep 'admin'"
end
