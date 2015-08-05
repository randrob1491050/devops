salt-master:
  ssh_auth:
    - present
    - user: root
    - source: salt://common/files/salt-master.id_rsa.pub
