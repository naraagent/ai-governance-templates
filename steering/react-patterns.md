---
inclusion: fileMatch
fileMatchPattern: "**/*.tsx,**/*.jsx,**/next.config.*"
---

# React / Next.js Patterns

> Activates when working with React/Next.js files.

## Required

- Next.js 14+ with App Router
- TypeScript strict mode
- Functional components only (no class components)
- Server Components by default, `"use client"` only when needed
- Accessibility: WCAG 2.1 AA compliance

## Component Pattern

```tsx
// ✅ Typed, accessible, server-first
interface OrderCardProps {
  order: Order;
  onCancel?: (orderId: string) => void;
}

export function OrderCard({ order, onCancel }: OrderCardProps) {
  return (
    <article
      aria-label={`Order ${order.id}`}
      className="rounded-lg border p-4 shadow-sm"
    >
      <h3 className="text-lg font-semibold">{order.title}</h3>
      <p className="text-muted-foreground">{order.status}</p>
      {onCancel && (
        <button
          onClick={() => onCancel(order.id)}
          aria-label={`Cancel order ${order.id}`}
          className="mt-2 text-destructive"
        >
          Cancel
        </button>
      )}
    </article>
  );
}
```

## State Management

- Zustand for global client state
- React state for local component state
- Server state via fetch + React cache (App Router)
- No prop drilling beyond 2 levels

## Styling

- Tailwind CSS utility classes only
- shadcn/ui for base components
- No inline styles, no CSS modules
- Design tokens via CSS variables

## Testing

- Unit: Vitest + React Testing Library
- E2E: Playwright
- Test user behavior, not implementation
- Accessible queries preferred (`getByRole`, `getByLabelText`)

## NEVER

- Class components
- `dangerouslySetInnerHTML` without sanitization
- Client-side API keys or secrets
- UI libraries other than shadcn/ui
- `@ts-ignore` without justification
- `useEffect` for data fetching (use Server Components or SWR)
