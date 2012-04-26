name "jenkins-controller"
description "This inherits from role[single-controller], and sets default attributes required for to run this role via jenkins"
run_list(
  "role[single-controller]"
)
default_attributes(
  "mysql" => {
    "allow_remote_root" => true,
    "root_network_acl" => "%"
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
