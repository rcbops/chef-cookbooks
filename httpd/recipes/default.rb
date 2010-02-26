package "httpd" do
        action :install
end

package "httpd-devel" do
        action :install
end

package "mod_ssl" do
        action :install
end

service "httpd" do
        supports :status => true, :restart => true
        action :enable
end


template "/etc/httpd/conf/httpd.conf" do
        source "httpd.conf.erb"
        owner "root"
        group "root"
        mode "0644"
        variables(
          :keepalive => node[:httpdd][:keepalive],
          :max_keepalive_requests => node[:httpd][:max_keepalive_requests],
          :keepalive_timeout => node[:httpd][:keepalive_timeout],
          :start_servers => node[:httpd][:start_servers],
          :min_spare_servers => node[:httpd][:min_spare_servers],
          :max_spare_servers => node[:httpd][:max_spare_servers],
          :server_limit => node[:httpd][:server_limit],
          :max_clients => node[:httpd][:max_clients],
          :max_requests_per_child => node[:httpd][:max_requests_per_child]
        )
        notifies :restart, resources(:service => "httpd"), :delayed
end

template "/etc/httpd/conf.d/modules.conf" do
        source "modules.conf.erb"
        owner "root"
        group "root"
        mode "0644"
        notifies :restart, resources(:service => "httpd"), :delayed
end

template "/etc/httpd/conf.d/logging.conf" do
        source "logging.conf.erb"
        owner "root"
        group "root"
        mode "0644"
        notifies :restart, resources(:service => "httpd"), :delayed
end

template "/etc/httpd/conf.d/server_status.conf" do
        source "server_status.conf.erb"
        owner "root"
        group "root"
        mode "0644"
        notifies :restart, resources(:service => "httpd"), :delayed
end

template "/etc/httpd/conf.d/userdir.conf" do
        source "userdir.conf.erb"
        owner "root"
        group "root"
        mode "0644"
        notifies :restart, resources(:service => "httpd"), :delayed
end

template "/etc/httpd/conf.d/error.conf" do
        source "error.conf.erb"
        owner "root"
        group "root"
        mode "0644"
        notifies :restart, resources(:service => "httpd"), :delayed
end

template "/etc/httpd/conf.d/icons.conf" do
        source "icons.conf.erb"
        owner "root"
        group "root"
        mode "0644"
        notifies :restart, resources(:service => "httpd"), :delayed
end

template "/etc/httpd/conf.d/browser_match.conf" do
        source "browser_match.conf.erb"
        owner "root"
        group "root"
        mode "0644"
        notifies :restart, resources(:service => "httpd"), :delayed
end

template "/etc/httpd/conf.d/mod_proxy.conf" do
        source "mod_proxy.conf.erb"
        owner "root"
        group "root"
        mode "0644"
        notifies :restart, resources(:service => "httpd"), :delayed
end

template "/etc/httpd/conf.d/language.conf" do
        source "language.conf.erb"
        owner "root"
        group "root"
        mode "0644"
        notifies :restart, resources(:service => "httpd"), :delayed
end

directory "/etc/httpd/vhosts" do
  owner "root"
  group "root"
  mode "0755"
  action :create
  not_if "test -d /etc/httpd/vhosts"
end

template "/etc/httpd/vhosts/000-default.conf" do
        source "000-default.conf.erb"
        owner "root"
        group "root"
        mode "0644"
        notifies :restart, resources(:service => "httpd"), :delayed
end
