#
# Cookbook Name:: glance
# Attributes:: glance
#
# Copyright 2009, Rackspace Hosting, Inc.
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

default[:glance][:db] = "glance"
default[:glance][:db_user] = "glance"
default[:glance][:db_passwd] = "glance"
default[:glance][:db_ipaddress] = node[:controller_ipaddress]
default[:glance][:api_ipaddress] = node[:controller_ipaddress]
default[:glance][:api_port] = "9292"
default[:glance][:registry_port] = "9191"
default[:glance][:images] = [ "tty", "natty" ]

default[:rabbit][:rabbit_ipaddress] = node[:controller_ipaddress]

default[:glance][:service_tenant_name] = "service"
default[:glance][:service_user] = "glance"
default[:glance][:service_pass] = "vARxre7K"
default[:glance][:service_role] = "admin"

default[:glance][:image][:oneiric] = "http://c250663.r63.cf1.rackcdn.com/ubuntu-11.10-server-uec-amd64-multinic.tar.gz"
default[:glance][:image][:natty] = "http://c250663.r63.cf1.rackcdn.com/ubuntu-11.04-server-uec-amd64-multinic.tar.gz"
default[:glance][:image][:maverick] = "http://c250663.r63.cf1.rackcdn.com/ubuntu-10.10-server-uec-amd64-multinic.tar.gz"
default[:glance][:image][:tty] = "http://smoser.brickies.net/ubuntu/ttylinux-uec/ttylinux-uec-amd64-12.1_2.6.35-22_1.tar.gz"

default[:controller_ipaddress] = node[:ipaddress]
