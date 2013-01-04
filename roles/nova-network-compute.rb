name "nova-network-compute"
description "Setup nova-networking for compute"
run_list(
  "recipe[nova-network::nova-compute]"
)
