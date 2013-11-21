name "ceph-osd"
description "Ceph Object Storage Device"
run_list(
        'role[base]',
        'recipe[ceph::repo]',
        'recipe[ceph::osd]'
)
