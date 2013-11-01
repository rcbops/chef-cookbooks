name "quantum-setup"
description "Where the setup operations for quantum get run"
run_list(
      "recipe[nova-network::quantum-setup]"
)
