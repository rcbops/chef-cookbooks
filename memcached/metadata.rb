maintainer       "Justin Shepherd"
maintainer_email "jshepher@rackspace.com"
license          "Apache 2.0"
description      "Installs/Configures memcached"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.2"

attribute 'memcached/port',
  :display_name => "Port",
  :description => "Listen on TCP port <num>, the default is port 11211.",
  :default => "11211"

attribute 'memcached/user',
  :display_name => "Username",
  :description => "Assume the identity of <username> (only when run as root).",
  :default => "nobody"

attribute 'memcached/max_connections',
  :display_name => "Max Connections",
  :description => "Use <num> max simultaneous connections; the default is 1024.",
  :default => 1024

attribute 'memcached/cache_size',
  :display_name => "Cache Size",
  :description => "Use <num> MB memory max to use for object storage; the default is 64 megabytes.",
  :default => 64

attribute 'memcached/memcache_options',
  :display_name => "Additional Options",
  :description => "Any additional options that are outside of the listed attributes",
  :default => ""

attribute 'memcached/address',
  :display_name => "Address",
  :description => "Listen on <ip_addr>; default to 127.0.0.1. This is an important option to consider as there is no other way to secure the installation.",
  :default => "127.0.0.1"
