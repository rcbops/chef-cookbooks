name "nova-cert"
description "Nova Certificate Service"
run_list(
  "role[base]",
  "recipe[nova::nova-cert]",
  "recipe[openstack-monitoring::nova-cert]"
)
