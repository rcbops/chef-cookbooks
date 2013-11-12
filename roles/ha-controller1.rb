name "ha-controller1"
description "Nova Controller 1 (HA)"
run_list(
  "role[base]",
  "recipe[osops-utils::keepalived-timeouts]",
  "role[rsyslog-server]",
  "role[mysql-master]",
  "role[rabbitmq-server]",
  "role[memcached]",
  "role[keystone-setup]",
  "role[keystone-api]",
  "role[glance-setup]",
  "role[glance-registry]",
  "role[glance-api]",
  "recipe[glance::replicator]",
  "role[nova-setup]",
  "role[nova-network-controller]",
  "role[nova-scheduler]",
  "role[nova-conductor]",
  "role[nova-api-ec2]",
  "role[nova-api-os-compute]",
  "role[cinder-setup]",
  "role[cinder-api]",
  "role[cinder-scheduler]",
  "role[nova-cert]",
  "role[nova-vncproxy]",
  "role[horizon-server]",
  "role[openstack-ha]",
  "role[openstack-logging]",
  "role[ceilometer-setup]",
  "role[ceilometer-api]",
  "role[ceilometer-collector]",
  "role[ceilometer-central-agent]"
)

override_attributes "keepalived" => { "shared_address" => "true" }
