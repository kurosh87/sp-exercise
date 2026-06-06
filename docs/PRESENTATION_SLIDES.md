# Shakepay Design Exercise — Presentation Slides

## Slide 1: Title

# Shakepay UX Prototype
## 3 System-Level Improvements to Home & First-Click Flows

**Pejman Afrakhteh**  
Design Exercise — June 2026

---

## Slide 2: The Problem

### Current Experience

- Setup prompts scattered as individual cards
- Home CTA always says "Add / Send" regardless of state
- Users discover blockers **late** in flows
- Promotions interrupt money actions

### Result
> Users enter flows they cannot complete, then abandon.

---

## Slide 3: The Approach

### Not a Visual Redesign

**What I didn't do:**
- Change colors, fonts, or iconography
- Add new features
- Redesign the tab structure

**What I did:**
- Introduced a single `AccountState` model
- Made the UI **respond to state** instead of being static
- Moved promotions out of task paths

### Core Principle
> "Clarity through state modeling, not visual polish."

---

## Slide 4: Change 1 — Account Readiness Model

### Before
- 3 separate setup cards (email, identity, security)
- No overall progress indicator
- Users can't see what's blocking them

### After
- Single readiness card: "Finish setting up Shakepay"
- "X of 5 complete" with progress bar
- Each step has direct action CTA
- Collapses to success state when done

### Impact
> Users understand account state in one glance.

**File:** `Components/AccountReadinessCard.swift`

---

## Slide 5: Change 1 — Visual

```
┌─────────────────────────────┐
│  Finish setting up Shakepay │
│  2 of 5 complete            │
│  ▓▓░░░░░░░░                 │
│                             │
│  ✅ Phone verified          │
│  ⭕ Confirm email    [Confirm]
│  ⭕ Verify identity  [Verify]
│  ⭕ Complete risk profile   │
│  ⭕ Add cash                │
└─────────────────────────────┘
```

---

## Slide 6: Change 2 — State-Aware Primary Actions

### Before
```
┌─────────┐ ┌─────────┐
│  Add    │ │  Send   │
└─────────┘ └─────────┘
```
Always the same. Always available. Always wrong for incomplete users.

### After
| State | Primary CTA |
|-------|-------------|
| Email not confirmed | **Confirm email** |
| Identity not verified | **Verify identity** |
| Risk profile incomplete | **Complete risk profile** |
| $0 balance | **Add cash** |
| All ready | **Buy bitcoin** |

### Impact
> Users never enter a flow they cannot complete.

**File:** `Components/StateAwareActionAreaView.swift`

---

## Slide 7: Change 2 — The Flow

```
User opens app (new account)
    │
    ▼
┌─────────────────┐
│ CTA: Confirm email │
└─────────────────┘
    │
    ▼
[User confirms email]
    │
    ▼
┌─────────────────┐
│ CTA: Verify identity │
└─────────────────┘
    │
    ▼
[User verifies identity]
    │
    ▼
┌─────────────────┐
│ CTA: Add cash      │
└─────────────────┘
    │
    ▼
[User adds $100]
    │
    ▼
┌─────────────────┐
│ CTA: Buy bitcoin   │
└─────────────────┘
```

---

## Slide 8: Change 3 — De-emphasize Promotions

### Before
- Recurring buy promo banner on Exchange main screen
- Card tab: always "Get the Card" (even if not eligible)
- Payments: blocking modal on first open

### After
- **Recurring promo** → Order Type Sheet only
- **Card CTA** → Shows requirements when not eligible
- **Payments** → Inline dismissible education card

### Impact
> Promotions don't interrupt money actions. Task completion clarity improves.

**Files:** `Flows/ExchangeView.swift` · `Tabs/CardView.swift` · `Tabs/PaymentsView.swift`

---

## Slide 9: Change 3 — Visual Comparison

### Exchange: Before vs After

**Before:**
```
┌─────────────────────────────┐
│  Exchange                   │
│                             │
│  No spread, no fees on      │
│  recurring buys [PROMO]     │
│                             │
│  $0.00                      │
│                             │
│  [Review buy]               │
└─────────────────────────────┘
```

**After:**
```
┌─────────────────────────────┐
│  Exchange        [One time ▼]│
│                             │
│  $0.00                      │
│                             │
│  [Review buy]               │
└─────────────────────────────┘

Order Type Sheet:
┌─────────────────────────────┐
│  One time                   │
│  Recurring buy              │
│  "No spread, no fees" [PROMO]│
│  Custom order               │
└─────────────────────────────┘
```

---

## Slide 10: The System Map

```
        AccountState
             │
    ┌────────┼────────┬────────┐
    │        │        │        │
    ▼        ▼        ▼        ▼
┌──────┐ ┌──────┐ ┌──────┐ ┌──────┐
│ Home │ │Exchange│ │ Card │ │Payments│
└──────┘ └──────┘ └──────┘ └──────┘
```

### One model drives all screens:
- Home: Readiness + Actions
- Exchange: Balance check
- Card: Eligibility check
- Payments: Inline help (no modal)

---

## Slide 11: Key User Flow

### The Failure → Recovery Loop

1. **Try buy BTC** → blocked (no cash)
2. **Tap "Add cash"** → Interac e-Transfer
3. **$100 added** → balance updates
4. **Retry buy** → success
5. **Activity logs** both transactions

> This loop proves the state model works end-to-end.

---

## Slide 12: What Was Removed

### Scope Control

❌ **Not in this prototype:**
- Backend integration
- Real payment processing
- New features beyond the 3 changes
- Visual redesign
- Fancy animations
- Multiple competing Home variants

✅ **What IS here:**
- 3 system changes
- State-driven UX
- Realistic 2-week scope
- End-to-end proof

---

## Slide 13: The Narrative

### What I Tell Reviewers

> "I didn't redesign Shakepay. I introduced a single account-state model that improves clarity across Home and all first-click flows."

### The 3 changes work together:
1. **Readiness Model** → makes state legible
2. **State-Aware Actions** → prevents blocked flows
3. **De-emphasized Promos** → reduces cognitive noise

### Result
> A prototype that demonstrates systems thinking, judgment, and tradeoffs.

---

## Slide 14: Demo

### Try It Yourself

1. Open the Proposed Home tab
2. Toggle between **Incomplete / Verified / Funded**
3. Watch the CTA change
4. Complete setup steps
5. See the readiness card update
6. Try the Add Cash → Buy Bitcoin flow

**Repo:** https://github.com/kurosh87/sp-exercise

---

## Slide 15: Thank You

# Questions?

**Pejman Afrakhteh**  
Design Exercise — Shakepay UX Prototype

**Key takeaway:**  
> "Meaningful UX improvement in fintech comes from state modeling and hierarchy changes, not visual redesign or feature expansion."
