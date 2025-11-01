# homelab

Check inventory:

    ansible all -m ping

Set Vault password:

    vim vault/.password

Encrypt Vault file:

    ansible-vault encrypt vault/file.yml

Lint playbook:

    ansible-lint site.yml

Run playbook:

    ansible-playbook site.yml
