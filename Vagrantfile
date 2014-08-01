# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # Box settings

  config.vm.box       = 'ubuntu12.04'

  config.vm.box_url   = 'http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box'

  config.vm.host_name = 'speech-music-discrimination'

  config.vm.network :private_network, :ip => '192.168.33.40'

  # First update apt
  config.vm.provision :shell, :inline => 'apt-get update'

  # Install ffmpeg
  config.vm.provision :shell,
    :path       => 'provisioning/install-ffmpeg.sh',
    :privileged => false

  # Install audiowaveform
  config.vm.provision :shell,
    :path       => 'provisioning/install-audiowaveform.sh',
    :privileged => false

  # Install YAFFE
  config.vm.provision :shell,
    :path       => 'provisioning/install-yaffe.sh',
    :privileged => false

  # Install YAFFE CBA extension
  config.vm.provision :shell,
    :path       => 'provisioning/install-yaffe-cba-extension.sh',
    :privileged => false

  # Install VAMP & BBC R&D Speech Music segmenter plugin
  config.vm.provision :shell,
    :path       => 'provisioning/install-vamp.sh',
    :privileged => false

  # Install ruby
  config.vm.provision :shell,
    :path       => 'provisioning/install-ruby.sh',
    :privileged => false

end
