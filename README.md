owl-playbook
============

`owl-playbook` includes as following both

* Windows setup script by using chocolatey and others
* Ubuntu setup for VM(Ubuntu) by using vagrant and ansible


Windows setup
-------------

### Requirements

* [Chocolatey](https://chocolatey.org/)

### Usage

Run `provision.bat` as administrator mode.


Ubuntu setup
------------

### Requirements

* [Vagrant](https://www.vagrantup.com/)
  * I use `1.9.5`
* [Virtualbox](https://www.virtualbox.org/)
  * I use `5.1.30 r118389`

### Provisioning VM (Only once)

```
$ cd vagrant/ubuntu-gui
$ vagrant up --provision
```

### Usage

```
$ make run
```

