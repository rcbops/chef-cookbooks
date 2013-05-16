name "keystone-api"
description "Keystone API"
run_list(
  "role[base]",
  "recipe[keystone::keystone-api]",
  "recipe[openstack-monitoring::keystone]"
)

