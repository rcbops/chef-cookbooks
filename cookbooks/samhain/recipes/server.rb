

remote_file "/tmp/samhain-current.tar.gz" do
	source "http://la-samhna.de/samhain/samhain-current.tar.gz"
	mode "0644"
end

execute "unpack_current_tarball"
	command "`which tar` -zxf /tmp/samhain-current.tar.gz"
	action :run
end

execute "unpack_versioned_tarball"
	command "`which tar` -zxf /tmp/samhain-2.6.4.tar.gz"
	action :run
end

script "install_samhain" do
	interpreter "bash"
	user "root"
	cwd "/tmp/samhain-2.6.4"
	code <<-EOH
	./configure --enable-network=server
	make
	make install
	make install-boot
	EOH
end

service 
	supports :status => true, :restart => true
	action :enable
end

directory "/var/lib/yule" do
	recursive true
	action :delete
end

directory "/var/lib/yule" do
	owner "daemon"
	group "daemon"
	mode "0700"
	action :create
end

template "/var/lib/yule/defaultrc"
	source "defaultrc.erb"
	owner "daemon"
	group "daemon"
	mode "0600"
	notifies :restart, resources(:service => "yule"), :delayed
end

file "/tmp/samhain-current.tar.gz" do
	action :delete
end

file "/tmp/samhain-2.6.4.tar.gz" do
	action :delete
end
