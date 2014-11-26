module Rds
	class Commands
		class << self

			def gpg_key_add key
				"sudo gpg --keyserver hkp://keys.gnupg.net --recv-keys #{key}"
			end

			def ssh_keys_add key_secret
		    code = <<-EOH
		      ssh-keygen -t rsa -N '' -P '' -f #{key_secret}
		      chmod 0600 #{key_secret}
		      chmod 0600 #{key_secret}.pub
		    EOH
		    code
			end

			def ssh_config_entry_add host, key_secret, config_file
		    txt = <<-TXT

Host            #{host}
Hostname        #{host}
IdentityFile    #{key_secret}
IdentitiesOnly  yes

    		TXT

				cmd = <<-CODE
		      touch #{config_file} && echo '#{txt}' >> #{config_file}
		    CODE
		    cmd    
			end

		end
	end
end