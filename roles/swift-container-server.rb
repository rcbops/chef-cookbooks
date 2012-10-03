name "swift-container-server"
description "swift container server"
run_list(
    "role[base]",
    "recipe[swift::container-server]"
)


