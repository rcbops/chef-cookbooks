name "nova-api"
description "Nova API"
run_list(
  "role[base]",
  "recipe[nova::api-ec2]",
  "recipe[nova::api-os-compute]"
)
