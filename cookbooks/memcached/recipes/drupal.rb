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

include_recipe "memcached::default"

template "/etc/init.d/memcached_block" do
        source "memcached_block.erb"
        owner "root"
        group "root"
        mode "0755"
end

service "memcached_block" do
        supports :status => true, :restart => true
        action :enable
        subscribes :restart, resources(:template => "/etc/init.d/memcached_block"), :immediately
end

template "/etc/init.d/memcached_filter" do
        source "memcached_filter.erb"
        owner "root"
        group "root"
        mode "0755"
end

service "memcached_filter" do
        supports :status => true, :restart => true
        action :enable
        subscribes :restart, resources(:template => "/etc/init.d/memcached_filter"), :immediately
end

template "/etc/init.d/memcached_form" do
        source "memcached_form.erb"
        owner "root"
        group "root"
        mode "0755"
end

service "memcached_form" do
        supports :status => true, :restart => true
        action :enable
        subscribes :restart, resources(:template => "/etc/init.d/memcached_form"), :immediately
end

template "/etc/init.d/memcached_menu" do
        source "memcached_menu.erb"
        owner "root"
        group "root"
        mode "0755"
end

service "memcached_menu" do
        supports :status => true, :restart => true
        action :enable
        subscribes :restart, resources(:template => "/etc/init.d/memcached_menu"), :immediately
end

template "/etc/init.d/memcached_page" do
        source "memcached_page.erb"
        owner "root"
        group "root"
        mode "0755"
end

service "memcached_page" do
        supports :status => true, :restart => true
        action :enable
        subscribes :restart, resources(:template => "/etc/init.d/memcached_page"), :immediately
end

template "/etc/init.d/memcached_updates" do
        source "memcached_updates.erb"
        owner "root"
        group "root"
        mode "0755"
end

service "memcached_updates" do
        supports :status => true, :restart => true
        action :enable
        subscribes :restart, resources(:template => "/etc/init.d/memcached_updates"), :immediately
end

template "/etc/init.d/memcached_views" do
        source "memcached_views.erb"
        owner "root"
        group "root"
        mode "0755"
end

service "memcached_views" do
        supports :status => true, :restart => true
        action :enable
        subscribes :restart, resources(:template => "/etc/init.d/memcached_views"), :immediately
end

template "/etc/init.d/memcached_content" do
        source "memcached_content.erb"
        owner "root"
        group "root"
        mode "0755"
end

service "memcached_content" do
        supports :status => true, :restart => true
        action :enable
        subscribes :restart, resources(:template => "/etc/init.d/memcached_content"), :immediately
end
