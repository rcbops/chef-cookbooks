name "nova-network"
description "Install nova-networking services and monitoring hooks"
run_list(
  "recipe[nova-network::network]"
)
