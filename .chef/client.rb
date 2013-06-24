chef_validation_client_name   = ENV['chef_validation_client_name'] || "chef-validator"
chef_validation_key           = ENV['chef_validation_key'] || "/vagrant/.chef/chef-validator.pem"
chef_server_url               = ENV['chef_server_url'] || "https://chef"

log_level                   :info
log_location                STDOUT
chef_server_url             chef_server_url
validation_client_name      chef_validation_client_name