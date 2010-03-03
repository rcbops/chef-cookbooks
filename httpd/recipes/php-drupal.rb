
include_recipe "httpd::php-minimal"
include_recipe "mysql::client"

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

include_recipe "httpd::php-pecl-memcache"
include_recipe "httpd::php-pecl-apc"
