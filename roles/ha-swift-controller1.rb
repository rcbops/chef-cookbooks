name "ha-swift-controller1"
description "swift controller 1 (HA)"
run_list(
  "role[base]",
  "role[mysql-master]",
  "role[keystone]",
  "role[swift-management-server]",
  "role[swift-setup]",
  "role[swift-proxy-server]",
  "role[openstack-ha]"
)

override_attributes "keepalived" => { "shared_address" => "true" }
override_attributes "ha" => { "swift-only" => true }
