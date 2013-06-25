name "ha-controller2"
description "Nova Controller 2 (non-HA)"
run_list(
  "role[base]",
  "role[mysql-master]",
  "role[rabbitmq-server]",
  "role[memcached]",
  "role[keystone-api]",
  "role[glance-registry]",
  "role[glance-api]",
  "role[nova-scheduler]",
  "role[nova-api-ec2]",
  "role[nova-api-os-compute]",
  "role[cinder-api]",
  "role[cinder-scheduler]",
  "role[nova-cert]",
  "role[nova-vncproxy]",
  "role[horizon-server]",
  "role[openstack-ha]"
)

override_attributes "keepalived" => { "shared_address" => "true" }
