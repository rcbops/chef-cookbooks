name "base"
description "Base role for a server"
run_list(
  "recipe[osops-utils::packages]",
  "recipe[osops-utils::vhost_net]",
  "recipe[openssh]",
  "recipe[ntp]",
  "recipe[sosreport]",
  "recipe[rsyslog::default]",
  "recipe[hardware]",
  "recipe[osops-utils::default]"
)
default_attributes(
  "ntp" => {
    "servers" => ["0.pool.ntp.org", "1.pool.ntp.org", "2.pool.ntp.org"]
  }
)
