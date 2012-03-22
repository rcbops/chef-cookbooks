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

package "nova-novnc" do
  action :upgrade
end

package "nova-vncproxy" do
  action :upgrade
end

execute "Fix permission Bug" do
  command "sed -i 's/nova$/root/g' /etc/init/nova-vncproxy.conf"
  action :run
  only_if "egrep 'exec.*nova$' /etc/init/nova-vncproxy.conf"
end

service "nova-vncproxy" do
  supports :status => true, :restart => true
  action :enable
  subscribes :restart, resources(:template => "/etc/nova/nova.conf"), :delayed
end
