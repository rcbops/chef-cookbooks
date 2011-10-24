
package "git" do
  action :install
end

package "curl" do
  action :install
end

package "python-virtualenv" do
  action :install
end

execute "git clone https://github.com/cloudbuilders/kong" do
  command "git clone https://github.com/cloudbuilders/kong"
  cwd "/opt"
  user "root"
  not_if do File.exists?("/opt/kong") end
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

template "/opt/kong/etc/config.ini" do
  source "config.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :keystone_host => node[:keystone][:host],
    :keystone_service_port => node[:keystone][:service_port],
    :keystone_admin_port => node[:keystone][:admin_port],
    :keystone_apiver => node[:keystone][:api_version],
    :keystone_user => node[:keystone][:user],
    :keystone_pass => node[:keystone][:password],
    :keystone_tenantid => node[:keystone][:tenantid],
    :keystone_region => node[:keystone][:region],
    :nova_network_label => node[:nova][:network_label],
    :rabbit_host => node[:rabbitmq][:host],
    :rabbit_user => node[:rabbitmq][:user],
    :swift_auth_host => node[:swift][:auth_host],
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
