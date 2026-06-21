## ADDED Requirements

### Requirement: Matrix homeserver endpoint

The system SHALL provide a Matrix homeserver at `https://matrix.echocharlie.xyz` using `matrix.echocharlie.xyz` as the Matrix server name.

#### Scenario: Homeserver is reachable

- **WHEN** a client requests Matrix client API endpoints under `https://matrix.echocharlie.xyz/_matrix/`
- **THEN** the request is routed to the Synapse homeserver

#### Scenario: Server name is stable

- **WHEN** a local user account is created
- **THEN** the Matrix user ID uses the `matrix.echocharlie.xyz` server name

### Requirement: Element Web client

The system SHALL host Element Web at `https://matrix.echocharlie.xyz` and configure it to use the local Synapse homeserver by default.

#### Scenario: User opens the Matrix site

- **WHEN** a user visits `https://matrix.echocharlie.xyz`
- **THEN** Element Web loads in the browser

#### Scenario: Element uses local homeserver

- **WHEN** Element Web starts
- **THEN** its default homeserver is `https://matrix.echocharlie.xyz`

### Requirement: Persistent homeserver state

The system SHALL persist Synapse state across container restarts, stack updates, and image upgrades.

#### Scenario: Stack is redeployed

- **WHEN** the Matrix stack is redeployed
- **THEN** existing accounts, room history, media, SQLite data, and Synapse signing identity remain available

### Requirement: SQLite initial storage

The system SHALL use SQLite for the initial Synapse database storage.

#### Scenario: Synapse starts

- **WHEN** the Synapse service starts
- **THEN** it uses a persisted SQLite database rather than an external Postgres service

### Requirement: Bootstrap registration control

The system SHALL support enabling registration for initial local user bootstrap and disabling registration after bootstrap.

#### Scenario: Bootstrap registration is enabled

- **WHEN** registration is enabled in the role configuration
- **THEN** local users can create accounts through the Matrix client

#### Scenario: Registration is disabled

- **WHEN** registration is disabled in the role configuration
- **THEN** unauthenticated users cannot create new accounts through the Matrix client

### Requirement: Caddy integration

The system SHALL expose Matrix and Element Web through the existing Caddy Docker proxy network.

#### Scenario: Matrix API request is received

- **WHEN** Caddy receives a request for `/_matrix/*` or `/_synapse/client/*` on `matrix.echocharlie.xyz`
- **THEN** Caddy reverse proxies the request to Synapse

#### Scenario: Web client request is received

- **WHEN** Caddy receives a non-Matrix request on `matrix.echocharlie.xyz`
- **THEN** Caddy reverse proxies the request to Element Web

### Requirement: Internal-use deployment

The system SHALL deploy Matrix for local-network use without adding public federation exposure.

#### Scenario: Matrix stack is deployed

- **WHEN** the Matrix role deploys the stack
- **THEN** it does not publish the Matrix federation port `8448`
