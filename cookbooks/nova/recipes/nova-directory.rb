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

include_recipe "nova::system-dependencies"

package "git-core" do
	action :install
end

execute "git clone nova" do
	command "git clone https://github.com/termie/nova.git /opt/nova"
	action :run
	not_if "test -d /opt/nova"
end

directory "/var/lib/nova/instances" do
	owner "root"
	group "root"
	mode "0755"
	action :create
	recursive true
	not_if "test -d /opt/nova/instances"
end
