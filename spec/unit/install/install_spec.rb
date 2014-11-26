require_relative '../spec_helper'
describe 'gitolite::install' do
  let(:chef_run) { 
  	stub_command("cat /.ssh/config | grep id_rsa").and_return(true)
  	ChefSpec::SoloRunner.new(step_into: ["gitolite"]).converge(described_recipe)   	
	}

  it 'create a git user' do
    expect(chef_run).to create_user('git')
  end

  it 'create a the ssh environment' do
    expect(chef_run).to create_sshenv('git')
  end

  it 'install git' do
    expect(chef_run).to install_package('git')
  end

  # it 'clone git' do
  #   expect(chef_run).to sync_git("#{Chef::Config[:file_cache_path]}/gitolite")
  # end

  # it 'notifies to run install gitolite' do
  # 	resource = chef_run.git("#{Chef::Config[:file_cache_path]}/gitolite")
  #   expect(resource).to notify('bash[install gitolite]').to(:run).immediately
  # end

  # it 'notifies to clone admin repo' do
  # 	resource = chef_run.bash("install gitolite")
  #   expect(resource).to notify("git[/home/git/gitolite-admin/]").to(:sync).immediately
  # end

end
