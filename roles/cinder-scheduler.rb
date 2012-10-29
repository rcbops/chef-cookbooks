name "cinder-scheduler"
description "Cinder scheduler Service"
run_list(
  "role[base]",
  "recipe[cinder::cinder-scheduler]"
)
