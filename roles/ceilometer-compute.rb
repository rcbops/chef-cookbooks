name "ceilometer-compute"
description "ceilometer compute agent"
run_list(
  "role[base]",
  "recipe[ceilometer::ceilometer-compute]",
  "recipe[openstack-monitoring::ceilometer-agent-compute]"
)

