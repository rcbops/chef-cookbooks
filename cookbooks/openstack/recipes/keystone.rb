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
  notifies :restart, resources(:service => "keystone"), :immediately
  notifies :run, resources(:execute => "keystone-manage db_sync"), :immediately
end

token = "#{node[:keystone][:admin_token]}"
admin_url = "http://#{node[:controller_ipaddress]}:#{node[:keystone][:admin_port]}/v2.0"
keystone_cmd = "keystone --token #{token} --endpoint #{admin_url}"

execute "Keystone: add openstack tenant" do
  command "#{keystone_cmd} tenant-create --name openstack --description openstack_tenant --enabled true"
  action :run
  not_if "#{keystone_cmd} tenant-list|grep openstack"
end

bash "Keystone: add admin user" do
  user "root"
  code <<-EOH
    TENANT_UUID=$(#{keystone_cmd} tenant-list|grep openstack|awk '{print $2}')
    if ! #{keystone_cmd} user-list ${TENANT_UUID}|grep admin; then
        #{keystone_cmd} user-create --name admin --pass secrete --tenant_id ${TENANT_UUID} --enabled true
    fi
  EOH
end



#ruby_block "Grap user_uuid" do
#  block do
#    user_uuid = %x[#{keystone_cmd} user-list | grep admin | awk '{print $2}'].chomp()
#  end
#  action :create
#end


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

bash "Keystone: user-role-add --user admin --role admin --tenant <openstack uuid>
  user "root"
  code <<-EOH
    TENANT_UUID=$(#{keystone_cmd} tenant-list|grep openstack|awk '{print $2}')
    USER_UUID=$(#{keystone_cmd} user-list ${TENANT_UUID}|grep admin|awk '{print $2}')
    ROLE_UUID=$(#{keystone_cmd} role-list|grep admin | head -1 |awk '{print $2}')
    semaphore=/var/lib/keystone/nice_to_see_we_are_still_not_testing_the_cli.semaphore
    if [ ! -e ${semaphore} ];
        #{keystone_cmd} user-role-add --user ${USER_UUID} --role ${ROLE_UUID} --tenant_id ${TENANT_UUID}
        touch ${semaphore}
    fi
  EOH
end

##execute "Keystone: user-role-add --user admin --role admin --tenant openstack" do
##  Chef::Log.info "User ID: #{node['user_uuid']}"
##  Chef::Log.info "Tenant ID: #{node['tenant_uuid']}"
##  Chef::Log.info "Admin Role ID: #{node['admin_uuid']}"
##  command "#{keystone_cmd} user-role-add --user #{user_uuid} --role #{admin_uuid} --tenant #{tenant_uuid} && touch /var/lib/keystone/nice_to_see_we_are_still_not_testing_the_cli.semaphore"
##  action :run
##  not_if { File.exists?("/var/lib/keystone/nice_to_see_we_are_still_not_testing_the_cli.semaphore") }
##end

execute "Keystone: service-create --name keystone --type identity" do
  command "#{keystone_cmd} service-create --name keystone --type identity --description='Keystone Identity Service'"
  action :run
  not_if "#{keystone_cmd} service-list |grep keystone"
end

##execute "Keystone: create identity endpoint" do
##  cmd = Chef::ShellOut.new("#{keystone_cmd} service-list | grep keystone | awk '{print $2}'")
##  tmp = cmd.run_command
##  service_uuid = tmp.stdout.chomp
#  Chef::Log.info "Keystone Service ID: #{service_uuid}"
##  node.set[:keystone][:adminURL] = "http://#{node[:controller_ipaddress]}:#{node[:keystone][:admin_port]}/v2.0"
##  node.set[:keystone][:internalURL] = "http://#{node[:controller_ipaddress]}:#{node[:keystone][:service_port]}/v2.0"
##  node.set[:keystone][:publicURL] = node[:keystone][:internalURL]
##  command "#{keystone_cmd} endpoint-create --region RegionOne --service_id #{service_uuid} --publicurl #{node[:keystone][:publicURL]} --adminurl #{node[:keystone][:adminURL]} --internalurl #{node[:keystone][:internalURL]}"
##  action :run
##  not_if "#{keystone_cmd} endpoint-list |grep #{node[:keystone][:adminURL]}"
##end

execute "Keystone: service-create --name nova --type compute" do
  command "#{keystone_cmd} service-create --name nova --type compute --description='Nova Compute Service'"
  action :run
  not_if "#{keystone_cmd} service-list |grep nova"
end

##execute "Keystone: create compute endpoint" do
##  cmd = Chef::ShellOut.new("#{keystone_cmd} service-list | grep nova | awk '{print $2}'")
##  tmp = cmd.run_command
##  service_uuid = tmp.stdout.chomp
#  Chef::Log.info "Nova Service ID: #{service_uuid}"
##  node.set[:nova][:adminURL] = "http://#{node[:controller_ipaddress]}:8774/v1.1/%tenant_id%"
##  node.set[:nova][:internalURL] = node[:nova][:adminURL]
##  node.set[:nova][:publicURL] = node[:nova][:adminURL]
##  command "#{keystone_cmd} endpoint-create --region RegionOne --service_id #{service_uuid} --publicurl #{node[:nova][:publicURL]} --adminurl #{node[:nova][:adminURL]} --internalurl #{node[:nova][:internalURL]}"
##  action :run
##  not_if "#{keystone_cmd} endpoint-list |grep #{node[:nova][:adminURL]}"
##end

execute "Keystone: service-create --name glance --type image" do
  command "#{keystone_cmd} service-create --name glance --type image --description='Glance Image Service'"
  action :run
  not_if "#{keystone_cmd} service-list |grep glance"
end

##execute "Keystone: create image endpoint" do
##  cmd = Chef::ShellOut.new("#{keystone_cmd} service-list | grep glance | awk '{print $2}'")
##  tmp = cmd.run_command
##  service_uuid = tmp.stdout.chomp
#  Chef::Log.info "Glance Service ID: #{service_uuid}"
##  node.set[:glance][:adminURL] = "http://#{node[:controller_ipaddress]}:#{node[:glance][:api_port]}/v1"
##  node.set[:glance][:internalURL] = node[:glance][:adminURL]
##  node.set[:glance][:publicURL] = node[:glance][:adminURL]
##  command "#{keystone_cmd} endpoint-create --region RegionOne --service_id #{service_uuid} --publicurl #{node[:glance][:publicURL]} --adminurl #{node[:glance][:adminURL]} --internalurl #{node[:glance][:internalURL]}"
##  action :run
##  not_if "#{keystone_cmd} endpoint-list |grep #{node[:glance][:adminURL]}"
##end

execute "Keystone: service-create --name ec2 --type ec2" do
  command "#{keystone_cmd} service-create --name ec2 --type ec2 --description='EC2 Compatibility Layer'"
  action :run
  not_if "#{keystone_cmd} service-list |grep ec2"
end

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
