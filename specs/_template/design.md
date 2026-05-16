# Design: [Feature Name]

> Spec Version: 1.0.0
> Requirements: #[[file:requirements.md]]
> Date: YYYY-MM-DD

## Architecture

### Component Diagram

```
┌──────────┐     ┌──────────────┐     ┌──────────┐
│  Client  │────▶│   Service    │────▶│   Store  │
└──────────┘     └──────────────┘     └──────────┘
```

### Design Decisions

| Decision | Options Considered | Choice | Rationale |
|----------|-------------------|--------|-----------|
| ... | A, B, C | B | ... |

## API Design

### Endpoints

```
METHOD /path
  Request: { ... }
  Response: { ... }
  Errors: 400, 401, 404, 500
```

### Data Models

```typescript
interface EntityName {
  id: string;
  // ...
  createdAt: Date;
  updatedAt: Date;
}
```

## Sequence Diagram

```
User → Service: request
Service → DB: query
DB → Service: result
Service → User: response
```

## Error Handling

| Error Case | HTTP Code | Response | Recovery |
|-----------|-----------|----------|----------|
| Not found | 404 | `{ error: "..." }` | Retry with different ID |
| Validation | 422 | `{ errors: [...] }` | Fix input |
| Server error | 500 | `{ error: "internal" }` | Retry with backoff |

## Security Considerations

- Authentication: [how]
- Authorization: [what checks]
- Data encryption: [at rest / in transit]
- Audit: [what is logged]

## Observability

- Logs: [key events to log]
- Metrics: [counters, histograms]
- Traces: [span boundaries]
- Alerts: [threshold conditions]

## Migration Plan

- [ ] Database migrations (if any)
- [ ] Feature flags (for gradual rollout)
- [ ] Backward compatibility period
- [ ] Rollback procedure
