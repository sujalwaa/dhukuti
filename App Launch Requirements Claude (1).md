# Dhukuti — Product Requirements Document

**धुकुटि · know your money**

| | |
|---|---|
| **Status** | Draft — planning for public launch |
| **Owner** | Sujal |
| **Prepared** | September 2026 |
| **Prior version** | React prototype (single-user, local state, Google Sheets backup) |
| **This version scopes** | Native rewrite in Flutter + backend for multi-user public launch |

---

## 1. Overview

### 1.1 Purpose
Dhukuti is a mobile-first personal finance app for tracking money across multiple accounts, categorizing expenses, and saving toward goals through a "virtual pot" system where money physically moves between accounts and goals rather than being merely labeled.

### 1.2 Name & Brand
The name references the traditional Newari rotating community savings system (dhukuti), chosen for cultural resonance with the app's savings features. Wordmark is lowercase, DM Sans 800, paired with the tagline धुकुटि · know your money. Currency notation uses रु (Devanagari), not ₹.

### 1.3 Target User
Individuals in Nepal — starting with young professionals — who juggle multiple payment methods (NIC Asia, Nabil Bank, cash, mobile wallets) and want a clear, culturally native view of where their money goes. NPR is the default currency; local bank and merchant names (Bhat Bhateni, Pathao) are used as real-world reference points, not just placeholders.

### 1.4 Key Differentiators
- **Virtual pot savings goals** — contributing to a goal actually moves money out of a source account balance; withdrawing returns it. Not a label on top of a shared balance.
- **Nepali-first design** — NPR default, रु symbol, local institutions, Nepal-specific roadmap items (see §8).
- **Dark hero visual anchor** — the Total Capital card is the emotional and visual center of the app.
- **Explicit over implicit UX** — dates, categories, and account selection are always visible and editable, never silently defaulted. This came directly from Samir's own habit of logging transactions days after they happen.

### 1.5 What's Changing From the Prototype
The existing build is a fully-featured single-file React app: no login, no server, no persistence beyond a manual Google Sheets backup via Apps Script. Launching publicly requires moving from **one user, local state** to **many users, a real backend, and a native app shell**. This PRD covers that transition.

---

## 2. Goals & Non-Goals

### 2.1 Goals for Public Launch (v1)
- Any user can create an account, log in, and have their data private and persistent
- Full feature parity with the current prototype (Overview, Analytics, Savings, Add Transaction)
- Data syncs automatically across a user's own devices
- Users can import existing transactions from a bank-exported CSV/XLSX file instead of manual entry
- App is distributable through the Apple App Store and Google Play Store

### 2.2 Non-Goals (v1)
- Direct bank API integration / live balance pulling (manual entry and file import only)
- Joint/shared accounts or multi-user goals (see §8 roadmap)
- Payment processing or money movement outside the app's own ledger
- Web app version (native only, per current direction)

---

## 3. Technical Architecture

### 3.1 Stack Decision

| Layer | Choice | Notes |
|---|---|---|
| Client framework | **Flutter** | Full rewrite from React; chosen for native performance and Samir's access to Flutter-experienced friends for support |
| Backend | **Supabase** | Postgres + Auth + Row-Level Security out of the box; official `supabase_flutter` SDK |
| Database | **Postgres** (via Supabase) | Relational model maps cleanly onto existing Accounts/Categories/Transactions/Goals schema |
| Local/offline storage | `sqflite` or `drift` | Offline-first cache that syncs to Supabase on reconnect — important for a finance app where connectivity shouldn't block logging a transaction |
| Auth | **Supabase Auth** | Email/password at minimum; Apple Sign-In required by App Store policy if any third-party social login is offered; Google Sign-In optional |
| File import parsing | `csv` and `excel` Dart packages | Client-side parsing, no server round-trip needed |
| Cross-device sync | **Supabase** (single source of truth) | Recommendation: do not run iCloud as a parallel sync system — see §3.3 |
| Optional backup/export | Google Sheets (existing Apps Script approach, ported) | Kept as an export/backup convenience, not the primary sync mechanism |

### 3.2 Why Not the Original React App
Flutter requires a full UI rewrite — no JSX carries over directly. However, the existing documentation (design tokens, spacing, color palette, animation timing, screen map) transfers directly as a build spec; it does not need to be rediscovered.

### 3.3 Sync Strategy: Supabase vs. iCloud
Because this is now a native build, iCloud/CloudKit sync is technically reachable (unlike in a web app). However, running two independent sync systems (Supabase + iCloud) means two sources of truth that can disagree. **Recommendation: Supabase is the single sync backbone across iOS and Android.** iCloud is deferred unless a specific offline-first, server-optional architecture is desired later.

### 3.4 Data Model (carried over from prototype, adapted for Postgres)

All monetary amounts stored as integers in paisa (1 NPR = 100 paisa) to avoid floating-point rounding errors.

**accounts**
| Field | Type | Notes |
|---|---|---|
| id | uuid | |
| user_id | uuid | FK → auth.users, RLS scoped |
| name | text | e.g. "NIC Asia" |
| color | text | hex |
| icon | text | icon key |
| balance | bigint | paisa |

**categories**
| Field | Type | Notes |
|---|---|---|
| id | uuid | |
| user_id | uuid | |
| name | text | |
| icon | text | |
| color | text | |

**transactions**
| Field | Type | Notes |
|---|---|---|
| id | uuid | |
| user_id | uuid | |
| name | text | merchant/description |
| account_id | uuid | FK → accounts |
| category_id | uuid | FK → categories |
| amount | bigint | paisa, negative = expense |
| date | timestamp | |
| source | text | `manual` \| `import` — tracks provenance |

**incomes**
| Field | Type | Notes |
|---|---|---|
| id | uuid | |
| user_id | uuid | |
| name | text | |
| account_id | uuid | |
| amount | bigint | paisa, positive |
| date | timestamp | |

**goals**
| Field | Type | Notes |
|---|---|---|
| id | uuid | |
| user_id | uuid | |
| name | text | |
| target | bigint | paisa |
| icon, color | text | |
| source_account_id | uuid | FK → accounts |
| balance | bigint | current pot value, paisa |
| auto_enabled | boolean | |
| auto_amount | bigint | paisa |
| auto_day_of_month | int | |

**contributions**
| Field | Type | Notes |
|---|---|---|
| id | uuid | |
| goal_id | uuid | FK → goals |
| type | text | `contribute` \| `withdraw` |
| amount | bigint | paisa |
| date | timestamp | |
| note | text | |

**Money flow invariants (unchanged from prototype):**
- Contribute X to goal: `account.balance -= X`, `goal.balance += X`
- Withdraw X from goal: `goal.balance -= X`, `account.balance += X`
- Delete goal: remaining `goal.balance` returned to `source_account`
- **Total Capital** = sum(account balances) + sum(goal balances)

All tables use Row-Level Security scoped to `user_id = auth.uid()` so users can never read or write another user's data.

---

## 4. Feature Requirements

### 4.1 Authentication & User Management
- Sign up / log in via email + password
- Apple Sign-In (mandatory alongside any other social login, per App Store review policy)
- Google Sign-In (optional, doubles as a natural bridge to Google Sheets export)
- Password reset flow
- Session persistence across app restarts
- Account deletion (required by both app stores for any app that collects account data)

### 4.2 Core App (feature parity with prototype)

**Overview Tab**
- Dark hero Total Capital card
- Swipeable account cards with inline "add money"
- Searchable transaction list
- Hide-balance privacy toggle

**Analytics Tab**
- Period filtering (this month / last month / all time)
- Donut expense breakdown chart
- Category drill-down detail view

**Savings Tab**
- Goal creation with source account linking
- Optional initial deposit and monthly auto-contribution (with day-of-month picker)
- Contribute / withdraw flows with directional money-flow visualization
- Contribution history per goal
- Pace estimation toward target
- Safe deletion — returns remaining balance to source account

**Add Transaction**
- Type toggle (expense/income)
- Account picker
- Date picker: calendar bottom sheet, month navigation, blocked future dates, quick chips (Today / Yesterday / 2 days ago) — always visible, never silently defaulted
- Category chips
- Numpad entry
- Dynamic submit button labeling

### 4.3 Transaction Import (new for v1)
- User selects a CSV or XLSX file exported from any Nepali banking app or source
- **Column mapping screen**: since every bank exports differently (column names, date formats, debit/credit split vs. signed single-amount column), the user maps their file's columns to Dhukuti's schema (Date, Description, Amount, [optional] Category)
- **Preview & confirm step** before anything is committed to the database
- **Duplicate detection**: flags likely-duplicate rows (matching date + amount + description) already present in `transactions`
- Imported transactions are tagged `source: import` for traceability
- Post-import: user can bulk-assign categories to unmapped rows

### 4.4 Sync
- All reads/writes go through Supabase; any device signed into the same account sees the same data
- Offline: local cache (`sqflite`/`drift`) queues writes and reconciles on reconnect
- Google Sheets export remains available as a manual/scheduled backup (ported from existing Apps Script integration), not a sync path

---

## 5. Design System

Carried over unchanged from the existing documentation; Flutter implementation should treat these as fixed tokens.

**Color Palette**
| Token | Hex | Usage |
|---|---|---|
| Background | `#FAFAFA` | App canvas |
| Surface | `#FFFFFF` | Cards |
| Text primary | `#111111` | Main text |
| Text secondary | `#666666` | Descriptions |
| Text tertiary | `#999999` | Labels |
| Border | `#EEEEEE` | Card outlines, dividers |
| Success | `#34C759` | Income, positive progress |
| Danger | `#FF3B5C` | Expenses, deletions |
| Info | `#007AFF` | Income actions, links |
| Warning | `#FFD60A` | Auto-contribute indicator |
| Accent purple | `#AF52DE` | Investments, mesh highlights |

**Hero Dark Gradient** (Total Capital / Savings hero cards)
```
linear-gradient(135deg, #0a0a1a 0%, #1a1a2e 50%, #16213e 100%)
```
Radial mesh accents in purple/blue/green at 25–35% opacity, plus grain noise overlay.

**Typography**: DM Sans, weights 400–800. Hero numbers 34px/800/-1.2 letter-spacing. Section headers 20px/700. Body 13–14px/500.

**Iconography**: Line-style icons at stroke width 1.8–2 (Lucide in the prototype; Flutter equivalent — e.g. Phosphor or a matching line-icon set — should preserve the same visual weight). No emojis, anywhere.

**Spacing/Radii**: 20px container padding, 14–24px card radii depending on size, 10–13px button radii.

Full token reference (shadows, animation timings, user-pickable palette) is preserved in the original `finance-app-docs.md` and should be treated as the authoritative source during Flutter implementation.

---

## 6. Launch Requirements Checklist

### App Store / Play Store
- [ ] Apple Developer account ($99/yr)
- [ ] Google Play Developer account ($25 one-time)
- [ ] App icons at all required sizes (iOS + Android)
- [ ] Screenshots per required device size
- [ ] Privacy Policy (mandatory; extra scrutiny expected given financial data)
- [ ] Apple Privacy Nutrition Label disclosures
- [ ] Apple Sign-In implemented (required if any other social login is offered)
- [ ] Account deletion flow (required by both stores)

### Security & Compliance
- [ ] Encryption at rest (handled by Supabase/Postgres defaults, verify configuration)
- [ ] HTTPS everywhere (default with Supabase)
- [ ] No raw account numbers or sensitive banking credentials logged or stored
- [ ] Row-Level Security verified on every table before launch
- [ ] Terms of Service drafted
- [ ] Monitor Nepal Rastra Bank (NRB) guidance if any future feature touches real payments or bank credentials (out of scope for v1's manual-entry model)

### Infrastructure
- [ ] Supabase project provisioned (production + staging)
- [ ] CI/CD for Flutter builds (iOS + Android)
- [ ] Crash reporting / analytics (e.g. Sentry, Firebase Crashlytics)

---

## 7. Open Questions
1. Should Google Sign-In be included in v1, given it also enables a smoother Sheets-export path?
2. Should the column-mapping UI for CSV/XLSX import remember a user's mapping per bank for future imports?
3. Offline-first depth: is queuing writes while offline sufficient for v1, or is full offline read access (browsing past transactions with no connection) required at launch?
4. Multi-currency (USD alongside NPR) was in the original prototype's differentiators — is this in scope for v1 or deferred?

---

## 8. Post-Launch Roadmap (from original prototype's Future Enhancements)

**Near-term**
- Recurring transactions (rent, subscriptions) with auto-creation
- Transfers between accounts (not counted as income/expense)
- Smart category suggestion based on merchant name (Pathao → Transport, Bhat Bhateni → Food)
- Category budgets with threshold warnings
- Dark mode

**Nepal-specific**
- eSewa / Khalti / IME Pay as first-class account types
- Dashain/Tihar seasonal budget mode
- Nepali fiscal year (Shrawan–Ashad) reporting
- Gold/silver asset tracking

**Collaboration (post-v1)**
- Joint accounts with permission levels
- Shared savings goals (e.g., group trip fund)
- Envelope budgeting across categories

**Intelligence**
- Predictive balance ("At current spending rate, this account runs out on day 22")
- Anomaly detection on unusual spending
- Receipt OCR for auto-fill on the Add screen
- PDF statement export

---

*This PRD supersedes the "Personal Finance App" prototype documentation for planning purposes. The prototype's `finance-app-docs.md` remains the authoritative reference for exact visual specs, component structure, and interaction detail during Flutter implementation.*
