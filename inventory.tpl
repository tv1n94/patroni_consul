[iscsi]
${ip[0]} ansible_name=iscsi local_ip=192.168.2.10

[node1]
${ip[1]} ansible_name=node1 local_ip=192.168.2.11 state=MASTER keep_priority=100

[node2]
${ip[2]} ansible_name=node2 local_ip=192.168.2.12 state=BACKUP keep_priority=101

[db1]
${ip[3]} ansible_name=db1 local_ip=192.168.2.13

[db2]
${ip[4]} ansible_name=db2 local_ip=192.168.2.14

[proxy]
${ip[5]} ansible_name=proxy local_ip=192.168.2.15