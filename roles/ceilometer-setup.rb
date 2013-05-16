name "ceilometer-setup"
description "ceilometer setup activities "
run_list(
  "role[base]",
  "recipe[ceilometer::ceilometer-setup]"
)

