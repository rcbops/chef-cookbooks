#
# Cookbook Name:: horizon
# Recipe:: default
#
# Copyright 2012, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apache2"
include_recipe "apache2::mod_wsgi"
# include_recipe "nova::apt"
# include_recipe "nova::mysql"
# include_recipe "nova::api"

include_recipe "mysql::client"

connection_info = {:host => node[:horizon][:db_host], :username => "root", :password => node['mysql']['server_root_password']}
mysql_database "create horizon database" do
  connection connection_info
  database_name node[:horizon][:db]
  action :create
end

mysql_database_user node[:horizon][:db_user] do
  connection connection_info
  password node[:horizon][:db_passwd]
  action :create
end

mysql_database_user node[:horizon][:db_user] do
  connection connection_info
  password node[:horizon][:db_passwd]
  database_name node[:horizon][:db]
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
            :user => node[:horizon][:db_user],
            :passwd => node[:horizon][:db_passwd],
            :ip_address => node[:controller_ipaddress],
            :db_name => node[:horizon][:db],
            :db_host => node[:horizon][:db_host],
            :service_port => node[:identity][:service_port],
            :admin_port => node[:identity][:admin_port],
            :admin_token => node[:identity][:admin_token]
  )
end

execute "openstack-dashboard syncdb" do
  cwd "/usr/share/openstack-dashboard"
  environment ({'PYTHONPATH' => '/etc/openstack-dashboard:/usr/share/openstack-dashboard:$PYTHONPATH'})
  command "python manage.py syncdb"
  action :run
  # not_if "/usr/bin/mysql -u root -e 'describe #{node["dash"][:db]}.django_content_type'"
end

template value_for_platform(
  [ "redhat", "centos" ] => { "default" => "#{node[:apache][:dir]}/vhost.d/openstack-dashboard" }, 
  [ "ubuntu","debian" ] => { "default" => "#{node[:apache][:dir]}/sites-available/openstack-dashboard" },
  "default" => { "default" => "#{node[:apache][:dir]}/openstack-dashboard" }
  ) do
  source "dash-site.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
      :apache_contact => node[:apache][:contact],
      :ssl_cert_file => "#{node[:apache][:cert_dir]}certs/#{node[:apache][:self_cert]}",
      :ssl_key_file => "#{node[:apache][:cert_dir]}private/#{node[:apache][:self_cert_key]}",
      :apache_log_dir => node[:apache][:log_dir],
      :django_wsgi_path => "#{node[:horizon][:wsgi_path]}",
      :dash_path => "#{node[:horizon][:dash_path]}"
  )
end

if platform?("debian", "ubuntu") then 
  apache_site "openstack-dashboard"
end

# This is a dirty hack to deal with https://bugs.launchpad.net/nova/+bug/932468
directory "/var/www/.novaclient" do
  owner node[:apache][:user]
  group node[:apache][:group]
  mode "0755"
  action :create
end

# TODO(shep)
# Horizon has a forced dependency on their being a volume service endpoint in your keystone catalog
# https://answers.launchpad.net/horizon/+question/189551

service "apache2" do
   action :restart
end
