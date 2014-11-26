
use_inline_resources

def whyrun_supported?
  true
end

def conf_path
  @conf_path ||= "#{node.default['gitolite']['home']}/.gitolite"
end

def admin_path
  @admin_path = "#{node['gitolite']['home']}/gitolite-admin"
end

def gitolite
  unless @gitolite
    git admin_path do
      user 'git'
      group 'git'
      repository 'ssh://git@localhost/gitolite-admin.git'
      action :checkout
    end
    @gitolite = Rds::Gitolite.new "#{admin_path}/conf/gitolite.conf"
    @gitolite.load_config    
  end
  @gitolite
end

def load_current_resource
  @current_resource = Chef::Resource::GitoliteRepository.new(@new_resource.name)
  # clone attributes from @new_resource to @current_resource 
  [	:name, :repository, :permission, :key_name, :key_string, :key_path ].each do |k|
  	@current_resource.send( k, ( @new_resource.send( k ) ) )    
	end
end

action :remove_key do
  key = @current_resource.key_name
  if keys.include? key
    file "#{admin_path}/keydir/#{key}.pub" do
      action :delete
    end
    comment = "Removed key #{key}"
    push comment
    Chef::Log.info comment
  else
    Chef::Log.info "key #{key} don't exists - nothing to do"
  end
end

action :sync do
  comments = ["Done by chef"]
	permission_changed = gitolite.edit_permission @current_resource.name, @current_resource.key_name, @current_resource.permission		
	if permission_changed 
    Chef::Log.info "permission on repository #{@current_resource.repository} updated"
    write_config
    comments << 'Edit permission on repository #{@current_resource.repository}'
  else  
    Chef::Log.info "permission on repository #{@current_resource.repository} are not changed"    
  end   
  if keys.include?(@current_resource.key_name)
    Chef::Log.info "key #{@current_resource.key_name} already exists"
  else
    Chef::Log.info("adding key #{@current_resource.key_name}")
    add_key
    key_new = true	
    comments << "added key #{@current_resource.key_name}"
  end   
	if permission_changed || key_new
		Chef::Log.info("Pushing edits in Gitolite")
		push comments.join('. ')
	else
		Chef::Log.info("Gitolite config has not changed")		
	end
end

def add_key 
  resource = @current_resource
  new_file = "#{admin_path}/keydir/#{resource.key_name}.pub"
  if resource.key_path
    # copy content on keydir
    FileUtils.cp resource.key_path, new_file
    return true
  elsif resource.key_string
    file new_file do
      owner node['gitolite']['user']
      group node['gitolite']['group']
      content resource.key_string
    end
    return true
  else 
    Chef::Log.error "ERROR: you supply a key #{resource.key_name} that don't exists on keydir: use a key_path or key_string method to provide the key"
    raise 'No key provided'
  end
end

def write_config
  file "#{admin_path}/conf/gitolite.conf" do
    owner 'git'
    group 'git'
    content gitolite.conf_to_string
  end
end

def push comment
  FileUtils.chown_R 'git', 'git', "#{admin_path}/keydir/"                
  FileUtils.chown 'git', 'git', "#{admin_path}/conf/gitolite.conf"   
  # we rebuild here the instance variavle @admin_path, 
  # because the resource is evaluated on compile_path (no instance variables can be )    
  bash 'push edits to gitolite-admin repository' do
    user 'git'
    group 'git' 
    cwd admin_path
    code <<-EOH
      git pull
      git add -A
      git commit -m '#{comment}'
      git push
    EOH
    environment ({ 'HOME' => ::Dir.home(node['gitolite']['user']), 'USER' => node['gitolite']['user']})
  end    
end

def keys 
	(Dir.entries("#{conf_path}/keydir") -  ['.', '..']).map{|f|f.gsub '.pub', ''}
end

