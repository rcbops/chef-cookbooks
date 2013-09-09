name "single-compute-usage"
description ""
run_list(
  "role[base]",
  "recipe[osops-utils::keepalived-timeouts]",
  "role[rsyslog-client]",
  "role[nova-network-compute]",
  "role[single-compute]",
  "role[ceilometer-compute]",
  "recipe[openstack-monitoring::nova-compute]",
  "role[openstack-logging]"
)
