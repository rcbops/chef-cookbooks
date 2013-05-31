name "single-compute"
description "Nova compute (with non-HA Controller)"
run_list(
  "role[base]",
  "role[rsyslog-client]",
  "role[nova-network-compute]",
  "recipe[nova::compute]",
         "recipe[openstack-monitoring::nova-compute]",
  "role[openstack-logging]"
)
