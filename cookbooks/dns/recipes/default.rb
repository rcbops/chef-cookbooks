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

package "caching-nameserver" do
	action :install
end

package "bind" do
	action :install
end

package "bind-libs" do
	action :install
end

package "bind-utils" do
	action :install
end

package "bind-chroot" do
	action :install
end

service "named" do
        supports :status => true, :restart => true
	action :enable
end

template "/etc/resolv.conf" do
	source "resolv.conf.erb"
	owner "root"
	group "root"
	mode "0644"
	variables(
          :search_domain => node[:dns][:search_domain],
          :local_nameserver => node[:dns][:local_nameserver],
          :dc_nameserver_1 => node[:dns][:dc_nameserver_1],
          :dc_nameserver_2 => node[:dns][:dc_nameserver_2]
	)
        notifies :restart, resources(:service => "named"), :delayed
end

directory "/var/named/chroot/var/named/masters" do
        owner "mysql"
        group "mysql"
        mode "0755"
        action :create
        not_if "test -d /var/named/chroot/var/named/masters"
end

template "/var/named/chroot/etc/named.conf" do
	source "named.conf.erb"
	owner "root"
	group "root"
	mode "0644"
	variables(
          :search_domain => node[:dns][:search_domain],
          :local_nameserver => node[:dns][:local_nameserver],
          :dc_nameserver_1 => node[:dns][:dc_nameserver_1],
          :dc_nameserver_2 => node[:dns][:dc_nameserver_2]
	)
        notifies :restart, resources(:service => "named"), :delayed
end

template "/var/named/chroot/var/named/masters/src.rms" do
        source "src.rms.erb"
        owner "root"
        group "root"
        mode "0644"
        notifies :restart, resources(:service => "named"), :delayed
end
