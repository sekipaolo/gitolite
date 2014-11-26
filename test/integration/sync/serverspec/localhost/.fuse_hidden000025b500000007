require 'spec_helper'

describe 'sshenv::default'  do
	context 'with default attributes' do

		it 'should have a user_with_default_attributes user' do
	    expect(user 'user_with_default_attributes' ).to exist
		end

		it 'should have key secret file' do
	    expect(file '/home/user_with_default_attributes/.ssh/id_rsa').to be_file
		end

		it 'should have key public file' do
	    expect(file '/home/user_with_default_attributes/.ssh/id_rsa.pub').to be_file
		end

		it 'should have edited config file' do
			# TODO test also key 
			# TODO let host be configurable
	    expect(file('/home/user_with_default_attributes/.ssh/config').content).to match(/Hostname+\s*localhost$\nIdentityFile+\s*/)
		end

		it 'has a known_hosts file' do
			#TODO check also corrispondence with host
	    expect(file '/etc/ssh/ssh_known_hosts').to be_file
		end
	end 
		
	context 'with custom attributes' do
		it 'should have a user_with_custom_attributes user' do
	    expect(user 'user_with_custom_attributes' ).to exist
		end

		it 'should have key secret file' do
	    expect(file '/custom_home/.ssh/custom_key_name').to be_file
		end

		it 'should have key public file' do
	    expect(file '/custom_home/.ssh/custom_key_name.pub').to be_file
		end

		it 'should have edited config file' do
			# TODO test also key 
			# TODO let host be configurable
	    expect(file('/custom_home/.ssh/config').content).to match(/Hostname+\s*localhost$\nIdentityFile+\s*/)
		end

		it 'has a known_hosts file' do
			#TODO check also corrispondence with host
	    expect(file '/etc/ssh/ssh_known_hosts').to be_file
		end
	end	
end
