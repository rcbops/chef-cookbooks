name "glance-registry"
description "Glance Registry server"
run_list(
  "role[base]",
  "recipe[osops-utils::keepalived-timeouts]",
  "recipe[glance::registry]",
  "recipe[openstack-monitoring::glance-registry]"
)

