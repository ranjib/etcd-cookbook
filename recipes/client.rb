chef_gem "etcd"
include_recipe "etcd"

case node['platform_family']
when 'rel'
  initd_template = 'etcd_chef_agent_init_rel.erb'
when 'debian'
  initd_template = 'etcd_chef_agent_init_debian.erb'
else
  raise "Unsupported platform family"
end

template '/etc/chef/chef_etcd_agent.rb' do
  variables(:port=> 4001, :ipaddress=> '127.0.0.1', :read_only=> false)
end

template "/etc/init.d/chef_etcd_agent" do
  source initd_template
end

service "chef_etcd_agent" do
  action [:start, :enable]
end
