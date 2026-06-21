## Purpose
Deploy Hermes Agent as a persistent Matrix-connected gateway service.

## Requirements

### Requirement: Hermes Swarm deployment

The system SHALL deploy Hermes Agent as a Docker Swarm stack through an Ansible role.

#### Scenario: Hermes role is applied

- **WHEN** the Hermes role runs in the Raspberry Pi 5 play
- **THEN** a Docker Swarm stack named `hermes` is deployed

#### Scenario: Hermes service is placed on the target node

- **WHEN** the Hermes stack is deployed
- **THEN** the Hermes service uses a placement constraint for the current Ansible host

### Requirement: Persistent Hermes state

The system SHALL persist Hermes mutable state across container restarts, stack updates, and image upgrades.

#### Scenario: Stack is redeployed

- **WHEN** the Hermes stack is redeployed
- **THEN** Hermes configuration, Matrix credentials, sessions, memory, skills, and logs remain available from the persisted `/opt/data` mount

### Requirement: Hermes gateway mode

The system SHALL run Hermes in persistent gateway mode.

#### Scenario: Hermes container starts

- **WHEN** the Hermes service starts
- **THEN** it runs the Hermes gateway process using `gateway run`

### Requirement: Matrix bot integration

The system SHALL connect Hermes to the existing Matrix homeserver as a dedicated bot account.

#### Scenario: Matrix credentials are configured

- **WHEN** the Hermes gateway starts
- **THEN** it uses `https://matrix.echocharlie.xyz` as the Matrix homeserver
- **AND** it authenticates with the configured Matrix bot access token

#### Scenario: Bot account is invited

- **WHEN** the Hermes Matrix bot is invited to a room
- **THEN** Hermes accepts the invite and can respond to authorized Matrix users in that room

### Requirement: Matrix access controls

The system SHALL restrict who can trigger Hermes through Matrix.

#### Scenario: Allowed Matrix user sends a message

- **WHEN** a Matrix user listed in the Hermes allowed users configuration messages the bot
- **THEN** Hermes processes the message

#### Scenario: Unlisted Matrix user sends a message

- **WHEN** a Matrix user not listed in the Hermes allowed users configuration messages the bot
- **THEN** Hermes does not process the message

#### Scenario: Allowed rooms are configured

- **WHEN** the Hermes allowed rooms configuration contains one or more room IDs
- **THEN** Hermes only responds in those Matrix rooms and direct messages from allowed users

### Requirement: Matrix room behavior

The system SHALL use safe default room behavior for Matrix conversations.

#### Scenario: Message is sent in a shared Matrix room

- **WHEN** an allowed Matrix user sends a room message without mentioning Hermes
- **THEN** Hermes does not respond by default

#### Scenario: Mention is sent in a shared Matrix room

- **WHEN** an allowed Matrix user mentions Hermes in a configured Matrix room
- **THEN** Hermes responds using room-scoped session context

### Requirement: Caddy dashboard exposure

The system SHALL expose the Hermes dashboard through the existing Caddy Docker proxy network only when dashboard exposure is enabled.

#### Scenario: Dashboard exposure is enabled

- **WHEN** the Hermes dashboard is enabled in role configuration
- **THEN** Caddy routes the configured Hermes dashboard hostname to the Hermes dashboard port

#### Scenario: Dashboard exposure is disabled

- **WHEN** the Hermes dashboard is disabled in role configuration
- **THEN** the Hermes stack does not publish a Caddy dashboard route

### Requirement: Optional API exposure

The system SHALL expose the Hermes OpenAI-compatible API endpoint only when API exposure is enabled.

#### Scenario: API exposure is enabled

- **WHEN** Hermes API exposure is enabled in role configuration
- **THEN** Caddy routes the configured API hostname to the Hermes API port

#### Scenario: API exposure is disabled

- **WHEN** Hermes API exposure is disabled in role configuration
- **THEN** the Hermes stack does not publish a Caddy API route

### Requirement: Pinned Hermes image

The system SHALL use an explicit Hermes Agent image tag.

#### Scenario: Compose template is rendered

- **WHEN** the Hermes Compose template is rendered
- **THEN** the Hermes image reference includes a configured version tag rather than `latest`
