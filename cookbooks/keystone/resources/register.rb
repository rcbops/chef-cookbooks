
actions :create_service, :create_endpoint

attribute :auth_protocol, :kind_of => String, :equal_to => [ "http", "https" ]
attribute :auth_host, :kind_of => String
attribute :auth_port, :kind_of => String
attribute :api_ver, :kind_of => String, :default => "/v2.0"
attribute :auth_token, :kind_of => String


# :create_service specific attributes
attribute :service_type, :kind_of => String, :equal_to => [ "image", "identity", "compute", "storage", "ec2" ]
attribute :sertice_name, :kind_of => String
attribute :service_description, :kind_of => String

# :create_endpoint specific attributes
