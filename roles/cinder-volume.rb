name "cinder-volume"
description "Cinder Volume Service"
run_list(
  "role[base]",
  "role[cinder-scheduler]",
  "recipe[cinder::cinder-volume]",
  "recipe[openstack-monitoring::cinder-volume]"
)
