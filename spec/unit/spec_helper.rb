
require 'chefspec'
require 'chefspec/berkshelf'


RSpec.configure do |c|
  c.filter_run(focus: true)
  c.run_all_when_everything_filtered = true
  c.log_level = :debug
end