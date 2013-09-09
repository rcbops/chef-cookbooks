name "nova-cert"
description "Nova Certificate Service"
run_list(
  "role[base]",
  "recipe[osops-utils::keepalived-timeouts]",
  "recipe[nova::nova-cert]",
  "recipe[openstack-monitoring::nova-cert]"
)
