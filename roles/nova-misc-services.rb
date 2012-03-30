name "misc-services"
description "Nova Controller (non-HA)"
run_list(
  "role[base]",
  "recipe[nova::nova-setup]",
  "recipe[nova::volume]",
  "recipe[horizon::server]"
)

