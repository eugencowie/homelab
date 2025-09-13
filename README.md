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

Migrate volume:

    docker stack rm my_stack
    ssh root@192.168.0.2 docker volume create my_volume
    rsync -avP {,root@192.168.0.2:}/mnt/dietpi_userdata/docker-data/volumes/my_volume/_data/
    docker volume rm my_volume
