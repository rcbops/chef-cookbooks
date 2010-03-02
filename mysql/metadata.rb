maintainer       "Justin Shepherd"
maintainer_email "jshepher@rackspace.com"
license          "Apache 2.0"
description      "Installs/Configures mysql"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.2"

attribute 'mysql/datadir',
  :display_name => "DataDir",
  :description => "The MySQL data directory.",
  :default => "/var/lib/mysql"

attribute 'mysql/tmpdir',
  :display_name => "TempDir",
  :description => "",
  :default => "/var/lib/mysqltmp"

attribute 'mysql/logdir',
  :display_name => "LogDir",
  :description => "",
  :default => "/var/lib/mysqllog"

attribute 'mysql/socket',
  :display_name => "Socket",
  :description => "",
  :default => "/var/lib/mysql/mysql.sock"

attribute 'mysql/table_cache',
  :display_name => "Table Cache",
  :description => "",
  :default => 2048

attribute 'mysql/thread_cache_size',
  :display_name => "Thread Cache Size",
  :description => "",
  :default => 16

attribute 'mysql/open_files_limit',
  :display_name => "Open Files Limit",
  :description => "",
  :default => 20000

attribute 'mysql/max_connections',
  :display_name => "Max Connections",
  :description => "",
  :default => 200

attribute 'mysql/max_allowed_packet',
  :display_name => "Max Allowed Packet",
  :description => "",
  :default => "16M" 

attribute 'mysql/tmp_table_size',
  :display_name => "Temp Table Size",
  :description => "",
  :default => "64M"

attribute 'mysql/max_heap_table_size',
  :display_name => "Max Heap Table Size",
  :description => "",
  :default => "64M"

attribute 'mysql/query_cache_size',
  :display_name => "Query Cache Size",
  :description => "",
  :default => "32M"

attribute 'mysql/sort_buffer_size',
  :display_name => "Sort Buffer Size",
  :description => "",
  :default => "1M"

attribute 'mysql/read_buffer_size',
  :display_name => "Read Buffer Size",
  :description => "",
  :default => "1M"

attribute 'mysql/read_rnd_buffer_size',
  :display_name => "Read Random Buffer Size",
  :description => "",
  :default => "8M"

attribute 'mysql/join_buffer_size',
  :display_name => "Join Buffer Size",
  :description => "",
  :default => "1M"

attribute 'mysql/default_storage_engine',
  :display_name => "Default Storage Engine",
  :description => "",
  :default => "MyISAM"

attribute 'mysql/key_buffer_size',
  :display_name => "MyISAM Key Buffer Size",
  :description => "",
  :default => "64M"

attribute 'mysql/myisam_sort_buffer_size',
  :display_name => "MyISAM Sort Buffer Size",
  :description => "",
  :default => "64M"

attribute 'mysql/innodb_buffer_pool_size',
  :display_name => "InnoDB Buffer Pool Size",
  :description => "The size of the memory buffer InnoDB uses to cache data and indexes of its tables.",
  :default => "2048M"

attribute 'mysql/innodb_additional_mem_pool_size',
  :display_name => "InnoDB Additional Mem Pool Size",
  :description => "The size of a memory pool InnoDB uses to store data dictionary information and other internal data structures.",
  :default => "20M"

attribute 'mysql/innodb_thread_concurrency',
  :display_name => "InnoDB Thread Concurrency",
  :description => "InnoDB tries to keep the number of operating system threads concurrently inside InnoDB less than or equal to the limit given by this variable.",
  :default => 16

attribute 'mysql/server_id',
  :display_name => "Server ID",
  :description => "The server ID, used in replication to give each master and slave a unique identity.",
  :default => "10"

attribute 'mysql/expire_logs_days',
  :display_name => "Expire Logs Days",
  :description => "The number of days for automatic binary log file removal. ",
  :default => 7

attribute 'mysql/binlog_enabled',
  :display_name => "Enable Binary Logging",
  :description => "This variable controls wether Binary Logging is enabled or disabled",
  :default => "false"

attribute 'mysql/relaylog_enabled',
  :display_name => "Enable Relay Logs",
  :description => "This variable controls wether Relay Logging is enabled or disabled",
  :default => "false"

attribute 'mysql/log_slave_updates_enabled',
  :display_name => "Enable Log Slave Updates",
  :description => "This variable controls wether Slave Update Logging is enabled or disabled",
  :default => "false"
