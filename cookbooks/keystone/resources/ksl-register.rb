
actions :create_service, :create_endpoint

attribute :auth_protocol, :kind_of => string, :equal_to => [ "http", "https" ]
attribute :auth_host, :kind_of => string
attribute :auth_port, :kind_of => string
attribute :api_ver, :kind_of => string, :default => "/v2.0"
attribute :auth_token, :kind_of => string


# :create_service specific attributes
attribute :service_type, :kind_of => string, :equal_to => [ "image", "identity", "compute", "storage", "ec2" ]
attribute :sertice_name, :kind_of => string
attribute :service_description, :kind_of => string

# :create_endpoint specific attributes
