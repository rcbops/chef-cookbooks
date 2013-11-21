name "ceph-mon"
description "Ceph Monitor"
run_list(
        'role[base]',
        'recipe[ceph::repo]',
        'recipe[ceph::mon]'
)
