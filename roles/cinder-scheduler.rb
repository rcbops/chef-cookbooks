name "cinder-scheduler"
description "Cinder scheduler Service"
run_list(
  "role[base]",
  "recipe[cinder::cinder-scheduler]",
  "recipe[openstack-monitoring::cinder-scheduler]"
)
