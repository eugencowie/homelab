## Why

The homelab does not currently provide an internal real-time messaging service for local users. Adding Matrix gives the local network a self-hosted chat system with first-party web access and room history under the existing Ansible-managed Docker Swarm deployment.

## What Changes

- Add a Matrix homeserver capability served at `https://matrix.echocharlie.xyz`.
- Host Element Web as the browser client in the same Matrix stack.
- Run Synapse as a single-node homeserver using SQLite-backed storage for the initial small local-user deployment.
- Integrate the Matrix stack with the existing shared Caddy overlay network and Caddy Docker labels.
- Allow open registration during initial bootstrap, with configuration that can later disable registration.
- Keep all Matrix runtime state in persistent Docker volumes managed by the stack.

## Capabilities

### New Capabilities

- `matrix-homeserver`: Provides an internally hosted Matrix homeserver and Element Web client through the homelab deployment.

### Modified Capabilities

- None.

## Impact

- Adds a new Ansible role for the Matrix stack.
- Updates the Raspberry Pi 5 playbook to include the new role.
- Adds Matrix-specific templates/configuration for Synapse and Element Web.
- Uses existing Docker Swarm, Caddy, Cloudflare DNS challenge, and local DNS patterns already present in the repository.
- Introduces new container images for Synapse and Element Web.
