name             'rbenv_passenger'
maintainer       'Zen Kyprianou'
maintainer_email 'zen@kyprianou.eu'
license          'MIT'
description      'Installs rbenv and passenger on nginx'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.1'

depends "rbenv"

supports "ubuntu"
supports "centos"
supports "oracle"
