name "heat-api-cfn"
description "heat Cloudformation api"
run_list(
  "role[base]",
  "recipe[heat::heat-api-cfn]",
  "recipe[openstack-monitoring::heat-api-cfn]"
)



