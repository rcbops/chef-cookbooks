
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

# set_unless[:mysql][:]		= ""
# set_unless[:mysql][:]		= ""
# set_unless[:mysql][:]		= ""
# Tunable Parameters
