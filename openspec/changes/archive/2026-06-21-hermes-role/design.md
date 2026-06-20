## Context

The repository deploys homelab services as small Ansible roles that render Docker Swarm Compose templates and expose HTTP services through the shared `caddy` overlay network. Matrix already runs at `https://matrix.echocharlie.xyz` and provides the homeserver Hermes should use.

Hermes Agent's Docker image stores mutable state under `/opt/data` and supports running a persistent `gateway run` process. Its Matrix adapter uses Matrix credentials supplied through environment variables and supports user and room allowlists.

## Goals / Non-Goals

**Goals:**

- Deploy Hermes Agent as a single Swarm service managed by a new Ansible role.
- Persist all Hermes mutable state in a stack volume mounted at `/opt/data`.
- Connect Hermes to the local Matrix homeserver with a dedicated bot access token.
- Restrict Matrix usage to configured users and, when configured, rooms.
- Expose the dashboard and API only through explicit configuration.
- Follow existing role patterns with the smallest useful file set.

**Non-Goals:**

- Automate Matrix bot account creation or token generation.
- Add Matrix federation or change the Matrix homeserver deployment.
- Enable Matrix end-to-end encryption in the first implementation.
- Build a custom Hermes image or install extra tools at deploy time.
- Manage multiple Hermes profiles or separate gateway containers.

## Decisions

1. Use one Hermes container running `gateway run`.

   The official image supervises gateway and optional dashboard processes inside the container, so one Swarm service is enough. A service-per-profile layout adds deployment surface without solving a current requirement.

   Alternative considered: multiple containers or profiles. This is only useful once distinct isolation or per-profile API ports are needed.

2. Store Hermes state in a Docker named volume at `/opt/data`.

   This matches the Hermes Docker contract and the existing repo pattern for app data. It preserves config, sessions, memory, skills, logs, and Matrix crypto/cache state across stack redeploys.

   Alternative considered: bind mount to a host path. Existing roles mostly use named stack volumes, so a named volume keeps this role consistent.

3. Keep Matrix account bootstrap manual.

   The role will consume a Vault-backed Matrix access token for `@hermes:matrix.echocharlie.xyz`. Creating the account and token through Ansible would require Synapse admin assumptions that are not currently modeled in the Matrix role.

   Alternative considered: automate registration through Synapse shared-secret registration. That couples this role to Synapse internals and token rotation flow.

4. Configure Matrix hardening through environment variables.

   `MATRIX_ALLOWED_USERS` is required, `MATRIX_ALLOWED_ROOMS` is optional, `MATRIX_REQUIRE_MENTION` stays enabled, and `MATRIX_SESSION_SCOPE=room` keeps room context stable.

   Alternative considered: generate Hermes config files. Environment variables are the documented path for gateway platform setup and avoid another template.

5. Expose only requested surfaces through Caddy.

   The Matrix bot works without host ports. The dashboard can be exposed at `hermes.echocharlie.xyz` when enabled. The OpenAI-compatible API can be exposed separately only if trusted clients need it.

   Alternative considered: publish Docker ports directly. The repo already centralizes HTTP ingress through Caddy labels.

6. Pin the Hermes image tag.

   Existing roles pin images instead of using `latest`. The first implementation should use a versioned Hermes tag and update it explicitly later.

   Alternative considered: `latest`. It is simpler initially but makes redeploy behavior less predictable.

## Risks / Trade-offs

- Matrix token expires or is revoked -> Hermes will fail to authenticate; rotate the Vault value and redeploy.
- Missing or broad Matrix allowlists -> unauthorized users may trigger agent work; require `MATRIX_ALLOWED_USERS` and document room allowlists for shared rooms.
- Optional dashboard/API exposure increases attack surface -> keep both disabled unless configured, and route only through Caddy.
- No first-pass E2EE support -> encrypted Matrix rooms will not be supported initially; add `MATRIX_E2EE_MODE` and recovery-key handling later if needed.
- Named volume hides file ownership issues until runtime -> rely on the official image's `/opt/data` ownership handling and verify with a deployed gateway check.

## Migration Plan

1. Create a Matrix bot account manually on the existing homeserver.
2. Generate a Matrix access token for the bot account.
3. Store the token and allowed Matrix users in `vault/hermes.yml`.
4. Deploy the Hermes role with dashboard/API exposure disabled or explicitly configured.
5. Invite `@hermes:matrix.echocharlie.xyz` to the desired Matrix room or DM.
6. Send a test message from an allowed user and confirm Hermes replies.

Rollback is removing the Hermes role from the playbook and redeploying. The Hermes stack volume can be left in place for later recovery or removed manually if the state is no longer needed.

## Open Questions

- Should the dashboard domain be `hermes.echocharlie.xyz`?
- Should the OpenAI-compatible API be exposed through Caddy now, or kept internal-only?
- Which Matrix room IDs should be included in the initial allowed-room list?
