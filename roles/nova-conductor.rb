name "nova-conductor"
description "Nova Conductor"
run_list(
  "role[base]",
  "recipe[osops-utils::keepalived-timeouts]",
  "recipe[osops-utils::centos-amqplib-keepalive-patch]",
  "recipe[nova::nova-conductor]",
  "recipe[openstack-monitoring::nova-conductor]"
)
