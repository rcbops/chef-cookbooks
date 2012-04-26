name "jenkins-compute"
description "This inherits from role[single-compute], and sets default attributes required for to run this role via jenkins"
run_list(
  "role[single-compute]"
)
default_attributes(
  "mysql" => {
    "allow_remote_root" => true
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
