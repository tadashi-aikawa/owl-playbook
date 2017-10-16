owl-playbook
============

Ansible playbook for Linux


Usage
-----

```
$ ansible-playbook -K --extra-vars "env=${env}" -i local site.yml
```

You can specify `$env` in `ansible/group_vars`, and add your original env.

