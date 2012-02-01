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

# extract the mysql root pass fropm the attributes file for easy reference 
# later in the recipe
root_pass = node['mysql']['root_pass']

# set some preseed selections before installing mysql-server
directory "/var/cache/local/preseeding" do
  owner "root"
  group node['mysql']['root_group']
  mode 0755
  recursive true
end

execute "preseed mysql-server" do
  command "debconf-set-selections /var/cache/local/preseeding/mysql-server.seed"
  action :nothing
end

template "/var/cache/local/preseeding/mysql-server.seed" do
  cookbook "openstack"
  source "mysql-server.seed.erb"
  owner "root"
  group node['mysql']['root_group']
  mode "0600"
  notifies :run, resources(:execute => "preseed mysql-server"), :immediately
end



# go ahead and install
package "mysql-server" do
  action :install
end

service "mysql" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end

package "mysql-client" do
  action :install
end

template "/etc/mysql/conf.d/nova-mysql.cnf" do
  # conf.d settings will override my.cnf settings
  source "nova-mysql.cnf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "mysql"), :immediately
end

["nova", "glance", "keystone", "dash"].each do |service|
  execute "create #{service} database schema" do
    command "mysql -u root  -p#{root_pass} -e 'create database #{node[service][:db]}'"
    action :run
    not_if "/usr/bin/mysql -u root -p#{root_pass} -e 'show databases;'|grep '#{node[service][:db]}'"
  end
end

["nova", "glance", "keystone", "dash"].each do |service|
  execute "create #{service} user" do
    command "mysql -u root -p#{root_pass} -e \"grant all privileges on #{node[service][:db]}.* to '#{node[service][:db_user]}'@'%'\""
    action :run
    not_if "mysql -u root -p#{root_pass} -e \"show grants for '#{node[service][:db_user]}'@'%'\""
  end
end

["nova", "glance", "keystone", "dash"].each do |service|
  execute "set #{service} user password" do
    command "mysql -u root -p#{root_pass} -e \"SET PASSWORD for '#{node[service][:db_user]}'@'%' = PASSWORD('#{node[service][:db_passwd]}')\""
    not_if "mysql -u root -e -p#{root_pass}\"select * from mysql.user where user='#{node[service][:db_user]}' and password=PASSWORD('#{node[service][:db_passwd]}')\""
  end
end
