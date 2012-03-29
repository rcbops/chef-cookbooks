name "horizon-server"
description "Horizon server"
run_list(
  "role[base]",
  "recipe[horizon::server]"
)
