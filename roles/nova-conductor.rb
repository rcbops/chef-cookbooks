name "nova-conductor"
description "Nova Conductor"
run_list(
  "role[base]",
  "recipe[nova::nova-conductor]"
)
