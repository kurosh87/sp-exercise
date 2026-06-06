# Shakepay Design Exercise — UX Prototype

A front-end iOS prototype demonstrating **3 system-level UX improvements** to Shakepay's Home and first-click flows.

> **This is not a production app.** It is a prototype demonstrating how a single account-state model can improve clarity across Home and all first-click flows without visual redesign or feature expansion.

---

## Quick Start

> **View the prototype:** Open `shakepay-exercise.xcodeproj` in Xcode and run on iPhone 15 Pro simulator.

**Demo controls:** On the Proposed Home tab, use the segmented control to toggle between 3 account states:
- **Incomplete** — New user, nothing verified
- **Verified** — Identity complete, $0 balance  
- **Funded** — All ready, $100 balance

---

## The 3 Changes

### 1. Account Readiness Model (Home Only)

**Problem:** Setup and security prompts were scattered across the Home screen as a carousel of individual cards.

**Solution:** A single structured readiness card showing all setup steps, completion progress, and clear "X of 5 complete" indicator.

**What it solves:** Users can see their overall account state in one place instead of discovering blockers late in flows.

**Key behaviors:**
- Shows 5 steps: Phone verified, Confirm email, Verify identity, Complete risk profile, Add cash
- Progress ring and bar update in real time
- Collapses to compact success state when all steps complete
- Each incomplete step has a direct action CTA

**File:** `Components/AccountReadinessCard.swift`

---

### 2. State-Aware Primary Actions

**Problem:** Home CTA was always "Add / Send" regardless of account state. Users could enter flows they couldn't complete.

**Solution:** The primary action adapts dynamically based on `AccountState`.

| State | Primary CTA | Secondary CTA |
|-------|-------------|---------------|
| Email not confirmed | **Confirm email** | Add cash · Send |
| Identity not verified | **Verify identity** | Add cash · Send |
| Risk profile incomplete | **Complete risk profile** | Add cash · Send |
| $0 cash balance | **Add cash** | Send |
| All ready | **Buy bitcoin** | Send |

**What it solves:** Users don't enter blocked flows. The app surfaces the next required action instead of showing generic buttons.

**Key behaviors:**
- "Next step" card appears for blocking actions with contextual description
- Buttons are side-by-side (primary blue + secondary gray) matching Shakepay's pattern
- Transitions smoothly between states with animation

**File:** `Components/StateAwareActionAreaView.swift`

---

### 3. De-emphasize Promotions During Task Intent

**Problem:** Promotional content interrupted core transaction flows.

**Solution:** Promotions still exist but are moved out of core transaction paths.

| Element | Before | After |
|---------|--------|-------|
| Recurring buy promo | On main Exchange screen | Moved to Order Type Sheet only |
| Card marketing CTA | Always "Get the Card" | State-aware: shows requirements when not eligible |
| Payments first open | Blocking modal | Inline dismissible education card |

**What it solves:** Reduces cognitive noise during money actions. Users can complete tasks without promotional interruptions.

**Files:** `Flows/ExchangeView.swift` · `Tabs/CardView.swift` · `Tabs/PaymentsView.swift`

---

## Screenshots

### Home States (3 Variants)

> **To capture:** Use the "Incomplete / Verified / Funded" segmented control on Proposed Home tab.

| Incomplete (1/5) | Verified (3/5) | Funded (5/5) |
|------------------|----------------|--------------|
| Readiness card shows "Confirm email" as pending | Readiness card shows "Add cash" as pending | Card collapsed to "Your account is ready" |
| CTA: "Confirm email" | CTA: "Add cash" | CTA: "Buy bitcoin" |

### Exchange Flow

> **To capture:** Tap "Buy bitcoin" from Funded state, enter amount, tap Review.

| Main Screen | Order Type Sheet | Success State |
|-------------|------------------|---------------|
| Clean amount entry with asset picker | Recurring promo shown here only | "Bought Bitcoin" success overlay |

### Card State Change

> **To capture:** Switch between Incomplete and Funded presets, then open Card tab.

| Not Eligible | Eligible |
|--------------|----------|
| Shows checklist: "Confirm email", "Verify identity" | Shows "Get the Shakepay Card" CTA |

### Payments (No Modal)

> **To capture:** Open Payments tab from any state.

| Inline Help Card |
|------------------|
| Dismissible education card at top — no blocking modal |

---

## System Architecture

### Single Source of Truth

All screens read from one shared state:

```swift
struct AccountState {
    var emailConfirmed: Bool
    var identityVerified: Bool
    var riskProfileComplete: Bool
    var cashBalance: Double
    var cardSetupComplete: Bool
    var securityUpgraded: Bool
}
```

### State-Driven UX Flow

```
AccountState
    ├── Home (Readiness Card + Actions)
    ├── Exchange (Balance check + Flow gating)
    ├── Card (Eligibility check)
    ├── Payments (Inline help)
    └── Activity (Transaction history)
```

### Demo State Presets

The prototype includes 3 preset states for demonstration:

| Preset | emailConfirmed | identityVerified | riskProfileComplete | cashBalance |
|--------|---------------|------------------|---------------------|-------------|
| **Incomplete** | ❌ | ❌ | ❌ | $0 |
| **Verified** | ✅ | ✅ | ✅ | $0 |
| **Funded** | ✅ | ✅ | ✅ | $100 |

Toggle between presets using the segmented control on the Proposed Home tab.

---

## User Flows

### Flow A: Setup Completion Loop

1. Home shows missing setup items in readiness card
2. User taps action CTA (e.g., "Confirm" for email)
3. Setup flow screen opens
4. User completes step → state updates
5. Home updates in real time → readiness card reflects progress
6. When all complete, card collapses to success state

### Flow B: Add Cash → Unlock Transaction

1. User has $0 balance → Home shows "Add cash" as primary CTA
2. User taps "Add cash" → AddCashView opens
3. User selects Interac e-Transfer → $100 added to balance
4. Home updates → CTA changes to "Buy bitcoin"
5. User can now enter Exchange and complete a buy

### Flow C: Buy Crypto Success Loop

1. Enter Exchange with sufficient cash
2. Enter amount → Review buy
3. Confirm → Success overlay
4. Cash balance decreases
5. Transaction appears in Activity

---

## Project Structure

```
shakepay-exercise/
├── shakepay-exercise/
│   ├── AccountState.swift          # Data model + next best action logic
│   ├── Models.swift                # Supporting types
│   ├── Theme.swift                 # Colors, typography
│   ├── App.swift                   # App entry point
│   ├── RootView.swift              # Tab container
│   ├── HomeView.swift              # Current (original) Home
│   ├── ProposedHomeView.swift      # Proposed Home with 3 changes
│   ├── Components/
│   │   ├── AccountReadinessCard.swift      # Change 1
│   │   ├── StateAwareActionAreaView.swift  # Change 2
│   │   └── ... other components
│   ├── Flows/                      # Flow screens
│   │   ├── AddCashView.swift
│   │   ├── SendView.swift
│   │   └── ...
│   └── Tabs/                       # Tab screens
│       ├── CardView.swift          # Change 3
│       ├── PaymentsView.swift      # Change 3
│       └── ActivityView.swift
├── docs/
│   ├── 3_CHANGES.md               # Detailed breakdown
│   ├── SYSTEM_MAP.md              # Architecture
│   └── DESIGN_DECISIONS.md        # What was removed and why
└── README.md                       # This file
```

---

## Tech Stack

- **Platform:** iOS 17.0+
- **Framework:** SwiftUI
- **Build Tool:** XcodeGen (`project.yml`)
- **No external dependencies**

---

## Running the Prototype

### Requirements
- Xcode 15.0+
- iOS 17.0+ Simulator or device

### Steps

1. Clone the repository:
   ```bash
   git clone https://github.com/kurosh87/sp-exercise.git
   cd sp-exercise
   ```

2. Generate the Xcode project:
   ```bash
   xcodegen generate
   ```

3. Open `shakepay-exercise.xcodeproj` in Xcode

4. Build and run on iPhone 15 Pro simulator

---

## Design Decisions

### What Was Removed

- **Fragmented setup carousel** → Single readiness card
- **Static "Add / Send" buttons** → Dynamic state-aware CTA
- **Blocking Payments modal** → Inline education card
- **Recurring buy promo on Exchange main** → Moved to Order Type Sheet
- **Generic Card CTA** → State-aware eligibility check

### What Was Preserved

- Shakepay's dark theme, blue accent, card backgrounds
- Existing tab structure (Home, Card, Exchange, Payments, Activity)
- Visual language and typography system
- Current vs. Proposed toggle for comparison

### Why System > UI

The evaluation criteria are **systems thinking, judgment, and tradeoffs** — not UI craft. Every visual decision serves the state model.

---

## Key Insight

> "I didn't redesign Shakepay. I introduced a single account-state model that improves clarity across Home and all first-click flows."

The 3 changes work together as a system:
1. **Readiness Model** makes account state legible
2. **State-Aware Actions** prevents users entering blocked flows
3. **De-emphasized Promotions** reduces cognitive interference during money actions

All three are driven by the same `AccountState` model, creating a coherent experience where updating state in one place updates all screens.

---

## License

This is a design exercise prototype. Not for production use.
