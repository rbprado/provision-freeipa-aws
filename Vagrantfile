# -*- mode: ruby -*-
# vi: set ft=ruby :

#HOSTS = {
#   'freeipa' => ['centos', 'ami-8183a1eb', 'gerrit.yml'],
#   'gerrit'  => ['ubuntu', 'ami-9a562df2', 'freeipa.yml']
#}

name = 'ubuntu'
amazon_image = 'ami-9a562df2'
playbook = 'gerrit.yml'

Vagrant.configure(2) do |config|
  config.vm.box = "aws"
  config.vm.synced_folder ".", "/vagrant", disabled: true
  
  #HOSTS.each do | (name, vm_info) |
  # name, amazon_image, playbook = vm_info
    
    config.vm.define name do |vm_name|
      vm_name.vm.provider :aws do |aws, override|
        aws.access_key_id = ENV['AWS_ACCESS_KEY']
        aws.secret_access_key = ENV['AWS_SECRET_KEY']
        aws.region = ENV['AWS_DEFAULT_REGION']
        aws.availability_zone = ENV['AWS_DEFAULT_REGION'] + "a"
        aws.ami = amazon_image
        aws.keypair_name = ENV['AWS_EC2_KEY_NAME']
        aws.instance_type = "t2.micro"
        aws.block_device_mapping = [{ 'DeviceName' => '/dev/sda1', 'Ebs.VolumeSize' => 8 }]
        aws.security_groups = ENV['AWS_SECURITY_GROUP_NAME']
        aws.tags = {
          'Name' => name,
          'Environment' => 'vagrant-sandbox'
          }  
        # Credentials to login to EC2 Instance
        override.ssh.username = name
        override.ssh.private_key_path = ENV['AWS_PRIVATE_KEY_PATH']
      end
      
      # Configuration for Ansible as Provisioner
      vm_name.vm.provision :ansible do |ansible|
        ansible.playbook = playbook
        ansible.verbose = "vv"
        ansible.host_key_checking = false
        ansible.limit = 'all'
      end
    end
  #end

name = 'centos'
sshuser = "ec2-user"
amazon_image = 'ami-8183a1eb'
playbook = 'freeipa.yml'
  
  config.vm.define name do |vm_name|
      vm_name.vm.provider :aws do |aws, override|
        aws.access_key_id = ENV['AWS_ACCESS_KEY']
        aws.secret_access_key = ENV['AWS_SECRET_KEY']
        aws.region = ENV['AWS_DEFAULT_REGION']
        aws.availability_zone = ENV['AWS_DEFAULT_REGION'] + "a"
        aws.ami = amazon_image
        aws.keypair_name = ENV['AWS_EC2_KEY_NAME']
        aws.instance_type = "t2.micro"
        aws.block_device_mapping = [{ 'DeviceName' => '/dev/sda1', 'Ebs.VolumeSize' => 15 }]
        aws.security_groups = ENV['AWS_SECURITY_GROUP_NAME']
        aws.tags = {
          'Name' => name,
          'Environment' => 'vagrant-sandbox'
          }  
        # Credentials to login to EC2 Instance
        override.ssh.username = sshuser
        override.ssh.private_key_path = ENV['AWS_PRIVATE_KEY_PATH']
      end
      
      # Configuration for Ansible as Provisioner
      vm_name.vm.provision :ansible do |ansible|
        ansible.playbook = playbook
        ansible.verbose = "vv"
        ansible.host_key_checking = false
        ansible.limit = 'all'
      end
    end

end