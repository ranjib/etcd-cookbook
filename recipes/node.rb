#
# Cookbook Name:: etcd
# Recipe:: default
#
# Copyright 2013, Ranjib Dey
#
#

etcd_dir = node["etcd"]["install_path"]
etcd_data_dir = node["etcd"]["install_path"] + "/data"


package "golang"

directory etcd_dir

execute "download_etcd_source" do
  cwd node["etcd"]["install_path"]
  environment( :gopath=> etcd_dir)
  command "go get github.com/coreos/etcd"
  not_if "test -f"
end

execute "build_etcd_binary" do
  cwd node["etcd"]["install_path"]
  environment( :gopath=> etcd_dir)
  command "go install github.com/coreos/etcd"
  not_if "test -f"
end

case node['platform_family']
when 'rel'
  config_file = '/etc/sysconfig/etcd'
  initd_template = 'etcd_init_rel.erb'
when 'debian'
  config_file = '/etc/default/etcd'
  initd_template = 'etcd_init_debian.erb'
else
  raise "Unsupported platform family"
end

template config_file do
  variables(:port=> 4001, :ipaddress=> '127.0.0.1', :data_dir=>etcd_data_dir)
end

template "/etc/init.d/etcd" do
  source initd_template
end

service "etcd" do
  action [:start, :enable]
end
