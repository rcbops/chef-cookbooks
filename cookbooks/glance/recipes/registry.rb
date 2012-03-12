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
# include_recipe "keystone::server"

package "curl" do
  action :install
end

package "python-mysqldb" do
  action :install
end

# Supposedly Resolved
# Fixes issue https://bugs.launchpad.net/ubuntu/+source/glance/+bug/943748
#package "python-dateutil" do
#  action :install
#end

package "glance" do
  action :upgrade
end

service "glance-registry" do
  supports :status => true, :restart => true
  action :enable
end

execute "glance-manage db_sync" do
        command "glance-manage db_sync"
        action :nothing
        notifies :restart, resources(:service => "glance-registry"), :immediately
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
    :ip_address => node[:controller_ipaddress],
    :db_name => node[:glance][:db],
    :service_port => node[:keystone][:service_port],
    :admin_port => node[:keystone][:admin_port],
    :admin_token => node[:keystone][:admin_token]
  )
  notifies :run, resources(:execute => "glance-manage db_sync"), :immediately
end

template "/etc/glance/glance-registry-paste.ini" do
  source "glance-registry-paste.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :ip_address => node[:controller_ipaddress],
    :service_port => node[:keystone][:service_port],
    :admin_port => node[:keystone][:admin_port],
    :admin_token => node[:keystone][:admin_token]
  )
  notifies :restart, resources(:service => "glance-registry"), :immediately
end
