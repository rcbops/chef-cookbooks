
include_recipe "mysql::client"
include_recipe "memcached"

package "php-common" do
        action :install
end

package "php-cli" do
        action :install
end

package "php" do
        action :install
end

package "php-devel" do
        action :install
end

package "php-gd" do
        action :install
end

package "php-pdo" do
        action :install
end

package "php-mysql" do
        action :install
end

package "php-pear" do
        action :install
end

package "php-pecl-apc" do
        action :install
end

package "php-pecl-memcache" do
        action :install
end

template "/etc/php.ini" do
        source "php.ini.erb"
        owner "root"
        group "root"
        mode "0644"
        variables(
	  :php_memory_limit => node[:httpd][:php_memory_limit]
        )
        notifies :restart, resources(:service => "httpd"), :delayed
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
