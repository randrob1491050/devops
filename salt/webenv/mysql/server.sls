include:
  - mysql
  - mysql.salt_local_module

mysql-server:
  pkg:
    - installed
  service:
    - name: mysql
    - running
