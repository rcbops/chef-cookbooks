#
# Cookbook Name:: horizon
# Recipe:: default
#
# Copyright 2012, Rackspace Hosting, Inc.
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

include_recipe "apache2"
include_recipe "apache2::mod_wsgi"
include_recipe "apache2::mod_rewrite"
include_recipe "apache2::mod_ssl"
include_recipe "mysql::client"

connection_info = {:host => node["horizon"]["db_ipaddress"], :username => "root", :password => node["mysql"]["server_root_password"]}
mysql_database "create horizon database" do
  connection connection_info
  database_name node["horizon"]["db"]
  action :create
end

mysql_database_user node["horizon"]["db_user"] do
  connection connection_info
  password node["horizon"]["db_passwd"]
  action :create
end

mysql_database_user node["horizon"]["db_user"] do
  connection connection_info
  password node["horizon"]["db_passwd"]
  database_name node["horizon"]["db"]
  host '%'
  privileges [:all]
  action :grant 
end

package "openstack-dashboard" do
    action :upgrade
end

template "/etc/openstack-dashboard/local_settings.py" do
  source "local_settings.py.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
            :user => node["horizon"]["db_user"],
            :passwd => node["horizon"]["db_passwd"],
            :ip_address => node["controller_ipaddress"],
            :db_name => node["horizon"]["db"],
            :db_ipaddress => node["horizon"]["db_ipaddress"],
            :keystone_api_ipaddress => node["keystone"]["api_ipaddress"],
            :service_port => node["identity"]["service_port"],
            :admin_port => node["identity"]["admin_port"],
            :admin_token => node["identity"]["admin_token"]
  )
end

execute "openstack-dashboard syncdb" do
  cwd "/usr/share/openstack-dashboard"
  environment ({'PYTHONPATH' => '/etc/openstack-dashboard:/usr/share/openstack-dashboard:$PYTHONPATH'})
  command "python manage.py syncdb"
  action :run
  # not_if "/usr/bin/mysql -u root -e 'describe #{node["dash"]["db"]}.django_content_type'"
end

template value_for_platform(
  [ "redhat","centos","fedora" ] => { "default" => "#{node["apache"]["dir"]}/vhost.d/openstack-dashboard" }, 
  [ "ubuntu","debian" ] => { "default" => "#{node["apache"]["dir"]}/sites-available/openstack-dashboard" },
  "default" => { "default" => "#{node["apache"]["dir"]}/openstack-dashboard" }
  ) do
  source "dash-site.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
      :apache_contact => node["apache"]["contact"],
      :ssl_cert_file => "#{node["horizon"]["cert_dir"]}/certs/#{node["horizon"]["self_cert"]}",
      :ssl_key_file => "#{node["horizon"]["cert_dir"]}/private/#{node["horizon"]["self_cert_key"]}",
      :apache_log_dir => node["apache"]["log_dir"],
      :django_wsgi_path => node["horizon"]["wsgi_path"],
      :dash_path => node["horizon"]["dash_path"]
  )
end

if platform?("debian", "ubuntu") then 
  apache_site "openstack-dashboard"
  apache_site(
    :name => "000-default",
    :enable => false
  )
end

# This is a dirty hack to deal with https://bugs.launchpad.net/nova/+bug/932468
directory "/var/www/.novaclient" do
  owner node["apache"]["user"]
  group node["apache"]["group"]
  mode "0755"
  action :create
end

# TODO(shep)
# Horizon has a forced dependency on their being a volume service endpoint in your keystone catalog
# https://answers.launchpad.net/horizon/+question/189551

service "apache2" do
   action :restart
end
