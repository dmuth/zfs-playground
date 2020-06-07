# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  #
  # Set this or else VBHost additions will be downloaded and built EVERY SINGLE TIME 
  # that you start a VM.  Note that not updating does run the risk of version incompatabilities.
  # This isn't the best idea, it's just an idea, is all.
  #
  # Source: https://github.com/dotless-de/vagrant-vbguest
  #
  config.vbguest.auto_update = false

  config.vm.box = "hashicorp/bionic64"

  #
  # Expose Splunk
  #
  config.vm.network "forwarded_port", guest: 8000, host: 8000

  config.vm.provider "virtualbox" do |vb|
     vb.memory = "1024"
     vb.cpus = 2
  end

  config.vm.provision "shell", path: "./provision.sh"

end

