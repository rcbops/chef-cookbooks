name "glance-api"
description "Glance API server"
run_list(
  "role[base]",
  "recipe[osops-utils::keepalived-timeouts]",
  "recipe[glance::api]",
  "recipe[openstack-monitoring::glance-api]"
)

