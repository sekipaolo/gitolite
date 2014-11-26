gitolite_repository "my_awesome_repo" do
  key_name 'my_awesome_key'
  action :remove_key
end

gitolite_repository "my_awesome_repo" do
	key_name 'my_awesome_key'
  key_string 'ssh-dss AAAAB3NzaC1kc3MAAACBAKN3bcvdBfyPHZK0arAC6j0gTHTbrLtfpwkXKTCDBmbtMK4831ZFhOAHrZ0Zo9hIwLCpqL/KyOyeWn97FuHfklf/bnDmdNXF5aMTtwU3q0eo3KAIKyxv6d/NOJw9KJPr24xnACFmURiPjMXhWOE+FwLLn3I7q1lvylRK1ErxszYpAAAAFQDjgzTAcCGsesS+sLvre3rd1cl6pwAAAIB8mzSSdLo+Tob7umwovM8YQFIKycp41Hg/5EIr7SfvUXa+6y7yPQhQy+AcGUIJAW9jJFBdK/dJD8AaOIsgd2oygli+6YO2sOpDyRjEL/bDNp++NOIKgct78F3mxc9m0EfFOSVcAgMJfdHt9Ktvv5rHi1BAGpuud/ITKkyIZ/6L0AAAAIBI3Z/XB3atN7l2XxiYv1MzRRBvTlJdVG2r7HaxZoN9NR1L3r8fglqJEC/Z+d3/vv4SGke8djf4m47xE9LciUdAMqI878RBJ6RmGMrtvP4oo8p6CpJYTyI/a+159da0Y7FReeLMbcsgYg0trhJcwnyPKWL8N94463YYSsMiCRAB9w== vagrant@sync-debian-6010'
  permission 'R'
  action :sync
end

repo_dir = '/home/vagrant/test/repo_clone'
# recreate the temporary dir
directory repo_dir do
  action :delete
  recursive true
end

directory repo_dir do
  owner 'vagrant'
  group 'vagrant'
  recursive true
end

sshenv 'vagrant' do
  known_hosts ['localhost']
end

gitolite_repository "my_awesome_repo" do
  key_name "vagrant_id_rsa"
  key_path "/home/vagrant/.ssh/id_rsa.pub"
  permission 'RW'
  action :sync
end

git repo_dir do
  user 'vagrant'
  group 'vagrant'
  repository 'ssh://git@localhost/my_awesome_repo.git'
  action :sync
end