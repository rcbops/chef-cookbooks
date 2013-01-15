name "nova-network-controller"
description "Setup nova-networking for controller node"
run_list(
  "recipe[nova-network::nova-controller]"
)
