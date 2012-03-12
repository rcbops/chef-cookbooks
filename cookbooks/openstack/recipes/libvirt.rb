#
# Cookbook Name:: openstack
# Recipe:: libvirt
#

service "libvirt-bin" do
  supports :status => true, :restart => true
  action :enable
end

package "sasl2-bin" do
    # install sasl2-bin for sasl2passwd
    action :install
    only_if node[:libvirt][:auth_tcp] == "sasl"
end

if node[:libvirt][:auth_tcp] == "sasl"
    # TODO(breu): do some sasl stuff
    # TODO(breu): saslpasswd2 -a libvirt sasl_username
    # TODO(breu): pass in the password sasl_password
end

#
# TODO(breu): this section needs to be rewritten to support key privisioning
#
template "/etc/libvirt/libvirtd.conf" do
  source "libvirtd.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    :auth_tcp => node[:libvirt][:auth_tcp]
  )
  notifies :restart, resources(:service => "libvirt-bin"), :immediately
end

template "/etc/default/libvirt-bin" do
  source "libvirt-bin.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "libvirt-bin"), :immediately
end

