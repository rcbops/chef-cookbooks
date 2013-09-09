name "nova-network-controller"
description "Setup nova-networking for controller node"
run_list(
  "recipe[osops-utils::keepalived-timeouts]",
  "recipe[nova-network::nova-controller]",
  "recipe[openstack-monitoring::nova-network]"
)
