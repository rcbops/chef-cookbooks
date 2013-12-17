name "ceilometer-collector"
description "ceilometer collector server"
run_list(
  "role[base]",
  "recipe[ceilometer::ceilometer-collector]",
  "recipe[openstack-monitoring::ceilometer-collector]"
)

