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
include_recipe "nova::python-dependencies"

package "python-eventlet" do
	action :install
end

execute "patch python-eventlet" do
	cwd "/usr/share/pyshared/eventlet/green"
        command "curl https://bitbucket-assetroot.s3.amazonaws.com/which_linden/eventlet/20110214/77/greenpipe-wrap.patch | sudo patch -b"
        action :run
	not_if "test -e subprocess.py.orig"
end

