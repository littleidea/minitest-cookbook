require 'minitest/autorun'

action :test do
  testcase = ChefMiniTest::Unit::TestCase.new(new_resource.name, &new_resource.block)
  testcase.run(ChefMiniTest::Runner.runner)
  new_resource.updated_by_last_action(true) if ChefMiniTest::Runner.runner.run [ "-v" ]
end



