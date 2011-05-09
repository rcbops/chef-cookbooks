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

package "mysql-server" do
	action :install
end

service "mysql" do
	supports :status => true, :restart => true
        action :enable
end

package "mysql-client" do
	action :install
end

execute "configure mysql bind addr" do
	command "perl -pi -e 's/127.0.0.1/0.0.0.0/g' /etc/mysql/my.cnf"
	action :run
	notifies :restart, resources(:service => "mysql"), :immediately
end

execute "create nova database" do
	command "mysql -u root -e 'create database nova'"
	action :run
	only_if "/usr/bin/mysql -u root -e 'show databases;'"
end

execute "create nova user" do
	command 'mysql -u root -e 'grant all privileges on nova.* to \'nova\'@\'%\' identified by "nova"''
	action :run
	only_if "/usr/bin/mysql -u root -e 'show databases;'"
end

