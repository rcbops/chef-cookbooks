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
# include_recipe "openstack::apt"
# include_recipe "openstack::mysql"
# include_recipe "openstack::api"

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
            :ip_address => node[:compute][:controller_ipaddress],
            :db_name => node[:horizon][:db],
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
      :apache_log_dir => node[:apache][:log_dir]
  )
end

if platform?("debian", "ubuntu") then 
  apache_site "openstack-dashboard"
end

service "apache2" do
   action :restart
end
