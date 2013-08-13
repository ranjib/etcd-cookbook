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

tarball_name = 'etcd-v0.1.0-Linux.tar.gz'
local_tarball = Chef::Config[:file_cache_path] + "/" + tarball_name
tarball_url = "https://github.com/coreos/etcd/releases/download/v0.1.0/" + tarball_name

remote_file local_tarball do
  source tarball_url
  not_if "test -f #{local_tarball}"
end

execute "install_etcd_binary" do
  command "tar -zvxf #{local_tarball} -C #{etcd_dir}"
  not_if "test -f #{etcd_dir}/bin/etcd"
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
