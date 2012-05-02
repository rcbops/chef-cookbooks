
package "git" do
  action :install
end

package "curl" do
  action :install
end

package "python-virtualenv" do
  action :install
end

execute "git clone https://github.com/rcbops/kong" do
  command "git clone https://github.com/rcbops/kong"
  cwd "/opt"
  user "root"
  not_if do File.exists?("/opt/kong") end
end

execute "checkout kong branch" do
  command "git checkout #{node[:kong][:branch]}"
  cwd "/opt/kong"
  user "root"
end

execute "generate swift_small object" do
  command "dd if=/dev/zero of=swift_small bs=512 count=1024"
  cwd "/opt/kong/include/swift_objects"
  user "root"
  not_if do File.exists?("/opt/kong/include/swift_objects/swift_small") end
end

execute "generate swift_medium object" do
  command "dd if=/dev/zero of=swift_medium bs=512 count=1024000"
  cwd "/opt/kong/include/swift_objects"
  user "root"
  not_if do File.exists?("/opt/kong/include/swift_objects/swift_medium") end
end

execute "generate swift_large object" do
  command "dd if=/dev/zero of=swift_large bs=1024 count=1024"
  cwd "/opt/kong/include/swift_objects"
  user "root"
  not_if do File.exists?("/opt/kong/include/swift_objects/swift_large") end
end

execute "grab the sample_vm" do
  cwd "/opt/kong/include/sample_vm"
  user "root"
  command "curl http://c250663.r63.cf1.rackcdn.com/ttylinux.tgz | tar -zx"
  not_if do File.exists?("/opt/kong/include/sample_vm/ttylinux.img") end
end

execute "install virtualenv" do
  command "python tools/install_venv.py"
  cwd "/opt/kong"
  user "root"
end

if Chef::Config[:solo]
  Chef::Log.warn("This recipe uses search. Chef Solo does not support search.")
else
  # Lookup keystone api ip address
  keystone, start, arbitary_value = Chef::Search::Query.new.search(:node, "roles:keystone AND chef_environment:#{node.chef_environment}")
  if keystone.length > 0
    Chef::Log.info("kong/default: using search")
      keystone_admin_username = "admin"
      keystone_admin_password = keystone[0]['keystone']['users']['admin']['password']
      keystone_admin_tenantname = keystone[0]['keystone']['users']['admin']['default_tenant']
      keystone_internal_url = keystone[0]['keystone']['internalURL']
      keystone_admin_url = keystone[0]['keystone']['adminURL']
      keystone_admin_token = keystone[0]['keystone']['admin_token']
      keystone_admin_port = keystone[0]['keystone']['admin_port']
      keystone_region = keystone[0]['keystone']['admin_port']
      ec2_access = keystone[0]["credentials"]["EC2"]["admin"]["access"]
      ec2_secret = keystone[0]["credentials"]["EC2"]["admin"]["secret"]
      keystone_api_ip = keystone[0]['keystone']['api_ipaddress']
      keystone_service_port = keystone[0]['keystone']['service_port']
  else
    Chef::Log.info("kong/keystone: NOT using search")
      keystone_admin_username = "admin"
      keystone_admin_password = node['keystone']['users']['admin']['password']
      keystone_admin_tenantname = node['keystone']['users']['admin']['default_tenant']
      keystone_internal_url = node['keystone']['internalURL']
      keystone_admin_url = node['keystone']['adminURL']
      keystone_admin_token = node['keystone']['admin_token']
      keystone_admin_port = node['keystone']['admin_port']
      ec2_access = node["credentials"]["EC2"]["admin"]["access"]
      ec2_secret = node["credentials"]["EC2"]["admin"]["secret"]
      keystone_api_ip = node['keystone']['api_ipaddress']
      keystone_service_port = node['keystone']['service_port']
  end

rabbit, something, arbitary_value = Chef::Search::Query.new.search(:node, "roles:rabbitmq-server AND chef_environment:#{node.chef_environment}")
  if rabbit.length > 0
    Chef::Log.info("kong/rabbitmq: using search")
    rabbit_ip_address = rabbit[0]['ipaddress']
    rabbit_user = rabbit[0]['rabbitmq']['default_user']
    rabbit_password = rabbit[0]['rabbitmq']['default_pass']
  else
    Chef::Log.info("nova-common/rabbitmq: NOT using search")
    rabbit_ip_address = node['ipaddress']
    rabbit_user = node['rabbitmq']['default_user']
  end
end

template "/opt/kong/etc/config.ini" do
  source "config.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :ip_address => keystone_api_ip,
    :keystone_service_port => keystone_service_port,
    :keystone_admin_port => keystone_admin_port,
    :keystone_apiver => node[:keystone][:api_version],
    :keystone_user => keystone_admin_username,
    :keystone_pass => keystone_admin_password,
    :keystone_tenantid => keystone_admin_tenantname,
    :keystone_region => 'RegionOne',
    :nova_network_label => node[:nova][:network_label],
    :rabbit_user => rabbit_user,
    :rabbit_password => rabbit_password,
    :rabbit_ip_address => rabbit_ip_address,
    :swift_auth_port => node[:swift][:auth_port],
    :swift_auth_prefix => node[:swift][:auth_prefix],
    :swift_ssl => node[:swift][:auth_ssl],
    :swift_account => node[:swift][:account],
    :swift_user => node[:swift][:username],
    :swift_pass => node[:swift][:password]
  )
end

execute "Kong: Nova test suite" do
  command "./run_tests.sh -V --nova"
  cwd "/opt/kong"
  user "root"
  action :nothing
end
