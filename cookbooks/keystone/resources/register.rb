
actions :create_service, :create_endpoint, :create_tenant, :create_user, :create_role, :grant_role

attribute :auth_protocol, :kind_of => String, :equal_to => [ "http", "https" ]
attribute :auth_host, :kind_of => String
attribute :auth_port, :kind_of => String
attribute :api_ver, :kind_of => String, :default => "/v2.0"
attribute :auth_token, :kind_of => String

# Used by both :create_service and :create_endpoint
attribute :service_type, :kind_of => String, :equal_to => [ "image", "identity", "compute", "storage", "ec2", "volume" ]

# :create_service specific attributes
attribute :service_name, :kind_of => String
attribute :service_description, :kind_of => String

# :create_endpoint specific attributes
attribute :endpoint_region, :kind_of => String, :default => "RegionOne"
attribute :endpoint_adminurl, :kind_of => String
attribute :endpoint_internalurl, :kind_of => String
attribute :endpoint_publicurl, :kind_of => String

# Used by both :create_tenant and :create_user
attribute :tenant_name, :kind_of => String

# :create_tenant specific attributes
attribute :tenant_description, :kind_of => String
attribute :tenant_enabled, :kind_of => String, :equal_to => [ "true", "false" ], :default => "true"

# :create_user specific attributes
attribute :user_name, :kind_of => String
attribute :user_pass, :kind_of => String
# attribute :user_email, :kind_of => String
attribute :user_enabled, :kind_of => String, :equal_to => [ "true", "false" ], :default => "true"

# Used by :create_role and :grant_role specific attributes
attribute :role_name, :kind_of => String
