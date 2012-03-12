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

include_recipe "mysql::client"

mysql_database "create nova database" do
  host node[:controller_ip]
  username "root"
  password node['mysql']['server_root_password']
  database node[:nova][:db]
  action [:create_db]
end

mysql_database "create nova db user" do
  host node[:controller_ip]
  username "root"
  password node['mysql']['server_root_password']
  sql "grant all privileges on #{node[:nova][:db]}.* to '#{node[:nova][:db_user]}'@'%'"
  action :query
end

mysql_database "configure nova db password" do
  host node[:controller_ip]
  username "root"
  password node['mysql']['server_root_password']
  sql "SET PASSWORD for '#{node[:nova][:db_user]}'@'%' = PASSWORD('#{node[:nova][:db_passwd]}')"
  action :query
end

# extract the mysql root pass fropm the attributes file for easy reference 
# later in the recipe
#root_pass = node['mysql']['root_pass']


#["nova", "glance", "keystone", "dash"].each do |service|
#  execute "create #{service} database schema" do
#    command "mysql -u root  -p#{root_pass} -e 'create database #{node[service][:db]}'"
#    action :run
#    not_if "/usr/bin/mysql -u root -p#{root_pass} -e 'show databases;'|grep '#{node[service][:db]}'"
#  end
#end

#["nova", "glance", "keystone", "dash"].each do |service|
#  execute "create #{service} user" do
#    command "mysql -u root -p#{root_pass} -e \"grant all privileges on #{node[service][:db]}.* to '#{node[service][:db_user]}'@'%'\""
#    action :run
#    not_if "mysql -u root -p#{root_pass} -e \"show grants for '#{node[service][:db_user]}'@'%'\""
#  end
#end

#["nova", "glance", "keystone", "dash"].each do |service|
#  execute "set #{service} user password" do
#    command "mysql -u root -p#{root_pass} -e \"SET PASSWORD for '#{node[service][:db_user]}'@'%' = PASSWORD('#{node[service][:db_passwd]}')\""
#    not_if "mysql -u root -e -p#{root_pass}\"select * from mysql.user where user='#{node[service][:db_user]}' and password=PASSWORD('#{node[service][:db_passwd]}')\\G\"| grep #{node[service][:db_user]}"
#  end
#end
