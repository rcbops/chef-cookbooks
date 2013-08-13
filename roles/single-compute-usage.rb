name "single-compute-usage"
description ""
run_list(
  "role[single-compute]",
  "role[ceilometer-compute]"
)
