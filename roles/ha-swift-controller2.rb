name "ha-swift-controller2"
description "swift controller 2 (HA)"
run_list(
  "role[base]",
  "role[mysql-master]",
  "role[keystone-api]",
  "role[swift-proxy-server]",
  "role[openstack-ha]"
)

override_attributes "keepalived" => { "shared_address" => "true" }
override_attributes "ha" => { "swift-only" => true }
