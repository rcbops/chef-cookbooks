name "cinder-volume"
description "Cinder Volume Service"
run_list(
  "role[base]",
  "recipe[cinder::cinder-volume]",
  "recipe[openstack-monitoring::cinder-volume]"
)
