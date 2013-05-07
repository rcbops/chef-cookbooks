name "keystone"
description "Keystone server"
run_list(
  "role[base]",
  "role[keystone-setup]",
  "role[keystone-api]"
)

