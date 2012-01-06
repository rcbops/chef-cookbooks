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
include_recipe "openstack::mysql"
include_recipe "openstack::api"
include_recipe "openstack::keystone"

package "openstack-dashboard" do
  action :upgrade
end

service "apache2" do
  supports :status => true, :reload => true, :restart => true
  action :enable
end

execute "a2enmod rewrite" do
        command "a2enmod rewrite"
        action :run
        notifies :restart, resources(:service => "apache2"), :delayed
end

execute "a2enmod wsgi" do
        command "a2enmod wsgi"
        action :run
        notifies :restart, resources(:service => "apache2"), :immediately
end

execute "a2ensite dash" do
        command "a2ensite dash"
        action :run
        notifies :reload, resources(:service => "apache2"), :immediately
end

execute "a2dissite default" do
	command "a2dissite default"
	action :run
	notifies :reload, resources(:service => "apache2"), :immediately
end

template "/var/lib/dash/local/local_settings.py" do
  source "local_settings.py.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :user => node[:dash][:db_user],
    :passwd => node[:dash][:db_passwd],
    :ip_address => node[:controller_ipaddress],
    :db_name => node[:dash][:db],
    :service_port => node[:keystone][:service_port],
    :admin_token => node[:keystone][:admin_token]
  )
end

execute "PYTHONPATH=/var/lib/dash/ python dashboard/manage.py syncdb" do
  cwd "/var/lib/dash"
  environment ({'PYTHONPATH' => '/var/lib/dash/'})
  command "python dashboard/manage.py syncdb"
  action :run
  notifies :restart, resources(:service => "apache2"), :immediately
  notifies :restart, resources(:service => "nova-api"), :immediately
end

