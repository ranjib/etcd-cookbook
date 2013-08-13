#
# Cookbook Name:: etcd
# Recipe:: default
#
# Copyright 2013, Ranjib Dey
#
#

include_recipe 'etcd'

etcd_dir = node["etcd"]["install_path"]
etcd_data_dir = node["etcd"]["install_path"] + "/data"

case node['platform_family']
when 'rhel'
  config_file = '/etc/sysconfig/etcd'
  initd_template = 'etcd_init_rhel.erb'
  include_recipe "etcd::source"
when 'debian'
  package "golang"
  config_file = '/etc/default/etcd'
  initd_template = 'etcd_init_debian.erb'
else
  raise "Unsupported platform family"
end


directory etcd_dir

execute "download_etcd_source" do
  cwd node["etcd"]["install_path"]
  command "git clone  https://github.com/coreos/etcd ."
  not_if "test -f /tmp/foo"
end

execute "build_etcd_binary" do
  cwd node["etcd"]["install_path"]
  environment( 'PATH'=>"/opt/go/bin:#{ENV['PATH']}")
  command "bash -c ./build"
  not_if "test -f /tmp/foo"
end

template config_file do
  variables(:port=> 4001, :ipaddress=> '127.0.0.1', :data_dir=>etcd_data_dir)
  source 'etcd.conf.erb'
end

template "/etc/init.d/etcd" do
  source initd_template
end

service "etcd" do
  action [:start, :enable]
end
