## 1. Role Structure

- [x] 1.1 Create the `matrix` Ansible role directory structure with `tasks`, `templates`, `defaults`, and `meta` files matching existing role conventions.
- [x] 1.2 Add Matrix role defaults for hostname, server name, Synapse image tag, Element Web image tag, registration toggle, and persistent state path or volume names.
- [x] 1.3 Add Matrix vault variables for Synapse secrets needed by the rendered homeserver configuration.

## 2. Synapse Configuration

- [x] 2.1 Add a Synapse homeserver configuration template for `matrix.echocharlie.xyz` with `public_baseurl`, reverse-proxy listener settings, SQLite storage, and configurable registration.
- [x] 2.2 Ensure Synapse signing identity, SQLite database, media store, and runtime state persist across redeploys.
- [x] 2.3 Add initialization logic if required so Synapse configuration and signing keys are created once and not regenerated during normal stack updates.

## 3. Element Web Configuration

- [x] 3.1 Add an Element Web `config.json` template that sets `https://matrix.echocharlie.xyz` as the default homeserver.
- [x] 3.2 Add Ansible tasks to publish the Element Web config through the same Docker config pattern used by existing roles where appropriate.

## 4. Stack Deployment

- [x] 4.1 Add a Matrix stack compose template with Synapse and Element Web services on the external `caddy` overlay network.
- [x] 4.2 Add Caddy Docker labels so `/_matrix/*` and `/_synapse/client/*` route to Synapse and other requests route to Element Web.
- [x] 4.3 Add node placement constraints consistent with the other Raspberry Pi 5 service roles.
- [x] 4.4 Ensure the stack does not publish Matrix federation port `8448`.

## 5. Playbook Integration

- [x] 5.1 Add `vault/matrix.yml` to the Raspberry Pi 5 play vars file list.
- [x] 5.2 Add the `matrix` role to the Raspberry Pi 5 role list in `site.yml`.

## 6. Verification

- [x] 6.1 Run Ansible syntax or lint checks for the updated playbook and role.
- [x] 6.2 Deploy or render-check the Matrix stack and verify generated compose/config structure.
- [ ] 6.3 Verify `https://matrix.echocharlie.xyz` serves Element Web.
- [ ] 6.4 Verify Matrix client API requests under `/_matrix/` reach Synapse.
- [ ] 6.5 Verify a local user can register while registration is enabled.
- [ ] 6.6 Disable registration through configuration and verify new unauthenticated account creation is rejected.
