Provision and configure a Freeipa master in AWS EC2 instance with Vagrant and Ansible
=====================================================================================

This is repository contains all you need to provision a freeipa master EC2 VM at an AWS VPC.
The ansible playbook is preparing everything to the Freeipa installation, however the freeipa installation is been done through the freeipa_install.sh script called at the end of the Vagrantfile.

## Required packages:
For first, install the following packages at your unix system:
* vagrant 1.6.5 or higher
* ansible 2.0.0.2 or higher

## Install the vagrant-aws plugin:
The vagrant-aws plugin can be installed executing the following:
```
$ vagrant plugin install vagrant-aws
```

## AWS account set up:
Please set up your AWS account and export the following variables:
```
$ export AWS_ACCESS_KEY='????????????????????'                      
$ export AWS_SECRET_KEY='????????????????????????????????????????'
$ export AWS_PRIVATE_KEY_PATH='~/.ssh/vagrant.pem'
$ export AWS_DEFAULT_REGION='us-east-1'
$ export AWS_EC2_KEY_NAME='vagrant'
$ export AWS_SECURITY_GROUP_NAME='vagrant'
```

NOTE:
You can set it into your ~/.profile or ~/.bashrc.
To reach the data to set the variables follow the below instructions,
starting from your AWS console:
* AWS_ACCESS_KEY and AWS_SECRET_KEY:
  1. Go to Security Credentials
  2. Create a new Access Key 
  3. Obtain the data at the fields: Access Key ID and Secret Access Key

* AWS_DEFAULT_REGION
  1. Go to Services
  2. EC2
  3. Select the region

* AWS_PRIVATE_KEY_PATH and AWS_EC2_KEY_NAME
  1. Go to Services
  2. EC2
  3. Key Pairs
  4. Create Key Pairs
  5. Copy the file to the path

* AWS_SECURITY_GROUP_NAME
  1. Go to Services
  2. EC2
  3. Security Groups 
  4. Create Security Group
  5. Add a inbound rule for HTTP and SSH from anywhere.


## Edit data at the Vagrantfile
Please configure the following keys at the Vagrantfile file according to your AWS setup:
```
HOSTS = {
  'freeipa' => {
    :amazon_image   => 'ami-8183a1eb',
    :shh_username   => 'ec2-user',
    :instance_type  => 't2.micro',
    :disk_size_gb   => 15,
    :security_group => 'sg-4c72a434',
    :elastic_ip     => '50.16.170.94',
    :private_ip     => '172.31.0.10',
    :subnet_id      => 'subnet-4168ec37'
  }
}
```
NOTE 1: You need to create an elastic IP for your VM, without it after each reboot you will get a new IP.
NOTE 2: Do not forget to open the needed ports at your security group.
NOTE 3: While using VPC, the security group must be set through ID and not by it's name.


## Edit the defaults for the VM
At the file freeipa_pre/defaults/main.yml is possible configure some freeipa intallation data:
Please set these data according your freeipa configuration:
```
freeipa_pass: 12345678
freeipa_realm: COMPUTE-1.AMAZONAWS.COM
freeipa_domain: compute-1.amazonaws.com
ldap_dc_full: dc=compute-1,dc=amazonaws,dc=com
```
NOTE 1: Here we are using the public dns dynamic set by amazon as hostname, ofcourse it's just for testing purposes, at production you need a registered domain, or you can configure the freeipa to be a DNS resolver.
NOTE 2: In case of configure freeipa to be a DNS resolver, edit the file freeipa_pre/templates/freeipa_install.sh, and point your machines to his public ip as DNS resolver. Then every machine which you set at your VPC can be registered to the freeipa by using the freeipa-client package, so the hostname set at the configuration of all machines will be resolved and you do not well need to register any domain.


## Usage
After set the configuration listed above, just try the following line:
```
$ vagrant up --provider=aws
```

To access the command line of your EC2 instance execute the following line:
```
$ vagrant ssh
```

To access the Web UI just use the AWS Public DNS generated for the EC2 instance, it's dynamic.
The http link will be printed at the end of the provision.

Never forget to destroy your EC2 instance after testing:
```
$ vagrant destroy
```


## License

BSD

Thank you for trying this environment and be free to contribute :.
