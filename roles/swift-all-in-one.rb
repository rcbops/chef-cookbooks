name "swift-all-in-one"
description "combined storage and proxy server"
run_list(
    "role[base]",
    "role[swift-proxy-server]",
    "role[swift-object-server]",
    "role[swift-container-server]",
    "role[swift-account-server]"
)


