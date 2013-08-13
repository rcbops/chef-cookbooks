name "rsyslog-server"
description "rsyslog-server config"
run_list(
  "role[base]",
  "recipe[rsyslog::server]"
)

default_attributes(
  "rsyslog" => {
    "server" => "true",
    "server_search" => "roles:rsyslog-server",
    "per_host_dir" => "%HOSTNAME%",
    "log_dir" => "/var/log/rsyslog",
    "priv_seperation" => false,
    "preserve_fqdn" => "on"
  }
)
