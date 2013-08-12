# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant::configure("2") do |config|
  config.vm.box = "precise64"
  config.vm.network :forwarded_port, guest: 8000, host: 8000, auto_correct: true
  config.vm.network :forwarded_port, guest: 22, host: 2022, auto_correct: true
  config.vm.synced_folder"./shared", "/home/vagrant/host_shared"
  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "cookbooks"
    chef.data_bags_path = "data_bags"
    chef.add_recipe "apt"
    chef.add_recipe "build-essential"
    chef.add_recipe "ohai"
    chef.add_recipe "configure"
  end
end
