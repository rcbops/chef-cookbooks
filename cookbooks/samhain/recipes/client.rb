
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

if (node[:samhain][:master_server])
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
	log "You will need to run the following steps to complete the installation of Samhaim - Client:" { level :info }
	log "On the Master: /usr/local/sbin/yule --gen-password" { level :info }
	log "On the Client: " { level :info}
	log "	/usr/local/sbin/samhain_setpwd samhain asdf <16 digit hex>" { level :info }
	log "	mv samhain.asdf /usr/local/sbin/samhain"" { level :info }
	log "On the Master:" { level :info }
	log "	/usr/local/sbin/yule -P <16 digit hex> >> /etc/yulerc" { level :info }
	log "	service yule restart" { level :info }
	log "On the Client:" { level :info }
	log "	/usr/local/sbin/samhain -t init" { level :info }
	log "	SCP this file to the Master_Server, place it in /var/lib/yule/file.<client_hostname>" { level :info }
	log "On the Master:" { level :info }
	log "	chown daemon:daemon /var/lib/yule/file.<client_hostname>" { level :info }
	log "	chmod 640 /var/lib/yule/file.<client_hostname>" { level :info }
	log "On the Client:" { level :info }
	log "	service samhain start" { level :info }
else
	log "Can not compile Samhain without \"Master Server\" defined" { level :error }
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

file "/tmp/samhain-2.6.4" do
	action :delete
end
