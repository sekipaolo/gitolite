require 'spec_helper'

describe 'gitolite::install'  do
  context 'with default attributes' do

    it 'add group git' do
      expect(user 'git' ).to exist
    end

    it 'add user git' do
      expect(user 'git' ).to exist
    end

    it 'install git' do
      expect(package 'git' ).to be_installed
    end

    it 'install git' do
      expect(package 'git' ).to be_installed
    end

    it 'add key' do
      expect(file '/home/git/.gitolite/keydir/my_awesome_key.pub').to be_file
    end

    it 'update authorized_keys file' do
      expect(file('/home/git/.ssh/authorized_keys').content).to match(/my_awesome_key/)      
    end  

    it 'update config file' do
      expect(file('/home/git/.gitolite/conf/gitolite.conf').content).to match(/my_awesome_key/)      
    end  
    

    # TODO CHEK THAT THE USER CAN REALLY CLONE
  end   
end
