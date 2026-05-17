---
name: "dependency-review-lambda"
version: "1.0.0"
description: "Dependency review focused on bundle size impact for Lambda functions"
triggers:
  - "dependency review"
  - "new dependency"
  - "bundle size"
  - "npm install"
applies_to:
  languages: ["typescript", "javascript"]
  categories: ["dependencies", "lambda", "performance"]
---

# Dependency Review — Lambda Node.js

You are reviewing a dependency addition or change in a Lambda Node.js project. Bundle size is CRITICAL for cold start performance.

## Review Checklist

### 1. Size Impact (CRITICAL)
- [ ] Package size (unpacked) < 500KB
- [ ] Does not pull in excessive transitive dependencies (< 10 new)
- [ ] Tree-shakeable (ESM exports)
- [ ] Current bundle + new dep stays under 5MB limit
- [ ] No duplicate functionality with existing dependencies

### 2. Necessity
- [ ] No built-in Node.js alternative (crypto, fs, path, url, etc.)
- [ ] No lighter alternative available (see approved list)
- [ ] Functionality cannot be implemented in < 50 lines
- [ ] Used in production code (not dev-only mistakenly in dependencies)

### 3. Quality
- [ ] Actively maintained (commit in last 6 months)
- [ ] No known critical CVEs
- [ ] > 1000 weekly downloads (not abandoned)
- [ ] TypeScript types included or @types available
- [ ] Not deprecated

### 4. Lambda Compatibility
- [ ] Works in Lambda runtime (no native binaries unless linux-compiled)
- [ ] No filesystem writes to non-/tmp paths
- [ ] No long-running background processes
- [ ] Compatible with Node.js 20.x

### 5. Layer Consideration
- [ ] If > 1MB: should this go in a Lambda Layer instead?
- [ ] If shared across > 3 functions: extract to layer
- [ ] If AWS SDK related: already in runtime (exclude from bundle)

## Banned Dependencies (Lambda Context)

| Package | Reason | Alternative |
|---------|--------|-------------|
| aws-sdk (v2) | Massive, deprecated | @aws-sdk/client-* (v3) |
| moment | 300KB+ | dayjs (2KB) |
| lodash (full) | 70KB+ | Individual lodash-es functions |
| express | Overkill for single function | Native handler + middy |
| mongoose | Heavy for Lambda | DynamoDB SDK or lightweight Prisma |
| sharp | Native binary issues | Lambda Layer with prebuilt |

## Output Format

```markdown
## Dependency Review

**Package**: {name}@{version}
**Size Impact**: +{X}KB (bundle total: {Y}MB / 5MB limit)
**Cold Start Impact**: estimated +{N}ms
**Recommendation**: APPROVE | NEEDS_LAYER | REJECT

### Analysis
- Size: {unpacked size}
- Transitive deps: {count}
- Tree-shakeable: yes/no
- Alternatives considered: ...

### Decision
{APPROVE/REJECT with justification}
```
