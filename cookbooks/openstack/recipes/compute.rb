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

include_recipe "openstack::nova-common"
include_recipe "openstack::api"
include_recipe "openstack::network"
include_recipe "openstack::libvirt"

# package "mysql-client" do
#	action :install
#end

if node[:virt_type] == "kvm"
  compute_package = "nova-compute-kvm"
elsif node[:virt_type] == "qemu"
  compute_package = "nova-compute-qemu"
end

package compute_package do
  action :upgrade
  options "-o Dpkg::Options::='--force-confold' --force-yes"
end

service "nova-compute" do
  supports :status => true, :restart => true
  action :enable
  subscribes :restart, resources(:template => "/etc/nova/nova.conf"), :delayed
end
