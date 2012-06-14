name "ha-controller"
description "Nova Controller (non-HA)"
run_list(
  "role[base]",
  "recipe[rabbitmq]",
  "recipe[keystone::server]",
  "recipe[glance]",
  "role[nova-setup]",
  "recipe[nova::scheduler]",
  "recipe[nova::api-ec2]",
  "recipe[nova::api-metadata]",
  "recipe[nova::api-os-compute]",
  "recipe[nova::api-os-volume]",
  "recipe[nova::volume]",
  "recipe[horizon::server]"
)
