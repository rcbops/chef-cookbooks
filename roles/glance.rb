name "glance"
description "Glance server"
run_list(
  "role[base]",
  "role[glance-setup]",
  "role[glance-registry]",
  "role[glance-api]"
)

