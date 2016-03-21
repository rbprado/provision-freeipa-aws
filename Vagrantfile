# -*- mode: ruby -*-
# vi: set ft=ruby :

HOSTS = {
  'freeipa' => {
    :amazon_image  => 'ami-8183a1eb',
    :shh_username  => 'ec2-user',
    :instance_type => 't2.micro',
    :disk_size_gb  => 15,
    :security_group => 'sg-4c72a434'
  }
}

HOSTS.each do | name, info |
  Vagrant.configure(2) do |config|

    config.vm.box = 'aws'
    config.vm.synced_folder '.', '/vagrant', disabled: true

    config.vm.define name do |vm_name|
      vm_name.vm.provider :aws do |aws, override|
        aws.private_ip_address   = '172.31.0.10'
        aws.subnet_id            = 'subnet-4168ec37'
        aws.associate_public_ip  = true
        aws.access_key_id        = ENV['AWS_ACCESS_KEY']
        aws.secret_access_key    = ENV['AWS_SECRET_KEY']
        aws.region               = ENV['AWS_DEFAULT_REGION']
        aws.availability_zone    = ENV['AWS_DEFAULT_REGION'] + 'a'
        aws.keypair_name         = ENV['AWS_EC2_KEY_NAME']
        aws.security_groups      = info[:security_group]
        aws.ami                  = info[:amazon_image]
        aws.instance_type        = info[:instance_type]
        aws.block_device_mapping = [{ 'DeviceName' => '/dev/sda1', 'Ebs.VolumeSize' => info[:disk_size_gb] }]
        aws.tags = {
          'Name'        => name,
          'Environment' => 'vagrant-sandbox'
          }  
        # Credentials to login to EC2 Instance
        override.ssh.username         = info[:shh_username]
        override.ssh.private_key_path = ENV['AWS_PRIVATE_KEY_PATH']
      end
      
      # Configuration for Ansible as Provisioner
      vm_name.vm.provision :ansible do |ansible|
        ansible.playbook = 'playbook.yml'
        ansible.verbose = "vv"
        ansible.host_key_checking = false
        ansible.limit = 'all'
      end
    end
  end
end