#
# Cookbook Name:: mysql
# Recipe:: server
#
# Copyright 2009, Example Com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "mysql::client"

package "perl-DBD-MySQL" do
	action :install
end

package "mysql-server" do
	action :install
end

package "maatkit" do
	action :install
end

service "mysqld" do
	supports :status => true, :restart => true
	action :enable
end

directory "#{node[:mysql][:tmpdir]}" do
	owner "mysql"
	group "mysql"
	mode "0755"
	action :create
	not_if "test -d #{node[:mysql][:tmpdir]}"
end

directory "#{node[:mysql][:logdir]}" do
	owner "mysql"
	group "mysql"
	mode "0755"
	action :create
	not_if "test -d #{node[:mysql][:logdir]}"
end

template "/etc/my.cnf" do
	source "my.cnf.erb"
	owner "root"
	group "root"
	mode "0644"
	variables(
          :datadir => node[:mysql][:datadir],
          :tmpdir => node[:mysql][:tmpdir],
          :logdir => node[:mysql][:logdir],
          :socket => node[:mysql][:socket],
          :table_cache => node[:mysql][:table_cache],
          :thread_cache_size => node[:mysql][:thread_cache_size],
          :open_files_limit => node[:mysql][:open_files_limit],
          :max_connections => node[:mysql][:max_connections],
          :max_allowed_packet => node[:mysql][:max_allowed_packet],
          :tmp_table_size => node[:mysql][:tmp_table_size],
          :max_heap_table_size => node[:mysql][:max_heap_table_size],
          :query_cache_size => node[:mysql][:query_cache_size],
          :sort_buffer_size => node[:mysql][:sort_buffer_size],
          :read_buffer_size => node[:mysql][:read_buffer_size],
          :read_rnd_buffer_size => node[:mysql][:read_rnd_buffer_size],
          :join_buffer_size => node[:mysql][:join_buffer_size],
          :log_slow_queries => node[:mysql][:log_slow_queries],
          :max_join_size => node[:mysql][:max_join_size],
          :default_storage_engine => node[:mysql][:default_storage_engine],
          :key_buffer_size =>  node[:mysql][:key_buffer_size],
          :myisam_sort_buffer_size => node[:mysql][:myisam_sort_buffer_size],
          :innodb_buffer_pool_size => node[:mysql][:innodb_buffer_pool_size],
          :innodb_additional_mem_pool_size => node[:mysql][:innodb_additional_mem_pool_size],
          :innodb_thread_concurrency => node[:mysql][:innodb_thread_concurrency],
          :server_id => node[:mysql][:server_id],
          :expire_logs_days => node[:mysql][:expire_logs_days],
          :log_bin => node[:mysql][:log_bin],
          :log_bin_index => node[:mysql][:log_bin_index]
	)
	notifies :restart, resources(:service => "mysqld"), :immediately
end

if (node[:mysql][:root_password])
	execute "setting-mysql-passwd" do
		command "mysqladmin -u root password #{node[:mysql][:root_password]}"
	end
end
