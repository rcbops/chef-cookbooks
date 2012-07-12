name "rsyslog-client"
description "rsyslog-client config"
run_list(
  "role[base]",
  "recipe[rsyslog::client]"
)
default_attributes(
  "rsyslog" => {
    "server_search" => "role:rsyslog-server",
  }
)
