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

include_recipe "openstack::nova-common"

package "python-keystone" do
  action :upgrade
end

package "nova-api" do
  action :upgrade
  options "-o Dpkg::Options::='--force-confold' --force-yes"
end

service "apache2" do
  supports :status => true, :reload => true, :restart => true
  action :enable
end

template "/etc/nova/api-paste.ini" do
  source "api-paste.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :ip_address => node[:controller_ipaddress],
    :component  => node[:package_component],
    :service_port => node[:keystone][:service_port],
    :admin_port => node[:keystone][:admin_port],
    :admin_token => node[:keystone][:admin_token]
  )
#  notifies :restart, resources(:service => "nova-api"), :immediately
end

template "/etc/nova/policy.json" do
  source "nova-api-policy.json.erb"
  owner "root"
  group "root"
  mode "0644"
#  notifies :restart, resources(:service => "nova-api"), :immediately
end

template "/etc/apache2/sites-available/nova-api" do
  source "nova-api-ssl.erb"
  owner "root"
  group "root"
  mode "0644"
end

template "/var/lib/nova/nova-api.wsgi" do
  source "nova-api-apache-wsgi.erb"
  owner "root"
  group "root"
  mode "0644"
end

service "apache2" do
  supports :status => true, :reload => true, :restart => true
  action :enable
end

service "nova-api" do
  supports :status => true, :restart => true
  action :disable
  subscribes :restart, resources(:template => "/etc/nova/nova.conf"), :delayed
  subscribes :restart, resources(:template => "/etc/nova/policy.json"), :delayed
end

execute "a2enmod wsgi" do
  command "a2enmod wsgi"
  action :run
  notifies :restart, resources(:services => "apache2"), :immediately
  not_if "test -L /etc/apache2/mods-enabled/wsgi.load"
end

execute "a2ensite nova-api" do
  command "a2ensite nova-api"
  action :run
  notifies :reload, resources(:service => "apache2"), :immediately
  not_if "test -L /etc/apache2/sites-enabled/nova-api"
end
