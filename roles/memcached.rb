name "memcached"
description "Memcached server"
run_list(
  "role[base]",
  "recipe[memcached-openstack::default]"
)
