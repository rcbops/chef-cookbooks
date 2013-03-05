name "openstack-ha"
description "installs keepalived, and configures vrrp and virtual_servers."
run_list(
  "role[base]",
  "recipe[openstack-ha::default]"
)

override_attributes "keepalived" => { "shared_address" => "true" }
