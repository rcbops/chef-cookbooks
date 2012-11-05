name "cinder-api"
description "Cinder API Service"
run_list(
  "role[base]",
  "recipe[cinder::cinder-api]"
)
