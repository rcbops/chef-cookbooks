name "single-controller-usage"
description ""
run_list(
  "role[single-controller]",
  "role[ceilometer-setup]",
  "role[ceilometer-api]",
  "role[ceilometer-central-agent]",
  "role[ceilometer-collector]"
)
