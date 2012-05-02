name "jenkins-mysql-master"
description "This inherits from role[mysql-master], and sets default attributes required for to run this role via jenkins"
run_list(
  "role[mysql-master]"
)
default_attributes(
  "mysql" => {
    "allow_remote_root" => true,
    "root_network_acl" => "%"
  }
)
