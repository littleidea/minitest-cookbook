Vagrant::Config.run do |config|
  config.vm.define :minitest do |minitest|
    minitest.vm.customize do |vm|
      vm.memory_size = 512
    end
    minitest.vm.box = 'natty64_cloudscaling'
    minitest.vm.box_url = "http://d1lfnqkkmlbdsd.cloudfront.net/vagrant/natty64_cloudscaling.box"
    minitest.vm.provision :chef_solo do |chef|
      chef.cookbooks_path = [:vm, "cookbooks"]
      chef.add_recipe "minitest"
      chef.add_recipe "minitest::examples"
    end

    minitest.vm.share_folder( File.basename(__FILE__),
                              "/tmp/vagrant-chef/cookbooks/minitest",
                              File.dirname(__FILE__) )
  end
end
