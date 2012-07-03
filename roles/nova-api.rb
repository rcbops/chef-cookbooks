name "nova-api"
description "Nova API"
run_list(
  "role[base]",
  "role[nova-api-ec2]",
  "role[nova-api-os-compute]"
)
