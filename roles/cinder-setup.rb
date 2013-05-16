name "cinder-setup"
description "Where the setup operations for cinder get run"
run_list(
  "role[base]",
  "recipe[cinder::cinder-setup]",
  "recipe[openstack-monitoring::cinder-setup]"
)
