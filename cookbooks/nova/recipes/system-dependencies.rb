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

package "openssh-server" do
	action :install
end

service "ssh" do
	supports :status => true, :restart => true
	action :enable
end

package "kvm" do
	action :install
end

package "libvirt-bin" do
	action :install
end

package "curl" do
	action :install
end

package "git-core" do
	action :install
end

package "bzr" do
	action :install
end
