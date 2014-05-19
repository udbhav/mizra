name             'mizra'
maintainer       'Udbhav Gupta'
maintainer_email 'dev@udbhavgupta.com'
license          'All rights reserved'
description      'Recipe to provision a Vagrant development machine'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends "apt"
depends "nginx"
depends "python"
depends "postgresql"
depends "nodejs"
depends "ruby_build"
depends "rbenv"
depends "supervisor"
depends "locale"
depends "mongodb"
