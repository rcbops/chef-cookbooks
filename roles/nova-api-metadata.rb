name "nova-api-metadata"
description "Nova API for Openstack Metadata"
run_list(
  "role[base]",
  "recipe[osops-utils::keepalived-timeouts]",
  "recipe[nova::api-metadata]",
  "recipe[openstack-monitoring::nova-api-metadata]"
)
