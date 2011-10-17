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

package "mysql-server" do
	action :install
end

service "mysql" do
	supports :status => true, :restart => true
        action :enable
end

package "mysql-client" do
	action :install
end

execute "configure mysql bind addr" do
	command "perl -pi -e 's/127.0.0.1/0.0.0.0/g' /etc/mysql/my.cnf"
	action :run
	notifies :restart, resources(:service => "mysql"), :immediately
end

execute "create openstack database schemas" do
  ["nova", "glance", "keystone"].each do |service|
    command "mysql -u root -e 'create database #{node[service][:db]}"
    action :run
    not_if "/usr/bin/mysql -u root -e 'show databases;'|grep '#{node[service][:db]}'"
  end
end

# execute "create nova database" do
#	command "mysql -u root -e 'create database #{node[:nova][:db]}'"
#	action :run
#	not_if "/usr/bin/mysql -u root -e 'show databases;'|grep '#{node[:nova][:db]}'"
#end

execute "create nova user" do
	command "mysql -u root -e \"grant all privileges on #{node[:nova][:db]}.* to '#{node[:nova][:db_user]}'@'%'\""
	action :run
end

execute "set nova user password" do
	command "mysql -u root -e \"SET PASSWORD for '#{node[:nova][:db_user]}'@'%' = PASSWORD('#{node[:nova][:db_passwd]}')\""
end

#execute "create glance database" do
#	command "mysql -u root -e 'create database #{node[:glance][:db]}'"
#	action :run
#	not_if "/usr/bin/mysql -u root -e 'show databases;'|grep '#{node[:glance][:db]}'"
#end

execute "create glance user" do
	command "mysql -u root -e \"grant all privileges on #{node[:glance][:db]}.* to '#{node[:glance][:db_user]}'@'%'\""
	action :run
end

execute "set glance user password" do
	command "mysql -u root -e \"SET PASSWORD for '#{node[:glance][:db_user]}'@'%' = PASSWORD('#{node[:glance][:db_passwd]}')\""
end

#execute "create keystone database" do
#	command "mysql -u root -e 'create database #{node[:keystone][:db]}'"
#	action :run
#	not_if "/usr/bin/mysql -u root -e 'show databases;'|grep '#{node[:keystone][:db]}'"
#end

execute "create glance user" do
	command "mysql -u root -e \"grant all privileges on #{node[:keystone][:db]}.* to '#{node[:keystone][:db_user]}'@'%'\""
	action :run
end

execute "set glance user password" do
	command "mysql -u root -e \"SET PASSWORD for '#{node[:keystone][:db_user]}'@'%' = PASSWORD('#{node[:keystone][:db_passwd]}')\""
end

