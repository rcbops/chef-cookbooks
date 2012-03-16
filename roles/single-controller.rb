name "single-controller"
description "Nova Controller (non-HA)"
run_list(
  "role[base]",
  "recipe[mysql::server]",
  "recipe[rabbitmq]",
  "recipe[keystone::server]",
  "recipe[glance]",
  "recipe[openstack::nova-setup]",
  "recipe[openstack::scheduler]",
  "recipe[openstack::api]",
  "recipe[horizon::server]"
)

