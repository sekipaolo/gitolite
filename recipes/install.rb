#########################################
# GIT SERVER: Gitolite
#########################################

group node[:gitolite][:group]
user node[:gitolite][:user] do
  home node[:gitolite][:home]
  group node[:gitolite][:group]
  shell "/bin/bash"
  manage_home true  
end

sshenv node[:gitolite][:user] do
  home node[:gitolite][:home]
  group node[:gitolite][:group]
  key_name node['gitolite']['user']
  known_hosts ['localhost']
end

package "git"
package "mc"

git "#{node['gitolite']['home']}/gitolite-source" do
  user node['gitolite']['user']
  group node['gitolite']['group']
  repository 'https://github.com/sitaramc/gitolite.git'
  action :sync
end

bash 'install gitolite' do
  cwd "#{node['gitolite']['home']}/gitolite-source"
  code <<-EOH
    mkdir -p #{node[:gitolite][:home]}/server
    sudo ./install -to #{node['gitolite']['home']}/server            
    sudo ln -s #{node['gitolite']['home']}/server/gitolite /usr/local/bin/gitolite
  EOH
  not_if { ::File.exists? '/usr/local/bin/gitolite' }
end

bash "setup gitolite for user git" do
  user node['gitolite']['user']
  group node['gitolite']['group']
  cwd "#{node['gitolite']['home']}/"
  code <<-CODE
    /usr/local/bin/gitolite setup -pk #{node['gitolite']['home']}/.ssh/#{node['gitolite']['user']}.pub
    git clone git@localhost:gitolite-admin.git
  CODE
  environment ({'HOME' => node['gitolite']['home']})
  not_if {::File.exists? "#{node['gitolite']['home']}/.gitolite/keydir/#{node['gitolite']['user']}.pub"}
end
