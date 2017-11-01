# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.box_version = "20171030.0.0"

  # port forward
  (8080..8081).to_a.push(80).to_a.push(80).each do |port|
    config.vm.network "forwarded_port", guest: port, host: port, host_ip: "127.0.0.1"
  end
  config.vm.network "private_network", ip: "192.168.33.10"

  # provider
  config.vm.provider "virtualbox" do |vb|
    vb.cpus = 2 
    vb.memory = "2048"
  end

  # sync
  config.vm.synced_folder "../../", "/whome"

  # timezone
  config.vm.provision "shell", inline: "ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime"

  # Provisioning with ansible
  config.vm.provision "ansible_local" do |ansible|
    ansible.playbook = "ansible/site.yml"
    ansible.inventory_path = "ansible/local"
    ansible.limit = "localhost"
    ansible.raw_arguments = ["-K"]
    ansible.extra_vars = {
      env: 'vm'
    }
  end
end

