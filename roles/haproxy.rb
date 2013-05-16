name "haproxy"
description "install and configure haproxy load balancer for openstack services"
run_list(
  "role[base]",
  "recipe[haproxy::default]",
  "recipe[openstack-monitoring::haproxy]"
)
