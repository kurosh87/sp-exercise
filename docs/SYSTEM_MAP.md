# System Map

```
┌─────────────────────────────────────────────────────────────┐
│                        AppState                              │
│  ┌─────────────────────────────────────────────────────┐   │
│  │              AccountState (single source)            │   │
│  │  emailConfirmed • identityVerified                 │   │
│  │  riskProfileComplete • cashBalance                 │   │
│  │  cardSetupComplete • securityUpgraded               │   │
│  └─────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
        ▼                     ▼                     ▼
┌──────────────┐   ┌─────────────────┐   ┌─────────────────┐
│     Home     │   │    Exchange     │   │      Card       │
│              │   │                 │   │                 │
│ Readiness    │   │ Amount entry    │   │ Eligibility     │
│ Card         │──▶│ Asset picker    │◀──│ check           │
│              │   │ Review buy      │   │ State-aware CTA │
│ State-Aware  │   │                 │   │                 │
│ Actions      │   │ Blocked if      │   │ Blocked if      │
│              │   │ cash < amount   │   │ not verified    │
└──────────────┘   └─────────────────┘   └─────────────────┘
        │                     │                     │
        │                     │                     │
        ▼                     ▼                     ▼
┌──────────────┐   ┌─────────────────┐   ┌─────────────────┐
│   Activity   │   │    Payments     │   │   Setup Flows   │
│              │   │                 │   │                 │
│ Live tx list │   │ Inline help     │   │ Confirm Email   │
│ (appends on  │   │ (no modal)      │   │ Verify Identity │
│  buy/add)    │   │                 │   │ Risk Profile    │
└──────────────┘   └─────────────────┘   └─────────────────┘
```

## State Flow

### Setup Completion Loop
1. Home shows readiness card with missing steps
2. User taps action CTA (e.g., "Confirm") → navigates to setup screen
3. User completes step → `AccountState` updates
4. Home updates in real time (via `@Published`)
5. When all steps complete, readiness card collapses to success state

### Add Cash → Unlock Transaction Loop
1. User has $0 cash → Home shows "Add cash" as primary CTA
2. User taps "Add cash" → AddCashView opens
3. User selects Interac e-Transfer → `cashBalance += 100`
4. Home updates → CTA changes to "Buy bitcoin"

### Buy Crypto Success Loop
1. User enters Exchange (with sufficient cash)
2. Enters amount, reviews buy
3. Confirms buy → `cashBalance -= amount`
4. Success overlay shown
5. Transaction logged in Activity

## Key Files

| File | Responsibility |
|------|---------------|
| `AccountState.swift` | Data model, presets, next best action logic |
| `ProposedHomeView.swift` | Proposed Home with all 3 changes integrated |
| `Components/AccountReadinessCard.swift` | Change 1: Readiness UI |
| `Components/StateAwareActionAreaView.swift` | Change 2: Dynamic CTAs |
| `Flows/ExchangeView.swift` | Exchange with state-aware blocking |
| `Tabs/CardView.swift` | State-aware card eligibility |
| `Tabs/PaymentsView.swift` | Inline help (no modal) |
| `Tabs/ActivityView.swift` | Transaction history |
