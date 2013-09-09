name "nova-vncproxy"
description "Nova VNC Proxy"
run_list(
  "role[base]",
  "recipe[osops-utils::keepalived-timeouts]",
  "recipe[nova::vncproxy]",
  "recipe[openstack-monitoring::nova-vncproxy]"
)

