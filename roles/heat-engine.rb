name "heat-engine"
description "heat engine"
run_list(
  "role[base]",
  "recipe[heat::heat-engine]",
  "recipe[openstack-monitoring::heat-engine]"
)
