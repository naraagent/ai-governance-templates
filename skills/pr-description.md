---
name: "pr-description"
version: "1.0.0"
description: "Generate standardized PR descriptions following FEMSA template"
triggers:
  - "PR description"
  - "pull request description"
  - "describir PR"
  - "generar descripción"
applies_to:
  languages: ["*"]
  categories: ["pr", "git", "documentation"]
---

# PR Description Generator Skill

Generate a standardized PR description following FEMSA enterprise standards.

## Template

```markdown
## Qué cambia
- [Brief description of each logical change]

## Por qué
- [Link to Jira ticket: TICKET-XXX]
- [Business context / problem being solved]

## Cómo probar
1. [Step-by-step verification instructions]
2. [Expected behavior]
3. [Edge cases to verify]

## Tipo de cambio
- [ ] Feature (nueva funcionalidad)
- [ ] Fix (corrección de bug)
- [ ] Refactor (no cambia comportamiento)
- [ ] Docs (solo documentación)
- [ ] Chore (mantenimiento, deps, CI)

## Impacto
- **Servicios afectados**: [list]
- **Breaking changes**: [yes/no, details]
- **Requiere migración**: [yes/no, details]

## Checklist
- [ ] Tests agregados/actualizados
- [ ] Sin secrets en el código
- [ ] Lint pasa sin errores
- [ ] Build exitoso
- [ ] Documentación actualizada (si aplica)
- [ ] Reviewed by: @[reviewer]
```

## Rules

1. PR title MUST include Jira ticket: `TICKET-123 Description`
2. Description must explain WHAT changed and WHY (not HOW)
3. Testing instructions must be actionable
4. Flag any breaking changes prominently
5. If PR > 400 lines, suggest splitting strategy
