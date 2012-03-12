#
# Cookbook Name:: openstack
# Recipe:: libvirt
#

service "libvirt-bin" do
  supports :status => true, :restart => true
  action :enable
end

if node[:libvirt][:auth_tcp] == "sasl"
    package "sasl2-bin" do
        # install sasl2-bin for sasl2passwd
        action :install
    end

    service "saslauthd" do
      supports :status => true, :restart => true
      action :enable
    end

    # TODO(breu): do some sasl stuff
    # TODO(breu): saslpasswd2 -a libvirt sasl_username
    # TODO(breu): pass in the password sasl_password
    VIRT_SASL_PASSWORD = "#{node[:libvirt][:sasl_password]}"
    VIRT_SASL_USERNAME = "#{node[:libvirt][:sasl_username]}"
    bash "create sasl user" do
        cwd "/tmp"
        user "root"
        code <<-EOH
            set -x
            echo '#{VIRT_SASL_PASSWORD}' | saslpasswd2 -p -c -a libvirt #{VIRT_SASL_USERNAME}
        EOH
    end
end

template "/etc/default/saslauthd" do
    source "saslauthd"
    owner "root"
    group "root"
    mode "0644"
    action :create
    notifies :restart, resources(:service => "saslauthd"), :immediately
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

