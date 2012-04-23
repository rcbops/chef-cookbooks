name "nova-scheduler"
description "Nova scheduler"
run_list(
  "role[base]",
  "recipe[nova::nova-setup]",
  "recipe[nova::scheduler]"
)

