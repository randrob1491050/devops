ntp-package:
  pkg:
    - name: ntp
    - installed

ntp-service:
  service:
    - name: ntp
    - running
    - enable: True
    - require:
      - pkg: ntp-package
