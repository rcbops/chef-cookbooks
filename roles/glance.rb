name "glance"
description "Glance server"
run_list(
  "role[base]",
  "recipe[glance]"
)

