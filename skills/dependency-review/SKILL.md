---
name: dependency-review
description: "Use when adding new packages, reviewing npm install or pip install, or evaluating third-party dependencies. Checks security (CVEs), licensing, maintenance status, and supply chain risks before approving new dependencies."
license: MIT
metadata:
  author: "nara-governance"
  category: "dependencies"
  languages: "all"
---

# Dependency Review Skill

When a new dependency is being added, perform this review.

## Checklist

### 1. Security
- No known CVEs (check npm audit / pip audit / Snyk)
- Package name is correct (no typosquatting)
- Maintainer is reputable (org-backed or well-known)
- No suspicious post-install scripts

### 2. Maintenance
- Last published within 12 months
- Active maintainers (>1)
- GitHub stars > 500 (for non-internal packages)
- Open issues being triaged

### 3. Licensing
- License compatible with project (MIT, Apache 2.0, ISC preferred)
- No GPL/AGPL without legal review
- No proprietary licenses for production deps

### 4. Necessity
- Cannot be achieved with existing dependencies
- Not duplicating functionality already present
- Minimal dependency tree (avoid bloat)

### 5. Integration
- Compatible with current Node/Python version
- No conflicting peer dependencies
- Pinned to exact version in lockfile

## Output Format

```markdown
## Dependency Review: {package_name}@{version}

| Check | Status | Notes |
|-------|--------|-------|
| Security (CVEs) | ✅/❌ | ... |
| Typosquatting | ✅/❌ | ... |
| Maintenance | ✅/❌ | Last published: ... |
| License | ✅/❌ | License: ... |
| Necessity | ✅/❌ | ... |
| Compatibility | ✅/❌ | ... |

**Recommendation**: APPROVE / REJECT / NEEDS_REVIEW
**Reason**: ...
```
