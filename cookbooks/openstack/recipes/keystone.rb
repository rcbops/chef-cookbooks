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

include_recipe "openstack::nova-common"
include_recipe "openstack::mysql"

package "keystone" do
  action :install
  options "--force-yes"
end

service "keystone" do
  supports :status => true, :restart => true
  action :enable
end

template "/etc/keystone/keystone.conf" do
  source "keystone.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :user => node[:keystone][:db_user],
    :passwd => node[:keystone][:db_passwd],
    :ip_address => node[:ipaddress],
    :db_name => node[:keystone][:db]
  )
  notifies :restart, resources(:service => "keystone"), :immediately
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
  command "keystone-manage token add 999888777666 admin openstack 2015-02-05T00:0"
  action :run
  not_if "keystone-manage token list | grep 999888777666"
end

execute "Keystone: add Admin role" do
  command "keystone-manage role add Admin"
  action :run
  not_if "keystone-manage role list|grep Admin"
end

execute "Keystone: grant Admin role to admin user" do
  # command syntax: role grant 'role' 'user' 'tenant (optional)'
  command "keystone-manage role grant Admin admin openstack"
  action :run
  not_if "keystone-manage role list openstack|grep Admin"
end

["identity", "nova", "glance"].each do |name|
  execute "Keystone: add #{name} service" do
    # command syntax: service add 'service'
    command "keystone-manage service add #{name}" 
    action :run
    not_if "keystone-manage service list|grep #{name}"
  end
end

execute "Keystone: add identity entpointTemplates" do
  # command syntax: endpointTemplates add 'region' 'service' 'publicURL' 'adminURL' 'internalURL' 'enabled' 'global'
  node.set[:keystone][:adminURL] = "http://#{node[:ipaddress]}:5001/v2.0" 
  node.set[:keystone][:internalURL] = "http://#{node[:ipaddress]}:5000/v2.0"
  node.set[:keystone][:publicURL] = node[:keystone][:internalURL]
  command "keystone-manage endpointTemplates add RegionOne identity #{node[:keystone][:publicURL]} #{node[:keystone][:adminURL]} #{node[:keystone][:internalURL]} 1 1"
  action :run
  not_if "keystone-manage endpointTemplates list|grep 'identity'"
end

execute "Keystone: add nova entpointTemplates" do
  # command syntax: endpointTemplates add 'region' 'service' 'publicURL' 'adminURL' 'internalURL' 'enabled' 'global'
  node.set[:nova][:adminURL] = "http://#{node[:ipaddress]}:8774/v1.1/%tenant_id%" 
  node.set[:nova][:internalURL] = node[:nova][:adminURL]
  node.set[:nova][:publicURL] = node[:nova][:adminURL]
  command "keystone-manage endpointTemplates add RegionOne nova #{node[:nova][:publicURL]} #{node[:nova][:adminURL]} #{node[:nova][:internalURL]} 1 1"
  action :run
  not_if "keystone-manage endpointTemplates list|grep 'nova'"
end

execute "Keystone: add glance entpointTemplates" do
  # command syntax: endpointTemplates add 'region' 'service' 'publicURL' 'adminURL' 'internalURL' 'enabled' 'global'
  node.set[:glance][:adminURL] = "http://#{node[:ipaddress]}:9292/v1.1/%tenant_id%" 
  node.set[:glance][:internalURL] = node[:glance][:adminURL] 
  node.set[:glance][:publicURL] = node[:glance][:adminURL]
  command "keystone-manage endpointTemplates add RegionOne glance #{node[:glance][:publicURL]} #{node[:glance][:adminURL]} #{node[:glance][:internalURL]} 1 1"
  action :run
  not_if "keystone-manage endpointTemplates list|grep 'glance'"
end

["identity", "nova", "glance"].each_index do |index|
  execute "Keystone: add service (index: #{index}) endpoint" do
    # command syntax: endPoint add tenant endPointTemplate
    command "keystone-manage endpoint add 1 #{index+1}"
    action :run
  end
end
