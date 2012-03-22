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

include_recipe "mysql::server"
include_recipe "openssh::default"

include_recipe "rabbitmq::default"
include_recipe "keystone::server"
include_recipe "glance::registry"
include_recipe "glance::api"
include_recipe "nova::nova-setup"
include_recipe "nova::scheduler"
include_recipe "nova::api"

if platform?(%w{fedora})
  # Fedora skipping vncproxy for right now
else
  include_recipe "nova::vncproxy"
end
