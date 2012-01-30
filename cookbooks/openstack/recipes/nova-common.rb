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

package "nova-common" do
  action :upgrade
  options "-o Dpkg::Options::='--force-confold' --force-yes"
end

template "/etc/nova/nova.conf" do
  source "nova.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :user => node[:nova][:db_user],
    :passwd => node[:nova][:db_passwd],
    :ip_address => node[:controller_ipaddress],
    :db_name => node[:nova][:db],
    :api_port => node[:glance][:api_port],
    :ipv4_cidr => node[:public][:ipv4_cidr],
    :virt_type => node[:virt_type]
  )
end

template "/root/.novarc" do
  source "novarc.erb"
  owner "root"
  group "root"
  mode "0600"
  variables(
    :user => 'admin',
    :tenant => 'openstack',
    :password => 'secrete',
    :keystone_api_ip => node[:controller_ipaddress],
    :keystone_service_port => node[:keystone][:service_port],
    :nova_api_version => '1.1',
    :keystone_region => 'RegionOne',
    :auth_strategy => 'keystone'
  )
end
