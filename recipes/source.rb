
file = 'go1.1.2.linux-amd64.tar.gz'
tarball_url = 'http://go.googlecode.com/files/' + file
local_tarball = Chef::Config[:file_cache_path]+"/"+ file

remote_file local_tarball do
  source tarball_url
  not_if "test -f #{local_tarball}"
end

execute "unpack_go_tarball" do
  command "tar -zxvf #{local_tarball} -C /opt"
  not_if "test -f /opt/go1.1.2.linux-amd64/Makefile"
end
