

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

template "/opt/exerstack/localrc" do
  source "localrc.erb"
  owner "root"
  group "root"
  mode "0644"
end

# execute "run exerstack" do
#   command "./exercises.sh"
#   cwd "/opt/exerstack"
#   user "root"
#   action :nothing
# end

