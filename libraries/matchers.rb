if defined?(ChefSpec)
 
  def create_sshenv(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:sshenv, :create, resource_name)
  end
 
  def sync_gitolite_repository(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:gitolite_repository, :sync, resource_name)
  end

end
