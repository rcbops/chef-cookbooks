

case node["platform"]
when "ubuntu","debian"
  %w{git bc euca2ools netcat}.each do |pkg|
    package pkg do
      action :install
    end
  end
when "redhat","centos","fedora","scientific","amazon"
  %w{git bc euca2ools nc}.each do |pkg|
    package pkg do
      action :install
    end
  end
end

execute "git clone https://github.com/rcbops/exerstack" do
  command "git clone https://github.com/rcbops/exerstack"
  cwd "/opt"
  user "root"
  not_if do File.exists?("/opt/exerstack") end
end

keystone = search(:node, "roles:keystone AND chef_environment:#{node.chef_environment}")
if keystone.length > 0
  keystone_admin_username = "admin"
  keystone_admin_password = keystone[0]['keystone']['users']['admin']['password']
  keystone_admin_tenantname = keystone[0]['keystone']['users']['admin']['default_tenant']
  ec2_access = keystone[0]["credentials"]["EC2"]["admin"]["access"]
  ec2_secret = keystone[0]["credentials"]["EC2"]["admin"]["secret"]
else
  keystone_admin_username = "admin"
  keystone_admin_password = node['keystone']['users']['admin']['password']
  keystone_admin_tenantname = node['keystone']['users']['admin']['default_tenant']
  ec2_access = node["credentials"]["EC2"]["admin"]["access"]
  ec2_secret = node["credentials"]["EC2"]["admin"]["secret"]
end

template "/opt/exerstack/localrc" do
  source "localrc.erb"
  owner "root"
  group "root"
  mode "0644"
  variables(
    "keystone_admin_username" => keystone_admin_username,
    "keystone_admin_password" => keystone_admin_password,
    "keystone_admin_tenantname" => keystone_admin_tenantname,
    "keystone_region_name" => "RegionOne",
    "ec2_access" => ec2_access,
    "ec2_secret" => ec2_secret
  )
end

# execute "run exerstack" do
#   command "./exercises.sh"
#   cwd "/opt/exerstack"
#   user "root"
#   action :nothing
# end

