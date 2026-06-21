## Why

The homelab can already host Matrix, but it does not yet provide a persistent Hermes Agent gateway that can be reached from Matrix or managed through the existing Swarm deployment.

Adding Hermes as an Ansible-managed role gives the homelab a self-hosted assistant with persistent state, Matrix access, and optional dashboard/API access under the same Caddy-backed deployment pattern as the rest of the stack.

## What Changes

- Add a Hermes Agent service deployed through Docker Swarm.
- Persist Hermes runtime state, configuration, sessions, memory, skills, and logs in a Docker volume mounted at `/opt/data`.
- Configure Hermes to run in gateway mode and connect to the local Matrix homeserver as a dedicated bot account.
- Restrict Matrix access with allowed Matrix users and optional allowed Matrix rooms.
- Expose the Hermes dashboard through Caddy when enabled.
- Optionally expose the OpenAI-compatible API endpoint through Caddy for trusted internal clients.
- Keep Hermes image versioning pinned rather than using `latest`.

## Capabilities

### New Capabilities

- `hermes-agent`: Provides a self-hosted Hermes Agent gateway integrated with Matrix and the homelab Caddy/Swarm deployment.

### Modified Capabilities

- None.

## Impact

- Adds a new Ansible role for the Hermes Agent stack.
- Updates the Raspberry Pi 5 playbook to include the Hermes role.
- Adds Hermes-specific defaults and Vault-backed secrets for Matrix credentials and optional API/dashboard settings.
- Uses the existing Docker Swarm, Caddy overlay network, Caddy Docker labels, and image pruning handler patterns.
- Introduces the `nousresearch/hermes-agent` container image.
