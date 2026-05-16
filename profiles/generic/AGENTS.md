# AGENTS.md — Generic Profile

> Standard: AAIF/Linux Foundation AGENTS.md v1.0
> Profile: generic | Org: FEMSA Digital

## Identity

- Organization: FEMSA Digital (Salud, Proximidad)
- Platform: Kubernetes 1.34 on AWS EKS
- CI/CD: Jenkins + Helm + Vault
- Code hosting: Bitbucket (workspace: digitaldifarma)

## Build

```bash
# Most repos
npm install
npm run build
npm test
```

## Conventions

### Branching
- Format: `type/TICKET-descripcion-corta`
- Types: `feature/`, `fix/`, `bugfix/`, `hotfix/`, `release/`, `chore/`
- Integration: `develop` | Production: `main`
- Never push directly to `main` or `develop`

### Commits
- Format: `type(scope): descripción`
- Types: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `perf`, `ci`, `build`
- Max 72 chars, lowercase, imperative, no period
- Breaking changes: `feat(scope)!: description`

### Pull Requests
- Title: `TICKET-123 Clear description of the change`
- Max recommended: 400 lines diff (critical if > 800)
- Target: `develop` (never direct to `main` except hotfix)
- One PR = one ticket/feature

### Security (Critical)
- NEVER hardcode secrets, tokens, passwords, API keys
- NEVER commit `.env`, `credentials.json`, keystores
- All external communication via HTTPS
- All user input validated and sanitized
- SQL queries use prepared statements only
- No MD5/SHA1 for passwords — use bcrypt/argon2/scrypt
- Dependencies pinned to exact versions

### Testing
- All new business logic requires unit tests
- Min coverage target: 70% for new code
- Tests must be independent (no execution order dependency)
- External services always mocked in unit tests
- Test names describe behavior, not implementation

## Constraints

- Do NOT modify files in `vendor/`, `node_modules/`, or generated directories
- Do NOT introduce new dependencies without justification
- Do NOT disable ESLint/linting rules without comment explanation
- Do NOT use `console.log` in production code — use structured logger
- Do NOT catch exceptions silently — always log + handle

## Agent Autonomy

- Level: supervised (changes require human review)
- Allowed: read all files, suggest changes, run linters/tests
- Blocked: deploy, modify CI/CD pipelines, access secrets directly
- Approval required: dependency additions, security-sensitive changes
