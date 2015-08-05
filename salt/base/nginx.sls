/usr/local/nginx/conf/nginx.conf:
  file:
    - managed
    - source: salt://nginx.conf
    - user: root
    - group: root
    - mode: 644
    - backup: minion
