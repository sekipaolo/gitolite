
require 'gitolite'
require 'tempfile'

describe 'Rds::Gitolite' do 

	let(:gitolite) {Rds::Gitolite.new 'spec/fixtures/gitolite.conf'}
	before(:each) {gitolite.load_config}
	context 'parsing file' do 

		it 'can parse the config files' do
			repos = gitolite.repositories
			expect(repos).to be_kind_of(Hash)
		end

		it 'can find repositories' do
			repos = gitolite.repositories
			expect(repos.include? 'projectsample').to eq true
		end

		it 'can find permissions' do
			permissions = gitolite.repositories['projectsample'][:permissions]
			expect(permissions.include? 'R').to eq true 
		end	

		it 'can find keys' do
			keys = gitolite.repositories['projectsample'][:permissions]['R']
			expect(keys.include? 'gitweb').to eq true 
		end	

		it 'retrive correct permission for user/repo' do
			expect(gitolite.get_permission('projectsample', 'gitweb')).to eq 'R'
		end

		it 'can write correct config' do
			gitolite.edit_permission 'projectsample', 'gitweb', 'W'			
			str = gitolite.conf_to_string 
			file = Tempfile.new('foo')
			gitolite.conf_file = file.path
			file.close
			file.unlink
			expect(gitolite.get_permission('projectsample', 'gitweb')).to eq 'W'
		end
	
	end

	context 'remove permission' do		
		
		it 'permission exists ' do
			repos = gitolite.repositories
			res = gitolite.edit_permission 'projectsample', 'gitweb', nil
			expect(res).to eq true
			expect(gitolite.get_permission('projectsample', 'gitweb')).to be_nil
		end
		
		it 'permission not exists ' do
			repos = gitolite.repositories
			res = gitolite.edit_permission 'project_not_present', 'gitweb', nil
			expect(res).to eq false
		end		
	
	end
	
	context 'edit a permission that exists' do	
	
		it 'add repository if not exists' do
			repos = gitolite.repositories
			res = gitolite.edit_permission 'new_repo', 'gitweb', 'R'
			expect(res).to eq true
			expect(gitolite.get_permission('new_repo', 'gitweb')).to eq 'R'
		end

		it 'add permission if not exists' do
			repos = gitolite.repositories
			res = gitolite.edit_permission 'projectsample', 'new_key', 'W+'
			expect(res).to eq true
			expect(gitolite.get_permission('projectsample', 'new_key')).to eq 'W+'
		end

		it 'move key if permission exists' do
			repos = gitolite.repositories
			res = gitolite.edit_permission 'projectsample', 'gitweb', 'W+'
			expect(res).to eq true
			expect(gitolite.get_permission('projectsample', 'gitweb')).to eq 'W+'
		end

		it 'do nothing if perm exist' do
			repos = gitolite.repositories
			res = gitolite.edit_permission 'projectsample', 'gitweb', 'R'
			expect(res).to eq false
		end
	
	end
end