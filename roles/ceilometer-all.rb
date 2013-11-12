name "ceilometer-all"
description "Ceilometer Services"
run_list(
  "role[ceilometer-api]",
  "role[ceilometer-central-agent]",
  "role[ceilometer-collector]",
  "role[ceilometer-compute]",
  "role[ceilometer-setup]"
)

