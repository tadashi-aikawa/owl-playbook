owl-playbook
============

`owl-playbook` includes as following both

* Windows setup script by using chocolatey and others
* Ubuntu setup for VM(Ubuntu 18.04) by using vagrant and ansible


Windows setup
-------------

### Requirements

* [Chocolatey](https://chocolatey.org/)
* [Scoop](https://github.com/lukesampson/scoop)

### Usage

1. Move `windows`
2. Run `provision.bat` as administrator mode.


Ubuntu setup
------------

### Requirements

* [Vagrant](https://www.vagrantup.com/)
  * I use `2.1.2`
* [Virtualbox](https://www.virtualbox.org/)
  * I use `5.2.18 r124319`

You can install above tools by `provision.bat`.

### Provisioning VM (Only once)

```
$ cd vagrant/ubuntu-gui
$ vagrant up --provision
```

### Usage

```
$ make run
```

