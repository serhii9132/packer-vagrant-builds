NODE_CPUS = 4
NODE_MEMORY = 4096

Vagrant.configure('2') do |config|
    config.vm.box_check_update = false
    config.ssh.insert_key = false

    config.vm.box = "debian-12.11"
    
    config.vm.provider "virtualbox" do |vb|
        vb.name = "debian-vm-test"
        vb.memory = NODE_MEMORY
        vb.cpus = NODE_CPUS
    end

    config.vm.network "private_network", ip: "192.168.56.103"
    config.vm.provision "file", source: "D:/app_data/git_home/.ssh/keys/dev/packer-test-vm/key.pub", destination: "~/.ssh/authorized_keys"
end