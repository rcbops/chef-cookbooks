maintainer       "Justin Shepherd"
maintainer_email "jshepher@rackspace.com"
license          "Apache 2.0"
description      "Installs/Configures mysql"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.2"

attribute 'mysql/datadir',
  :display_name => "DataDir",
  :description => "",
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

attribute 'mysql/datadir',
  :display_name => "DataDir",
  :description => "",
  :default => "/var/lib/mysql"
