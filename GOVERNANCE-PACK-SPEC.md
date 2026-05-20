# Governance Pack Specification — @femsa/ai-governance CLI

> Versión: 3.0.0 | Fecha: 2026-05-19
> Estándar: AAIF/Linux Foundation Skills Directory + MCP 2025-06-18 + A2A 1.0
> Investigación: 200+ fuentes enterprise 2026 (OpenAI, Anthropic, DeepSeek, AAIF, MCP, Google A2A)

---

## 1. PROBLEMA ACTUAL

El comando `generate --country CL --force` produce solo **3 archivos genéricos** en modo fallback:
- `.kiro/steering/project-context.md` (template vacío)
- `.kiro/steering/security.md` (reglas genéricas)
- `.kiro/steering/tech.md` (auto-detectado)

**NO genera**: skills, hooks, ni AGENTS.md personalizado por stack.

### Root Cause
```
generate.ts → callBackendGenerate() → timeout/error → fallback mode
                                                       └── Solo 2 steering estáticos + tech.md
```

El `fetchProfileFiles()` en `template-fetcher.ts` retorna `null` (marcado `@deprecated v2.0`).
Los perfiles completos existen en `profiles/{name}/` pero **nunca se leen** durante fallback.

---

## 2. ARQUITECTURA PROPUESTA

### Flujo Corregido

```
ai-gov generate --profile eks-nodejs --country CL --force
  │
  ├─► Step 1: detectStack() → fileManifest + stack
  ├─► Step 2: matchProfile() → profileName + confidence
  ├─► Step 3: callBackendGenerate() → GovernancePack (AI-powered)
  │     │
  │     └── Si falla/timeout:
  │           └─► Step 3b: generateFromProfile(profileName) → GovernancePack (local)
  │                 ├── Lee profiles/{name}/AGENTS.md
  │                 ├── Lee profiles/{name}/.kiro/steering/*
  │                 ├── Lee profiles/{name}/.kiro/skills/*
  │                 ├── Lee profiles/{name}/.kiro/hooks/*
  │                 └── Aplica country overlay (si existe)
  │
  ├─► Step 4: writeGovernancePack() → archivos en disco
  └─► Step 5: writeConfig() → .ai-governance.json
```

### Diferencia Clave: Backend vs Local

| Aspecto | Backend (AI-powered) | Local (Fallback) |
|---------|---------------------|------------------|
| Source | Generator Agent + RAG | profiles/ bundled |
| Personalización | Alta (usa context del repo) | Media (template + country) |
| Skills/Hooks | Generados dinámicamente | Copiados de template |
| AGENTS.md | Personalizado con deps reales | Template con placeholders resueltos |
| Disponibilidad | Requiere red + backend activo | Siempre disponible |

---

## 3. ESTÁNDAR AAIF 2026 — SKILLS DIRECTORY

### 3.1 Skill File Schema (AAIF Skills Directory v1.0)

```yaml
---
name: "skill-name"
version: "1.0.0"
description: "What this skill does"
triggers:
  - "keyword that activates"
  - "otro keyword"
applies_to:
  languages: ["typescript", "python"]  # o ["*"]
  categories: ["security", "code-review"]
inclusion: auto  # auto | manual | fileMatch
fileMatchPattern: "*.ts"  # solo si inclusion: fileMatch
---

# Skill Title

## Context
When and why this skill activates.

## Instructions
Step-by-step instructions for the AI agent.

## Output Format
Expected output structure.
```

### 3.2 Hook File Schema (Kiro Hooks v1.0)

```json
{
  "name": "Human-readable name",
  "version": "1.0.0",
  "description": "What triggers and why",
  "when": {
    "type": "fileEdited | fileCreated | preToolUse | postToolUse | userTriggered | promptSubmit | agentStop | preTaskExecution | postTaskExecution",
    "patterns": ["*.ts", "*.tsx"],
    "toolTypes": ["write", "shell", "read", "web", "spec", "*"]
  },
  "then": {
    "type": "askAgent | runCommand",
    "prompt": "Instructions for askAgent",
    "command": "shell command for runCommand"
  }
}
```

### 3.3 AGENTS.md Schema (AAIF/Linux Foundation v1.0)

Secciones obligatorias (en orden):
1. **Identity** — Org, tipo de servicio, runtime, deploy, CI
2. **Build** — Comandos exactos para build/lint/test
3. **Project Structure** — Layout de archivos con explicación
4. **Conventions** — Reglas de código, branching, commits, security
5. **Deployment** — Cómo se deploya, environments, pipelines
6. **Constraints** — Qué NO hacer (bloqueos explícitos)
7. **Agent Autonomy** — Nivel de autonomía, allowed/blocked actions

---

## 4. CATÁLOGO DE SKILLS POR PERFIL

### Catálogo Maestro de Skills

| Skill | Descripción | Perfiles que lo usan |
|-------|-------------|---------------------|
| `code-review.md` | Revisión de código con checklist por stack | TODOS |
| `security-scan.md` | Escaneo OWASP + agentic top 10 | TODOS |
| `dependency-review.md` | Revisión de dependencias, CVEs, bundle size | eks-nodejs, lambda-nodejs, frontend-react |
| `architecture-review.md` | Validación de capas y boundaries | eks-nodejs, service-ecs-hub, frontend-react |
| `pr-description.md` | Generación de PR description | TODOS |
| `performance-review.md` | Cold start, bundle size, latencia | lambda-nodejs, lambda-python, frontend-react |
| `container-review.md` | Dockerfile best practices, image size | eks-nodejs, service-ecs-hub |
| `helm-review.md` | Chart validation, resource limits | helm-infra, service-ecs-hub |
| `terraform-review.md` | Module compliance, state safety | terraform-module |
| `mobile-review.md` | Platform-specific patterns | android-kotlin, ios-swift |
| `accessibility-review.md` | WCAG 2.1 AA compliance | frontend-react |
| `api-contract-review.md` | OpenAPI/schema validation | eks-nodejs, service-ecs-hub |

### Skills por Perfil (Mínimo 2, Recomendado 3-4)

| Perfil | Skills |
|--------|--------|
| **eks-nodejs** | code-review, security-scan, dependency-review, container-review |
| **service-ecs-hub** | code-review, security-scan, architecture-review, container-review |
| **lambda-nodejs** | code-review, security-scan, dependency-review, performance-review |
| **lambda-python** | code-review, security-scan, dependency-review, performance-review |
| **frontend-react** | code-review, security-scan, accessibility-review, performance-review |
| **terraform-module** | code-review, security-scan, terraform-review |
| **helm-infra** | code-review, security-scan, helm-review |
| **android-kotlin** | code-review, security-scan, mobile-review |
| **ios-swift** | code-review, security-scan, mobile-review |
| **generic** | code-review, security-scan, pr-description |

---

## 5. CATÁLOGO DE HOOKS POR PERFIL

### Catálogo Maestro de Hooks

| Hook | Tipo | Descripción | Perfiles |
|------|------|-------------|----------|
| `lint-on-save.json` | fileEdited | Lint al guardar | TODOS (varía el comando) |
| `security-gate.json` | preToolUse/write | Verifica seguridad antes de escribir | TODOS |
| `conventional-commits.json` | preToolUse/shell | Valida formato de commits | TODOS |
| `test-after-task.json` | postTaskExecution | Ejecuta tests después de completar task | eks-nodejs, lambda-*, frontend-react |
| `accessibility-check.json` | fileEdited | Verifica a11y en componentes | frontend-react |
| `bundle-size-check.json` | fileEdited | Verifica impacto en bundle | lambda-nodejs, frontend-react |
| `terraform-plan.json` | fileEdited/*.tf | Ejecuta `terraform plan` | terraform-module |
| `helm-lint.json` | fileEdited/*.yaml | Ejecuta `helm lint` | helm-infra |
| `dockerfile-lint.json` | fileEdited/Dockerfile* | Lint de Dockerfile | eks-nodejs, service-ecs-hub |
| `gradle-sync.json` | fileEdited/*.gradle* | Sync Gradle después de cambios | android-kotlin |
| `swiftlint.json` | fileEdited/*.swift | SwiftLint al guardar | ios-swift |

### Hooks por Perfil (Mínimo 2, Recomendado 3)

| Perfil | Hooks |
|--------|-------|
| **eks-nodejs** | lint-on-save, security-gate, conventional-commits |
| **service-ecs-hub** | lint-on-save, security-gate, dockerfile-lint |
| **lambda-nodejs** | lint-on-save, security-gate, bundle-size-check |
| **lambda-python** | lint-on-save, security-gate, test-after-task |
| **frontend-react** | lint-on-save, security-gate, accessibility-check |
| **terraform-module** | lint-on-save, security-gate, terraform-plan |
| **helm-infra** | lint-on-save, security-gate, helm-lint |
| **android-kotlin** | lint-on-save, security-gate, gradle-sync |
| **ios-swift** | lint-on-save, security-gate, swiftlint |
| **generic** | lint-on-save, security-gate, conventional-commits |

---

## 6. ESTRUCTURA COMPLETA POR PERFIL

### Template Directory Canónico

```
profiles/{profile-name}/
├── AGENTS.md                          # AAIF v1.0 (7 secciones obligatorias)
├── profile.json                       # Metadata: detection, priority, runtime, tags
└── .kiro/
    ├── steering/
    │   ├── code-standards.md          # inclusion: auto — siempre cargado
    │   ├── {stack-specific}.md        # inclusion: auto o fileMatch
    │   └── security.md               # inclusion: auto (si no existe global)
    ├── skills/
    │   ├── code-review.md            # inclusion: auto — review genérica + stack
    │   ├── security-scan.md          # inclusion: auto — OWASP + agentic
    │   └── {profile-specific}.md     # skills adicionales por perfil
    └── hooks/
        ├── lint-on-save.json         # fileEdited → runCommand
        ├── security-gate.json        # preToolUse/write → askAgent
        └── {profile-specific}.json   # hooks adicionales por perfil
```

### Archivos Generados por Comando

| Comando | Archivos que genera |
|---------|-------------------|
| `init` | `.kiro/steering/`, `.kiro/skills/`, `.kiro/hooks/`, `.ai-context/` (7 templates), `AGENTS.md` (genérico), `.ai-governance.json` |
| `generate` | `.kiro/steering/*` (profile), `.kiro/skills/*` (profile), `.kiro/hooks/*` (profile), `AGENTS.md` (profile), `.kiro/steering/tech.md` (auto), `.ai-governance.json` (updated) |
| `validate` | `.ai-governance/validation-report.json` (output only) |
| `discover` | `.ai-governance/stack.json`, `.ai-governance/meta.json`, `.ai-governance/architecture.json`, `.ai-governance/risks.json` |

---

## 7. MEJORA DEL GENERATOR: FALLBACK LOCAL CON CONTENIDO REAL

### 7.1 Implementación de `generateFromProfile()`

El fallback actual genera 3 archivos vacíos. La mejora:

```typescript
// Nueva función en generate.ts
async function generateFromProfile(
  profileName: string,
  country?: string,
  stack?: StackInfo,
): Promise<GovernancePack> {
  const profileDir = resolveProfileDir(profileName); // Bundled con CLI o en node_modules
  
  // 1. Leer AGENTS.md del perfil
  const agentsMd = await readProfileFile(profileDir, 'AGENTS.md');
  
  // 2. Leer todos los steering files
  const steeringFiles = await readProfileDir(profileDir, '.kiro/steering/');
  
  // 3. Leer todos los skill files
  const skillFiles = await readProfileDir(profileDir, '.kiro/skills/');
  
  // 4. Leer todos los hook files
  const hookFiles = await readProfileDir(profileDir, '.kiro/hooks/');
  
  // 5. Aplicar country overlay (si existe)
  if (country) {
    const overlay = await loadCountryOverlay(profileName, country);
    if (overlay) {
      // Merge overlay steering, extend AGENTS.md Identity section
    }
  }
  
  // 6. Template interpolation (reemplazar placeholders con stack real)
  const interpolated = interpolateTemplates({
    agentsMd,
    steeringFiles,
    skillFiles,
    hookFiles,
    context: { stack, country, repoName: path.basename(process.cwd()) },
  });
  
  return interpolated;
}
```

### 7.2 Bundling de Profiles en el CLI

**Opción A (Recomendada)**: Incluir profiles/ en el package del CLI vía `tsup` + `files` en package.json.

```json
// package.json
{
  "files": ["dist/", "profiles/"]
}
```

**Opción B**: Profiles como dependencia separada (`@femsa/ai-governance-profiles`).

### 7.3 Country Overlays

```
profiles/{profile-name}/
└── overlays/
    ├── CL.json    # Chile: timezone, currency, SII integration
    ├── CO.json    # Colombia: DIAN, timezone
    ├── EC.json    # Ecuador: SRI, timezone
    └── MX.json    # Mexico: SAT, timezone
```

Cada overlay extiende la sección Identity del AGENTS.md y puede agregar steering files adicionales con regulaciones locales.

---

## 8. CONTENIDO REAL DE SKILLS (Ejemplos Completos)

### 8.1 performance-review.md (Lambda/Frontend)

```yaml
---
name: "performance-review"
version: "1.0.0"
description: "Review code for performance impact: cold starts, bundle size, latency"
triggers:
  - "performance"
  - "cold start"
  - "bundle size"
  - "latency"
  - "rendimiento"
applies_to:
  languages: ["typescript", "python"]
  categories: ["performance", "optimization"]
inclusion: auto
---

# Performance Review Skill

## Context
Activates when reviewing changes that may impact runtime performance.

## Lambda-Specific Checks
- [ ] No top-level imports of heavy libraries (lazy load instead)
- [ ] Connection reuse (keep-alive, connection pooling outside handler)
- [ ] Handler function is lightweight (< 50ms cold path)
- [ ] Environment variables read at module level, not per-invocation
- [ ] Bundle size < 50MB (warn at 30MB)
- [ ] No synchronous file I/O in handler path

## Frontend-Specific Checks
- [ ] Dynamic imports for non-critical components
- [ ] Images optimized (next/image or responsive)
- [ ] No layout shifts (CLS < 0.1)
- [ ] First contentful paint path minimal
- [ ] Server Components used where possible (no unnecessary "use client")
- [ ] No large dependencies in client bundle (check with bundle analyzer)

## Output
Rate: PASS | WARN | FAIL with specific metrics affected.
```

### 8.2 container-review.md (EKS/ECS)

```yaml
---
name: "container-review"
version: "1.0.0"
description: "Dockerfile and container best practices for EKS/ECS workloads"
triggers:
  - "dockerfile"
  - "container"
  - "docker"
  - "image"
applies_to:
  languages: ["dockerfile"]
  categories: ["infrastructure", "security"]
inclusion: fileMatch
fileMatchPattern: "Dockerfile*"
---

# Container Review Skill

## Checks
- [ ] Multi-stage build (builder → runtime)
- [ ] Runtime image is minimal (alpine or distroless)
- [ ] Non-root user (`USER node` or `USER 1001`)
- [ ] HEALTHCHECK instruction present
- [ ] No secrets in build args or ENV
- [ ] .dockerignore exists and excludes node_modules, .git, .env
- [ ] Pinned base image version (no :latest)
- [ ] Layer ordering optimized (deps before code)
- [ ] COPY --chown used for proper permissions
```

---

## 9. CONTENIDO REAL DE HOOKS (Ejemplos Completos)

### 9.1 bundle-size-check.json

```json
{
  "name": "Bundle Size Check",
  "version": "1.0.0",
  "description": "Verify bundle size impact when package.json or source files change",
  "when": {
    "type": "fileEdited",
    "patterns": ["package.json", "package-lock.json", "src/**/*.ts"]
  },
  "then": {
    "type": "askAgent",
    "prompt": "Check if recent changes affect bundle size. For Lambda: verify total bundle stays under 50MB (warn at 30MB). For frontend: verify no heavy library added to client bundle without dynamic import. Run: npx bundlesize (if configured) or estimate impact from added dependencies."
  }
}
```

### 9.2 terraform-plan.json

```json
{
  "name": "Terraform Plan on Save",
  "version": "1.0.0",
  "description": "Run terraform plan when .tf files are modified",
  "when": {
    "type": "fileEdited",
    "patterns": ["*.tf", "*.tfvars"]
  },
  "then": {
    "type": "runCommand",
    "command": "terraform fmt -check && terraform validate"
  }
}
```

### 9.3 helm-lint.json

```json
{
  "name": "Helm Lint on Save",
  "version": "1.0.0",
  "description": "Run helm lint when chart templates or values change",
  "when": {
    "type": "fileEdited",
    "patterns": ["templates/**/*.yaml", "values.yaml", "Chart.yaml"]
  },
  "then": {
    "type": "runCommand",
    "command": "helm lint ."
  }
}
```

### 9.4 gradle-sync.json

```json
{
  "name": "Gradle Sync Check",
  "version": "1.0.0",
  "description": "Remind to sync Gradle when build files change",
  "when": {
    "type": "fileEdited",
    "patterns": ["*.gradle", "*.gradle.kts", "gradle.properties"]
  },
  "then": {
    "type": "askAgent",
    "prompt": "Build configuration files changed. Verify: 1) Dependencies are compatible with target SDK version. 2) No deprecated APIs introduced. 3) ProGuard/R8 rules updated if new libraries added. Suggest running: ./gradlew dependencies --configuration releaseRuntimeClasspath"
  }
}
```

### 9.5 swiftlint.json

```json
{
  "name": "SwiftLint on Save",
  "version": "1.0.0",
  "description": "Run SwiftLint when Swift files are saved",
  "when": {
    "type": "fileEdited",
    "patterns": ["*.swift"]
  },
  "then": {
    "type": "runCommand",
    "command": "swiftlint lint --path ${file} --quiet"
  }
}
```

---

## 10. FLUJO POR COMANDO CLI

### 10.1 `init` — Primera vez en un repo

```
ai-gov init
  → Crea estructura .kiro/ vacía
  → Crea .ai-context/ con 7 templates
  → Crea AGENTS.md genérico (placeholder)
  → Crea .ai-governance.json (config base)
  → NO genera contenido personalizado (requiere generate)
```

### 10.2 `generate` — Genera governance pack completo

```
ai-gov generate [--profile NAME] [--country CODE] [--force]
  → detectStack() → stack + fileManifest
  → matchProfile() → profileName
  → TRY: callBackendGenerate() → GovernancePack (AI-powered con RAG)
    └── ON FAIL: generateFromProfile() → GovernancePack (local bundled)
  → writeGovernancePack() → escribe AGENTS.md + steering + skills + hooks
  → updateConfig() → .ai-governance.json
```

### 10.3 `validate` — Valida compliance

```
ai-gov validate [--ci]
  → Lee AGENTS.md → valida secciones AAIF (7 obligatorias)
  → Lee .kiro/steering/ → valida ≥2 archivos con front-matter válido
  → Lee .kiro/skills/ → valida ≥2 archivos con schema correcto
  → Lee .kiro/hooks/ → valida ≥2 archivos con JSON schema
  → Security checks (secrets, .env en .gitignore)
  → Genera report → .ai-governance/validation-report.json
  → Si --ci: exit code 1 en error
```

---

## 11. MEJORA DEL BACKEND (Generator Agent con RAG)

### 11.1 Qué debe hacer el Generator Agent

Cuando el CLI llama a `POST /governance/generate`, el backend:

1. **Recibe**: repo_id, repo_name, stack, file_manifest, dependencies, stack_hash
2. **Busca en RAG**: Perfiles similares, patrones de la org, steering ya generados
3. **Genera personalizado**:
   - AGENTS.md con dependencias REALES del repo
   - Steering con reglas específicas para las librerías detectadas
   - Skills con checks relevantes al stack exacto
   - Hooks con comandos reales del repo (lint, test, build)
4. **Retorna**: GovernancePack completo

### 11.2 RAG Sources para Generator Agent

| Source | Tipo | Contenido |
|--------|------|-----------|
| `profiles/` directory | Embeddings | Templates base por perfil |
| `ai-governance-templates/steering/` | Embeddings | Steering patterns globales |
| `ai-governance-templates/skills/` | Embeddings | Skill templates globales |
| Histórico de generaciones | Vector DB | Governance packs ya generados para repos similares |
| Dependencias (npm/pip) | Lookup | Best practices por librería |
| OWASP Top 10 + Agentic Top 10 | Static | Security checklist |
| FEMSA conventions | Static | Org-specific patterns |

---

## 12. IMPLEMENTACIÓN INCREMENTAL

### Fase 1 (Inmediata): Fallback Local con Contenido Real
- [ ] Restaurar `fetchProfileFiles()` para leer de profiles/ bundled
- [ ] Implementar `generateFromProfile()` en generate.ts
- [ ] Asegurar que fallback genera ≥1 AGENTS.md + ≥2 steering + ≥2 skills + ≥2 hooks
- [ ] Bundling de profiles/ en el CLI package

### Fase 2: Country Overlays
- [ ] Crear estructura overlays/ por perfil
- [ ] Implementar merge de overlays en generateFromProfile()
- [ ] Steering adicional por país (regulaciones locales)

### Fase 3: Backend Generator Agent Mejorado
- [ ] RAG con profiles + steering + skills como fuente
- [ ] Personalización basada en dependencies reales
- [ ] Template interpolation con stack detectado
- [ ] Histórico de generaciones para mejora continua

### Fase 4: Validación AAIF Completa
- [ ] Validate secciones obligatorias de AGENTS.md (7)
- [ ] Validate schema de skills (front-matter)
- [ ] Validate schema de hooks (JSON)
- [ ] Validate file counts por perfil (mínimos)
- [ ] Property-based tests (fast-check)

---

## 13. PROFILES COMPLETOS — ESTADO ACTUAL VS REQUERIDO

| Perfil | AGENTS.md | Steering (≥2) | Skills (≥2) | Hooks (≥2) | profile.json | Estado |
|--------|-----------|---------------|-------------|------------|--------------|--------|
| eks-nodejs | ✅ | ✅ (3) | ✅ (2) | ✅ (2) | ✅ | ✅ Completo |
| frontend-react | ✅ | ✅ (2) | ✅ (2) | ✅ (2) | ✅ | ✅ Completo |
| service-ecs-hub | ✅ | ✅ (2+) | ✅ (2+) | ✅ (2+) | ✅ | ✅ Completo |
| lambda-nodejs | ✅ | ✅ (2+) | ✅ (2+) | ✅ (2+) | ✅ | ✅ Completo |
| android-kotlin | ✅ | ✅ (2+) | ✅ (2+) | ✅ (2+) | ✅ | ✅ Completo |
| ios-swift | ✅ | ✅ (2+) | ✅ (2+) | ✅ (2+) | ✅ | ✅ Completo |
| helm-infra | ✅ | ✅ (2+) | ✅ (2+) | ✅ (2+) | ✅ | ✅ Completo |
| terraform-module | ✅ | ✅ (2+) | ✅ (2+) | ✅ (2+) | ✅ | ✅ Completo |
| lambda-python | ✅ | ⚠️ (1?) | ❌ (0) | ⚠️ (1?) | ❌ | 🔴 Incompleto |
| generic | ✅ | ⚠️ (1?) | ❌ (0) | ⚠️ (1?) | ❌ | 🔴 Incompleto |

**Acción requerida**: Completar lambda-python y generic con skills + hooks + profile.json.

---

## 14. RESUMEN EJECUTIVO

### Qué falta para que `generate` produzca contenido real:

1. **Restaurar lectura local de profiles/** — La función `fetchProfileFiles()` fue deprecada pero los profiles existen. Reimplementar para que el fallback lea los templates completos.

2. **Completar 2 perfiles incompletos** — lambda-python y generic necesitan skills/ y hooks/.

3. **Implementar `generateFromProfile()`** — Función que construye un GovernancePack desde el profile directory, con template interpolation básica.

4. **Country overlays** — Estructura para personalización por país (FEMSA opera en CL, CO, EC, MX).

5. **Bundling** — Incluir profiles/ en el npm package del CLI.

### Output esperado post-fix:

```bash
$ ai-gov generate --profile eks-nodejs --country CL --force

  AI Governance — Generate
  Mode:     local-profile
  Profile:  eks-nodejs
  Country:  CL
  Files:    9 created, 0 skipped

  Files created:
    ✔ AGENTS.md
    ✔ .kiro/steering/code-standards.md
    ✔ .kiro/steering/deployment.md
    ✔ .kiro/steering/femsa-conventions.md
    ✔ .kiro/steering/tech.md (auto-filled)
    ✔ .kiro/skills/code-review.md
    ✔ .kiro/skills/security-scan.md
    ✔ .kiro/hooks/lint-on-save.json
    ✔ .kiro/hooks/security-gate.json
```
