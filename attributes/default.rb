default[:gitolite] = {
  user: 'git',
  group: 'git',
  home: '/home/git', # when override  make sure that it is owned by gitolite user
  key_name: 'gitolite_admin_id_rsa'
}

