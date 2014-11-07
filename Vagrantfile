VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  #require_version ">= 1.6.3"

  # Every Vagrant virtual environment requires a box to build off of.
  config.vm.box = "ubuntu/trusty32"

  # accessing "localhost:8000" will access port 80 on the guest machine.
  config.vm.network "forwarded_port", guest: 80, host: 8001
  config.vm.network "forwarded_port", guest: 3306, host: 33061
  config.vm.network "forwarded_port", guest: 5432, host: 54321


  #config.vm.network "private_network", ip: "192.168.10.10"


  # Configure A Few VirtualBox Settings
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--memory", 256]
    vb.customize ["modifyvm", :id, "--cpus", 1]
    vb.customize ["modifyvm", :id, "--natdnsproxy1", "on"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]

    #If for some crazy reason you want a GUI uncomment this
    #vb.gui = true
  end

  #push enviroment config
  #config.vm.provision "file", run: "always" do |file|
  #  file.source      = '../_ss_environment.php'
  #  file.destination = '/var/www/_ss_environment.php'
  #end


  config.vm.synced_folder "./", "/var/www/html", create: true, owner: "www-data"

  config.vm.provision :shell, :path => "bootstrap.sh"
end
