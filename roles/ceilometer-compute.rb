name "ceilometer-compute"
description "ceilometer compute agent"
run_list(
  "role[base]",
  "recipe[ceilometer::ceilometer-compute]"
)

