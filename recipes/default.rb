ENV['LANGUAGE'] = ENV['LANG'] = ENV['LC_ALL'] = "en_US.UTF-8"
# trust anything
node.default['postgresql']['pg_hba'] = [{
  :type => 'host', :db => 'all', :user => 'all', :addr => '127.0.0.1/32', :method => 'trust'}]
# node.default['postgresql']['version'] = "9.4"
node.default['postgresql']['version'] = "9.4"
node.default['postgresql']['dir'] = "/etc/postgresql/9.4/main"
node.default['postgresql']['server']['service_name'] = "postgresql"
node.default['postgresql']['client']['packages'] = ["postgresql-client-9.4","libpq-dev"]
node.default['postgresql']['server']['packages'] = ["postgresql-9.4"]
node.default['postgresql']['contrib']['packages'] = ["postgresql-contrib-9.4"]
include_recipe "postgresql::server"

service "postgresql" do
  action :restart
end

include_recipe "locale"
include_recipe "python"
include_recipe "nodejs"

# virtualenv
python_virtualenv "#{node['mizra']['env_root']}" do
  action :create
  owner node['mizra']['user']
end

# required packages
packages = [
  'libjpeg-dev', 'libfreetype6', 'libfreetype6-dev', 'zlib1g-dev', 'libxml2-dev',
  'libxslt-dev', 'apache2-utils', 'libffi-dev', 'lzop', 'pv', 'daemontools',
  'libmemcached-dev', 'libssl-dev', 'build-essential']

packages.each do |pkg|
  package pkg do
    action :install
  end
end

# python requirements
execute "python_requirements" do
  command "#{node['mizra']['env_root']}/bin/pip install -r requirements.txt"
  cwd node['mizra']['app_root']
  user node['mizra']['user']
end

# create db role and db if they don't exist
db_user = node['mizra']['db']['user']
db_name = node['mizra']['db']['name']

execute "create_db_role" do
  command "psql -tAc \"SELECT 1 FROM pg_roles WHERE rolname='#{db_user}'\" | grep -q 1 || createuser -SDR #{db_user}"
  user "postgres"
end

execute "create_db" do
  command "psql -lqt | cut -d \\| -f 1 | grep -wq #{db_name} || createdb -O #{db_user} #{db_name}"
  user "postgres"
end

# add ability to create dbs to db_user
execute "alter_db_user" do
  command "psql -c 'ALTER USER #{node['mizra']['db']['user']} CREATEDB'"
  user "postgres"
end

# migrations
execute "migrate" do
  command "#{node['mizra']['env_root']}/bin/python src/manage.py migrate"
  cwd node['mizra']['app_root']
  user node['mizra']['user']
end
