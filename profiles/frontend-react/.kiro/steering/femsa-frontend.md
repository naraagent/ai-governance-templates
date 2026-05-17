---
inclusion: auto
---

# FEMSA Frontend Conventions — Next.js 14

## Next.js 14 App Router Patterns

- Route groups: `(auth)`, `(dashboard)`, `(public)` for layout separation
- Parallel routes: `@modal`, `@sidebar` for complex layouts
- Intercepting routes: `(.)photo` for modal patterns
- Loading UI: `loading.tsx` per route segment
- Error boundaries: `error.tsx` per route segment
- Server Components by default — `"use client"` only for interactivity
- Metadata API: `generateMetadata()` for SEO per page

## Zustand Store Conventions

- One store per domain: `useAuthStore`, `useCartStore`, `useUIStore`
- Immer middleware for complex state mutations
- Persist middleware for localStorage when needed
- Pattern:
  ```typescript
  export const useCartStore = create<CartState>()(
    immer((set) => ({
      items: [],
      addItem: (item) => set((state) => { state.items.push(item) }),
    }))
  )
  ```
- No store-to-store dependencies (use selectors in components)
- Devtools middleware in development only

## AWS Cognito JWT Handling

- NextAuth.js adapter with Cognito provider
- JWT callback: extract custom claims (country, role, permissions)
- Middleware (`middleware.ts`): validate session, redirect unauthenticated
- Protected routes: `(auth)` route group with layout-level auth check
- Token refresh: handled automatically by NextAuth
- Logout: revoke tokens + clear session

## i18n (next-intl)

- Messages directory: `/messages/{locale}.json`
- Supported locales: es-CL, es-CO, es-EC, es-MX, en
- Default locale: es-CL
- Namespace pattern: one JSON file per locale, organized by feature keys
- Usage: `useTranslations('namespace')` in client components
- Server components: `getTranslations('namespace')`
- Date/number formatting: use next-intl formatters (locale-aware)

## Component Patterns

- Feature components in `src/components/features/{feature}/`
- Shared UI in `src/components/ui/` (shadcn/ui primitives)
- Container/Presentational split for complex features
- Custom hooks in `src/hooks/use-{feature}.ts`

## Environment Promotion

- develop → staging (auto) → production (approval)
- Environment-specific config via `NEXT_PUBLIC_*` env vars
- Feature flags via environment variables or remote config
