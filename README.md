owl-playbook
============

Ansible playbook for WSL(Ubuntu) or VM(Ubuntu) on windows


Usage
-----


### WSL

```
$ ansible-playbook -K --extra-vars "env=${env}" -i local site.yml
```

You can specify `$env` in `ansible/group_vars`, and add your original env.


### VM on windows

#### Not in VM (windows)

`cd vagrant/ubuntu-{gui,cui}`

```
$ vagrant up --provision
```

#### In VM (not windows)

```
$ ansible-playbook -K --extra-vars "env=vm" -i local site.yml
```

### For engsvr (with Ubuntu desktop)

Login Ubuntu desktop and

```
$ ansible-playbook -K --extra-vars "env=vm" --tags engsvr -i local site.yml
```

