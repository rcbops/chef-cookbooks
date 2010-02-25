#
# Cookbook Name:: mysql
# Recipe:: server
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

include_recipe "mysql::client"

package "perl-DBD-MySQL"
	action :install
end

package "mysql-server" do
	action :install
end

service "mysqld" do
	supports :status => true, :restart => true
	action :enable
end

template "/etc/my.cnf" do
	source "my.cnf.erb"
	owner "root"
	group "root"
	mode "0644"
	variables(

	)
	notifies :restart, resources(:service => "mysqld"), :immediately
end

#	variables(
#          :port => node[:memcached][:port],
#          :user => node[:memcached][:user],
#          :max_connections => node[:memcached][:max_connections],
#          :cache_size => node[:memcached][:cache_size],
#          :memcache_options => node[:memcached][:memcache_options],
#          :address => node[:memcached][:address]
#	)
