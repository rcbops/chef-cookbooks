name "haproxy"
description "Where the setup operations for cinder get run"
run_list(
  "role[base]",
  "recipe[oshaproxy::default]"
)
