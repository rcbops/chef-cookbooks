name "jenkins-nova-api"
description "Jenkins Nova API"
run_list(
  "role[base]",
  "recipe[nova::nova-setup]",
  "recipe[nova::api-ec2]",
  "recipe[nova::api-os-compute]"
)
default_attributes(
  "public" => {
    "bridge_dev" => "eth0.100"
  },
  "private" => {
    "bridge_dev" => "eth0.101"
  }
)

