name "single-controller"
description "Nova Controller (non-HA)"
run_list(
  "role[base]",
  "recipe[mysql::server]",
)

