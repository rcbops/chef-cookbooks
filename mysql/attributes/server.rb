
# Misc Settings
# -------------
set_unless[:mysql][:datadir]		= "/var/lib/mysql"
set_unless[:mysql][:tmpdir]		= "/var/lib/mysqltmp"
set_unless[:mysql][:logdir]		= "/var/lib/mysqllog"
set_unless[:mysql][:socket]		= "#{mysql[:datadir]}/mysql.sock"
set_unless[:mysql][:table_cache]	= 2048
set_unless[:mysql][:thread_cache_size]	= 16
set_unless[:mysql][:open_files_limit]	= 20000
set_unless[:mysql][:max_connections]	= 100

# Slow Query Log Settings
# -----------------------
set[:mysql][:log_slow_queries]		= "#{mysql[:logdir]}/slow-queries.log"

# Global, Non Engine-Specific Buffers
# -----------------------------------
set_unless[:mysql][:max_allowed_packet]		= "16M"
set_unless[:mysql][:tmp_table_size]		= "64M"
set_unless[:mysql][:max_heap_table_size]	= "64M"
set_unless[:mysql][:query_cache_size]		= "32M"

# Per-Thread Buffers
# ------------------
set_unless[:mysql][:sort_buffer_size]		= "1M"
set_unless[:mysql][:read_buffer_size]		= "1M"
set_unless[:mysql][:read_rnd_buffer_size]	= "8M"
set_unless[:mysql][:join_buffer_size]		= "1M"

#
set[:mysql][:max_join_size]	= "4294967295"

set_unless[:mysql][:default_storage_engine]	= "MyISAM"

# MyISAM Specific Values
set_unless[:mysql][:key_buffer_size]		= "64M"
set_unless[:mysql][:myisam_sort_buffer_size]	= "64M"

# InnoDB Specific Values
set_unless[:mysql][:innodb_buffer_pool_size]		= "2048M"
set_unless[:mysql][:innodb_additional_mem_pool_size]	= "20M"
set_unless[:mysql][:innodb_thread_concurrency]		= 16

# Replication Values
set_unless[:mysql][:server_id]		= "10"
set_unless[:mysql][:expire_logs_days]	= 7

# Binary Logging
set_unless[:mysql][:binlog_enabled]     = "false"
set[:mysql][:log_bin]            = "#{mysql[:logdir]}/#{hostname}-bin-log"
set[:mysql][:log_bin_index]      = "#{mysql[:logdir]}/#{hostname}-bin-log.index"

# Relay Logging
set_unless[:mysql][:relaylog_enabled]	= "false"
set[:mysql][:relay_log]          = "#{mysql[:logdir]}/#{hostname}-relay-log"
set[:mysql][:relay_log_index]    = "#{mysql[:logdir]}/#{hostname}-relay-log.index"

# Log Slave Updates
set_unless[:mysql][:log_slave_updates_enabled] 	= "false"
