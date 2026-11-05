# homelab

Services for my Raspberry Pi 5, deployed to Docker Swarm by [doco-cd](https://doco.cd). Ansible prepares the host.

## Structure

- `stacks/` - One Swarm stack per folder, deployed by doco-cd from `main`
- `images/` - Images built by CI, since Swarm can't build
- `roles/`, `site.yml` - Ansible playbook that sets up Swarm and tmux on the host
- `vault/` - Ansible Vault files

## Development Tasks

- `mise run lint` - Lint workflows, playbook and stacks
- `mise run deploy` - Run playbook
- `mise run ping` - Check inventory
- `mise run ssh:copy-id <host>` - Copy SSH key to host, e.g. `dietpi@192.168.0.2`
- `mise run age:keygen` - Create your SOPS age key, unless it exists, and print its public key
- `mise run secrets:edit <file>` - Create or edit a SOPS-encrypted file
- `mise run vault:password` - Set the Vault password
- `mise run vault:decrypt <file>` - Decrypt a Vault file
- `mise run vault:encrypt <file>` - Encrypt a Vault file
