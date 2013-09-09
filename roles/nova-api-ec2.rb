name "nova-api-ec2"
description "Nova API EC2"
run_list(
  "role[base]",
  "recipe[osops-utils::keepalived-timeouts]",
  "recipe[nova::api-ec2]",
  "recipe[openstack-monitoring::nova-api-ec2]"
)
