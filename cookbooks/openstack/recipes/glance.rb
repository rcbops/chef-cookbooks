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

include_recipe "openstack::mysql"

package "python-mysqldb" do
  action :install
end

package "glance" do
  action :install
  options "--force-yes"
end

service "glance-api" do
  supports :status => true, :restart => true
  action :enable
end

service "glance-registry" do
  supports :status => true, :restart => true
  action :enable
end

file "/var/lib/glance/glance.sqlite" do
    action :delete
end

template "/etc/glance/glance-registry.conf" do
  source "glance-registry.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :registry_port => node[:glance][:registry_port],
    :user => node[:glance][:db_user],
    :passwd => node[:glance][:db_passwd],
    :ip_address => node[:ipaddress],
    :db_name => node[:glance][:db]
  )
  notifies :restart, resources(:service => "glance-registry"), :immediately
end

template "/etc/glance/glance-api.conf" do
  source "glance-api.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :api_port => node[:glance][:api_port],
    :registry_port => node[:glance][:registry_port]
  )
  notifies :restart, resources(:service => "glance-api"), :immediately
end

template "/etc/glance/glance-scrubber.conf" do
  source "glance-scrubber.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :user => node[:glance][:db_user],
    :passwd => node[:glance][:db_passwd],
    :ip_address => node[:ipaddress],
    :db_name => node[:glance][:db]
  )
end

bash "default image setup" do
  cwd "/tmp"
  user "root"
  code <<-EOH
      mkdir images
      wget #{node[:image][:ubuntu-11.04]} | tar -zxv -C images/
      glance -A 999888777666 add name="ubuntu-11.04-kernel" disk_format=aki container_format=aki < images/natty-server-uec-amd64-vmlinuz-virtual
      glance -A 999888777666 add name="ubuntu-11.04-initrd" disk_format=ari container_format=ari < images/natty-server-uec-amd64-loader
      glance -A 999888777666 add name="ubuntu-11.04-server" disk_format=ami container_format=ami kernel_id=1 ramdisk_id=2 < images/natty-server-uec-amd64.img

  EOH
  not_if "glance -A 999888777666 index | grep 'ubuntu-11.04-server'"
end
