name             'bakebox'
maintainer       'Zen Kyprianou'
maintainer_email 'zen@kyprianou.eu'
license          'MIT'
description      'Installs rbenv and passenger on nginx'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.0.2'

depends "nginx"
depends "rbenv"

supports "ubuntu"
supports "centos"
supports "oracle"
