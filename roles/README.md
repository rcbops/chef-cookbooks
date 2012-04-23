Create roles here, in either the Role Ruby DSL (.rb) or JSON (.json) files. To install roles on the server, use knife.

For example, create `roles/base_example.rb`:

    name "base_example"
    description "Example base role applied to all nodes."
    # List of recipes and roles to apply. Requires Chef 0.8, earlier versions use 'recipes()'.
    #run_list()
    # Attributes applied if the node doesn't have it set already.
    #default_attributes()
    # Attributes applied no matter what the node has set already.
    #override_attributes()

Then upload it to the Chef Server:
    
    knife role from file roles/base_example.rb


Roles in use:

role - base
    recipe - rcb::packages
    recipe - openssh
    recipe - ntp

Simple:
~~~~~
role - allinone
    role - single-controller
        role - base
        role - mysql-master
        role - rabbitmq-server
        role - keystone
        role - glance-registry
        role - glance-api
        recipe - nova::nova-setup
        role - nova-scheduler
        role - nova-api-ec2
        role - nova-api-os-compute
        role - nova-volume
        role - nova-vncproxy
        role - horizon-server

    role - single-compute
        role - base
        recipe - nova::compute


Complex:
~~~~~~~
role - single-controller
    role - base
    role - mysql-master
    role - rabbitmq-server
    recipe - keystone::server
    recipe - glance
    recipe - nova::nova-setup
    recipe - nova::scheduler
    recipe - nova::api-ec2
    recipe - nova::api-os-compute
    recipe - nova::volume
    recipe - nova::vncproxy
    role - horizon-server

role - single-compute
    role - base
    recipe - nova::compute


Even More Complex:
~~~~~~~~~~~~
role - glance-api
    role - base
    recipe - glance::api

role - glance-registry
    role - base
    recipe - glance::registry

role - keystone
    role - base
    recipe - keystone::server

role - mysql-master
    role - base
    recipe - mysql::Server

role - nova-api
    role - base
    recipe - nova::setup
    recipe - nova::api-ec2
    recipe - nova::api-os-compute

role - nova-scheduler
    role - base
    recipe - nova::nova-setup
    recipe - nova::nova::scheduler

role - rabbitmq-server
    role - base
    recipe - erlang::default
    recipe - rabbitmq::default

role - horizon
    role - base
    recipe - horizon::Server

role - nova-volume
    role - base
    recipe - nova::volume

role - single-compute
    role - base
    recipe - nova::compute
