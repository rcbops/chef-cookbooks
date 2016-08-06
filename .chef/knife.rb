chef_node_name                = ENV['chef_node_name'] || "admin"
chef_client_key               = ENV['chef_client_key'] || "/vagrant/.chef/admin.pem"
chef_validation_client_name   = ENV['chef_validation_client_name'] || "chef-validator"
chef_validation_key           = ENV['chef_validation_key'] || "/vagrant/.chef/chef-validator.pem"
chef_server_url               = ENV['chef_server_url'] || "https://chef"

log_level                :info
log_location             STDOUT
node_name                chef_node_name
client_key               chef_client_key
validation_client_name   chef_validation_client_name
validation_key           chef_validation_key
chef_server_url          chef_server_url
cache_type               'BasicFile'
cache_options( :path => '/home/vagrant/.chef/checksums' )
