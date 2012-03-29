name "ubuntu-base"
description "Base role for an Ubuntu Server"
run_list(
  "recipe[apt]",
  "role[base]"
)
