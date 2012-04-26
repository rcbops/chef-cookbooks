name "jenkins-nova-api"
description "Jenkins Nova API"
run_list(
  "role[nova-api]",
)
default_attributes(
  "public" => {
    "bridge_dev" => "eth0.100"
  },
  "private" => {
    "bridge_dev" => "eth0.101"
  }
)

