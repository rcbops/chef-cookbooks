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

package "euca2ools" do
	action :install
end

package "python-boto" do
        action :install
end

package "python-carrot" do
        action :install
end

package "python-cheetah" do
        action :install
end

package "python-eventlet" do
	action :install
end

package "python-gflags" do
        action :install
end

package "python-ipy" do
        action :install
end

package "python-lockfile" do
        action :install
end

package "python-m2crypto" do
        action :install
end

package "python-migrate" do
        action :install
end

package "python-mysqldb" do
        action :install
end

package "python-netaddr" do
        action :install
end

package "python-paste" do
        action :install
end

package "python-pastedeploy" do
        action :install
end

package "python-routes" do
        action :install
end

package "python-sqlalchemy" do
        action :install
end

package "python-tempita" do
        action :install
end

package "python-libvirt" do
	action :install
end

package "python-libxml2" do
	action :install
end
