# 3 Changes

This prototype demonstrates three system-level UX improvements to the Shakepay Home and first-click flows.

---

## Change 1: Account Readiness Model (Home Only)

**Problem:** Setup and security prompts were scattered across the Home screen as a carousel of individual cards. Users could not see their overall account state in one place.

**Decision:** Replace the fragmented carousel with a single structured readiness card showing all setup steps, completion progress, and a clear "X of 5 complete" indicator.

**Tradeoff:** Removed the individual setup cards from Home. The readiness card collapses to a compact success state when all steps are done, reducing visual noise for completed users.

**Screens impacted:** Home (Proposed variant)

**Files:** `Components/AccountReadinessCard.swift`

---

## Change 2: State-Aware Primary Actions

**Problem:** The Home CTA was always "Add / Send" regardless of account state. Users could tap into flows they were not eligible to complete (e.g., buying BTC with $0 balance or unverified identity).

**Decision:** The primary action on Home adapts dynamically based on `AccountState`:

1. `confirmEmail` — when email not confirmed
2. `verifyIdentity` — when identity not verified
3. `completeRiskProfile` — when risk profile incomplete
4. `addCash` — when cash balance is $0
5. `buyBitcoin` — when all readiness checks pass

**Tradeoff:** The static "Add / Send" buttons are replaced by a dynamic single CTA. This removes the familiar always-available "Add" button, but prevents users from entering blocked flows.

**Screens impacted:** Home (Proposed variant), Exchange (via sheet), Card (eligibility check)

**Files:** `Components/StateAwareActionAreaView.swift`

---

## Change 3: De-emphasize Promotions During Task Intent

**Problem:** Promotional content interrupted core transaction flows. The recurring-buy promo banner sat on the main Exchange screen. The Card marketing CTA blocked task execution. Payments used a blocking modal on first open.

**Decision:**

- **Recurring buy promo** — moved to the Order Type Sheet only (not shown on main Exchange screen)
- **Card marketing CTA** — becomes state-aware: shows setup requirements when user is not eligible, shows "Get the Shakepay Card" when eligible
- **Payments modal** — removed entirely; replaced with an inline dismissible education card

**Tradeoff:** Promotional content is less visible. But task completion clarity is significantly improved because promotions no longer block or interrupt money actions.

**Screens impacted:** Exchange, Card, Payments

**Files:** `Flows/ExchangeView.swift`, `Tabs/CardView.swift`, `Tabs/PaymentsView.swift`

---

## What Was Removed (Scope Control)

To maintain a 2-week realistic scope, the following were explicitly excluded:

- Backend logic, real payments, or crypto integration
- Onboarding redesign system
- Analytics dashboards
- Multiple competing Home variants (only Current vs. Proposed)
- Fancy animations that don't serve state logic
- Any "new feature ideas" beyond the 3 changes

**Design principle:** System thinking over UI polish. State model over feature expansion.
