name "swift-object-server"
description "swift object server"
run_list(
    "role[base]",
    "recipe[swift::object-server]"
)


