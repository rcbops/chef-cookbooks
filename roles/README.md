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

Role Descriptions
=================

_allinone_
----------

Description: This will create an all-in-one (all services on one box) Openstack environment.

### run_list

    role[single-controller]
    role[single-compute]

_base_
---------

Description: "Base role for a server" __TODO__: Needs a better description

### run_list
    recipe[rcb::packages]
    recipe[openssh]
    recipe[ntp]

### default_attributes

    "ntp" => {
      "servers" => ["0.pool.ntp.org", "1.pool.ntp.org", "2.pool.ntp.org"]
    }

### Dependencies

_glance-api_
---------------

Description:  "Glance API server"

### run_list
    role[base]
    recipe[glance::api]

### Dependencies

_glance-registry_
--------------------

Description: "Glance Registry server"

### run_list(
    role[base]
    recipe[glance::registry]

### Dependencies

_glance_
--------

Description: "Glance server"

### run_list
    role[base]
    recipe[glance]

### Dependencies

_ha-controller_
---------------

Description: "Installs and configures a (non-HA) Nova Controller."
__TODO__: DO NOT USE THIS ROLE.

### run_list
    role[base]
    recipe[rabbitmq]
    recipe[keystone::server]
    recipe[glance]
    role[nova-setup]
    recipe[nova::scheduler]
    recipe[nova::api-ec2]
    recipe[nova::api-metadata]
    recipe[nova::api-os-compute]
    recipe[nova::api-os-volume]
    recipe[nova::volume]
    recipe[horizon::server]

_horizon-server_
----------------

Description: "Horizon (OpenStack Dashboard) Server"

### run_list
    role[base]
    recipe[horizon::server]

_jenkins-allinone_
------------------

Description: this inherits from role[allinone], sets default attributes required by our jenkins jobs.

### run_list

    role[allinone]

### default_attributes

    "mysql" => {
      "allow_remote_root" => true
    },
    "glance" => {
      "image_upload" => true,
      "images" => ["tty"]
    },
    "package_component" => "folsom",
    "public" => {
      "bridge_dev" => "eth0.100"
    },
    "private" => {
      "bridge_dev" => "eth0.101"
    },
    "virt_type" => "qemu"

_jenkins-compute_
-----------------

Description: This inherits from role[single-compute], and sets default attributes required by our jenkins jobs.

### run_list

    role[single-compute]

### default_attributes

    "mysql" => {
      "allow_remote_root" => true
    },
    "package_component" => "folsom",
    "public" => {
      "bridge_dev" => "eth0.100"
    },
    "private" => {
      "bridge_dev" => "eth0.101"
    },
    "virt_type" => "qemu"

_jenkins-controller_
--------------------

Description: This inherits from role[single-controller], and sets default attributes required by our jenkins jobs.

### run_list

    role[single-controller]

### default_attributes

    "mysql" => {
      "allow_remote_root" => true,
      "root_network_acl" => "%"
    },
    "glance" => {
      "image_upload" => true,
      "images" => ["tty"]
    },
    "package_component" => "folsom",
    "public" => {
      "bridge_dev" => "eth0.100"
    },
    "private" => {
      "bridge_dev" => "eth0.101"
    },
    "virt_type" => "qemu"

_keystone_
----------

Description: "Installs and Configures a Keystone Server"
__TODO__: Rename to keystone-server

### run_list
    role[base]
    recipe[keystone::server]

### dependencies
    Expects that a node with role[mysql-master] exists

_mysql-master_
--------------

Description: "MySQL Server (non-ha)"

### run_list
    role[base]
    recipe[mysql::server]

_nova-api-ec2_
--------------

Description: "Installs and Configures the OpenStack EC2 compatability API."

### run_list
    role[base]
    recipe[nova::api-ec2]

__TODO__: Need to make sure this list is correct

_nova-api-os-compute_
---------------------

Description: "Installs and Configures the OpenStack API."

### run_list
    role[base]
    recipe[nova::api-os-compute]

__TODO__: Need to make sure this list is correct

_nova-api_
----------

Description: "Installs and Configures both OpenStack APIs (OS and EC2)."

### run_list
    role[base]
    recipe[nova::api-ec2]
    recipe[nova::api-os-compute]

__TODO__: Need to make sure this list is correct

_nova-misc-services_
--------------------

__TODO__: Needs to be filled out

_nova-scheduler_
----------------

Description: "Installs the Nova Scheduler Service."

### run_list
    role[base]
    recipe[nova::scheduler]

_nova-vncproxy_
---------------

Description: "Installs the Nova VNCProxy Service."

### run_list
    role[base]
    recipe[nova::vncproxy]

_nova-volume_
-------------

Description: "Installs the Nova Volume Service."

### run_list
    role[base]
    recipe[nova::volume]

_rabbitmq-server_
-----------------

Description: "Installs a RabbitMQ Server."

### run_list
    role[base]
    recipe[erlang::default]
    recipe[rabbitmq::default]

 nova-controller
----------------

Description "Nova core functions"

### run_list
  role[base]
  role[nova-setup]
  role[nova-scheduler]
  role[nova-api-ec2]
  role[nova-api-os-compute]
  role[nova-volume]
  role[nova-vncproxy]
)

_single-compute_
----------------

Description: "Installs the Nova Compute Service."

### run_list
    role[base]
    recipe[nova::compute]

_single-controller_
-------------------

Description: "Installs and configures a (non-HA) Nova Controller."

### run_list
    role[base]
    role[mysql-master]
    role[rabbitmq-server]
    role[keystone]
    role[glance-registry]
    role[glance-api]
    role[nova-controller]
    role[nova-scheduler]
    role[nova-api-ec2]
    role[nova-api-os-compute]
    role[nova-volume]
    role[nova-vncproxy]
    role[horizon-server]

_swift-account-server_
----------------------

__TODO__: Needs to be filled out

_swift-all-in-one_
------------------

__TODO__: Needs to be filled out

_swift-container-server_
------------------------

__TODO__: Needs to be filled out

_swift-object-server_
---------------------

__TODO__: Needs to be filled out

_swift-proxy-server_
--------------------

__TODO__: Needs to be filled out


 collectd-server
----------------

Description "Collectd Server"

### run_list
  role[base]
  recipe[collectd-graphite::collectd-server]
)

 collectd-client
----------------

Description "Collectd Client"

### run_list
  role[base]
  recipe[collectd-graphite::collectd-client]
)

 graphite
----------------

Description "graphite and carbon/whisper"

### run_list
  role[base]
  recipe[graphite::graphite]
  recipe[graphite::carbon]
)
