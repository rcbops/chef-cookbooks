
include_recipe "memcached"

package "php-pecl-memcache" do
        action :install
end
