name "ceilometer-central-agent"
description "ceilometer central-agent server"
run_list(
  "role[base]",
  "recipe[ceilometer::ceilometer-central-agent]",
  "recipe[openstack-monitoring::ceilometer-central-agent-service]"
)

