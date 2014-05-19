name             'ghalib'
maintainer       'YOUR_NAME'
maintainer_email 'YOUR_EMAIL'
license          'All rights reserved'
description      'Installs/Configures ghalib'
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
