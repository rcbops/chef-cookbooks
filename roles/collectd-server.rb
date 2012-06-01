name "collectd-server"
description "Collectd Server"
run_list(
  "role[base]",
  "recipe[collectd-graphite::collectd-listener]"
)

