name "keystone-setup"
description "Sets up the keystone db and passwords"
run_list(
  "role[base]",
  "recipe[keystone::setup]"
)

