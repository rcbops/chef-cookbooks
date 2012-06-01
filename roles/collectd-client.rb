name "collectd-client"
description "Collectd client"
run_list(
  "role[base]",
  "recipe[collectd-graphite::collectd-client]"
)

