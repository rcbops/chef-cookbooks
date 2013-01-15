name "nova-network-setup"
description "Where the setup operations for nova's networking get run"
run_list(
  "recipe[nova-network::nova-setup]"
)
