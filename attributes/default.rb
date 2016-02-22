default['mizra']['user'] = 'vagrant'
default['mizra']['app_root'] = "/home/#{node['mizra']['user']}/app"
default['mizra']['env_root'] = "/home/#{node['mizra']['user']}/env"

default['mizra']['db']['name'] = "mizra"
default['mizra']['db']['user'] = "vagrant"
