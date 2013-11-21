name "ceph-mon"
description "Ceph Monitor"
run_list(
        'recipe[ceph::repo]',
        'recipe[ceph::mon]'
)
