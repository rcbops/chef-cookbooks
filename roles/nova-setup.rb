name "nova-setup"
description "Where the setup operations for nova get run"
run_list(
  "recipe[nova::nova-setup]"
)
