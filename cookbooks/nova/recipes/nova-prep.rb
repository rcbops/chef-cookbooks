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

execute "nova-manage db sync" do
	command "/opt/nova/bin/nova-manage db sync"
	action :nothing
end

directory "/etc/nova" do
	owner "root"
	group "root"
	mode 0755
	action :create
end

directory "/var/lock/nova" do
	owner "root"
	group "root"
	mode 0755
	action :create
end

directory "/var/lib/nova/images" do
	owner "root"
	group "root"
	mode 0755
	action :create
end

template "/etc/nova/nova.conf" do
	source "nova.conf.erb"
	owner "root"
	group "root"
	mode "0644"
	notifies :run, resources(:execute => "nova-manage db sync"), :immediately
end
