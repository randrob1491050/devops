#!/bin/sh

mkdir -p /root/.ssh
cat >> /root/.ssh/authorized_keys<<\EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCpih3nFxfFfjfS01y3cFbKQH8wNNHo2uuIrLzO658G39JqYXvvsUt/8uPMhK7aYHqtOhupDbV6H4Ujwp0D+EtlUNHewFkkE40uuaGdB8Pl2SZ6x5iJOl0YHfVGB47YaWCJmR+Jx+DOygFZd7HpFOLC7z3QN81hiFXZlxq2RBuNHyjCB7GXAvt3QUs/59AyrjaRuroKYSBX71GOE2LbGCHBNsVEZ+Ya9oZvsN/J+ia2nxnPy9VeQfqaE2zuKvgM/ky588lcFuR3FLN9g/KP/oiSUaZZfB8EY9jphCGjEtxYFzLPZ5fJmj3d+LA0u4CO0ieFZf6CanCC+YKIq0T8IxE3 vagrant@desktop
EOF

chmod 600 /root/.ssh/authorized_keys
