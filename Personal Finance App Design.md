# Personal Finance App — Complete Documentation

A mobile-first personal finance management app built with React. Tracks multiple bank accounts, categorizes expenses and incomes with date selection, and manages savings goals as virtual money pots with real balance transfers.

**Maintainer:** sujalwaa
**Default Currency:** NPR (Nepalese Rupee)
**Data:** Sample data only — state resets on page reload
**Last updated:** April 2026

---

## Table of Contents

1. [Application Overview](#1-application-overview)
2. [Tech Stack & Dependencies](#2-tech-stack--dependencies)
3. [Design System — Theme Reference](#3-design-system--theme-reference)
4. [Data Model — Complete Schema](#4-data-model--complete-schema)
5. [Screen-by-Screen Breakdown](#5-screen-by-screen-breakdown)
6. [UI Component Library](#6-ui-component-library)
7. [User Workflows — Step by Step](#7-user-workflows--step-by-step)
8. [Functionality Logic — How Things Work Internally](#8-functionality-logic--how-things-work-internally)
9. [State Management](#9-state-management)
10. [Usability & Accessibility](#10-usability--accessibility)
11. [Code Architecture](#11-code-architecture)
12. [Sample Data Inventory](#12-sample-data-inventory)
13. [Future Enhancements](#13-future-enhancements)

---

## 1. Application Overview

### What It Does
Tracks personal finances across multiple Nepali bank accounts (NIC Asia, Nabil Bank, Cash, Savings, Investments). Users log expenses and incomes with a date, categorize spending, analyze patterns through donut charts, and save toward specific goals using a virtual pot system where money physically moves between accounts and goals.

### Who It's For
Young professionals in Nepal who juggle multiple bank accounts and want to understand where their money goes, save intentionally, and see their total net worth in one place. Supports both NPR and USD display.

### Core Concepts
- **Accounts** are real-world holdings (bank accounts, cash, portfolios)
- **Transactions** are expenses (negative) and incomes (positive) linked to accounts
- **Categories** label expenses (Food, Transport, etc.)
- **Goals** are virtual savings pots — contributing moves real money from an account into the pot; withdrawing moves it back
- **Total Capital** = sum of all account balances + sum of all goal balances

---

## 2. Tech Stack & Dependencies

| Layer | Technology | Details |
|---|---|---|
| Framework | React 18+ | Functional components, hooks only (`useState`, `useRef`, `useEffect`) |
| Icons | `lucide-react` | 40+ icons imported, all rendered at strokeWidth 1.8-2.5 |
| Typography | DM Sans | Google Fonts, weights 400-800, loaded via `<link>` in render |
| Styling | Inline React styles | No CSS framework, no external stylesheets |
| State | React local state | All state in root `FinanceApp` component, passed down as props |
| Charts | Custom SVG | Hand-built donut chart, progress rings, sparkline, sources bar |
| Layout | Single `.jsx` file | ~1500 lines, max-width 430px mobile container |
| Persistence | None | Data lives in React state, resets on reload |

### Lucide Icons Used (complete list)
```
Home, BarChart3, PiggyBank, Plus, Settings, ChevronLeft, ChevronDown,
MoreHorizontal, ArrowDownLeft, ArrowUpRight, TrendingUp, Wallet, Building2,
Banknote, Landmark, Receipt, Utensils, Gamepad2, Car, Heart, ShoppingBag,
X, Check, Trash2, Edit3, Download, RefreshCw, Minus, Target, Shield, Plane,
Laptop, CreditCard, DollarSign, FileSpreadsheet, ChevronRight, User, Eye,
EyeOff, Tag, Layers, Delete, Search, Sparkles, Zap, Calendar, ArrowRight,
History, AlertCircle, Info
```

---

## 3. Design System — Theme Reference

### 3.1 Color Palette

#### Base Colors (app chrome)
| Token | Hex | Where Used |
|---|---|---|
| Canvas | `#FAFAFA` | App background, Modal backgrounds |
| Surface | `#FFFFFF` | Cards, inputs, bottom sheets |
| Muted surface | `#F5F5F5` | Toggle backgrounds, chips, numpad keys, search bar |
| Numpad key | `#F8F8F8` | Numpad button fill |
| Border | `#EEEEEE` | Input borders, unselected chips |
| Divider | `#F3F3F3` | Transaction row separators |
| Light divider | `#F5F5F5` | Income list separators |
| Light divider 2 | `#F8F8F8` | Category list separators in analytics |

#### Text Colors
| Token | Hex | Where Used |
|---|---|---|
| Primary | `#111111` | Main text, amounts, nav active |
| Secondary | `#333333` | Day grid numbers, modal titles |
| Tertiary | `#555555` | Settings gear icon, date label |
| Quaternary | `#666666` | Unselected category chips, cancel buttons |
| Muted | `#888888` | Numpad backspace, unselected icons |
| Label | `#999999` | Section labels ("Recent transactions"), secondary stats |
| Placeholder | `#AAAAAA` | Timestamps, subtle metadata |
| Disabled | `#BBBBBB` | Inactive nav icons |
| Faded | `#CCCCCC` | Chevron arrows, inactive dots |
| Very faded | `#DDDDDD` | Future dates in calendar, inactive pagination dots |

#### Semantic Colors
| Token | Hex | Use |
|---|---|---|
| Success / Income | `#34C759` | Income amounts, growth %, progress bars, success states, sparkline |
| Success bg | `#E8F9E8` | Growth badge background |
| Danger / Expense | `#FF3B5C` | Mandatory category, delete, error states, over-limit warning |
| Danger bg | `#FEE` / `#FEF2F2` | Delete zone background |
| Info / Income action | `#007AFF` | "Add income" button, blue categories, info badges |
| Warning / Auto | `#FFD60A` | Auto-contribute ⚡ zap icon (fill + stroke) |

#### User-Selectable Palette (accounts, categories, goals)
Used in color picker swatches — exactly these 10 colors in this order:
```
#FF3B5C, #FF8C00, #34C759, #007AFF, #AF52DE,
#FF69B4, #FFD60A, #5856D6, #FF6B6B, #00C9A7
```

Swatch rendering: 28×28px circles, 14px border-radius, 3px border (solid `#333` when selected, transparent otherwise).

#### Hero Dark Card Gradient
```css
background: linear-gradient(135deg, #0a0a1a 0%, #1a1a2e 50%, #16213e 100%);
```

Layered with three radial gradient mesh accents:
1. **Purple glow** — top-right, 180×180px, `rgba(175, 82, 222, 0.35)`, 70% fade
2. **Blue glow** — bottom-left, 200×200px, `rgba(0, 122, 255, 0.25)`, 70% fade
3. **Green glow** — center, 120×120px (on some variants only)

Plus a noise/grain texture SVG overlay at 8% opacity with `mixBlendMode: "overlay"`.

#### Account Card Gradient
Each account card uses its own color:
```css
background: linear-gradient(135deg, ${color}E8, ${color}BB);
```
With a decorative circle: 100×100px, `rgba(255,255,255,0.08)`, positioned top-right at -30px offset.

### 3.2 Typography

**Font family:** `'DM Sans', -apple-system, BlinkMacSystemFont, sans-serif`

Loaded weights: 400, 500, 600, 700, 800.

| Element | Size | Weight | Letter-spacing | Color |
|---|---|---|---|---|
| Hero total capital amount | 34px | 800 | -1.2px | white |
| Hero decimal portion | 24px | 600 | — | `rgba(255,255,255,0.45)` |
| Page title (Analytics, Savings) | 20px | 700 | — | `#111` |
| Add transaction title | 18px | 700 | — | `#111` |
| Modal title | 16px | 600 | — | `#333` (centered) |
| Account card balance | 22px | 700 | -0.5px | white |
| Amount on numpad screen | 38px | 700 | -1px | `#111` |
| Contribute/withdraw amount | 34px | 700 | -1px | `#111` or `#FF3B5C` (error) |
| Analytics net income | 24px | 700 | -0.5px | white |
| Goal detail saved amount | 30px | 800 | -0.5px | white |
| Donut chart center amount | 20px | 700 | — | `#111` |
| Transaction name | 14px | 500 | — | `#111` |
| Account tag | 9px | 600 | — | account color |
| Section label (uppercase) | 11px | 700 | 0.5px | `#AAA` |
| Section label (sentence case) | 13px | 600 | — | `#999` |
| Timestamp | 11px | 400 | — | `#AAA` |
| Navigation label | 10px | 400/600 | — | `#BBB`/`#111` |
| Quick chip label | 12px | 500 | — | varies |
| Category chip text | 12px | 500 | — | category color or `#666` |
| Account chip text | 11px | 500 | — | account color or `#888` |
| Weekday header (calendar) | 11px | 600 | — | `#BBB` |
| Calendar day number | 14px | 400/600/700 | — | varies by state |

### 3.3 Spacing & Layout

| Token | Value |
|---|---|
| App max-width | 430px |
| App min-height | 100vh |
| Horizontal page padding | 20px |
| Modal internal padding | 16px top, 20px sides, 100px bottom |
| Bottom sheet padding | 20px sides, 32px bottom |
| Card padding (hero) | 22-24px |
| Card padding (account) | 16-18px |
| Card padding (goal) | 16-18px |
| Transaction row vertical padding | 13px |
| Bottom nav padding | 6px top, 16px sides, 22px bottom |
| Scroll content bottom padding | 80px (clears nav bar) |

### 3.4 Border Radii

| Element | Radius |
|---|---|
| Hero dark card | 24px |
| Savings hero card | 22px |
| Account swipe cards | 18px |
| Analytics donut card | 18px |
| Goal cards | 16px |
| Standard cards / settings rows | 14px |
| Input fields | 10-12px |
| Numpad keys | 10-11px |
| Pill/chip selectors | 9-18px |
| Pagination dots | 3px |
| Bottom sheet top corners | 24px |
| Color swatches | 14px (circular) |
| Icon tiles (transaction rows) | 11px |
| Navigation "Add" button | 14px |
| Account icon in card | 8px |
| Small color dots | 3-5px |

### 3.5 Shadows

```css
/* Hero total capital card — strongest shadow in the app */
box-shadow: 0 20px 50px -12px rgba(10, 10, 26, 0.5),
            0 8px 20px -8px rgba(10, 10, 26, 0.4);

/* Savings hero card */
box-shadow: 0 15px 40px -10px rgba(10, 10, 26, 0.4);

/* Goal preview card (create goal) */
box-shadow: 0 10px 30px -10px ${color}60;  /* goal color at 37% opacity */

/* Analytics net income dark card */
box-shadow: 0 10px 30px -10px rgba(10, 10, 26, 0.4);

/* Standard card */
box-shadow: 0 1px 4px rgba(0, 0, 0, 0.04);

/* Slightly elevated card */
box-shadow: 0 1px 5px rgba(0, 0, 0, 0.04);

/* Item editor */
box-shadow: 0 2px 12px rgba(0, 0, 0, 0.06);

/* Toggle switch dot */
box-shadow: 0 1px 3px rgba(0, 0, 0, 0.15);

/* Bottom nav "Add" button */
box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);

/* Active toggle segment */
box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);

/* Savings goal progress bar glow */
box-shadow: 0 0 10px rgba(52, 199, 89, 0.5);
```

### 3.6 Animations

| Name | Duration | Easing | Keyframes | Used For |
|---|---|---|---|---|
| `fadeUp` | 400ms | ease | `translateY(10px) + opacity 0 → 0` | Page/tab transitions |
| `slideUp` | 300ms | ease | `translateY(100%) → 0` | Modals, bottom sheets |
| `fadeIn` | 200ms | ease | `opacity 0 → 1` | Bottom sheet overlays |
| `spin` | 1000ms | linear (infinite) | `rotate(0deg → 360deg)` | Loading spinners (backup, export) |
| Inline transitions | 150-800ms | ease | — | Progress bars (width), donut segments (stroke-dasharray/offset), dot pagination, color changes |

### 3.7 Iconography Rules
- **All icons are lucide-react** — no emojis anywhere in the app
- Default stroke width: 1.8
- Active/emphasis stroke width: 2-2.5
- Nav icons: 20px, active strokeWidth 2, inactive 1.5
- Transaction row icons: 16px in a 38×38px tile with 11px radius
- The user-selectable icon pool has exactly 20 options: `receipt, utensils, gamepad, car, heart, shoppingbag, wallet, building, banknote, trending, landmark, target, shield, plane, laptop, creditcard, dollar, tag, layers, piggybank`
- Icon selector grid: 36×36px per icon, 10px radius, 6px gap, wraps

---

## 4. Data Model — Complete Schema

### 4.1 Currency
```typescript
{
  symbol: string,     // "रू" or "$"
  name: string,       // "Nepalese Rupee"
  rate: number         // 1 for NPR (base), 0.0075 for USD
}
```
All monetary values are stored in **paisa** (1 NPR = 100 paisa). Display conversion: `value_in_paisa / 100 * currency.rate`. This means the raw numbers are always integers — no floating-point money math.

### 4.2 Account
```typescript
{
  id: string,          // "nic", "nabil", "cash", etc.
  name: string,        // "NIC Asia"
  color: string,       // "#FF3B5C"
  balance: number,     // 4523500 (paisa) = रू 45,235.00
  icon: string         // "creditcard" — key into ICON_MAP
}
```

### 4.3 Category (expense only)
```typescript
{
  id: string,          // "food"
  name: string,        // "Food"
  icon: string,        // "utensils"
  color: string        // "#FF8C00"
}
```

### 4.4 Transaction (expense)
```typescript
{
  id: number,
  name: string,        // "Bhat Bhateni"
  account: string,     // references Account.id
  amount: number,      // -435000 (negative = expense)
  date: string,        // ISO 8601: "2026-04-02T17:30:00"
  category: string     // references Category.id
}
```

### 4.5 Income
```typescript
{
  id: number,
  name: string,        // "Salary - April"
  account: string,     // references Account.id
  amount: number,      // 7500000 (positive)
  date: string         // ISO 8601
}
```

### 4.6 Goal (virtual savings pot)
```typescript
{
  id: number | string,
  name: string,            // "Emergency Fund"
  target: number,          // 10000000 paisa (रू 100,000)
  icon: string,            // "shield"
  color: string,           // "#FF3B5C"
  sourceAccount: string,   // Account.id — the linked bank account
  balance: number,         // current pot value in paisa
  auto: {
    enabled: boolean,
    amount: number,        // monthly auto-contribute amount in paisa
    dayOfMonth: number     // 1-28
  },
  contributions: [         // ordered by date, newest first for display
    {
      id: string,
      type: "contribute" | "withdraw",
      amount: number,      // always positive — direction determined by type
      date: string,        // ISO 8601
      note: string         // optional user note
    }
  ]
}
```

### 4.7 Money Flow Invariants (critical logic)

These rules ensure money is never created or destroyed:

1. **Contribute to goal:** `sourceAccount.balance -= amount`, `goal.balance += amount`, new contribution entry pushed
2. **Withdraw from goal:** `goal.balance -= amount`, `sourceAccount.balance += amount`, new withdrawal entry pushed
3. **Create goal with initial deposit:** goal created with `balance = initialDeposit`, `sourceAccount.balance -= initialDeposit`
4. **Delete goal:** `sourceAccount.balance += goal.balance` (remaining money returns), goal removed from array
5. **Total Capital** = `Σ(account.balance)` + `Σ(goal.balance)` — always conserved

### 4.8 Date Formatting Logic

The app uses a reference date of `2026-04-15T12:00:00` as "now".

- **fmtDate(d):** If within 24 hours → "Today at 1:30 pm". If within 48 hours → "Yesterday at 1:30 pm". Otherwise → "15 Apr at 1:30 pm". Time uses `en-GB` locale, 12-hour format, lowercase am/pm.
- **fmtShortDate(d):** "15 Apr 26" — used in goal contribution history.
- **fmtAmt(cents, currency):** Takes paisa, multiplies by rate, splits into int/dec, formats int with commas. Returns `{ sign, int, dec, symbol }`.

### 4.9 Period Filtering Logic
- `getMonthRange(0)` → April 1-30, 2026
- `getMonthRange(-1)` → March 1-31, 2026
- `filterByPeriod(items, "this")` → items with date in current month
- `filterByPeriod(items, "last")` → items with date in previous month
- `filterByPeriod(items, "custom")` → all items (no filter)

---

## 5. Screen-by-Screen Breakdown

### 5.1 Overview Tab

**Purpose:** Landing page showing total wealth, accounts, and recent activity.

**Layout (top to bottom):**

1. **Header row** (padding 12px 20px 16px)
   - Left: Avatar circle (40×40, gradient `#FFD6A0→#FFAB6B`, User icon 18px white) + greeting text ("Good evening," in 12px `#999`, "sujalwaa" in 15px weight 600)
   - Right: Settings gear icon (36×36 circle, 1px `#EEE` border, Settings icon 16px `#555`)

2. **Total Capital Hero Card** (margin 0 20px, margin-bottom 28px)
   - Dark gradient background with mesh glows and grain overlay
   - Top row: Sparkles icon + "TOTAL CAPITAL" label (11px uppercase `rgba(255,255,255,0.6)`) + Eye toggle (30×30 circle, `rgba(255,255,255,0.08)` background)
   - Main amount: 34px weight 800 white, decimal in 24px `rgba(255,255,255,0.45)`
   - If balance hidden: shows `••••••` with 4px letter-spacing
   - Stats row: "This month" with green ArrowUpRight + "+6.3%" in green 13px bold | divider (1px white 10% opacity) | "In goals" with total goal balance in white 13px bold
   - Right side: Sparkline SVG (120×40, green, gradient fill underneath)
   - Bottom section (separated by 1px border at 8% white): "{N} accounts · {N} goals" label + "View details >" + Sources bar (4px height, each account proportional, diagonal stripe pattern for goals portion)
   - **Shadow:** `0 20px 50px -12px rgba(10,10,26,0.5), 0 8px 20px -8px rgba(10,10,26,0.4)`
   - **Tap action:** Opens Capital Sheet (My Capital detail view)

3. **Accounts section label** (padding 0 20px, flex between)
   - Left: "Accounts" in 13px weight 600 `#999`
   - Right: "1 of 5" counter in 11px `#AAA`

4. **Swipeable Account Cards** (horizontal scroll, padding 0 20px, gap 10px)
   - Each card: `minWidth: calc(100% - 48px)`, `scrollSnapAlign: "center"`
   - Gradient background using account color
   - Top row: Icon tile (26×26, `rgba(255,255,255,0.2)`) + account name (12px, 0.9 opacity) | three-dot menu icon
   - Balance: 22px weight 700, decimal in 15px at 0.5 opacity. Hidden mode: `•••••`
   - "Add money" button: `rgba(255,255,255,0.22)` background with `backdropFilter: blur(8px)`, Plus icon + text, 11px radius
   - **Tap "Add money":** Opens AddMoneySheet bottom sheet for that account

5. **Pagination dots** (center, gap 5px, padding 10px 0 20px)
   - Active dot: 16×6px, `#333`, radius 3px
   - Inactive dots: 6×6px, `#DDD`, radius 3px
   - Transition: `all 0.3s`

6. **Recent Transactions** (padding 0 20px)
   - Section label: "Recent transactions" 13px weight 600 `#999`
   - **Search bar:** flex row, `#F5F5F5` background, 12px radius, 10px 14px padding. Search icon (15px `#AAA`) + text input (13px, transparent background, no border) + X clear button when search has text
   - **Transaction rows** (up to 10 shown, sorted newest first):
     - Icon tile: 38×38px, 11px radius, `#F5F5F5` background, category icon 16px in category color
     - Name (14px weight 500) + account tag (9px, account color, light tinted background, 4px radius)
     - Timestamp below (11px `#AAA`)
     - Amount right-aligned: 14px weight 600, `#111`. Hidden mode: `•••`
     - Divider: 1px `#F3F3F3`
   - Empty search state: "No matching transactions" centered in 13px `#AAA`

### 5.2 Capital Sheet (My Capital)

**Trigger:** Tap the Total Capital hero card on Overview.

**Type:** Full-screen Modal with `slideUp` animation.

**Layout:**
1. Header: "My capital" centered, back chevron left
2. Total amount: 32px weight 700, centered
3. Growth badge: green "6.3%" pill + "Month-over-Month" text
4. **Liquid vs Goals split:** Two stat cards side by side (grid 1fr 1fr, gap 10px)
   - "LIQUID (ACCOUNTS)" card with sum of account balances
   - "IN GOALS" card with sum of goal balances
5. **Accounts section:** "Accounts" label → SourcesBar (10px height) → list of accounts with colored dot + name + percentage + formatted amount
6. **Recent incomes section:** Income entries sorted by date, each with ArrowDownLeft icon in account-colored tile, name + account tag, timestamp, green amount

### 5.3 Analytics Tab

**Layout:**
1. Header: "Analytics" title + Settings gear
2. **Period toggle** (3 segments): "This month" | "Last month" | "All time". Active segment: white background with subtle shadow. Rounded 10px container with 3px padding, gray `#F5F5F5` background.
3. **Income / Expenses stat cards** (grid 2-col):
   - Income card: ArrowDownLeft icon green + "Income" label + formatted total
   - Expenses card: ArrowUpRight icon red + "Expenses" label + formatted total
4. **Net Income dark card** (same gradient as hero):
   - Purple radial glow top-right
   - Left: "Net income" label + amount (24px weight 700 white)
   - Right: "Savings rate" label + colored badge with TrendingUp icon + percentage
   - Savings rate = `(totalIncome - totalExpenses) / totalIncome * 100`
5. **Expenses by category card** (white, 18px radius):
   - DonutChart (190×190, 32px stroke width, rounded caps, 2px gap between segments)
   - Center text: total spent amount + "Total spent" label
   - Category legend rows (tappable): colored dot + name + percentage badge + amount + ChevronRight
   - **Tap category row:** Opens CategoryDetail modal

### 5.4 Category Detail

**Trigger:** Tap any category row in Analytics.

**Type:** Full-screen Modal.

**Layout:**
1. Category icon tile (56×56, 18px radius, tinted background)
2. Total amount for filtered period (28px weight 700)
3. Transaction count + period label ("6 transactions · This month")
4. Transaction list (same row format as Overview) filtered by both category AND active period
5. Empty state: Receipt icon + "No transactions in this period"

**Key logic:** Uses `filterByPeriod(transactions, period)` then filters by `t.category === category.id`. Sorted newest-first.

### 5.5 Savings Tab

**Layout:**
1. Header: "Savings" title + Settings gear
2. **Total Saved hero** (dark gradient, same style as overview hero):
   - "TOTAL SAVED ACROSS GOALS" label (11px uppercase)
   - Sum of all goal balances (30px weight 800)
   - "of {target} target" text
   - Full-width progress bar (6px, green gradient glow shadow)
   - Percentage label right-aligned
   - Auto-contribute summary: Zap icon + "Auto-saving रू X/mo across N goals"
3. **Info tip** (shown only when zero goals): Blue gradient card explaining how virtual pots work
4. **Goals list header:** "Your goals" + count
5. **Goal cards** (white, 16px radius, 16px padding):
   - ProgressRing (50px, account-color stroke) with icon centered inside
   - Name + ⚡ zap icon (if auto-enabled, yellow filled)
   - "रू X saved · रू Y to go" (11px `#AAA`)
   - Percentage badge (goal color, 12% tinted background)
   - Progress bar (4px, goal color fill)
   - Source account indicator: tiny colored dot + "From {account name}" (10px `#AAA`)
   - **Tap:** Opens GoalDetail
6. **"+ Create new savings goal" button:** dashed 2px border, white background, centered text

### 5.6 Goal Detail

**Trigger:** Tap any goal card on Savings tab.

**Type:** Full-screen Modal with Edit icon (Edit3) in top-right.

**Layout:**
1. **Hero card** (goal-color gradient, 22px radius, heavy shadow using goal color at 37%):
   - Decorative circles top-right and bottom-left
   - Large ProgressRing (90px, 6px stroke, white color) with goal icon centered (28px)
   - "Saved" label + balance amount (30px weight 800)
   - "of {target} target" text
   - Completion percentage in a white 15% opacity pill
2. **Action buttons** (flex row, gap 10):
   - **Contribute:** full-width, goal-colored background, white text, Plus icon
   - **Withdraw:** full-width, white background, dark text, Minus icon, 1px `#E4E4E4` border
3. **Info cards** (grid 2-col):
   - "REMAINING" with formatted remaining amount
   - "AT CURRENT PACE" with calculated months — logic: sum net contributions over last 3 months, divide by 3 to get monthly pace, divide remaining by pace. Shows "Complete! 🎉" if goal reached, "—" if no contributions.
4. **Source account card:** Shows linked account icon, name, and available balance
5. **Auto-contribute banner** (if enabled): goal-color tinted background, Zap icon, amount + day text ("रू 10,000 on the 5th of each month")
6. **Activity history:** History icon + "Activity" label. Contribution entries sorted newest-first. Each entry: ArrowDownLeft (contribute, goal-colored) or ArrowUpRight (withdraw, gray) icon, "Contribution" or "Withdrawal" text + optional note, short date, amount with +/- sign
7. **Danger zone** (bottom): Red tinted box. Initial state shows "Delete goal" text. Tap → inline confirmation with explanation ("The रू X in this goal will be returned to {account}") + Cancel/Delete buttons.

### 5.7 Create/Edit Goal Sheet

**Trigger:** "+ Create new savings goal" or Edit icon on Goal Detail.

**Type:** Full-screen Modal.

**Layout:**
1. **Live preview card** (goal-color gradient): Shows icon, name, and target as you type — updates in real time
2. **Goal Name** input: text field, 12px radius
3. **Target Amount** input: number field with currency symbol prefix positioned absolutely inside the field
4. **Icon & Color:** Color swatches (10 options, same grid as ItemEditor) + icon grid (20 options, 36×36 tiles)
5. **Source Account:** Tappable card showing selected account icon, name, and balance. Tap → AccountPicker bottom sheet
6. **Initial Deposit** (create mode only): Number input with currency prefix. Helper text: "This amount will be moved from {account} to the goal immediately."
7. **Auto-contribute toggle:** Zap icon + label + description + iOS-style toggle switch (42×26px, animated). When enabled, reveals:
   - Amount per month input (currency prefix)
   - Day of month input (1-28, clamped) with Calendar icon
   - All in a tinted container (goal color at 8% + 12px radius)
8. **Submit button:** "Create goal" or "Save changes" (black, disabled gray if name or target missing)

**Validation:** `canSave = name && target && Number(target) > 0 && sourceAccount`

### 5.8 Contribute/Withdraw Sheet

**Trigger:** Contribute or Withdraw button on Goal Detail.

**Type:** BottomSheet (max 80vh).

**Layout:**
1. Title: "Contribute to {name}" or "Withdraw from {name}" + close X
2. **Flow visualization card** (`#FAFAFA`, 14px radius): Shows FROM (icon + name + available balance) → ArrowRight → TO (icon + name). Direction reverses for withdraw vs contribute.
3. **Amount display:** 34px weight 700. Turns `#FF3B5C` red if exceeds max. Error message below with AlertCircle icon: "Exceeds available (रू X)".
4. **Note input:** optional, same style as description field
5. **Numpad** (shared component)
6. **Submit button:** Goal-colored for contribute, dark for withdraw. Disabled state: `#CCC`. Success state: green with Check icon + "Done!"

**Validation logic:**
- `maxAmount = type === "contribute" ? sourceAccount.balance : goal.balance`
- `exceedsMax = enteredAmountInPaisa > maxAmount`
- `canSubmit = amount !== "0" && amountInPaisa > 0 && !exceedsMax`

### 5.9 Add Transaction Tab

**Trigger:** Tap the "+" Add button in bottom navigation.

**Note:** This replaces the tab view entirely (nav bar hidden). Close X returns to Overview.

**Layout (top to bottom):**
1. Header: "Add transaction" (18px weight 700) + close X (32×32 circle)
2. **Type toggle:** "expense" | "income" (segmented control, same style as analytics period)
3. **Account + Date pill row** (flex center, gap 10px):
   - **Account pill:** colored dot + name + ChevronDown, tinted background at 12% account color. Tap → AccountPicker bottom sheet.
   - **Date pill:** Calendar icon (13px `#555`) + date label + ChevronDown, `#F5F5F5` background. Label shows "Today", "Yesterday", or formatted date (e.g., "12 Apr 2026"). Tap → DatePickerSheet.
4. **Amount display:** 38px weight 700, currency symbol prefix, centered. Decimal portion in `#999`.
5. **Description input:** text field, "Description (optional)" placeholder
6. **Category chips** (expense only): Horizontal scroll, gap 7px, no scrollbar. Each chip: icon + name, 11px radius. Selected: 2px solid border in category color + 8% tinted bg. Unselected: 1px `#EEE` border.
7. **Account quick chips:** Same horizontal scroll pattern, smaller (7px 12px padding, 9px radius). Shows colored dot + name.
8. **Numpad:** 3×4 grid, 7px gap, 11px radius keys. Backspace key shows Delete icon instead of text.
9. **Submit button:**
   - Expense mode: `#111` background, "Add expense" text
   - Income mode: `#007AFF` background, "Add income" text
   - Success: `#34C759` background, Check icon + "Added!"
   - Disabled (amount "0"): 40% opacity, cursor default
   - Animation: 1400ms timeout for success state, then resets amount and name

**Numpad input logic:**
- Cannot type two decimal points
- Maximum 2 decimal digits
- "back" key removes last character; if only 1 char left, resets to "0"
- Leading "0" replaced by first non-zero digit (except ".")
- Display formatting: commas in integer portion (`replace(/\B(?=(\d{3})+(?!\d))/g, ",")`)

### 5.10 Date Picker Sheet

**Trigger:** Tap the date pill on Add Transaction.

**Type:** BottomSheet.

**Layout:**
1. Header: "Pick a date" + close X
2. **Month navigation:** ChevronLeft (32×32, `#F5F5F5` background) + month/year label (14px weight 600, e.g., "April 2026") + ChevronRight. Wraps year (Dec → Jan increments year).
3. **Weekday headers:** Grid 7 columns, "Su Mo Tu We Th Fr Sa", 11px weight 600 `#BBB`
4. **Day grid:** Grid 7 columns, 2px gap.
   - Empty cells for first-day-of-week offset (Sunday = 0)
   - Each day: 14px, 10px padding top/bottom, 10px radius
   - **Today:** `#F0F0F0` background, weight 600, `#111` text
   - **Selected:** `#111` background, white text, weight 700
   - **Future dates:** `#DDD` text, cursor default, non-tappable (click ignored)
   - **Normal past:** `#333` text, weight 400, transparent bg
   - Transition: `all 0.15s`
5. **Quick action chips** (flex row, gap 8px, margin-top 16px): "Today" | "Yesterday" | "2 days ago". Each chip: flex 1, 10px padding, 10px radius, 12px weight 500. Active: `#111` bg + white text. Inactive: `#F5F5F5` bg + `#555` text.
6. **Tap a day or chip:** calls `onSelect(isoString)` and closes the sheet.
7. Future dates are blocked — `isFuture(day)` returns true if `new Date(year, month, day) > now`.

### 5.11 Settings Page

**Trigger:** Settings gear icon (top-right on Overview, Analytics, Savings).

**Type:** Full-screen Modal.

**Sections:**
1. **CURRENCY** (11px uppercase bold label): Two cards side by side (flex, gap 8). Active: `#111` bg + white text. Inactive: white bg + `#333`. Each shows currency symbol (20px bold) + code (11px). NPR default.
2. **PRIVACY:** Row with Eye/EyeOff icon + "Hide balances by default" + iOS-style toggle (42×26px). Toggle track: `#111` when on, `#E0E0E0` when off. Dot: 20×20 white circle with shadow, animates `left: 3px ↔ 19px`.
3. **DATA:**
   - "Backup to Google Sheets" row: FileSpreadsheet icon green. Tap → shows spinning RefreshCw icon (1s rotation) → shows Check icon after 1.5s.
   - "Export Data (CSV)" row: Download icon blue. Same spinner → check pattern (1.2s).
4. **MANAGE:**
   - "Income Sources / Accounts" → ManageList modal
   - "Expense Categories" → ManageList modal
   - Footer note with Info icon: "Manage savings goals from the Savings tab."

Each settings row: 15px padding, 14px radius, white bg, `0 1px 4px` shadow, flex between icon tile (34×34, `#F5F5F5`) + label and right element (chevron or toggle or spinner).

### 5.12 Manage List (Accounts / Categories)

**Type:** Full-screen Modal.

**States:**
- **List view:** Shows all items as tappable cards (icon tile + name + Edit3 pencil icon). Plus dashed "Add new" button at bottom.
- **Editor view:** Shows ItemEditor form (text/number inputs + color swatches + icon grid + Cancel/Save/Delete buttons).

### 5.13 Bottom Navigation Bar

**Position:** Fixed bottom, z-index 50, full-width within 430px container.
**Background:** `rgba(255,255,255,0.94)` with `backdrop-filter: blur(20px)`.
**Border:** 1px top, `rgba(0,0,0,0.05)`.
**Padding:** 6px 16px 22px (accounts for iPhone safe area).

**Contents:**
- 3 tab icons (Overview/Analytics/Savings) evenly spaced
- Active tab: icon at `#111` strokeWidth 2, label 10px weight 600 `#111`
- Inactive tab: icon at `#BBB` strokeWidth 1.5, label 10px weight 400 `#BBB`
- **"+ Add" button:** 52×52px, 14px radius, `#111` background, white Plus icon (20px) + "Add" text (9px weight 500). Shadow: `0 4px 12px rgba(0,0,0,0.15)`.

**Hidden when:** `tab === "add"` (Add Transaction is full-screen)

---

## 6. UI Component Library

### 6.1 Modal
Full-screen overlay anchored to viewport. Background `#FAFAFA`. Slides up on mount. Header: back chevron (left), centered title, optional right icon. Content scrolls independently with 100px bottom padding.

### 6.2 BottomSheet
Half-screen sheet from bottom. Backdrop: `rgba(0,0,0,0.4)` with `backdropFilter: blur(2px)` — tapping dismisses. Sheet: white, 24px top corners, 20px sides, 32px bottom padding. Max height 80vh, scrolls if overflows.

### 6.3 Numpad
Shared 3×4 grid. Keys: 1-9, `.`, `0`, backspace (Delete icon). Each key: 13px vertical padding, `#F8F8F8` background, 10px radius. Used in: AddTab, AddMoneySheet, ContributeSheet.

### 6.4 AccountPicker
BottomSheet listing all accounts. Each row: icon tile (38×38, 12px radius, tinted bg) + name + balance + check icon if selected. Selected row gets 2px colored border + 10% tinted bg. Tap selects and closes.

### 6.5 DatePickerSheet
BottomSheet with full calendar grid + quick action chips. Blocks future dates. On select → returns ISO string and closes.

### 6.6 DonutChart
SVG donut. Props: `data: [{ value, color }]`, `size` (default 190), `strokeWidth` (default 32). Each segment uses `strokeDasharray` with 2px gap, `strokeLinecap: "round"`, offset calculated cumulatively. Rotated 90° counter-clockwise (starts at top). All segments animate with `transition: all 0.6s ease`.

### 6.7 ProgressRing
SVG circular progress. Props: `progress` (0-1), `color`, `size`, `thickness`. Background ring in `#F0F0F0`. Foreground animates `stroke-dashoffset` over 600ms.

### 6.8 Sparkline
120×40px SVG. Hardcoded upward-trending polyline. Gradient fill from 30% color opacity to transparent underneath the line. Line: 2px stroke, round caps and joins.

### 6.9 SourcesBar
Horizontal flex bar (default 10px height, 5px radius). Each segment proportional to account balance, colored, with 2px gap.

### 6.10 IconRender
Wrapper that maps a string key (e.g., "utensils") to the corresponding lucide-react component. Falls back to Tag icon if key not found. Props: `name`, `size`, `color`, `strokeWidth`.

### 6.11 ItemEditor
Generic form component for creating/editing accounts, categories, goals. Field types:
- `text`: standard text input
- `number`: number input
- `color`: 10-color swatch grid
- `icon`: 20-icon grid with tinted highlight

Includes Cancel (gray), Save (dark), and optional Delete (red trash icon, 44×44) buttons.

### 6.12 Toggle Switch
Custom iOS-style toggle. Track: 42×26px, 13px radius. Dot: 20×20px, white, shadow. Animates `left: 3px ↔ 19px` on toggle. Track color: on = dynamic (goal color or `#111`), off = `#E0E0E0`.

---

## 7. User Workflows — Step by Step

### 7.1 Add an Expense (Backdated)
1. Tap **+ Add** in bottom nav → nav bar hides, full-screen entry opens
2. Type defaults to "Expense" (already selected)
3. See account pill (defaults to first account, e.g., "NIC Asia") and date pill ("Today")
4. **Tap date pill** → calendar opens as bottom sheet
5. Navigate to correct month if needed using chevron arrows
6. Tap the correct past date (e.g., April 12) — future dates are grayed out and untappable
7. Or tap "Yesterday" / "2 days ago" quick chip
8. Calendar closes, date pill now shows "12 Apr 2026"
9. Enter amount using numpad (e.g., tap 4, 3, 5 → shows "रू 435")
10. Tap description field, type "Grocery shopping" (optional)
11. Tap "Food" category chip (turns orange-bordered)
12. Optionally change account using pill or quick chips at bottom
13. Tap **"Add expense"** (dark button)
14. Button turns green with checkmark + "Added!" for 1.4 seconds
15. Amount and name reset, ready for next entry

### 7.2 Add an Income
1. Tap **+ Add** → same screen opens
2. **Tap "Income" toggle** → type switches, button becomes blue "Add income"
3. Tap date pill → pick the date salary was received
4. Category chips disappear (income has no categories)
5. Select account (e.g., "Nabil Bank")
6. Enter amount → tap **"Add income"** (blue button)

### 7.3 Search a Transaction
1. On Overview, scroll to "Recent transactions" section
2. Tap the search bar → keyboard opens
3. Type partial name (e.g., "pathao") → list filters in real time (case-insensitive)
4. Tap X icon in search bar to clear and show all transactions again

### 7.4 Create a Savings Goal
1. Go to **Savings** tab
2. Tap **"+ Create new savings goal"** (dashed border button)
3. Full-screen form opens with a live preview card at top
4. Type goal name: "Wedding Fund" → preview card updates immediately
5. Enter target: 500000 → preview shows "Target: रू 5,00,000"
6. Pick a color (e.g., pink `#FF69B4`) → preview card gradient updates
7. Pick an icon (e.g., heart) → preview card icon updates
8. Tap source account card → AccountPicker opens → select "Savings" → picker closes
9. Enter initial deposit: 50000 → helper text confirms "This amount will be moved from Savings to the goal immediately"
10. Toggle auto-contribute ON → fields appear with animation
11. Enter monthly amount: 25000, day: 1
12. Tap **"Create goal"** → goal appears in Savings list, Savings account balance drops by रू 50,000

### 7.5 Contribute to a Goal
1. **Savings** tab → tap "Emergency Fund" card
2. Goal Detail opens showing hero, stats, history
3. Tap **"Contribute"** button (goal-colored)
4. Bottom sheet shows flow: `[Savings] → [Emergency Fund]` with current balances
5. Enter amount: 15000
6. Type note: "Extra deposit from freelance"
7. Amount validates: green text (within limit). If entered more than Savings balance → turns red with error.
8. Tap **"Contribute"** → green success → sheet closes
9. Goal Detail now shows updated balance, new entry at top of activity list
10. Back on Savings tab, progress bar has grown
11. On Overview, Savings account card shows reduced balance

### 7.6 Withdraw from a Goal
1. Goal Detail → tap **"Withdraw"**
2. Flow reverses: `[Emergency Fund] → [Savings]`
3. Max amount = goal balance (cannot withdraw more than goal holds)
4. Enter amount → add note → submit
5. Goal balance decreases, source account balance increases

### 7.7 Delete a Goal
1. Goal Detail → scroll to bottom red zone
2. Tap "Delete goal" → inline confirmation appears
3. Message: "The রू 75,000 in this goal will be returned to Savings."
4. Tap "Cancel" to abort, or **"Delete goal"** (red button) to confirm
5. Goal removed, balance returned to source account, redirected to Savings list

### 7.8 Edit a Goal
1. Goal Detail → tap Edit icon (top-right pencil)
2. CreateGoalSheet opens pre-filled with current values
3. Change name, target, color, icon, auto settings
4. Tap **"Save changes"**
5. Note: Source account and balance are preserved — only metadata changes

### 7.9 Analyze Spending by Category
1. Go to **Analytics** tab
2. Select period: "This month" (default), "Last month", or "All time"
3. See income/expense cards, net income dark card, savings rate
4. Scroll to donut chart — segments sized by category spending
5. Below chart: category rows with name, %, and amount
6. **Tap "Food" row** → full-screen Category Detail opens
7. See total Food spend for selected period, transaction count
8. Browse individual Food transactions sorted newest-first
9. Back chevron returns to Analytics

### 7.10 Switch Currency
1. Tap Settings gear (any screen's top-right)
2. Under CURRENCY, tap **"USD"**
3. Card highlights (dark background, white text)
4. Close Settings → all amounts across all screens now show in $ with converted values
5. Conversion: `display = paisa_value / 100 * 0.0075`

### 7.11 Hide Balances
**Method A:** On Overview, tap the Eye icon on the hero card
**Method B:** Settings → Privacy → toggle "Hide balances by default"

Effect: All amounts across Overview (hero, cards, transactions) show as `•••••` or `•••`. Analytics and Savings still show amounts (privacy is for casual over-the-shoulder glances on the main screen).

### 7.12 Add Money to an Account
1. On Overview, swipe to the target account card
2. Tap **"+ Add money"** on the card
3. Bottom sheet with numpad opens
4. Enter amount → tap **"Add money"** (account-colored button)
5. Success state → sheet closes
6. Account balance increases

### 7.13 Manage Accounts
1. Settings → "Income Sources / Accounts"
2. See list of all accounts → tap one to edit
3. Change name, balance, color, icon
4. Tap Save. Or tap Delete (trash icon) to remove.
5. Tap "+ Add new" to create a new account from scratch

### 7.14 Manage Expense Categories
Same flow as accounts: Settings → "Expense Categories" → tap to edit or add new. Fields: name, color, icon (no balance field).

### 7.15 Backup / Export
1. Settings → DATA section
2. Tap "Backup to Google Sheets" → spinning icon for 1.5s → green check
3. Tap "Export Data (CSV)" → spinning icon for 1.2s → green check
4. (These are simulated — no actual file generated in this prototype)

---

## 8. Functionality Logic — How Things Work Internally

### 8.1 Amount Formatting (`fmtAmt`)
Input: amount in paisa (integer), currency code.
Process: `Math.abs(paisa) / 100 * rate` → `toFixed(2)` → split at `.` → add commas to integer part using regex `/\B(?=(\d{3})+(?!\d))/g`.
Output: `{ sign, int, dec, symbol }` object.

### 8.2 Numpad Input Logic
State: string `amount` (default "0").
Rules:
- `.` blocked if already contains `.`
- Digits after `.` capped at 2
- `back` removes last char; if 1 char left → resets to "0"
- First digit replaces leading "0" (unless it's `.`)
- Display: split at `.`, format integer with commas

### 8.3 Period Filtering
`getMonthRange(offset)` creates start (1st of month 00:00:00) and end (last day 23:59:59).
`filterByPeriod(items, "this")` → filters by April 2026.
`filterByPeriod(items, "last")` → filters by March 2026.
`filterByPeriod(items, "custom")` → returns all items unfiltered.

### 8.4 Category Totals Calculation
```
categories.map(cat =>
  filteredTransactions
    .filter(t => t.category === cat.id)
    .reduce(sum of Math.abs(t.amount))
)
.filter(total > 0)
.sort(descending by total)
```

### 8.5 Savings Rate Calculation
`savingsRate = (totalIncome - totalExpenses) / totalIncome * 100`
Shown as integer percentage. Positive = saving money. Negative = spending more than earning.

### 8.6 Goal Pace Estimation
1. Find all contributions from the last 3 months
2. Calculate net: `Σ(contribute amounts) - Σ(withdraw amounts)`
3. Monthly pace = net / 3
4. Months remaining = remaining target / monthly pace (ceiling)
5. Edge cases: if pace ≤ 0 → show "—". If remaining = 0 → show "Complete! 🎉"

### 8.7 Total Capital Calculation
```
totalCapital = accounts.reduce(sum of balance) + goals.reduce(sum of balance)
```
This is always conserved across operations (contribute/withdraw/create/delete).

### 8.8 Transaction Search
Case-insensitive `includes()` match on `transaction.name`. Runs on every keystroke against the sorted (newest-first) full transaction list. Shows up to 10 results.

### 8.9 Date Selection Logic
- Defaults to today's date
- Calendar grids out days where `new Date(year, month, day) > now`
- Quick chips calculate Yesterday and 2-days-ago using millisecond subtraction (86400000ms per day)
- Selected date stored as ISO string, displayed as "Today", "Yesterday", or "DD Mon YYYY"

### 8.10 Account Picker Selection
Opens as BottomSheet. Lists all accounts with balances. Tapping an account calls `onSelect(account.id)` and closes the sheet. Parent component updates its `account` state.

### 8.11 Goal Money Flow Handlers (in root FinanceApp)
```javascript
handleContribute(goalId, amount, note):
  1. Find goal by ID
  2. Decrease source account balance by amount
  3. Increase goal balance by amount
  4. Push new contribution entry to goal.contributions array

handleWithdraw(goalId, amount, note):
  1. Find goal by ID
  2. Decrease goal balance by amount
  3. Increase source account balance by amount
  4. Push new withdrawal entry

handleSaveGoal(goalData, sourceId, initialAmount):
  1. If goal exists → update in place
  2. If new → append to goals array
  3. If initialAmount > 0 → deduct from source account

handleDeleteGoal(goalId):
  1. Find goal
  2. Add goal.balance back to source account
  3. Remove goal from array
  4. Clear selectedGoalId
```

---

## 9. State Management

All state lives in the root `FinanceApp` component:

| State Variable | Type | Default | Purpose |
|---|---|---|---|
| `tab` | string | `"overview"` | Active navigation tab |
| `showCapital` | boolean | `false` | Capital Sheet modal visibility |
| `showSettings` | boolean | `false` | Settings modal visibility |
| `currency` | string | `"NPR"` | Active currency code |
| `hideBalance` | boolean | `false` | Privacy toggle |
| `accounts` | array | `INIT_ACCOUNTS` | All bank accounts |
| `categories` | array | `INIT_CATEGORIES` | Expense categories |
| `goals` | array | `INIT_GOALS` | Savings goals with contributions |
| `selectedGoalId` | string/null | `null` | Currently viewed goal |
| `creatingGoal` | boolean | `false` | Create goal sheet visibility |
| `editingGoalId` | string/null | `null` | Goal being edited |

Transactions and incomes are currently static (`INIT_TRANSACTIONS`, `INIT_INCOMES`) — not stored in state. The Add Transaction flow simulates submission but doesn't persist.

Child components manage their own UI state (toggle positions, input values, sheet visibility) locally.

---

## 10. Usability & Accessibility

### Touch Targets
- Minimum 30×30px for all interactive elements
- Navigation tabs: ~70px wide hit area
- Numpad keys: full cell width (~120px) × 40px+ height
- Settings rows: full-width, 50px+ height

### Visual Hierarchy
1. **Total Capital hero** (largest, darkest, heaviest shadow) — the single most important element
2. **Account cards** (vibrant color gradients) — second priority
3. **Transaction list** (monochromatic, understated) — scannable, not dominant
4. **Navigation** (near-invisible chrome) — never competes with content

### Progressive Disclosure
- Overview shows 10 transactions; full list available via search
- Analytics groups spending into categories; tap to expand into transactions
- Goal cards show summary; tap for full detail, history, and actions
- Delete requires 2 taps (initial + confirm) with consequence explained in plain language

### Feedback Patterns
- **Success:** Green background (#34C759) + Check icon + "Added!" / "Done!" text, 800-1400ms duration
- **Loading:** Spinning RefreshCw icon (1s rotation loop)
- **Error/Validation:** Red text (#FF3B5C) + AlertCircle icon + explanation ("Exceeds available")
- **Active state:** Colored border + tinted background on chips/pills
- **Disabled state:** 40% opacity + cursor default

### Consistency Rules
- Back = top-left chevron (always)
- Close = top-right X (bottom sheets and add transaction)
- Primary action = full-width button at bottom of every form
- Selected items = colored 2px border + 8% tinted background
- Section labels = 13px weight 600 `#999` (sentence case) or 11px weight 700 `#AAA` (uppercase)

### Color-Independent Communication
- Income: `+` prefix + green color + ArrowDownLeft icon (arrow indicates "in")
- Expense: `-` prefix + dark/red color + ArrowUpRight icon (arrow indicates "out")
- Contribute vs withdraw: plus/minus text labels + directional flow diagram + different icon directions
- Progress: percentage number + bar + ring — never color alone

---

## 11. Code Architecture

```
finance-app.jsx (single file, ~1500 lines)
│
├── IMPORTS (lucide-react, React hooks)
│
├── CONFIG
│   ├── CURRENCIES (NPR, USD with rates)
│   ├── ICON_MAP (20 icon mappings)
│   ├── ICON_OPTIONS (key array)
│   └── IconRender (wrapper component)
│
├── INITIAL DATA
│   ├── INIT_ACCOUNTS (5 accounts)
│   ├── INIT_CATEGORIES (6 categories)
│   ├── INIT_TRANSACTIONS (26 expenses, April + March)
│   ├── INIT_INCOMES (5 income entries)
│   └── INIT_GOALS (4 goals with contribution histories)
│
├── UTILITIES
│   ├── fmtAmt(cents, currency) → { sign, int, dec, symbol }
│   ├── fmtDate(isoString) → "Today at 1:30 pm" / "15 Apr at..."
│   ├── fmtShortDate(isoString) → "15 Apr 26"
│   ├── getMonthRange(offset) → { start, end }
│   ├── filterByPeriod(items, period) → filtered array
│   ├── COLORS_PICK (10-color array)
│   └── uid() → auto-incrementing ID generator
│
├── CHART COMPONENTS
│   ├── DonutChart ({ data, size, strokeWidth })
│   ├── ProgressRing ({ progress, color, size, thickness })
│   ├── SourcesBar ({ accounts })
│   └── Sparkline ({ color })
│
├── SHELL COMPONENTS
│   ├── Modal ({ title, onClose, children, rightIcon })
│   └── BottomSheet ({ children, onClose })
│
├── INPUT COMPONENTS
│   ├── Numpad ({ onKey })
│   ├── AccountPicker ({ accounts, selected, onSelect, onClose, title })
│   └── DatePickerSheet ({ selected, onSelect, onClose })
│
├── ACTION SHEETS
│   ├── AddMoneySheet ({ account, currency, onClose })
│   ├── CreateGoalSheet ({ accounts, currency, editingGoal, onClose, onSave })
│   └── ContributeSheet ({ goal, accounts, currency, type, onClose, onSubmit })
│
├── TAB PAGES
│   ├── OverviewTab (hero + cards + search + transactions)
│   ├── AnalyticsTab (period filter + stats + donut + category drill-down)
│   ├── SavingsTab (hero + goals list + create CTA)
│   └── AddTab (type toggle + date + amount + numpad + submit)
│
├── DETAIL VIEWS
│   ├── CapitalSheet (total capital breakdown + sources + incomes)
│   ├── CategoryDetail (filtered transactions for one category)
│   └── GoalDetail (hero + contribute/withdraw + history + delete)
│
├── CRUD COMPONENTS
│   ├── ManageList (list + add/edit/delete for any item type)
│   └── ItemEditor (generic form with text/number/color/icon fields)
│
├── SETTINGS
│   └── SettingsPage (currency + privacy + data + manage links)
│
└── ROOT EXPORT
    └── FinanceApp (state + handlers + routing + nav)
```

---

## 12. Sample Data Inventory

### Accounts (5)
| Name | Color | Balance (NPR) | Icon |
|---|---|---|---|
| NIC Asia | `#FF3B5C` | 45,235.00 | creditcard |
| Nabil Bank | `#FF8C00` | 78,752.00 | building |
| Cash | `#34C759` | 12,489.39 | banknote |
| Savings | `#007AFF` | 1,55,686.00 | landmark |
| Investments | `#AF52DE` | 2,85,132.90 | trending |

### Categories (6)
Mandatory (receipt, red), Food (utensils, orange), Entertainment (gamepad, blue), Transport (car, green), Health (heart, purple), Shopping (shoppingbag, pink)

### Transactions: 23 in April 2026, 3 in March 2026
Includes: Rent, utilities, Bhat Bhateni, Thamel Momo House, Himalayan Java, Pizza Hut, Netflix, Spotify, QFX Cinema, Pathao rides, Petrol IOC, Bus Pass, Gym, Dental, Daraz, Civil Mall.

### Incomes: 4 in April, 1 in March
Salary (75,000), Freelance (25,000), Investment Return (8,500), Side Gig (4,500).

### Goals (4)
| Name | Target | Saved | Source | Auto |
|---|---|---|---|---|
| Emergency Fund | 1,00,000 | 75,000 | Savings | ✅ 10,000/mo on 5th |
| Trip to Pokhara | 50,000 | 32,000 | NIC Asia | ❌ |
| MacBook Pro | 3,50,000 | 1,80,000 | Nabil Bank | ✅ 20,000/mo on 10th |
| Motorbike | 4,50,000 | 1,20,000 | Savings | ❌ |

Each goal has 1-5 pre-populated contribution history entries for realistic detail view display.

---

## 13. Future Enhancements

### Visual / UX
1. Spending velocity indicator (budget progress bar at top of Overview)
2. Category budget limits with warnings
3. 6-month trend line chart in Analytics
4. System-aware dark mode
5. Haptic-style press animations
6. Toast notification system

### Features
7. Recurring transactions (auto-create monthly)
8. Bill reminders ("Rent due in 3 days")
9. Smart category auto-detection from merchant names
10. Account-to-account transfers
11. Weekly/monthly auto-generated reports
12. Shared expense splitting
13. Multi-currency account support with live rates
14. PDF monthly statement export
15. Receipt scanner (camera OCR)
16. Persistent storage (localStorage or IndexedDB)
17. Cloud sync across devices

### Nepal-Specific
18. Dashain/Tihar festival budget mode
19. eSewa / Khalti / IME Pay as account types
20. Temple donation / Dakshina category
21. Gold / Silver asset tracking
22. Nepali fiscal year (Shrawan-Ashad) reports

---

*End of documentation.*
