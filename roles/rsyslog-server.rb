name "rsyslog-server"
description "rsyslog-server config"
run_list(
  "role[base]",
  "recipe[rsyslog::server]",
  "recipe[rsyslog::openstack]"
)
default_attributes(
  "rsyslog" => {
    "server" => "true",
    "server_search" => "role:rsyslog-server",
    "per_host_dir" => "%HOSTNAME%",
    "log_dir" => "/var/log/rsyslog"
  }
)
