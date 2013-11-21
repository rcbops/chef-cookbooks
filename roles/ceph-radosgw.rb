name "ceph-radosgw"
description "Ceph RADOS Gateway"
run_list(
        'role[base]',
        'recipe[ceph::repo]',
        'recipe[ceph::radosgw]'
)
