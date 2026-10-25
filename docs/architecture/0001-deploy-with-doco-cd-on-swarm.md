# Deploy with doco-cd on Swarm instead of Ansible

## Context

Ansible deployed every stack to the Raspberry Pi 5 with `mise run deploy`, run by hand from a laptop. The roles were mostly Jinja around Compose files: secrets from Ansible Vault, `node.hostname` constraints, and hash-named Swarm configs so that changed content produced a new config. Merged Renovate PRs only reached the Pi on the next manual deploy.

## Decision

[doco-cd](https://doco.cd) running on the Pi polls this public repository and deploys `main`.

- **Swarm stays.** doco-cd deploys a stack over an existing one of the same name, so each Ansible stack is taken over in place, one PR at a time. doco-cd also hash-suffixes and rotates configs and secrets itself. Plain Compose was rejected because migrating to it needs `docker stack rm` before each service and an outage of everything when the overlay network is replaced, for a single-node end state that gains little.
- **Layout:** one stack per `stacks/<name>/`, auto-discovered by `.doco-cd.yml`. Deleting a folder removes the stack, keeping its volumes; doco-cd only removes stacks it deployed from this repository.
- **Secrets:** SOPS with age, committed encrypted. Env secrets are a dotenv `secrets.env` per stack loaded with `env_file:`; secret files live in the stack's `secrets/` folder and use Swarm `secrets:`. The Pi's age key and the GitHub token are Swarm secrets created by hand.
- **Caddy image:** built for arm64 by CI and published to GHCR, since Swarm can't build. The stack pins it by digest and Renovate bumps it.
- **Feedback:** doco-cd reports a commit status per stack using a fine-grained PAT.

## Consequences

- Merging to `main` deploys within about five minutes, including Renovate PRs, which still need manual approval and merge. The exception is the Caddy image digest bump, which skips approval and the schedule since its Dockerfile change was already reviewed.
- Ansible is deleted once every stack is migrated. Host setup (Docker, swarm init, tmux) becomes a documented manual step.
- doco-cd's Swarm mode has no live-file reload. Its image prune only removes dangling images, so the `dococd-prune` stack runs a daily scheduled job to remove stopped containers and every unused image.
- `secrets.env` values are unquoted. Swarm deploys read `env_file:` with the Docker CLI, whose env-file format keeps quotes as part of the value, unlike Compose.
- A Caddy update takes two merges: the Dockerfile change, then Renovate's digest bump once CI has published the image.
