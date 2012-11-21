name "cinder-setup"
description "Where the setup operations for cinder get run"
run_list(
  "recipe[cinder::cinder-setup]"
)
