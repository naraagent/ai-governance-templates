# AGENTS.md — Generic Repository

> Standard: AAIF/Linux Foundation AGENTS.md v1.0
> Compatible: Codex, Copilot, Cursor, Kiro, OpenClaw, Devin, Amp
> Profile: generic | Org: FEMSA Digital

## Identity

- Organization: FEMSA Digital
- Repository: {{REPO_NAME}}
- CI/CD: Jenkins
- Code hosting: Bitbucket (workspace: digitaldifarma)

## Build

```bash
# Adjust per project
npm ci && npm run build && npm test
# or
./gradlew build test
# or
pip install -r requirements.txt && pytest
```

## Conventions

### Security (NON-NEGOTIABLE)
- No hardcoded secrets
- No committed .env or credential files
- HTTPS only
- Input validation required
- Parameterized queries
- Pinned dependencies

### Code Quality
- Explicit error handling
- Structured logging
- Single responsibility
- DRY principle

### Git
- Branch: `type/TICKET-description`
- Commit: `type(scope): description`
- PR: `TICKET-123 Description`
- Target: `develop`

### Testing
- New logic requires tests
- Coverage: 70%+
- Independent, mocked externals
- Behavior-focused names

## Constraints

- Do NOT commit secrets
- Do NOT disable linting without justification
- Do NOT introduce untested business logic
- Do NOT push directly to main/develop

## Agent Governance

- Mode: supervised
- Allowed: read, lint, test, suggest changes
- Blocked: deploy, access secrets, modify CI/CD
- Approval: new dependencies, breaking changes
