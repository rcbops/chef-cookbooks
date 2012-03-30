#
# Cookbook Name:: glance
# Recipe:: registry
#
# Copyright 2009, Rackspace Hosting, Inc.
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
  glance_package = "openstack-glance"
  glance_registry_service = "openstack-glance-registry"
  glance_package_options = ""
else
  # All Others (right now Debian and Ubuntu)
  mysql_python_package="python-mysqldb"
  glance_package = "glance"
  glance_registry_service = "glance-registry"
  glance_package_options = "-o Dpkg::Options::='--force-confold' --force-yes"
end

package "python-keystone" do
    action :install
end

connection_info = {:host => node["glance"]["db_ipaddress"], :username => "root", :password => node["mysql"]["server_root_password"]}
mysql_database "create glance database" do
  connection connection_info
  database_name node["glance"]["db"]
  action :create
end

mysql_database_user node["glance"]["db_user"] do
  connection connection_info
  password node["glance"]["db_passwd"]
  action :create
end

mysql_database_user node["glance"]["db_user"] do
  connection connection_info
  password node["glance"]["db_passwd"]
  database_name node["glance"]["db"]
  host '%'
  privileges [:all]
  action :grant 
end

package "curl" do
  action :install
end

package mysql_python_package do
  action :install
end

package glance_package do
  action :upgrade
end

service glance_registry_service do
  supports :status => true, :restart => true
  action :enable
end

execute "glance-manage db_sync" do
        command "sudo -u glance glance-manage db_sync"
        action :nothing
        notifies :restart, resources(:service => glance_registry_service), :immediately
end

file "/var/lib/glance/glance.sqlite" do
    action :delete
end

# Register Service Tenant
keystone_register "Register Service Tenant" do
  auth_host node["keystone"]["api_ipaddress"]
  auth_port node["keystone"]["admin_port"]
  auth_protocol "http"
  api_ver "/v2.0"
  auth_token node["keystone"]["admin_token"]
  tenant_name node["glance"]["service_tenant_name"]
  tenant_description "Service Tenant"
  tenant_enabled "true" # Not required as this is the default
  action :create_tenant
end

# Register Service User
keystone_register "Register Service User" do
  auth_host node["keystone"]["api_ipaddress"]
  auth_port node["keystone"]["admin_port"]
  auth_protocol "http"
  api_ver "/v2.0"
  auth_token node["keystone"]["admin_token"]
  tenant_name node["glance"]["service_tenant_name"]
  user_name node["glance"]["service_user"]
  user_pass node["glance"]["service_pass"]
  user_enabled "true" # Not required as this is the default
  action :create_user
end

## Grant Admin role to Service User for Service Tenant ##
keystone_register "Grant 'admin' Role to Service User for Service Tenant" do
  auth_host node["keystone"]["api_ipaddress"]
  auth_port node["keystone"]["admin_port"]
  auth_protocol "http"
  api_ver "/v2.0"
  auth_token node["keystone"]["admin_token"]
  tenant_name node["glance"]["service_tenant_name"]
  user_name node["glance"]["service_user"]
  role_name node["glance"]["service_role"]
  action :grant_role
end

directory "/etc/glance" do
  action :create
  group "glance"
  owner "glance"
  mode "0700"
  not_if do
    File.exists?("/etc/glance")
  end
end  

template "/etc/glance/glance-registry.conf" do
  source "glance-registry.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :registry_port => node["glance"]["registry_port"],
    :user => node["glance"]["db_user"],
    :keystone_api_ipaddress => node["keystone"]["api_ipaddress"],
    :passwd => node["glance"]["db_passwd"],
    :ip_address => node["controller_ipaddress"],
    :db_name => node["glance"]["db"],
    :db_ipaddress => node["glance"]["db_ipaddress"],
    :service_port => node["keystone"]["service_port"],
    :admin_port => node["keystone"]["admin_port"],
    :admin_token => node["keystone"]["admin_token"],
    :service_tenant_name => node["glance"]["service_tenant_name"],
    :service_user => node["glance"]["service_user"],
    :service_pass => node["glance"]["service_pass"]
  )
  notifies :run, resources(:execute => "glance-manage db_sync"), :immediately
end

template "/etc/glance/glance-registry-paste.ini" do
  source "glance-registry-paste.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :ip_address => node["controller_ipaddress"],
    :keystone_api_ipaddress => node["keystone"]["api_ipaddress"],
    :service_port => node["keystone"]["service_port"],
    :admin_port => node["keystone"]["admin_port"],
    :admin_token => node["keystone"]["admin_token"],
    :service_tenant_name => node["glance"]["service_tenant_name"],
    :service_user => node["glance"]["service_user"],
    :service_pass => node["glance"]["service_pass"]
  )
  notifies :restart, resources(:service => glance_registry_service), :immediately
end
