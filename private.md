# OC5 Show & Tell — Talking Points

## Layer-by-layer drilldown

### Layer 1: Route table (`app.js` lines 131-149)

**NIH objection:** "Where's the routing configuration? Symfony has `#[Route]` annotations."
**Answer:** Same information, different location. 14 lines in one place vs 14 annotations scattered across controllers. Both declarative. Both tell you what HTTP method maps to what handler.

### Layer 2: Route handlers (`routes/caches.js`)

**NIH objection:** "You check `req.user.id` inline? Where's the authorization layer?"
**Answer:** Auth middleware (`auth.js`) already validates the session and loads roles from the DB. `requireAuth` is equivalent to `$this->denyAccessUnlessGranted('ROLE_USER')` — 1 line instead of 1 attribute. Same guarantee. For role-based access: add a `requireRole('admin')` helper, same pattern.

### Layer 3: Data layer (`data/caches.js`)

**NIH objection:** "`ocGetCacheDetail` is a god function. SQL + mapping + markdown + log types in one function."
**Answer:** It's one query against 8 joined tables to avoid N+1. The markdown rendering and DNF computation ARE extractable — and we should. Own this as a known cleanup target. Everything else in the data layer is single-responsibility: one function per operation.

### Layer 4: Raw SQL vs QueryBuilder

**NIH objection:** "This 22-line SQL is unreadable. QueryBuilder abstracts this."
**Answer:** QueryBuilder doesn't abstract the complexity — it redistributes it. A 22-line SQL becomes a 50-line fluent chain. You still need to know JOIN semantics, parameter binding, and column aliases. With raw SQL you copy-paste into any SQL client and debug. With QueryBuilder you need a profiler. Same complexity, different visibility. We chose visibility.

### Layer 5: Shared utilities (`public/shared/coords.js`)

**NIH objection:** "You import from `public/`? That's a static asset directory."
**Answer:** It's a pure JS module with no DOM dependencies. Browser and Node.js import the same file. Symfony CANNOT do this — PHP can't run in the browser, JS can't run in PHP. Two implementations, two maintenance burdens, two surfaces for the same bug. We have one. The directory name is cosmetic — the architecture is the point.

## Known weaknesses (own them openly)

1. **`ocGetCacheDetail` mixes concerns** — SQL, object mapping, markdown rendering, DNF computation. The markdown and DNF blocks can be extracted into helpers. This is the one function in the codebase that deserves a refactor.

2. **Search/livemap response shapes are built in route handlers** — the data layer returns raw rows and the route does `.map()`. These shape transformations could move to the data layer for consistency with `ocGetCacheDetail`.

## Key narrative

The hard parts — SQL queries, business logic, template structure — port 1:1 from Symfony to Express. The framework is HTTP glue. The architecture is the data layer, and the data layer is just SQL with function names.

Three months, two people (not on the team), delivered what four years of Symfony didn't.
