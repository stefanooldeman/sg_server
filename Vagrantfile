# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "sl6"
  config.vm.box_url = "http://lyte.id.au/vagrant/sl6-64-lyte.box"

  config.vm.network :private_network, ip: "192.168.167.14"
  config.ssh.forward_agent = true

  config.vm.provision :shell, :path => "setup.sh"
end
