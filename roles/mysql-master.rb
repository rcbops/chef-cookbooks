name "mysql-master"
description "MySQL Server (non-ha)"
run_list(
  "role[base]",
  "recipe[nova::nova-db]"
)
