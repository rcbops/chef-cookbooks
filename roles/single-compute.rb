name "single-compute"
description "Nova compute (with non-HA Controller)"
run_list(
  "role[base]",
  "recipe[osops-utils::keepalived-timeouts]",
  "recipe[osops-utils::centos-amqplib-keepalive-patch]",
  "role[rsyslog-client]",
  "role[nova-network-compute]",
  "recipe[nova::compute]",
  "recipe[openstack-monitoring::nova-compute]",
  "role[openstack-logging]",
  "role[ceilometer-compute]"
)
