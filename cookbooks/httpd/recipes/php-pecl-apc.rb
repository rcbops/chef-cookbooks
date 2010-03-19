
package "php-pecl-apc" do
        action :install
end

template "/etc/php.d/apc.ini" do
        source "apc.ini.erb"
        owner "root"
        group "root"
        mode "0644"
        variables(
	  :apc_enabled => node[:httpd][:apc_enabled],
	  :apc_shm_segments => node[:httpd][:apc_shm_segments],
	  :apc_optimization => node[:httpd][:apc_optimization],
	  :apc_enable_cli => node[:httpd][:apc_enable_cli],
	  :apc_shm_size => node[:httpd][:apc_shm_size]
        )
        notifies :restart, resources(:service => "httpd"), :delayed
end
