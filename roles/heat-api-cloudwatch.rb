name "heat-api-cloudwatch"
description "heat cloudwatch api"
run_list(
  "role[base]",
  "recipe[heat::heat-api-cloudwatch]",
  "recipe[openstack-monitoring::heat-api-cloudwatch]"
)


