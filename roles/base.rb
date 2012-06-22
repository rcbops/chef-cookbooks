name "base"
description "Base role for a server"
run_list(
  "recipe[openssh]",
  "recipe[ntp]",
  "recipe[rsyslog::default]"
)
default_attributes(
  "ntp" => {
    "servers" => ["0.pool.ntp.org", "1.pool.ntp.org", "2.pool.ntp.org"]
  }
)
