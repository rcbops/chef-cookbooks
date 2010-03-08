include_recipe "mysql::client"
include_recipe "httpd::server"

package "php-bcmath" do
	action :install
end

package "php-cli" do
	action :install
end

package "php-common" do
	action :install
end

package "php-dba" do
	action :install
end

package "php-devel" do
	action :install
end

package "php-gd" do
	action :install
end

package "php" do
	action :install
end

package "php-imap" do
	action :install
end

package "php-ldap" do
	action :install
end

package "php-mbstring" do
	action :install
end

package "php-mcrypt" do
	action :install
end

package "php-mhash" do
	action :install
end

package "php-mysql" do
	action :install
end

package "php-ncurses" do
	action :install
end

package "php-odbc" do
	action :install
end

package "php-pdo" do
	action :install
end

package "php-pgsql" do
	action :install
end

package "php-snmp" do
	action :install
end

package "php-soap" do
	action :install
end

package "php-tidy" do
	action :install
end

package "php-xml" do
	action :install
end

package "php-xmlrpc" do
	action :install
end

package "php-pear" do
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
