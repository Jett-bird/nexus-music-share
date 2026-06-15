# Nexus Music Share Memory

## Technical Stack
- Backend: Supabase (Auth, Database, Storage)
- Icons: Custom SVG helper (previously Tabler Icons font)
- Caching: LocalStorage (nms_{userId}_{key})
- Performance: 
    - Service Worker for asset caching.
    - Optimistic bootstrapping (using cached profile).
    - Parallel background data fetching.
    - Predictive preloading on UI interaction (hover/pointerenter).

## Optimization History
- Removed Tabler Icon font (~1MB blocking) to save ~1s+ of load time.
- Implemented Service Worker for instant second load.
- Cached user profile locally to allow entering home screen before Supabase session is fully verified.
- Parallelized all initial data fetching (`Promise.all`).
