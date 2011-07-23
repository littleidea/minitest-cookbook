minitest_unit_testcase :test_bomb_the_fuck_out do
  block do
    assert_equal true, false
  end
end

ipaddress = node.ipaddress
http_port = 80
dns_search_path = "junglist.gen.nz"
dns_ndots = 1

{ "http_port" => Proc.new do
    require 'socket'
    assert_instance_of Socket, Socket.tcp(ipaddress, http_port), "http_port: socket could not be established to port #{ipaddress}:#{http_port}"
  end,
  "http_fitter_happier" => Proc.new do
    require 'uri'
    require 'chef/config'
    require 'chef/rest'
    require 'timeout'

    %w{/fitter_happier /fitter_happier/site_check /fitter_happier/site_and_database_check}.each do |path|
      uri = URI::HTTP.build :host => ipaddress, :port => http_port, :path => path
      request = Chef::REST::RESTRequest.new(:GET, uri, nil)
      Timeout::timeout(5) do
        assert_instance_of Net::HTTPOK, request.call, "http_fitter_happier: GET to #{uri.inspect} did not return HTTPOK"
      end
    end

  end,
  "dns_resolution" => Proc.new do
    require 'resolv'
    resolver = Resolv::DNS.new(:nameserver => ipaddress, :search => dns_search_path, :ndots => dns_ndots)
    assert_instance_of Resolv::IPv4, resolver.getaddress("www.google.com"), "dns_resolution: could not resolve www.google.com"
  end,
  "tftp_binary_get" => Proc.new do
    Gem.clear_paths
    require 'tempfile'
    require 'net/tftp'
    require 'timeout'

    tftp = Net::TFTP.new(ipaddress)
    Tempfile.open("pxelinux.0") do |tempfile|
      Timeout::timeout(5) do
        tftp.getbinary "pxelinux.0", tempfile
      end
      refute_equal 0, tempfile.size, "tftp_bianry_get: tempfile.size is is #{tempfile.size}"
    end
  end
}.each do |name, proc|
  minitest_unit_testcase(name) do
    block(&proc)
  end
end
