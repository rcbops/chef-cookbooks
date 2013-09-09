name "nova-conductor"
description "Nova Conductor"
run_list(
  "role[base]",
  "recipe[osops-utils::keepalived-timeouts]",
  "recipe[nova::nova-conductor]",
  "recipe[openstack-monitoring::nova-conductor]"
)
