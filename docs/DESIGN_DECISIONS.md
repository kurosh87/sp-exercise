# Design Decisions

## What We Removed

### Fragmented setup carousel
The original Home had multiple individual setup cards (Confirm email, Verify identity, etc.) scattered across the screen. Replaced with a single `AccountReadinessCard` that consolidates all setup steps into one structured view.

### Static "Add / Send" buttons
The original Home always showed "Add / Send" regardless of account state. Users could tap "Send" with $0 balance or tap into Exchange without verified identity. Replaced with `StateAwareActionAreaView` that dynamically changes the primary CTA based on the next required action.

### Blocking modal in Payments
The original Payments tab used a blocking modal on first open. Replaced with an inline dismissible education card that provides the same information without interrupting task flow.

### Recurring buy promo on main Exchange screen
The original Exchange showed the recurring buy promo banner on the main screen. Moved to the Order Type Sheet where users explicitly choosing recurring buys will see it.

### Generic Card CTA
The original Card tab always showed "Get the Shakepay Card" regardless of eligibility. Replaced with state-aware CTA that shows setup requirements when the user is not eligible.

## What We Preserved

### Shakepay visual language
No redesign of colors, typography, or iconography. The dark theme, blue accent, card backgrounds, and system fonts are all preserved. This is a systems change, not a visual rebrand.

### Existing tab structure
Home, Card, Exchange, Payments, Activity tabs remain. No new tabs added.

### Card marketing content
The Card screen still shows benefits, the card illustration, and the value proposition. Only the CTA behavior changes.

### Current vs. Proposed toggle
Users can switch between the original (Current) and improved (Proposed) Home screens to compare before/after.

## Why System > UI

The prototype intentionally avoids:

- **Polish over proof:** Fancy animations that don't demonstrate state logic
- **Feature expansion:** New product ideas beyond the 3 changes
- **Visual redesign:** Changing Shakepay's look instead of its behavior

The evaluation criteria for this exercise are systems thinking, judgment, and tradeoffs — not UI craft. Every visual decision serves the state model.

## Failure → Recovery Loop

The most important signal this prototype sends is the **failure → recovery loop**:

1. Try buy BTC → blocked (no cash)
2. → Add cash via Interac
3. → Retry buy
4. → Success
5. → Activity logs both transactions

This loop proves the state model works end-to-end. Without it, the prototype is just a collection of screens.

## Scope Boundaries

What was explicitly excluded to maintain 2-week feasibility:

- Backend integration or real payment processing
- Crypto wallet functionality
- Push notifications
- Analytics or tracking
- Accessibility audit (would be next step)
- iPad or landscape support
- Unit tests (prototype only)
