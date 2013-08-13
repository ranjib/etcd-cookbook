
current_dir = ::File.dirname(__FILE__)
require "#{current_dir}/libraries/recipe_helper"

name             'etcd'
maintainer       'Ranjib Dey'
maintainer_email 'dey.ranjib@gmail.com'
license          'All rights reserved'
description      'Installs/Configures etcd'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          Etcd::Recipe::VERSION
