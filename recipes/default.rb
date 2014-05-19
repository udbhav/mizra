include_recipe "apt"
include_recipe "locale"
include_recipe "nginx"
include_recipe "python"

ENV['LANGUAGE'] = ENV['LANG'] = ENV['LC_ALL'] = "en_US.UTF-8"
node.default['postgresql']['pg_hba'].unshift({
  :type => 'host', :db => 'all', :user => 'all', :addr => '127.0.0.1/32', :method => 'trust'})

include_recipe "postgresql::server"

include_recipe "nodejs::install_from_package"
include_recipe "supervisor"
include_recipe "ruby_build"
include_recipe "rbenv::user"

# packages
packages = [
  'libjpeg-dev', 'libfreetype6', 'libfreetype6-dev', 'zlib1g-dev', 'memcached',
  'imagemagick', 'redis-server']

packages.each do |pkg|
  package pkg
end

# rbenv and bundler
execute "rbenv-bundler" do
  path = node['ghalib']['home'] + '/.rbenv/plugins/bundler'
  git_url = "git://github.com/carsomyr/rbenv-bundler.git"
  # if dir doesn't exist
  command "[ -d #{path} ] || git clone #{git_url} #{path}"
  user "vagrant"
end

# mongodb
include_recipe "mongodb::10gen_repo"
include_recipe "mongodb::default"
