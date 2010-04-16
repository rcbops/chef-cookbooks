maintainer       "Justin Shepherd"
maintainer_email "jshepher@rackspace.com"
license          "Apache 2.0"
description      "Installs/Configures bind and caching-nameserver"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.2"

attribute 'dns/search_domain',
  :display_name => "Search Domain",
  :description => "Search list for host-name lookups."
  :default => "somedomain.com"

attribute 'dns/dc_nameserver_1',
  :display_name => "DC Nameserver 1",
  :description => "The IP address of the Primary Caching Nameserver (ns1.<datacenter>.rackspace.com)."
  :default => "ns1.rackspace.com"

attribute 'dns/dc_nameserver_2',
  :display_name => "DC Nameserver 2",
  :description => "The IP address of the Secondary Caching Nameserver (ns2.<datacenter>.rackspace.com."
  :default => "ns2.rackspace.com"
