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

include_recipe "mysql::client"

# Distribution specific settings go here
if platform?(%w{fedora})
  # Fedora
  mysql_python_package = "MySQL-python"
  keystone_package = "openstack-keystone"
  keystone_service = keystone_package
  keystone_package_options = ""
else
  # All Others (right now Debian and Ubuntu)
  mysql_python_package="python-mysqldb"
  keystone_package = "keystone"
  keystone_service = keystone_package
  keystone_package_options = "-o Dpkg::Options::='--force-confold' --force-yes"
end

if platform?(%w{fedora})
  # THIS IS TEMPORARY!!!  Remove this when fedora fixes their packages.
  remote_file "/tmp/openstack-keystone-2012.1-0.11.erc1.fc17.noarch.rpm" do
    source "http://www.breu.org/filedrop/nova/openstack-keystone-2012.1-0.11.erc1.fc17.noarch.rpm"
    action :create_if_missing
  end
  remote_file "/tmp/python-keystone-2012.1-0.11.erc1.fc17.noarch.rpm" do
    source "http://www.breu.org/filedrop/nova/python-keystone-2012.1-0.11.erc1.fc17.noarch.rpm"
    action :create_if_missing
  end

  bash "install keystone" do
    cwd "/tmp"
    user "root"
    code <<-EOH
        set -e
        set -x
        yum -y install /tmp/openstack-keystone-2012.1-0.11.erc1.fc17.noarch.rpm /tmp/python-keystone-2012.1-0.11.erc1.fc17.noarch.rpm || :
        service openstack-keystone restart
    EOH
  end
end

connection_info = {:host => node[:keystone][:db_host], :username => "root", :password => node['mysql']['server_root_password']}
mysql_database "create keystone database" do
  connection connection_info
  database_name node[:keystone][:db]
  action :create
end

mysql_database_user node[:keystone][:db_user] do
  connection connection_info
  password node[:keystone][:db_passwd]
  action :create
end

mysql_database_user node[:keystone][:db_user] do
  connection connection_info
  password node[:keystone][:db_passwd]
  database_name node[:keystone][:db]
  host '%'
  privileges [:all]
  action :grant 
end

##### NOTE #####
# https://bugs.launchpad.net/ubuntu/+source/keystone/+bug/931236
################

package mysql_python_package do
  action :install
end

package keystone_package do
  action :upgrade
  options keystone_package_options
end

service keystone_service do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

file "/var/lib/keystone/keystone.db" do
  action :delete
end

execute "keystone-manage db_sync" do
  command "keystone-manage db_sync"
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
            :db_host => node[:keystone][:db_host],
            :service_port => node[:keystone][:service_port],
            :admin_port => node[:keystone][:admin_port],
            :admin_token => node[:keystone][:admin_token]
            )
  notifies :run, resources(:execute => "keystone-manage db_sync"), :immediately
end

template "/etc/keystone/logging.conf" do
  source "keystone-logging.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => keystone_service), :immediately
end

execute "Keystone: sleep" do
  command "sleep 10s"
  action :run
end

token = "#{node[:keystone][:admin_token]}"
admin_url = "http://#{node[:controller_ipaddress]}:#{node[:keystone][:admin_port]}/v2.0"
keystone_cmd = "keystone --token #{token} --endpoint #{admin_url}"


## Add openstack tenant ##
keystone_register "Register 'openstack' Tenant" do
  auth_host node[:controller_ipaddress]
  auth_port node[:keystone][:admin_port]
  auth_protocol "http"
  api_ver "/v2.0"
  auth_token node[:keystone][:admin_token]
  tenant_name "openstack"
  tenant_description "Default Tenant"
  tenant_enabled "true" # Not required as this is the default
  action :create_tenant
end

## Add admin user ##
keystone_register "Register 'admin' User" do
  auth_host node[:controller_ipaddress]
  auth_port node[:keystone][:admin_port]
  auth_protocol "http"
  api_ver "/v2.0"
  auth_token node[:keystone][:admin_token]
  tenant_name "openstack"
  user_name "admin"
  user_pass "secrete"
  user_enabled "true" # Not required as this is the default
  action :create_user
end

## Add Roles ##
node[:keystone][:roles].each do |role_key|
  keystone_register "Register '#{role_key.to_s}' Role" do
    auth_host node[:controller_ipaddress]
    auth_port node[:keystone][:admin_port]
    auth_protocol "http"
    api_ver "/v2.0"
    auth_token node[:keystone][:admin_token]
    role_name role_key
    action :create_role
  end
end


## Add Admin role to admin user ##
keystone_register "Grant 'admin' Role to 'admin' User" do
  auth_host node[:controller_ipaddress]
  auth_port node[:keystone][:admin_port]
  auth_protocol "http"
  api_ver "/v2.0"
  auth_token node[:keystone][:admin_token]
  tenant_name "openstack"
  user_name "admin"
  role_name "admin"
  action :grant_role
end

## Add Services ##

keystone_register "Register Identity Service" do
  auth_host node[:controller_ipaddress]
  auth_port node[:keystone][:admin_port]
  auth_protocol "http"
  api_ver "/v2.0"
  auth_token node[:keystone][:admin_token]
  service_name "keystone"
  service_type "identity"
  service_description "Keystone Identity Service"
  action :create_service
end

keystone_register "Register Compute Service" do
  auth_host node[:controller_ipaddress]
  auth_port node[:keystone][:admin_port]
  auth_protocol "http"
  api_ver "/v2.0"
  auth_token node[:keystone][:admin_token]
  service_name "nova"
  service_type "compute"
  service_description "Nova Compute Service"
  action :create_service
end

keystone_register "Register EC2 Service" do
  auth_host node[:controller_ipaddress]
  auth_port node[:keystone][:admin_port]
  auth_protocol "http"
  api_ver "/v2.0"
  auth_token node[:keystone][:admin_token]
  service_name "ec2"
  service_type "ec2"
  service_description "EC2 Compatibility Layer"
  action :create_service
end


## Add Endpoints ##

node[:keystone][:adminURL] = "http://#{node[:controller_ipaddress]}:#{node[:keystone][:admin_port]}/v2.0"
node[:keystone][:internalURL] = "http://#{node[:controller_ipaddress]}:#{node[:keystone][:service_port]}/v2.0"
node[:keystone][:publicURL] = node[:keystone][:internalURL]

Chef::Log.info "Keystone AdminURL: #{node[:keystone][:adminURL]}"
Chef::Log.info "Keystone InternalURL: #{node[:keystone][:internalURL]}"
Chef::Log.info "Keystone PublicURL: #{node[:keystone][:publicURL]}"

keystone_register "Register Identity Endpoint" do
  auth_host node[:controller_ipaddress]
  auth_port node[:keystone][:admin_port]
  auth_protocol "http"
  api_ver "/v2.0"
  auth_token node[:keystone][:admin_token]
  service_type "identity"
  endpoint_region "RegionOne"
  endpoint_adminurl node[:keystone][:adminURL]
  endpoint_internalurl node[:keystone][:internalURL]
  endpoint_publicurl node[:keystone][:publicURL]
  action :create_endpoint
end

node[:nova][:adminURL] = "http://#{node[:controller_ipaddress]}:8774/v1.1/%(tenant_id)s"
node[:nova][:internalURL] = node[:nova][:adminURL]
node[:nova][:publicURL] = node[:nova][:adminURL]

keystone_register "Register Compute Endpoint" do
  auth_host node[:controller_ipaddress]
  auth_port node[:keystone][:admin_port]
  auth_protocol "http"
  api_ver "/v2.0"
  auth_token node[:keystone][:admin_token]
  service_type "compute"
  endpoint_region "RegionOne"
  endpoint_adminurl node[:nova][:adminURL]
  endpoint_internalurl node[:nova][:internalURL]
  endpoint_publicurl node[:nova][:publicURL]
  action :create_endpoint
end


## Create EC2 credentials ##

##execute "Keystone: ec2-credentials create --user admin --tenant_id openstack" do
##  cmd = Chef::ShellOut.new("#{keystone_cmd} tenant-list | grep openstack | awk '{print $2}'")
##  tmp = cmd.run_command
##  tenant_uuid = tmp.stdout.chomp
#  Chef::Log.info "Tenant ID: #{tenant_uuid}"
##  cmd = Chef::ShellOut.new("#{keystone_cmd} user-list | grep admin | awk '{print $2}'")
##  tmp = cmd.run_command
##  user_uuid = tmp.stdout.chomp
#  Chef::Log.info "User ID: #{user_uuid}"
##  command "#{keystone_cmd} ec2-credentials-create --user #{user_uuid} --tenant_id #{tenant_uuid}"
##  action :run
##  not_if "#{keystone_cmd} ec2-credentials-list --user #{user_uuid} | grep 'admin'"
##end
