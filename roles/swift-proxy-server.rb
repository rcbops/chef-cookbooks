name "swift-proxy-server"
description "swift proxy server"
run_list(
    "role[base]",
    "recipe[swift::proxy-server]",
    "recipe[openstack-monitoring::swift-proxy-server]"
)

