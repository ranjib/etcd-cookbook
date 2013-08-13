
web_servers = search(:node, "role:web")

half = web_servers.size / 2

blues = web_servers[0..(half - 1)]
greens = web_servers[half..-1)]

with 'load_balancer'  do

  template  '/etc/foo/bar' do
    source "something"
    variables(:servers=>greens)
    notifies :restart, "service[httpd]"
  end
end

with blues do
  execute "git pull --rebase"
end
