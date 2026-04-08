# homelab

Set Vault password:

    vim vault/.password

Copy SSH key to host:

    ssh-copy-id dietpi@192.168.0.2

Check inventory:

    ansible all -m ping

Lint playbook:

    ansible-lint site.yml

Run playbook:

    ansible-playbook site.yml

Decrypt Vault file:

    ansible-vault decrypt vault/file.yml

Encrypt Vault file:

    ansible-vault encrypt vault/file.yml
