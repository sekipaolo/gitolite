module Rds
	class Checks
		class << self

			def gpg_key_present key
				"gpg --list-keys | grep BF04FF17"
			end

			def ssh_config_entry_present host, config_file, key_name
				# TODO: find a way to make a better chek: use awk or sed with regex (check for host and key on the same block)
				"cat #{config_file} | grep #{key_name}"   
			end

			def redmine_migrated user, pass, name
				"if [ `mysql -u#{user} -p#{pass} -e 'select count(id) FROM #{name}.users;' | sed -n '2 p'` -gt 0 ]; then echo '0'; else echo '1'; fi"
			end

		end
	end
end