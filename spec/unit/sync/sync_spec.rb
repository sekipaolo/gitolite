require_relative '../spec_helper'
describe 'gitolite::sync' do
  let(:chef_run) { 
  	ChefSpec::SoloRunner.new(step_into: ["gitolite::repository"]).converge(described_recipe)     
	}

  before do
    allow(File).to receive(:open).and_call_original
    allow(::File).to receive(:open).with( '/home/git/.gitolite/conf/gitolite.conf', "r" )
      .and_return( ::File.open 'spec/fixtures/gitolite.conf' )
    allow(Dir).to receive(:entries).and_call_original
    allow(Dir).to receive(:entries).with('/home/git/.gitolite/keydir')
      .and_return(['.','..','deploy_id_rsa.pub', 'gitolite_admin_id_rsa.pub', 'jenkins_id_rsa.pub', 'paolo_id_rsa.pub'])
    allow(FileUtils).to receive(:rm).with('/home/git/gitolite-admin/conf/gitolite.conf').and_return(true)
    allow(FileUtils).to receive(:mv).and_return(true)
    allow(FileUtils).to receive(:chown_R).and_return(true)
    allow(FileUtils).to receive(:chown).and_return(true)
  end

  # it 'call the sync action' do
  #   expect(chef_run).to gitolite_repository('test_repo')
  # end

end
