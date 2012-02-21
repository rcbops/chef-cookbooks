

%w{git bc euca2ools netcat}.each do |pkg|
  package pkg do
    action :install
  end
end

execute "git clone https://github.com/rpedde/exerstack" do
  command "git clone https://github.com/rpedde/exerstack"
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

