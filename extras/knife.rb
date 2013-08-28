log_level                :info
log_location             STDOUT
node_name                'admin'
client_key               '/vagrant/.chef/admin.pem'
validation_client_name   'chef-validator'
validation_key           '/vagrant/.chef/chef-validator.pem'
chef_server_url          'https://33.33.33.50'
cache_type               'BasicFile'
cache_options( :path => '/home/vagrant/.chef/checksums' )