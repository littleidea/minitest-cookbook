# Cookbook: minitest
#
# Copyright 2011, AJ Christensen <aj@junglist.gen.nz>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
# implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

begin
  gem "minitest"
  require "minitest/autorun"
rescue LoadError => e
  Chef::Log.info "missing gem: minitest"
end

module ChefMiniTest
  class Unit < MiniTest::Unit
    class TestCase < MiniTest::Unit::TestCase
      def test_minitest_unit_testcase
        assert_instance_of( TestCase,
                            ChefMiniTest::Unit::TestCase.new("test"),
                            "ChefMinitest::Unit::TestCase#new did not return a TestCase object"
                            )
      end

      def initialize(name, &block)
        name = "test_#{name}".to_sym unless name =~ /^test/
        Chef::Log.debug "ChefMiniTest::Unit::TestCase: name #{name}, block #{block.inspect} block_given?: #{block_given?}"

        define_singleton_method name do
          instance_exec name, &block
        end if block_given? and block

        Chef::Log.debug "ChefMiniTest::Unit::TestCase: methods matching /test_/: #{methods.select{|m| m =~ /test_/}}"
        super(name)
      end
    end
  end

  class Runner
    def self.runner
      @@runner ||= ChefMiniTest::Unit.new
    end
  end
end
