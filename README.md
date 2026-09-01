# homelab

Set Vault password:

    mise run vault:password

Copy SSH key to host:

    mise run ssh:copy-id dietpi@192.168.0.2

Check inventory:

    mise run ping

Lint playbook:

    mise run lint

Run playbook:

    mise run deploy

Decrypt Vault file:

    mise run vault:decrypt vault/file.yml

Encrypt Vault file:

    mise run vault:encrypt vault/file.yml
