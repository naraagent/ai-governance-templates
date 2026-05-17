---
inclusion: fileMatch
fileMatchPattern: "**/package.json,**/serverless.yml,**/serverless.yaml,**/template.yaml,**/webpack.config*,**/esbuild*"
---

# Bundle Size — Lambda Node.js

## Size Limits

| Metric | Warning | Critical |
|--------|---------|----------|
| Bundle (uncompressed) | > 3MB | > 5MB |
| Bundle (zipped) | > 1MB | > 2MB |
| Dependencies count | > 15 | > 25 |
| Cold start (256MB) | > 500ms | > 1000ms |

## Dependency Rules

### Before Adding ANY Dependency
1. Check bundle size impact: `npx bundlephobia <package>`
2. Evaluate if native/built-in alternative exists
3. Consider if it should go in a Lambda Layer instead
4. Verify tree-shaking compatibility (ESM export)

### Approved Lightweight Alternatives
| Instead of... | Use... | Size savings |
|---------------|--------|--------------|
| moment | dayjs | ~95% smaller |
| axios | got-lite / native fetch | ~80% smaller |
| lodash | lodash-es (individual) | ~90% smaller |
| uuid | crypto.randomUUID() | 100% (built-in) |
| aws-sdk (v2) | @aws-sdk/client-* (v3) | ~60% smaller |

### Banned in Lambda
- `aws-sdk` v2 (use v3 modular)
- `moment` (use dayjs or date-fns)
- `lodash` full bundle (use individual imports)
- `express` (for simple functions — use native handler)
- Any package > 2MB unpacked

## Lambda Layers

Use layers for shared dependencies across multiple functions:

```yaml
# serverless.yml
layers:
  CommonDeps:
    path: layers/common
    compatibleRuntimes:
      - nodejs20.x
    description: Shared dependencies (aws-sdk, middy, powertools)

functions:
  processOrder:
    handler: src/handlers/process-order.handler
    layers:
      - !Ref CommonDepsLambdaLayer
```

### Layer Guidelines
- Max 5 layers per function (AWS limit)
- Layer size: keep under 50MB (uncompressed)
- Version layers (don't update in place)
- Shared layers: aws-sdk clients, middy, powertools, validators

## Bundler Configuration (esbuild)

```typescript
// esbuild preferred for Lambda
{
  bundle: true,
  minify: true,
  sourcemap: true,
  target: 'node20',
  platform: 'node',
  external: ['@aws-sdk/*'],  // Exclude if using layer
  treeShaking: true,
  format: 'esm',
}
```

## Monitoring Bundle Size

- CI pipeline MUST check bundle size on every PR
- Alert if size increases > 500KB in a single PR
- Track cold start duration in CloudWatch
- Review dependencies quarterly for unused/replaceable packages

## Serverless Framework Packaging

```yaml
package:
  individually: true          # Package each function separately
  excludeDevDependencies: true
  patterns:
    - '!.git/**'
    - '!tests/**'
    - '!docs/**'
    - '!.env*'
    - '!*.md'
```
