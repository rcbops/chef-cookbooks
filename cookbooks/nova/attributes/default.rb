default[:mysql][:root_pass] = "secrete"

default[:nova][:db] = "nova"
default[:nova][:db_user] = "nova"
default[:nova][:db_passwd] = "nova"
default[:nova][:db_host] = node[:controller_ipaddress]

# TODO (cleanup this section)
default[:glance][:db] = "glance"
default[:glance][:db_user] = "glance"
default[:glance][:db_passwd] = "glance"
default[:glance][:api_port] = "9292"
default[:glance][:registry_port] = "9191"
default[:glance][:images] = [ "tty", "natty" ]

default[:volume][:api_port] = 8776
default[:volume][:adminURL] = "http://#{default[:controller_ipaddress]}:#{default[:volume][:api_port]}/v1"
default[:volume][:internalURL] = default[:volume][:adminURL]
default[:volume][:publicURL] = default[:volume][:adminURL]

# TODO (cleanup this section)
default[:keystone][:db] = "keystone"
default[:keystone][:db_user] = "keystone"
default[:keystone][:db_passwd] = "keystone"
default[:keystone][:verbose] = "False"
default[:keystone][:debug] = "False"
default[:keystone][:service_port] = "5000"
default[:keystone][:admin_port] = "35357"
default[:keystone][:admin_token] = "999888777666"

# TODO (cleanup this section)
default[:dash][:db] = "dash"
default[:dash][:db_user] = "dash"
default[:dash][:db_passwd] = "dash"

default[:image][:oneiric] = "http://c250663.r63.cf1.rackcdn.com/ubuntu-11.10-server-uec-amd64-multinic.tar.gz"
default[:image][:natty] = "http://c250663.r63.cf1.rackcdn.com/ubuntu-11.04-server-uec-amd64-multinic.tar.gz"
default[:image][:maverick] = "http://c250663.r63.cf1.rackcdn.com/ubuntu-10.10-server-uec-amd64-multinic.tar.gz"
default[:image][:tty] = "http://smoser.brickies.net/ubuntu/ttylinux-uec/ttylinux-uec-amd64-12.1_2.6.35-22_1.tar.gz"

default[:public][:label] = "public"
default[:public][:ipv4_cidr] = "192.168.100.0/24"
default[:public][:num_networks] = "1"
default[:public][:network_size] = "255"
default[:public][:bridge] = "br100"
default[:public][:bridge_dev] = "eth2"
default[:public][:dns1] = "8.8.8.8"
default[:public][:dns2] = "8.8.4.4"

default[:private][:label] = "private"
default[:private][:ipv4_cidr] = "192.168.200.0/24"
default[:private][:num_networks] = "1"
default[:private][:network_size] = "255"
default[:private][:bridge] = "br200"
default[:private][:bridge_dev] = "eth3"

default[:controller_ipaddress] = node[:ipaddress]
default[:virt_type] = "kvm"

default[:libvirt][:auth_tcp] = "none"
default[:libvirt][:ssh][:private_key] = "-----BEGIN DSA PRIVATE KEY-----
MIIBvAIBAAKBgQDUIz3rg0afavOwNeTJL/112U/l4B08kzZVx+QcflxllpW4sn/f
c+j+BeQ/sm2oW67vY9O/1GbN3FIN7Um3p0F9ycpfXpEiwk4UYneJtXFNhlu9rSrK
hWsEWENoKrCFhZ4Zuu8ads0DCMkU/ErumXMvJZQpSe+8CfguYSMbXvkYhQIVAPzY
syPKqOa3scshLqwPulZF64nZAoGABY60uqcFSJ8agPY2YZmLTsQ/OrVbUsnwT+RE
eXjqaofUvdlK43kWGw8I1v9Brh+32mFcYu2L0izv3ZvH9wd2OEiZnHxtZEojALBd
KMFRbC8PLC2Imz3yvNwEo+ZkgSo5LzP9nScyO/JDjbyOJAPEsCtKRxmth4XBcuY5
lPAtTlECgYEAtFtXDovPhgvLGhFrRZjBzp3HREWW1tihsWZA4qIFib+Rd+/s3lWG
CYiYhwoK8RM+z0TNXjBIWXpHwAqX5kFhg/xPySxWS58GePmPOXDbFEYq5FRWTx47
sQqRmVHmlZZ9AhsRfs65g4LlgJyBlWPeZ0xsfShYHKLKg5RrOGn90egCFQCcok5v
1TpUNWQC3NPFkwWHkp1zrg==
-----END DSA PRIVATE KEY-----"
default[:libvirt][:ssh][:public_key] = "ssh-dss AAAAB3NzaC1kc3MAAACBANQjPeuDRp9q87A15Mkv/XXZT+XgHTyTNlXH5Bx+XGWWlbiyf99z6P4F5D+ybahbru9j07/UZs3cUg3tSbenQX3Jyl9ekSLCThRid4m1cU2GW72tKsqFawRYQ2gqsIWFnhm67xp2zQMIyRT8Su6Zcy8llClJ77wJ+C5hIxte+RiFAAAAFQD82LMjyqjmt7HLIS6sD7pWReuJ2QAAAIAFjrS6pwVInxqA9jZhmYtOxD86tVtSyfBP5ER5eOpqh9S92UrjeRYbDwjW/0GuH7faYVxi7YvSLO/dm8f3B3Y4SJmcfG1kSiMAsF0owVFsLw8sLYibPfK83ASj5mSBKjkvM/2dJzI78kONvI4kA8SwK0pHGa2HhcFy5jmU8C1OUQAAAIEAtFtXDovPhgvLGhFrRZjBzp3HREWW1tihsWZA4qIFib+Rd+/s3lWGCYiYhwoK8RM+z0TNXjBIWXpHwAqX5kFhg/xPySxWS58GePmPOXDbFEYq5FRWTx47sQqRmVHmlZZ9AhsRfs65g4LlgJyBlWPeZ0xsfShYHKLKg5RrOGn90eg= root@example.com"
