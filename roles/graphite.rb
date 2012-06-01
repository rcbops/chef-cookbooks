name "graphite"
description "Graphite server and carbon/whisper"
run_list(
  "role[base]",
  "recipe[graphite::graphite]",
  "recipe[graphite::carbon]"
)

