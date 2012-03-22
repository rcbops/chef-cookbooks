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

include_recipe "nova::nova-common"
include_recipe "nova::api"
include_recipe "nova::network"

# package "mysql-client" do
#	action :install
#end

# Distribution specific settings go here
if platform?(%w{fedora})
  # Fedora
  nova_compute_package = "openstack-nova"
  nova_compute_service = "openstack-nova-compute"
  nova_compute_package_options = ""
else
  # All Others (right now Debian and Ubuntu)
  nova_compute_package = "nova-compute"
  nova_compute_service = nova_compute_package
  nova_compute_package_options = "-o Dpkg::Options::='--force-confold' --force-yes"
  if node[:virt_type] == "kvm"
    nova_compute_package = "nova-compute-kvm"
  elsif node[:virt_type] == "qemu"
    nova_compute_package = "nova-compute-qemu"
  end
end

package nova_compute_package do
  action :upgrade
  options "-o Dpkg::Options::='--force-confold' --force-yes"
end

service nova_compute_service do
  supports :status => true, :restart => true
  action :enable
  subscribes :restart, resources(:template => "/etc/nova/nova.conf"), :delayed
end

include_recipe "nova::libvirt"
