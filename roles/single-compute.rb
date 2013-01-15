name "single-compute"
description "Nova compute (with non-HA Controller)"
run_list(
  "role[base]",
  "role[nova-network-compute]",
  "recipe[nova::compute]"
)

