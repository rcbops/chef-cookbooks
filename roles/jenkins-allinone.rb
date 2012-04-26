name "jenkins-allinone"
description "This inherits from role[allinone], and sets default attributes required for to run this role via jenkins"
run_list(
  "role[allinone]"
)
default_attributes(
  "mysql" => {
    "allow_remote_root" => true
  },
  "glance" => {
    "image_upload" => true,
    "images" => ["tty"]
  },
  "package_component" => "essex-final",
  "nova" => {
    "libvirt" => { "virt_type" => "qemu" },
    "network" => {
      "public" => { "bridge_dev" => "eth0.100" },
      "private" => { "bridge_dev" => "eth0.101" },
    }
  }
)
