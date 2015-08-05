python-pip: 
  pkg.installed 

python-devel:
  pkg.installed

glances:
  pip.installed:
    - require:
      - pkg: python-pip
