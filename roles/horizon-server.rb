name "horizon-server"
description "Horizon server"
run_list(
  "role[base]",
  "recipe[osops-utils::keepalived-timeouts]",
  "recipe[mysql::client]",
  "recipe[mysql::ruby]",
  "recipe[horizon::server]"
)
