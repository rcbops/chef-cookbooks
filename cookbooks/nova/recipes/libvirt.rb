#
# Cookbook Name:: openstack
# Recipe:: libvirt
#

# Distribution specific settings go here
if platform?(%w{fedora})
  # Fedora
  libvirt_package = "libvirt"
  libvirt_service = "libvirtd"
  libvirt_package_options = ""
else
  # All Others (right now Debian and Ubuntu)
  libvirt_package = "libvirt-bin"
  libvirt_service = libvirt_package
  libvirt_package_options = "-o Dpkg::Options::='--force-confold' --force-yes"
end

package libvirt_package do
  action :install
end

if platform?(%w{fedora})
  # oh fedora...
  bash "create libvirtd group" do
    cwd "/tmp"
    user "root"
    code <<-EOH
        set -e
        set -x
        groupadd -f libvirtd
        usermod -G libvirtd nova
    EOH
  end
end

service libvirt_service do
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
  notifies :restart, resources(:service => libvirt_service), :immediately
end

template "/etc/default/libvirt-bin" do
  source "libvirt-bin.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => libvirt_service), :immediately
end

