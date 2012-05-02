name "jenkins-glance"
description "Jenkins Glance server"
run_list(
  "role[base]",
  "role[glance-registry]",
  "role[glance-api]"
)
default_attributes(
  "glance" => {
    "image_upload" => true,
    "images" => ["tty"]
  }
)
