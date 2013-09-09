name "nova-scheduler"
description "Nova scheduler"
run_list(
  "role[base]",
  "recipe[osops-utils::keepalived-timeouts]",
  "recipe[nova::scheduler]",
  "recipe[openstack-monitoring::nova-scheduler]"
)
