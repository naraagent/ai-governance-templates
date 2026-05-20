---
name: pr-description
description: "Use when creating pull request descriptions, writing PR summaries, or documenting code changes. Generates standardized PR descriptions with what changed, why, testing instructions, impact assessment, and compliance checklist."
license: MIT
metadata:
  author: "nara-governance"
  category: "documentation"
  languages: "all"
---

# PR Description Generator Skill

Generate a standardized PR description following enterprise standards.

## Template

```markdown
## Qué cambia
- [Brief description of each logical change]

## Por qué
- [Link to ticket: TICKET-XXX]
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
```

## Rules

1. PR title MUST include ticket reference: `TICKET-123 Description`
2. Description must explain WHAT changed and WHY (not HOW — the code shows how)
3. Testing instructions must be actionable
4. Flag any breaking changes prominently
5. If PR > 400 lines, suggest splitting strategy
