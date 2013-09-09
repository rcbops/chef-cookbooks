name "nova-api-os-compute"
description "Nova API for Compute"
run_list(
  "role[base]",
  "recipe[osops-utils::keepalived-timeouts]",
  "recipe[nova::api-os-compute]",
  "recipe[openstack-monitoring::nova-api-os-compute]"
)
