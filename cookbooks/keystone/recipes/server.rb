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

require 'chef/shell_out'

include_recipe "openstack::apt"
include_recipe "openstack::mysql"

##### NOTE #####
# https://bugs.launchpad.net/ubuntu/+source/keystone/+bug/931236
################

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
  command "sleep 20s"
  action :nothing
  notifies :restart, resources(:service => "keystone"), :immediately
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
  notifies :run, resources(:execute => "Keystone: sleep"), :immediately
end

token = "#{node[:keystone][:admin_token]}"
admin_url = "http://#{node[:controller_ipaddress]}:#{node[:keystone][:admin_port]}/v2.0"
keystone_cmd = "keystone --token #{token} --endpoint #{admin_url}"


## Add openstack tenant ##

execute "Keystone: add openstack tenant" do
  command "#{keystone_cmd} tenant-create --name openstack --description openstack_tenant --enabled true"
  action :run
  not_if "#{keystone_cmd} tenant-list|grep openstack"
end


## Add admin user ##

bash "Keystone: add admin user" do
  user "root"
  code <<-EOH
    TENANT_UUID=$(#{keystone_cmd} tenant-list|grep openstack|awk '{print $2}')
    if ! #{keystone_cmd} user-list ${TENANT_UUID}|grep admin; then
        #{keystone_cmd} user-create --name admin --pass secrete --tenant_id ${TENANT_UUID} --enabled true
    fi
  EOH
end


## Add Roles ##

execute "Keystone: add admin role" do
  command "#{keystone_cmd} role-create --name admin"
  action :run
  not_if "#{keystone_cmd} role-list |grep admin"
end

execute "Keystone: add Member role" do
  command "#{keystone_cmd} role-create --name Member"
  action :run
  not_if "#{keystone_cmd} role-list | grep Member"
end

execute "Keystone: add KeystoneAdmin role" do
  command "#{keystone_cmd} role-create --name KeystoneAdmin"
  action :run
  not_if "#{keystone_cmd} role-list | grep KeystoneAdmin"
end

execute "Keystone: add KeystoneServiceAdmin role" do
  command "#{keystone_cmd} role-create --name KeystoneServiceAdmin"
  action :run
  not_if "#{keystone_cmd} role-list | grep KeystoneServiceAdmin"
end

execute "Keystone: add sysadmin role" do
  command "#{keystone_cmd} role-create --name sysadmin"
  action :run
  not_if "#{keystone_cmd} role-list | grep sysadmin"
end

execute "Keystone: add netadmin role" do
  command "#{keystone_cmd} role-create --name netadmin"
  action :run
  not_if "#{keystone_cmd} role-list | grep netadmin"
end


## Add Admin role to admin user ##

# for keystone-2012.1~e4-0ubuntu2, this actually does nothing in the db
bash "Keystone: user-role-add --user admin --role admin --tenant <openstack uuid>" do
  user "root"
  code <<-EOH
    TENANT_UUID=$(#{keystone_cmd} tenant-list|grep openstack|awk '{print $2}')
    USER_UUID=$(#{keystone_cmd} user-list ${TENANT_UUID}|grep admin|awk '{print $2}')
    ROLE_UUID=$(#{keystone_cmd} role-list|grep admin | head -1 |awk '{print $2}')
    semaphore=/var/lib/keystone/nice_to_see_we_are_still_not_testing_the_cli.semaphore
    if [ ! -e ${semaphore} ]; then
        #{keystone_cmd} user-role-add --user ${USER_UUID} --role ${ROLE_UUID} --tenant_id ${TENANT_UUID}
        touch ${semaphore}
    fi
  EOH
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

keystone_register "Register Image Service" do
  auth_host node[:controller_ipaddress]
  auth_port node[:keystone][:admin_port]
  auth_protocol "http"
  api_ver "/v2.0"
  auth_token node[:keystone][:admin_token]
  service_name "glance"
  service_type "image"
  service_description "Glance Image Service"
  action :create_service
end


## Add Endpoints ##

node[:keystone][:adminURL] = "http://#{node[:controller_ipaddress]}:#{node[:keystone][:admin_port]}/v2.0"
node[:keystone][:internalURL] = "http://#{node[:controller_ipaddress]}:#{node[:keystone][:service_port]}/v2.0"
node[:keystone][:publicURL] = node[:keystone][:internalURL]

Chef::Log.info "Keystone AdminURL: #{node[:keystone][:adminURL]}"
Chef::Log.info "Keystone InternalURL: #{node[:keystone][:internalURL]}"
Chef::Log.info "Keystone PublicURL: #{node[:keystone][:publicURL]}"

bash "Keystone: create identity endpoint" do
  user "root"
  code <<-EOH
    SERVICE_UUID=$(#{keystone_cmd} service-list|grep identity|awk '{print $2}')
    if ! #{keystone_cmd} endpoint-list | grep "#{node[:keystone][:publicURL]}"; then
        #{keystone_cmd} endpoint-create --region RegionOne --service_id ${SERVICE_UUID} --publicurl "#{node[:keystone][:publicURL]}" --adminurl "#{node[:keystone][:adminURL]}" --internalurl "#{node[:keystone][:internalURL]}"
    fi
  EOH
end

node[:nova][:adminURL] = "http://#{node[:controller_ipaddress]}:8774/v1.1/%(tenant_id)s"
node[:nova][:internalURL] = node[:nova][:adminURL]
node[:nova][:publicURL] = node[:nova][:adminURL]

bash "Keystone: create compute endpoint" do
  user "root"
  code <<-EOH
    SERVICE_UUID=$(#{keystone_cmd} service-list|grep compute|awk '{print $2}')
    if ! #{keystone_cmd} endpoint-list | grep "#{node[:nova][:publicURL]}"; then
        #{keystone_cmd} endpoint-create --region RegionOne --service_id ${SERVICE_UUID} --publicurl "#{node[:nova][:publicURL]}" --adminurl "#{node[:nova][:adminURL]}" --internalurl "#{node[:nova][:internalURL]}"
    fi
  EOH
end

node[:glance][:adminURL] = "http://#{node[:controller_ipaddress]}:#{node[:glance][:api_port]}/v1"
node[:glance][:internalURL] = node[:glance][:adminURL]
node[:glance][:publicURL] = node[:glance][:adminURL]

bash "Keystone: create image endpoint" do
  user "root"
  code <<-EOH
    SERVICE_UUID=$(#{keystone_cmd} service-list|grep image|awk '{print $2}')
    if ! #{keystone_cmd} endpoint-list | "grep #{node[:glance][:publicURL]}"; then
        #{keystone_cmd} endpoint-create --region RegionOne --service_id ${SERVICE_UUID} --publicurl "#{node[:glance][:publicURL]}" --adminurl "#{node[:glance][:adminURL]}" --internalurl "#{node[:glance][:internalURL]}"
    fi
  EOH
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
