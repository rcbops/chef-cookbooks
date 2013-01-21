name "glance-registry-client"
description "Glance Registry client"
run_list(
  "role[base]",
  "recipe[glance::registry-client]"
)

