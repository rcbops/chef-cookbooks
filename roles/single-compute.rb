name "single-compute"
description "Nova compute (with non-HA Controller)"
run_list(
  "role[base]",
  "recipe[nova-network::network]",
  "recipe[nova::compute]"
)

