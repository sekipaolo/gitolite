actions :sync, :remove_key

attribute :home, :kind_of => String
attribute :group, :kind_of => String
attribute :key_name, :kind_of => String, :default => 'id_rsa'
attribute :key_string, :kind_of => String
attribute :key_path, :kind_of => String
attribute :repository, :kind_of => String
attribute :permission, :kind_of => String

def initialize(*args)
  super
  @home = "/home/#{@name}" unless @home
  @group = @name unless @group
  @action = :sync
end
