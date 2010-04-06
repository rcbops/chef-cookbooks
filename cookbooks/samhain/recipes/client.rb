
remote_file "/tmp/samhain-current.tar.gz" do
	source "http://la-samhna.de/samhain/samhain-current.tar.gz"
	mode "0644"
end

execute "unpack_current_tarball" do
	command "`which tar` -zxf /tmp/samhain-current.tar.gz"
	action :run
end

execute "unpack_versioned_tarball" do
	command "`which tar` -zxf /tmp/samhain-2.6.4.tar.gz"
	action :run
end

if (node[:samhain][:master_server] === "localhost.localdomain")
	ruby_block do
		block do
			Chef::Log.error("Can not compile Samhain without Master_Server defined")
		end
	end
else
	bash "install_samhain_client" do
		user "root"
		cwd "/tmp/samhain-2.6.4"
		code <<-EOH
		./configure --enable-network=client --enable-static --enable-userfiles --enable-port-check \
	            --with-logserver=node[:samhain][:master_server] --with-config-file=REQ_FROM_SERVER \
	            --with-data-file=REQ_FROM_SERVER/var/lib/samhain/samhain_file
		make
		make install
		make install-boot
		EOH
	end
	ruby_block do
		block do
			Chef::Log.info("You will need to run the following steps to complete the installation of Samhaim - Client")
			Chef::Log.info("On the Master: /usr/local/sbin/yule --gen-password")
			Chef::Log.info("On the Client: ")
			Chef::Log.info("	/usr/local/sbin/samhain_setpwd samhain asdf <16 digit hex>")
			Chef::Log.info("	mv samhain.asdf /usr/local/sbin/samhain")
			Chef::Log.info("On the Master:")
			Chef::Log.info("	/usr/local/sbin/yule -P <16 digit hex> >> /etc/yulerc")
			Chef::Log.info("	service yule restart")
			Chef::Log.info("On the Client:")
			Chef::Log.info("	/usr/local/sbin/samhain -t init")
			Chef::Log.info("	SCP this file to the Master_Server, place it in /var/lib/yule/file.<client_hostname>")
			Chef::Log.info("On the Master:")
			Chef::Log.info("	chown daemon:daemon /var/lib/yule/file.<client_hostname>")
			Chef::Log.info("	chmod 640 /var/lib/yule/file.<client_hostname>")
			Chef::Log.info("On the Client:")
			Chef::Log.info("	service samhain start")
		end
	end
end

service "samhain" do
	supports :status => true, :restart => true
	action :nothing
end

file "/tmp/samhain-current.tar.gz" do
	action :delete
end

file "/tmp/samhain-2.6.4.tar.gz" do
	action :delete
end

directory "/tmp/samhain-2.6.4" do
	recursive true
	action :delete
end
