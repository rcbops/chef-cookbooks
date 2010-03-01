
include_recipe "mysql::client"
include_recipe "memcached"
# include_recipe "httpd::server"

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
	   :memory_limit => node[:php][:memory_limit]
        )
        notifies :restart, resources(:service => "httpd"), :delayed
end
