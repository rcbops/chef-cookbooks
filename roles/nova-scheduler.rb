name "nova-scheduler"
description "Nova scheduler"
run_list(
  "role[base]",
  "recipe[nova::scheduler]",
  "recipe[openstack-monitoring::nova-scheduler]"
)
