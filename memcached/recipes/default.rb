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

package "memcached" do
	action :upgrade
end

service "memcached" do
	action :enable
end

template "/etc/sysconfig/memcached" do
	source "sysconfig_memcached.erb"
	owner "root"
	group "root"
	mode "0644"
	variables(
          :port => node[:memcached][:port],
          :user => node[:memcached][:user],
          :max_connections => node[:memcached][:max_connections],
          :cache_size => node[:memcached][:cache_size],
          :memcache_options => node[:memcached][:memcache_options],
          :address => node[:memcached][:address]
	)
	notifies :restart, resources(:service => "memcached"), :immediately

end
