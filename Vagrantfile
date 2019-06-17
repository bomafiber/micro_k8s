# -*- mode: ruby -*-
# vi: set ft=ruby :

#
# Replace GITHUB_KEY_URL with your own github key url. Your
# github key URL is a URL in the format https://github.com/your_github_username.keys
#
# Once the VM has been created and provisioned, you'll be able to SSH on to it as the
# user 'ansible'.
#

VM_LIST = [ "microk8s" ]
GITHUB_KEY_URL="https://github.com/t2tre.keys"
Vagrant.configure("2") do |config|

  config.vm.box = "ubuntu/bionic64"
  VM_LIST.each do |v|
    config.vm.define "#{v}" do |odp|
      odp.vm.box = "ubuntu/bionic64"
      odp.vm.provider "virtualbox" do |vb|
        vb.name = "#{v}"
        vb.memory = 6200
        vb.cpus = 2
        vb.customize ["modifyvm", :id, "--vram", "32"]
      end

      odp.vm.hostname = "#{v}"
      odp.vm.network "private_network", ip: "10.19.200.100"
      odp.vm.provision "shell", path: "bootstrap_system.sh", args: [ GITHUB_KEY_URL ]
    end
  end

end
