#
# Cookbook Name:: openstack
# Recipe:: libvirt
#

service "libvirt-bin" do
  supports :status => true, :restart => true
  action :enable
end


directory "/var/lib/nova/.ssh" do
    owner "nova"
    group "nova"
    mode "0700"
    action :create
end

template "/var/lib/nova/.ssh/id_dsa.pub" do
    # public key
    source "libvirtd-ssh-public-key.erb"
    owner "nova"
    group "nova"
    mode "0644"
    variables(
      :public_key => node[:libvirt][:ssh][:public_key]
    )
end

template "/var/lib/nova/.ssh/id_dsa" do
    # private key
    source "libvirtd-ssh-private-key.erb"
    owner "nova"
    group "nova"
    mode "0600"
    variables(
      :private_key => node[:libvirt][:ssh][:private_key]
    )
end

template "/var/lib/nova/.ssh/config" do
    # default config
    source "libvirtd-ssh-config"
    owner "nova"
    group "nova"
    mode "0644"
end

template "/var/lib/nova/.ssh/authorized_keys" do
    # copy of the public key
    source "libvirtd-ssh-public-key.erb"
    owner "nova"
    group "nova"
    mode "0600"
    variables(
      :public_key => node[:libvirt][:ssh][:public_key]
    )
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

