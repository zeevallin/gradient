require "gradient"
require "pry"

def fixture_path(file)
  Pathname(File.expand_path("../fixtures/#{file}", __FILE__))
end

def fixture_buffer(file)
  File.open(fixture_path(file), 'r').read
end

Dir[File.expand_path('../matchers/*.rb', __FILE__)].each { |f| require f }

RSpec.configure do |config|

  config.filter_run_excluding slow: true, profile: true

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.disable_monkey_patching!

  if config.files_to_run.one?
    config.default_formatter = "documentation"
  end

  config.profile_examples = 10
  config.order = :random

  Kernel.srand config.seed

end


