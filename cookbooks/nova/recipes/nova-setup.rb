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

include_recipe "nova::nova-common"
include_recipe "mysql::client"

connection_info = {:host => node[:nova][:db_host], :username => "root", :password => node['mysql']['server_root_password']}
mysql_database "create nova database" do
  connection connection_info
  database_name node[:nova][:db]
  action :create
end

mysql_database_user node[:nova][:db_user] do
  connection connection_info
  password node[:nova][:db_passwd]
  action :create
end

mysql_database_user node[:nova][:db_user] do
  connection connection_info
  password node[:nova][:db_passwd]
  database_name node[:nova][:db]
  host '%'
  privileges [:all]
  action :grant
end

execute "nova-manage db sync" do
  command "nova-manage db sync"
  action :run
  not_if "nova-manage db version && test $(nova-manage db version) -gt 0"
end

execute "nova-manage network create --label=public" do
  command "nova-manage network create --multi_host='T' --label=#{node[:public][:label]} --fixed_range_v4=#{node[:public][:ipv4_cidr]} --num_networks=#{node[:public][:num_networks]} --network_size=#{node[:public][:network_size]} --bridge=#{node[:public][:bridge]} --bridge_interface=#{node[:public][:bridge_dev]} --dns1=#{node[:public][:dns1]} --dns2=#{node[:public][:dns2]}"
  action :run
  not_if "nova-manage network list | grep #{node[:public][:ipv4_cidr]}"
end

execute "nova-manage network create --label=private" do
  command "nova-manage network create --multi_host='T' --label=#{node[:private][:label]} --fixed_range_v4=#{node[:private][:ipv4_cidr]} --num_networks=#{node[:private][:num_networks]} --network_size=#{node[:private][:network_size]} --bridge=#{node[:private][:bridge]} --bridge_interface=#{node[:private][:bridge_dev]}"
  action :run
  not_if "nova-manage network list | grep #{node[:private][:ipv4_cidr]}"
end


if node.has_key?(:floating) and node[:floating].has_key?(:ipv4_cidr)
  execute "nova-manage floating create" do
    command "nova-manage floating create --ip_range=#{node[:floating][:ipv4_cidr]}"
    action :run
    not_if "nova-manage floating list"
  end
end


