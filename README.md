# Shakepay Design Exercise — UX Prototype

A front-end iOS prototype demonstrating **3 system-level UX improvements** to Shakepay's Home and first-click flows.

> **This is not a production app.** It is a prototype demonstrating how a single account-state model can improve clarity across Home and all first-click flows without visual redesign or feature expansion.

---

## The 3 Changes

### 1. Account Readiness Model (Home Only)

**Before:** Scattered setup/security prompts as a carousel of individual cards.

**After:** A single structured readiness card showing all setup steps, completion progress, and clear "X of 5 complete" indicator.

**What it solves:** Users can see their overall account state in one place instead of discovering blockers late in flows.

**Key behaviors:**
- Shows 5 steps: Phone verified, Confirm email, Verify identity, Complete risk profile, Add cash
- Progress ring and bar update in real time
- Collapses to compact success state when all steps complete
- Each incomplete step has a direct action CTA

**File:** `Components/AccountReadinessCard.swift`

---

### 2. State-Aware Primary Actions

**Before:** Home CTA was always "Add / Send" regardless of account state. Users could enter flows they couldn't complete.

**After:** The primary action adapts dynamically based on `AccountState`.

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

**Before:** Promotional content interrupted core transaction flows.

**After:** Promotions still exist but are moved out of core transaction paths.

**Changes:**
- **Recurring buy promo** → Moved to Order Type Sheet only (not on main Exchange screen)
- **Card marketing CTA** → Becomes state-aware: shows setup requirements when not eligible
- **Payments modal** → Removed entirely; replaced with inline dismissible education card

**What it solves:** Reduces cognitive noise during money actions. Users can complete tasks without promotional interruptions.

**Files:** `Flows/ExchangeView.swift` · `Tabs/CardView.swift` · `Tabs/PaymentsView.swift`

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

### State-Driven UX

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
│   ├── Models.swift                # Supporting types (Asset, Transaction, etc.)
│   ├── Theme.swift                 # Colors, typography constants
│   ├── App.swift                   # App entry point
│   ├── RootView.swift              # Tab container with Current/Proposed toggle
│   ├── HomeView.swift              # Current (original) Home screen
│   ├── ProposedHomeView.swift      # Proposed Home with 3 changes
│   ├── PlaceholderView.swift       # Tab placeholders
│   ├── Components/                 # Reusable UI components
│   │   ├── AccountReadinessCard.swift      # Change 1
│   │   ├── StateAwareActionAreaView.swift  # Change 2
│   │   ├── SetupCarouselView.swift         # Original (Current) carousel
│   │   ├── ActionButtonsView.swift         # Original (Current) buttons
│   │   ├── BalanceHeroView.swift
│   │   ├── HeaderView.swift
│   │   ├── AssetRowView.swift
│   │   ├── ForYouCardView.swift
│   │   ├── DoMoreGridView.swift
│   │   ├── BottomTabBarView.swift
│   │   └── VariantToggle.swift
│   ├── Flows/                      # Flow screens
│   │   ├── AddCashView.swift
│   │   ├── SendView.swift
│   │   ├── AssetDetailView.swift
│   │   ├── AssetInsightsView.swift
│   │   ├── FlowNavBar.swift
│   │   └── FlowOptionRow.swift
│   └── Tabs/                       # Tab screens
│       ├── CardView.swift          # Change 3 (state-aware CTA)
│       ├── PaymentsView.swift      # Change 3 (inline help)
│       └── ActivityView.swift
├── docs/
│   ├── 3_CHANGES.md               # Detailed breakdown of each change
│   ├── SYSTEM_MAP.md              # Architecture diagram
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

2. Generate the Xcode project (if using XcodeGen):
   ```bash
   xcodegen generate
   ```

3. Open `shakepay-exercise.xcodeproj` in Xcode

4. Build and run on iPhone 15 Pro simulator (or any iOS 17+ device)

---

## Design Decisions

### What Was Removed

- **Multiple setup cards** → Replaced with single readiness card
- **Static "Add / Send" buttons** → Replaced with dynamic state-aware CTA
- **Blocking Payments modal** → Replaced with inline education card
- **Recurring buy promo on Exchange main screen** → Moved to Order Type Sheet
- **Generic Card CTA** → Replaced with state-aware eligibility check

### What Was Preserved

- Shakepay's dark theme, blue accent (`#1B7AFA`), card backgrounds
- Existing tab structure (Home, Card, Exchange, Payments, Activity)
- Visual language and typography system
- Card marketing content and benefits list

### Why System > UI

The evaluation criteria for this exercise are **systems thinking, judgment, and tradeoffs** — not UI craft. Every visual decision serves the state model. The prototype proves that meaningful UX improvement can come from state modeling and hierarchy changes rather than visual redesign or feature expansion.

---

## Screenshots

### Home States

| Incomplete | Verified | Funded |
|------------|----------|--------|
| Shows readiness card with 1/5 complete | Shows readiness card with 3/5 complete | Shows collapsed success state |
| CTA: "Confirm email" | CTA: "Add cash" | CTA: "Buy bitcoin" |

### Exchange Flow

| Main Screen | Order Type Sheet | Review Buy |
|-------------|------------------|------------|
| Clean amount entry | Recurring promo here only | Confirm with balance check |

### Card State Change

| Not Eligible | Eligible |
|--------------|----------|
| Shows setup requirements | Shows "Get the Shakepay Card" |

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
