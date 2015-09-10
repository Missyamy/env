# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.define 'web-server' do |server|
    server.vm.provider 'virtualbox' do |vb|
      vb.name = 'techtonic-web-server-' + Time.now.to_i.to_s
      vb.gui = false
    end
    server.vm.box = 'hashicorp/precise32'
    #server.vm.box_url = 'https://atlas.hashicorp.com/hashicorp/boxes/precise32'
    server.vm.network 'private_network', ip: '10.10.10.10'
    server.vm.synced_folder 'vault/', '/home/vagrant/vault'
    server.vm.provision 'shell', inline: $install_web_server
    server.vm.post_up_message = $message
  end
  config.vm.define 'db-server' do |db|
    config.vm.provider 'virtualbox' do |vb|
      vb.name = 'techtonic-db-server-' + Time.now.to_i.to_s
      vb.gui = false
    end
    db.vm.box = 'hashicorp/precise32'
    db.vm.network 'private_network', ip: '10.10.10.11'
    db.vm.synced_folder 'vault/', '/home/vagrant/vault'
    db.vm.network 'forwarded_port', guest: 5984, host: 5984, auto_correct: true
    db.vm.provision 'shell', path: 'bin/install_couchdb.sh'
  end
  config.vm.provider 'virtualbox' do |vb|
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/vagrant", "1"]
  end
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"
end

$message = <<MSG
░█░█░█▀▀░█▀▄
░█▄█░█▀▀░█▀▄
░▀░▀░▀▀▀░▀▀░
VM Name ---> web-server
IP --------> 10.10.10.10
MySQL Username: root
MySQL Password: 123

░█▀▄░█▀▄
░█░█░█▀▄
░▀▀░░▀▀░
VM Name ---> db-server
IP --------> 10.10.10.11
MSG

$install_web_server = <<WEB
  printf "Installing various items..."
  sudo apt-get update >/dev/null 2>&1
  sudo apt-get install -y make >/dev/null 2>&1
  sudo apt-get install -y figlet >/dev/null 2>&1
  sudo apt-get install -y toilet >/dev/null 2>&1
  sudo apt-get install -y curl >/dev/null 2>&1
  printf "Installing JRE and JDK..."
  sudo apt-get update >/dev/null 2>&1
  sudo apt-get install -y default-jre >/dev/null 2>&1
  sudo apt-get install -y default-jdk >/dev/null 2>&1
  printf "Preparing to install node.js and npm..."
  curl -sL https://deb.nodesource.com/setup | sudo bash - >/dev/null 2>&1
  printf "Installing node.js and npm..."
  sudo apt-get install -y nodejs >/dev/null 2>&1
  printf "Installing Git..."
  sudo apt-get install -y git >/dev/null 2>&1
  printf "Installing LAMP stack..."
  sudo apt-get update >/dev/null 2>&1
  sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password password 123'
  sudo debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password 123'
  sudo apt-get -y install lamp-server^ >/dev/null 2>&1
  printf "Creating symlink to /var/www..."
  sudo rm -rf /var/www
  sudo ln -fs /vagrant /var/www
  sudo a2enmod rewrite >/dev/null 2>&1
  sudo sed -i '/AllowOverride None/c AllowOverride All' /etc/apache2/sites-available/default >/dev/null 2>&1
  sudo service apache2 restart >/dev/null 2>&1
  # Fix 'Servername error'
  #printf "ServerName localhost" | sudo tee /etc/apache2/conf.d/fqdn >/dev/null 2>&1
  # Restart apache
  sudo service apache2 reload >/dev/null 2>&1
WEB

$install_mongo = <<MONGO
  printf "Installing MongoDB..."
  sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10 >/dev/null 2>&1
  printf 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | sudo tee /etc/apt/sources.list.d/mongodb.list >/dev/null 2>&1
  sudo apt-get update >/dev/null 2>&1
  sudo apt-get install -y mongodb-org >/dev/null 2>&1
  # Change config file to allow external connections
  sudo sed -i '/bind_ip/c # bind_ip = 127.0.0.1' /etc/mongod.conf >/dev/null 2>&1
  # Change default port to 8000
  #sudo sed -i '/#port/c port = 8000' /etc/mongod.conf >/dev/null 2>&1
  sudo service mongod restart >/dev/null 2>&1
MONGO

$install_redis = <<REDIS
  printf "Installing build-essential package..."
  sudo apt-get install -y build-essential >/dev/null 2>&1
  printf "Installing redis server..."
  sudo apt-get install -y redis-server >/dev/null 2>&1
  # Configure redis-server to accept remote connections
  sudo sed -i 's/bind 127.0.0.1/bind 0.0.0.0/' /etc/redis/redis.conf
  sudo service redis-server restart >/dev/null 2>&1
REDIS

$install_redis_make = <<REDIS
  sudo apt-get update >/dev/null 2>&1
  printf "Installing make..."
  sudo apt-get install -y make >/dev/null 2>&1
  printf "Installing tcl..."
  sudo apt-get install -y tcl8.5 >/dev/null 2>&1
  printf "Downloading redis..."
  sudo wget http://download.redis.io/releases/redis-2.8.19.tar.gz >/dev/null 2>&1
  sudo tar xzf redis-2.8.19.tar.gz
  cd redis-2.8.19
  printf "Building redis..."
  make >/dev/null 2>&1
  sudo make install >/dev/null 2>&1
  redis-server
  #cd utils
  #sudo ./install_server.sh
REDIS