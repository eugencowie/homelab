# Coding Standards

## Images

- Pin images as `tag@sha256:digest`, so Renovate can bump both.

## Services

- Keep Docker's default capabilities. Use `cap_add` only for what a service needs, and don't use `cap_drop`.
- Add a healthcheck only when it's needed. The image's own healthcheck is fine.
- Publish ports with the long syntax and `mode: host`, so the service sees the client's real source IP rather than
  the ingress gateway's.
- Write relative paths without `./`.
- Only `dococd` sets `update_config.failure_action: rollback`. A broken dococd can't deploy its own fix.
- Serve HTTP by joining the external `caddy` network and routing with `caddy` labels.

## Secrets

- Put env secrets in a SOPS-encrypted `secrets.env` with unquoted values, and secret files in `secrets/` as Swarm
  `secrets:`. See [ADR 0001](docs/architecture/0001-deploy-with-doco-cd-on-swarm.md).
- Prefer an app's `*_path` or `*_FILE` option over an env secret.

## Comments

- Explain why, not what.
