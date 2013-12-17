name "ceilometer-api"
description "ceilometer API server"
run_list(
  "role[base]",
  "recipe[ceilometer::ceilometer-api]",
  "recipe[openstack-monitoring::ceilometer-api]"
)

