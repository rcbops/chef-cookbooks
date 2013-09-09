name "keystone-api"
description "Keystone API"
run_list(
  "role[base]",
  "recipe[osops-utils::keepalived-timeouts]",
  "recipe[keystone::keystone-api]",
  "recipe[openstack-monitoring::keystone]"
)

