## 1. Role Structure

- [x] 1.1 Create `roles/hermes/tasks/main.yml` to deploy the `hermes` Docker stack and notify image pruning.
- [x] 1.2 Create `roles/hermes/templates/compose.yaml` with one Hermes service, a persistent `data` volume mounted at `/opt/data`, and the shared external `caddy` network.
- [x] 1.3 Create `roles/hermes/meta/main.yml` with the existing `common` role dependency.

## 2. Configuration

- [x] 2.1 Add `roles/hermes/defaults/main.yml` with the Hermes image tag, Matrix homeserver, bot user ID, allowed users, allowed rooms, dashboard/API exposure toggles, and hostnames.
- [x] 2.2 Add `vault/hermes.yml` for the Matrix bot access token and any dashboard/API secrets needed by enabled surfaces.
- [x] 2.3 Update `site.yml` to load `vault/hermes.yml` and include the `hermes` role in the Raspberry Pi 5 play.

## 3. Compose Behavior

- [x] 3.1 Render the Hermes service with `command: gateway run` and a pinned `nousresearch/hermes-agent` image tag.
- [x] 3.2 Pass Matrix gateway environment variables for homeserver, access token, allowed users, optional allowed rooms, mention-required behavior, and room-scoped sessions.
- [x] 3.3 Add Caddy labels for the dashboard only when dashboard exposure is enabled.
- [x] 3.4 Add Caddy labels for the OpenAI-compatible API only when API exposure is enabled.
- [x] 3.5 Add the existing node placement constraint using `ansible_facts['hostname']`.

## 4. Validation

- [x] 4.1 Run `ansible-lint site.yml`.
- [x] 4.2 Run a syntax or template check that renders the Hermes Compose template without missing variables.
- [x] 4.3 Document the manual Matrix bot bootstrap steps needed before first deploy.
