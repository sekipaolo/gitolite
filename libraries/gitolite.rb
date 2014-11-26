module Rds
	class Gitolite
		attr_accessor :repositories, :conf_file
		def initialize conf_file
		  @conf_file = conf_file
      puts "CONFFILE IS #{conf_file}"
		end

    # read config and load repositories in Hash
		def load_config
	    @repositories = {}
      current_repo = {}
	    line_num = 0
	    File.open(@conf_file, 'r').each do |line|
        puts "line is #{line}"
        line_num =+ 1
        line.gsub!(/^((".*?"|[^#"])*)#.*/) {|m| m=$1}
        line.gsub!('=', ' = ')
        line.gsub!(/\s+/, ' ')
        line.strip!
        next if line.empty?
        if res = line.match(/repo\s+([\w|\-|@]*)$/ )	        	
          @repositories[res[1]] = {permissions: {}, configs: [], options: []}
          current_repo = @repositories["#{res[1]}"]
        elsif line.match(/config\s[^$]*$/)      
          current_repo[:configs] << line
        elsif line.match(/option\s[^$]*$/)      
          current_repo[:options] << line
        elsif perm = line.match(/(.*)=(.*)$/)
          current_repo[:permissions][perm[1].strip] = perm[2].split(" ")
        else
          raise "Error parsing #{@conf_file}:#{lin_num}"
        end
      end  
		end	    

		def conf_to_string
      lines = []
      @repositories.each do |repo_name, repo|
	      lines << "repo #{repo_name}"
	      repo[:permissions].each do |perm, users|
	        lines << "  #{perm}        = #{users.join(' ')}"
	      end
	      repo[:configs].each do |line|
	        lines << "  #{line}"
	      end
	      lines << ''
	    end
      lines.join("\n")
    end


		def get_permission repo_name, key_name
			return nil unless repo = @repositories[repo_name]
			return nil unless perm = repo[:permissions].detect{|perm, keys| keys.include? key_name}
			perm.first
		end

		def remove_permission repo_name, key_name	
			perm = get_permission repo_name, key_name
			if perm
				row = @repositories[repo_name][:permissions][perm]				
				row.delete(key_name)
				return true
			end
			false
		end	

		def edit_permission repo_name, key_name, value
			return remove_permission repo_name, key_name unless value
			perm = get_permission repo_name, key_name
			if perm 
				return false if perm == value
				@repositories[repo_name][:permissions][perm].delete key_name
				@repositories[repo_name][:permissions][value] ||= []
				@repositories[repo_name][:permissions][value] << key_name
				return true
			else
				repo = @repositories[repo_name] 
				if repo
					perms = repo[:permissions]
					perms[value] ||= []
					perms[value] << key_name
					return true
				else 
					@repositories[repo_name] = {permissions: {"#{value}" => [key_name]}, configs: []}
					return true
				end	
			end
		end

	end
end