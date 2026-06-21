## Context

The homelab is managed by Ansible and deploys services to Docker Swarm on `raspberry-pi-5` at `192.168.0.2`. Most user-facing services join the shared external `caddy` overlay network and expose HTTPS routes through Caddy Docker labels with Cloudflare DNS challenge support.

The Matrix service is intended for local network use by a small number of users. The chosen public hostname is `matrix.echocharlie.xyz`, and local DNS resolves the relevant domain to `192.168.0.2`. The Matrix server name will also be `matrix.echocharlie.xyz`, so Matrix user IDs will have the form `@user:matrix.echocharlie.xyz` and no `echocharlie.xyz` delegation is required.

## Goals / Non-Goals

**Goals:**

- Deploy Synapse as the Matrix homeserver at `https://matrix.echocharlie.xyz`.
- Deploy Element Web in the same stack as the default browser client.
- Use SQLite for the initial small local deployment to avoid an additional database service.
- Keep Synapse state, media, database, and identity material persistent across stack updates.
- Integrate with the existing Ansible role, Docker Swarm, Caddy, and vault patterns.
- Allow registration during bootstrap and make it easy to disable later.

**Non-Goals:**

- Provide public federation or expose Matrix server-to-server port `8448`.
- Add Postgres in the initial implementation.
- Add TURN, voice/video relay, bridges, single sign-on, or identity server support.
- Change existing Caddy, DNS, or non-Matrix service behavior beyond adding the new route.

## Decisions

### Use Synapse with SQLite for the first deployment

Synapse is the conservative homeserver choice for compatibility with Matrix clients. SQLite is acceptable for the stated scope of a LAN-only server with a few users and substantially reduces the initial stack complexity.

Alternative considered: Synapse with Postgres. This remains the expected migration path if usage grows, federation is enabled, large rooms are joined, or concurrent load becomes noticeable.

### Use `matrix.echocharlie.xyz` as both hostname and server name

Using the same value for the HTTPS hostname and Matrix server name avoids Matrix `.well-known` delegation and keeps client configuration simple. Element Web can point directly at `https://matrix.echocharlie.xyz`.

Alternative considered: `echocharlie.xyz` as the server name with delegation to `matrix.echocharlie.xyz`. That gives shorter user IDs but adds extra Caddy routing and well-known requirements.

### Host Element Web and Synapse behind one Caddy site

Caddy should serve Element Web as the default route for `matrix.echocharlie.xyz` and reverse proxy Matrix API paths to Synapse:

- `/_matrix/*` to Synapse on port `8008`
- `/_synapse/client/*` to Synapse on port `8008`
- all other paths to Element Web

Element Web should mount a generated `config.json` that sets the default homeserver to `https://matrix.echocharlie.xyz`.

Alternative considered: expose Element Web on a separate hostname. That is simpler routing but creates an unnecessary second service URL for the initial local deployment.

### Persist Synapse identity and state deliberately

Synapse state must not be treated as disposable container state. The implementation must persist at least:

- the SQLite database
- media store
- generated signing key
- homeserver configuration or equivalent generated runtime config

The implementation should either use a durable host directory or a Docker volume plus an explicit initialization path. The chosen approach must avoid regenerating Synapse signing keys during normal redeploys.

### Keep bootstrap registration configurable

Registration should be enabled initially so local users can create accounts through Element Web. The role should expose a variable such as `matrix_enable_registration` so registration can be disabled after bootstrap without changing templates by hand.

Registration should not depend on email, CAPTCHA, or external identity providers in the initial implementation.

## Risks / Trade-offs

- SQLite performance limits growth -> Keep the deployment local and small; document Postgres as the migration path if usage increases.
- Open registration is unsafe if the service becomes reachable beyond the LAN -> Make registration a variable and disable it after bootstrap.
- Synapse signing key loss changes server identity -> Persist the key and avoid destructive volume recreation; include backup guidance in the role notes or tasks.
- Caddy routing for one hostname and two services is more complex than existing one-service routes -> Validate generated Caddy config or deployed behavior during implementation.
- Browser clients need HTTPS and correct base URL configuration -> Serve Element Web only through Caddy HTTPS and set Synapse `public_baseurl` to `https://matrix.echocharlie.xyz/`.

## Migration Plan

1. Add the Matrix role and templates without changing existing service behavior.
2. Add the role to the Raspberry Pi 5 play.
3. Deploy the stack and verify Element Web loads over HTTPS.
4. Register the initial local users while bootstrap registration is enabled.
5. Disable registration by changing the role variable and redeploying.

Rollback is to remove the Matrix role from the play and redeploy. The persistent Matrix state should be left intact unless intentionally deleting the service and its history.

## Open Questions

- Which exact Synapse and Element Web image tags should be pinned during implementation?
- Should Synapse runtime state use a host bind directory for easier backup, or named Docker volumes for consistency with most existing roles?
