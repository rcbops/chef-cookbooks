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

__TODO__: Needs to be filled out

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

### override_attributes

_glance-api_
---------------

__TODO__: Needs to be filled out

_glance-registry_
--------------------

__TODO__: Needs to be filled out

_glance_
--------

__TODO__: Needs to be filled out

_ha-controller_
---------------

__TODO__: Needs to be filled out

_horizon-server_
----------------

__TODO__: Needs to be filled out

_jenkins-allinone_
------------------

Description: this inherits from role[allinone], sets default attributes required by our jenkins jobs.

### run_list

    "role[allinone]"

### default_attributes

    "mysql" => {
      "allow_remote_root" => true
    },
    "glance" => {
      "image_upload" => true,
      "images" => ["tty"]
    },
    "package_component" => "essex-final",
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

    "role[single-compute]"

### default_attributes

    "mysql" => {
      "allow_remote_root" => true
    },
    "package_component" => "essex-final",
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

    "role[single-controller]"

### default_attributes

    "mysql" => {
      "allow_remote_root" => true,
      "root_network_acl" => "%"
    },
    "glance" => {
      "image_upload" => true,
      "images" => ["tty"]
    },
    "package_component" => "essex-final",
    "public" => {
      "bridge_dev" => "eth0.100"
    },
    "private" => {
      "bridge_dev" => "eth0.101"
    },
    "virt_type" => "qemu"

_keystone_
----------

__TODO__: Rename to keystone-server
__TODO__: Needs to be filled out

_mysql-master_
--------------

__TODO__: Needs to be filled out

_nova-api-ec2_
--------------

__TODO__: Needs to be filled out

_nova-api-os-compute_
---------------------

__TODO__: Needs to be filled out

_nova-api_
----------

__TODO__: Needs to be filled out

_nova-misc-services_
--------------------

__TODO__: Needs to be filled out

_nova-scheduler_
----------------

__TODO__: Needs to be filled out

_nova-vncproxy_
---------------

__TODO__: Needs to be filled out

_nova-volume_
-------------

__TODO__: Needs to be filled out

_rabbitmq-server_
-----------------

__TODO__: Needs to be filled out

_single-compute_
----------------

__TODO__: Needs to be filled out

_single-controller_
-------------------

__TODO__: Needs to be filled out

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

