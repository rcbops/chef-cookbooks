maintainer       "Justin Shepherd"
maintainer_email "jshepher@rackspace.com"
license          "Apache 2.0"
description      "Installs/Configures httpd"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.2"

attribute 'httpd/keepalive',
  :display_name => "Keepalive",
  :description => "The Keep-Alive extension to HTTP/1.0 and the persistent connection feature of HTTP/1.1 provide long-lived HTTP sessions which allow multiple requests to be sent over the same TCP connection.",
  :default => "Off"

attribute 'httpd/max_keepalive_requests',
  :display_name => "Max Keepalive Requests",
  :description => "Limits the number of requests allowed per connection when KeepAlive is on.",
  :default => 100

attribute 'httpd/keepalive_timeout',
  :display_name => "Keepalive Timeout",
  :description => "The number of seconds Apache will wait for a subsequent request before closing the connection.",
  :default => 15

attribute 'httpd/start_servers',
  :display_name => "Start Servers",
  :description => "Sets the number of child server processes created on startup.",
  :default => 8

attribute 'httpd/min_spare_servers',
  :display_name => "Min Spare Servers",
  :description => "Sets the desired minimum number of idle child server processes.",
  :default => 5

attribute 'httpd/max_spare_servers',
  :display_name => "Max Spare Servers",
  :description => "Sets the desired maximum number of idle child server processes.",
  :default => 20

attribute 'httpd/server_limit',
  :display_name => "Server Limit",
  :description => "Sets the maximum configured value for MaxClients for the lifetime of the Apache process.",
  :default => 256

attribute 'httpd/max_clients',
  :display_name => "Max Clients",
  :description => "Sets the limit on the number of simultaneous requests that will be served.",
  :default => 256

attribute 'httpd/max_requests_per_child',
  :display_name => "Max Requests Per Child",
  :description => "Sets the limit on the number of requests that an individual child server process will handle.",
  :default => 4000
