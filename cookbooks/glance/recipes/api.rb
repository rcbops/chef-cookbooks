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

# Distribution specific settings go here
if platform?(%w{fedora})
  # Fedora
  mysql_python_package = "MySQL-python"
  glance_package = "openstack-glance"
  glance_api_service = "openstack-glance-api"
  glance_package_options = ""
else
  # All Others (right now Debian and Ubuntu)
  mysql_python_package="python-mysqldb"
  glance_package = "glance"
  glance_api_service = "glance-api"
  glance_package_options = "-o Dpkg::Options::='--force-confold' --force-yes"
end

package "curl" do
  action :install
end

# Supposedly Resolved
# Fixes issue https://bugs.launchpad.net/ubuntu/+source/glance/+bug/943748
#package "python-dateutil" do
#  action :install
#end

if platform?(%w{fedora})
  # THIS IS TEMPORARY!!!  Remove this when fedora fixes their packages.  
  remote_file "/tmp/openstack-glance-2012.1-0.6.rc1.fc17.noarch.rpm" do
    source "http://www.breu.org/filedrop/nova/openstack-glance-2012.1-0.6.rc1.fc17.noarch.rpm"
    action :create_if_missing
  end
  remote_file "/tmp/python-glance-2012.1-0.6.rc1.fc17.noarch.rpm" do
    source "http://www.breu.org/filedrop/nova/python-glance-2012.1-0.6.rc1.fc17.noarch.rpm"
    action :create_if_missing
  end
  bash "install glance-api" do
    cwd "/tmp"
    user "root"
    code <<-EOH
        set -e
        set -x
        yum -y install /tmp/openstack-glance-2012.1-0.6.rc1.fc17.noarch.rpm /tmp/python-glance-2012.1-0.6.rc1.fc17.noarch.rpm || :
        service openstack-glance-api restart
    EOH
  end
end

package glance_package do
  action :upgrade
end

service glance_api_service do
  supports :status => true, :restart => true
  action :enable
end

template "/etc/glance/glance-api.conf" do
  source "glance-api.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :api_port => node[:glance][:api_port],
    :registry_port => node[:glance][:registry_port],
    :ip_address => node[:controller_ipaddress],
    :service_port => node[:keystone][:service_port],
    :admin_port => node[:keystone][:admin_port],
    :admin_token => node[:keystone][:admin_token]
  )
  notifies :restart, resources(:service => glance_api_service), :immediately
end

template "/etc/glance/glance-api-paste.ini" do
  source "glance-api-paste.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :ip_address => node[:controller_ipaddress],
    :service_port => node[:keystone][:service_port],
    :admin_port => node[:keystone][:admin_port],
    :admin_token => node[:keystone][:admin_token],
    :service_tenant_name => node[:glance][:service_tenant_name],
    :service_user => node[:glance][:service_user],
    :service_pass => node[:glance][:service_pass]
  )
  notifies :restart, resources(:service => glance_api_service), :immediately
end

template "/etc/glance/glance-scrubber.conf" do
  source "glance-scrubber.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :user => node[:glance][:db_user],
    :passwd => node[:glance][:db_passwd],
    :ip_address => node[:controller_ipaddress],
    :db_name => node[:glance][:db],
    :db_host => node[:glance][:db_host]
  )
end

# Register Image Service
keystone_register "Register Image Service" do
  auth_host node[:controller_ipaddress]
  auth_port node[:keystone][:admin_port]
  auth_protocol "http"
  api_ver "/v2.0"
  auth_token node[:keystone][:admin_token]
  service_name "glance"
  service_type "image"
  service_description "Glance Image Service"
  action :create_service
end

node[:glance][:adminURL] = "http://#{node[:controller_ipaddress]}:#{node[:glance][:api_port]}/v1"
node[:glance][:internalURL] = node[:glance][:adminURL]
node[:glance][:publicURL] = node[:glance][:adminURL]

# Register Image Endpoint
keystone_register "Register Image Endpoint" do
  auth_host node[:controller_ipaddress]
  auth_port node[:keystone][:admin_port]
  auth_protocol "http"
  api_ver "/v2.0"
  auth_token node[:keystone][:admin_token]
  service_type "image"
  endpoint_region "RegionOne"
  endpoint_adminurl node[:glance][:adminURL]
  endpoint_internalurl node[:glance][:internalURL]
  endpoint_publicurl node[:glance][:publicURL]
  action :create_endpoint
end

# This is a dirty hack for now.. NEED TO BE FIXED
keystone_auth_url = "http://#{node[:controller_ipaddress]}:#{node[:keystone][:admin_port]}/v2.0"
#extra_opts = "--username=admin --password=secrete --tenant=openstack --auth_url=#{keystone_auth_url}"
# new format for renamed command lines
extra_opts = "--os_username=admin --os_password=secrete --os_tenant=openstack --os_auth_url=#{keystone_auth_url}"

node[:glance][:images].each do |img|
  bash "default image setup for #{img.to_s}" do
    cwd "/tmp"
    user "root"
    code <<-EOH
      set -e
      set -x
      mkdir -p images

      curl #{node[:image][img.to_sym]} | tar -zx -C images/
      image_name=$(basename #{node[:image][img]} .tar.gz)

      image_name=${image_name%-multinic}

      kernel_file=$(ls images/*vmlinuz-virtual | head -n1)
      if [ ${#kernel_file} -eq 0 ]; then
         kernel_file=$(ls images/*vmlinuz | head -n1)
      fi

      ramdisk=$(ls images/*-initrd | head -n1)
      if [ ${#ramdisk} -eq 0 ]; then
          ramdisk=$(ls images/*-loader | head -n1)
      fi

      kernel=$(ls images/*.img | head -n1)

      kid=$(glance #{extra_opts} --silent-upload add name="${image_name}-kernel" disk_format=aki container_format=aki < ${kernel_file} | cut -d: -f2 | sed 's/ //')
      rid=$(glance #{extra_opts} --silent-upload add name="${image_name}-initrd" disk_format=ari container_format=ari < ${ramdisk} | cut -d: -f2 | sed 's/ //')
      glance #{extra_opts} --silent-upload add name="#{img.to_s}-image" disk_format=ami container_format=ami kernel_id=$kid ramdisk_id=$rid < ${kernel}
  EOH
    not_if "glance #{extra_opts} index | grep #{img.to_s}-image"
  end
end
