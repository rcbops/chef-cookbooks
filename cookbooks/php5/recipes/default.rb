#
# Cookbook Name:: PHP5
# Recipe:: default
#
# Copyright 2010, Rackspace Hosting
#
# All rights reserved - Do Not Redistribute
#
include_recipe "apache2"

case node[:platform]
  when "redhat","centos"
    node[:php][:packages].each do |pkg|
      package pkg
    end
  when "ubuntu","debian"
    node[:php][:packages].each do |pkg|
      package pkg do
        action :install
      end
    end
end

directory node[:php][:session][:save_path] do
  owner "root"
  group node[:apache][:user]
  mode 0770
  recursive true
  action :create
end

template "php.ini" do
  path node[:php][:ini]
  source "php.ini.erb"
  mode 0644
  owner "root"
  group "root"
  notifies :restart, resources(:service => "apache2")
end
