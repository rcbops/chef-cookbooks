#
# Cookbook Name:: apache2
# Recipe:: default
#
# Copyright 2008-2009, Opscode, Inc.
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

package "apache2" do
  package_name node[:apache][:package]
  action :install
end

service "apache2" do
  case node[:platform]
  when "centos","redhat","fedora","suse"
    service_name "httpd"
    # If restarted/reloaded too quickly httpd has a habit of failing.
    # This may happen with multiple recipes notifying apache to restart - like
    # during the initial bootstrap.
    restart_command "/sbin/service httpd restart && sleep 2"
    reload_command "/sbin/service httpd reload && sleep 2"
  when "debian","ubuntu"
    service_name "apache2"
    restart_command "/usr/sbin/invoke-rc.d apache2 restart && sleep 2"
    reload_command "/usr/sbin/invoke-rc.d apache2 reload && sleep 2"
  end
  supports value_for_platform(
    "debian" => { "4.0" => [ :restart, :reload ], "default" => [ :restart, :reload, :status ] },
    "ubuntu" => { "default" => [ :restart, :reload, :status ] },
    "centos" => { "default" => [ :restart, :reload, :status ] },
    "redhat" => { "default" => [ :restart, :reload, :status ] },
    "fedora" => { "default" => [ :restart, :reload, :status ] },
    "default" => { "default" => [:restart, :reload ] }
  )
  action :enable
end

template "apache2.conf" do
  case node[:platform]
  when "centos","redhat","fedora"
    path "#{node[:apache][:dir]}/conf/httpd.conf"
  when "debian","ubuntu"
    path "#{node[:apache][:dir]}/apache2.conf"
  end
  source "#{node[:apache][:package]}.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :restart, resources(:service => "apache2")
end

template "security" do
  if platform?("redhat","centos")
    path "#{node[:apache][:dir]}/conf.d/security.conf"
  else
    path "#{node[:apache][:dir]}/conf.d/security"
  end
  source "security.erb"
  owner "root"
  group "root"
  mode 0644
  backup false
  notifies :restart, resources(:service => "apache2")
end

template "#{node[:apache][:dir]}/ports.conf" do
  source "ports.conf.erb"
  group "root"
  owner "root"
  variables :apache_listen_ports => node[:apache][:listen_ports]
  mode 0644
  notifies :restart, resources(:service => "apache2")
end

if platform?("redhat","centos")
  directory "/etc/httpd/vhost.d" do
    mode 0755
    owner "root"
    group "root"
    action :create
  end

  file "#{node[:apache][:dir]}/conf.d/welcome.conf" do
    action :delete
  end

  file "/var/www/html/index.html" do
    action :touch
  end
end

template value_for_platform( 
  [ "redhat", "centos" ] => { "default" => "#{node[:apache][:dir]}/vhost.d/default.template" }, 
  [ "ubuntu","debian" ] => { "default" => "#{node[:apache][:dir]}/sites-available/default.template" },
  "default" => { "default" => "#{node[:apache][:dir]}/default.template" }
  ) do
  source "default.template.erb"
end

include_recipe "apache2::mod_status"
include_recipe "apache2::mod_alias"
include_recipe "apache2::mod_auth_basic"
include_recipe "apache2::mod_authn_file"
include_recipe "apache2::mod_authz_default"
include_recipe "apache2::mod_authz_groupfile"
include_recipe "apache2::mod_authz_host"
include_recipe "apache2::mod_authz_user"
include_recipe "apache2::mod_autoindex"
include_recipe "apache2::mod_dir"
include_recipe "apache2::mod_env"
include_recipe "apache2::mod_mime"
include_recipe "apache2::mod_negotiation"
include_recipe "apache2::mod_setenvif"
include_recipe "apache2::mod_ssl"
include_recipe "apache2::mod_rewrite"
# include_recipe "apache2::mod_php5"

execute "htpasswd"  do
  command "htpasswd -b -c #{node[:apache][:dir]}/status-htpasswd #{node[:apache][:status][:user]} #{node[:apache][:status][:pass]}"
  creates "#{node[:apache][:dir]}/status-htpasswd" 
  action :run
end

template "/root/.statuspass" do
  source "statuspass.erb"
  mode 0400
  owner "root"
  group "root"
  not_if "test -f /root/.statuspass"
end

# uncomment to get working example site on centos/redhat/fedora
#apache_site "default"

service "apache2" do
  action :start
end
