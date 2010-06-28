
dc_name_servers = Hash.new
dc_name_servers.store("default", Hash.new)
dc_name_servers.store("dfw", Hash.new)
dc_name_servers.store("iad2", Hash.new)
dc_name_servers.store("iad1", Hash.new)
dc_name_servers.store("ord1", Hash.new)
dc_name_servers.store("lon1", Hash.new)
dc_name_servers.store("lon3", Hash.new)

dc_name_servers['default'].store("ns1","69.20.95.4")
dc_name_servers['default'].store("ns2","65.61.188.4")
dc_name_servers['dfw'].store("ns1","72.3.128.240")
dc_name_servers['dfw'].store("ns2","72.3.128.241")
dc_name_servers['iad1'].store("ns1","69.20.0.164")
dc_name_servers['iad1'].store("ns2","69.20.0.196")
dc_name_servers['iad2'].store("ns1","69.20.0.164")
dc_name_servers['iad2'].store("ns2","69.20.0.196")
dc_name_servers['ord'].store("ns1","173.203.4.8")
dc_name_servers['ord'].store("ns2","173.203.4.9")
dc_name_servers['lon1'].store("ns1","83.138.151.80")
dc_name_servers['lon1'].store("ns2","83.138.151.81")
dc_name_servers['lon3'].store("ns1","83.138.151.80")
dc_name_servers['lon3'].store("ns2","83.138.151.81")

dc_file = "/root/.rackspace/datacenter"
if File.exists?(dc_file)
	datacenter = File.read(dc_file).gsub("\n",'')
else
	datacenter = "default"
end

set_unless[:dns][:search_domain] = "somedomain.com"
set[:dns][:local_nameserver] = "127.0.0.1"
set_unless[:dns][:dc_nameserver_1] = dc_name_servers[datacenter]["ns1"]
set_unless[:dns][:dc_nameserver_2] = dc_name_servers[datacenter]["ns2"]

