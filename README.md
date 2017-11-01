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

```
$ vagrant up --provision
```

### For engsvr (with Ubuntu GUI)

```
$ ansible-playbook -K --extra-vars "env=vm" --tags engsvr -i local site.yml
```

