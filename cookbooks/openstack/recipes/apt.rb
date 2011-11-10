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

# Install the rcbops keyring
package "rcbops-keyring" do
  action :install
  options "--force-yes"
end


template "/etc/apt/sources.list.d/rcb-packages.list" do
  source "rcb-packages.list.erb"
  variables(
    :url => node[:package_url],
    :release => node[:package_release],
    :component => node[:package_component]
  )
  notifies :run, resources(:execute => "apt-get update"), :immediately
end
