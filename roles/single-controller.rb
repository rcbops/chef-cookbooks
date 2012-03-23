name "single-controller"
description "Nova Controller (non-HA)"
run_list(
  "role[base]",
  "recipe[mysql::server]",
  "recipe[rabbitmq]",
  "recipe[keystone::server]",
  "recipe[glance]",
  "recipe[nova::nova-setup]",
  "recipe[nova::scheduler]",
  "recipe[nova::api-ec2]",
  "recipe[nova::api-os-compute]",
  "recipe[nova::volume]",
  "recipe[horizon::server]"
)

