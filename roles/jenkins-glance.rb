name "jenkins-glance"
description "Jenkins Glance server"
run_list(
  "role[base]",
  "recipe[glance]"
)
default_attributes(
  "glance" => {
    "image_upload" => true,
    "images" => ["tty"]
  },
)
