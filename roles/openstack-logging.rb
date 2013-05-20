name "openstack-logging"
description "configure OpenStack logging to a single source"
run_list(
  "role[base]",
  "recipe[openstack_logging::default]"
)
