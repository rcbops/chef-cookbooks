name "glance-setup"
description "sets up glance registry db and passwords"
run_list(
  "role[base]",
  "recipe[glance::setup]"
)

