
include_recipe "httpd::server"

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

template "/etc/php.d/memory_limit.ini" do
        source "memory_limit.ini.erb"
        owner "root"
        group "root"
        mode "0644"
        variables(
          :php_memory_limit => node[:httpd][:php_memory_limit]
        )
        notifies :restart, resources(:service => "httpd"), :delayed
end
