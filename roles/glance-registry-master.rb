name "glance-registry-master"
description "Glance Registry master server"
run_list(
  "role[base]",
  "recipe[glance::registry-master]"
)

