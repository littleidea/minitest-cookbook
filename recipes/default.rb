#
# Cookbook Name:: minitest
# Recipe:: default
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
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

node.minitest.gem_dependencies.each do |gem|
  gem_package(gem) { action :nothing }.run_action(:install)
end

minitest_unit_testcase "http_port" do
  block do
    assert_instance_of( Socket,
                        Socket.tcp("127.0.0.1", 80),
                        "socket could not be established to port localhost:80"
                        )
  end
  action :nothing
end
