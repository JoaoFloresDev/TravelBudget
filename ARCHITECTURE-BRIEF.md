# TravelBudget — Architecture Brief (single source for screen-builders)

App: travel expense tracker. Budget per trip, quick expense logging in any currency (rate locked per expense), "safe to spend today", stats, widget, CSV export. Free, no login, local-first. iOS 17+, SwiftUI, strict MVVM, max 300 lines/file, MARK everywhere, NO `#Preview`, `.foregroundStyle` only, shadows black-only via `.softShadow()`/`.elevatedShadow()` (View+Extensions).

## Paths
- Xcodegen root: `TravelBudget/` (repo) → `TravelBudget/TravelBudget/` (app target sources)
- Feature folders: `TravelBudget/TravelBudget/Presentation/<Feature>/{Views,ViewModels,Components}/`
- Existing features: `Trips` (TripsHomeView placeholder), `Stats` (StatsView placeholder), `Settings` (done), `Onboarding` (done), `TabBar/MainTabView.swift` (done)
- NEVER touch: `project.yml`, `Info.plist`, `Core/Localization/*.xcstrings` — return localization keys + any project needs in your report instead.

## Palette (via GambitCoreKit — call sites use AppColors.*)
Light values: background `#F7F6F2` · surface `#FFFFFF` · surfaceSecondary `#EFEDE7` · primary `#0C7489` (ocean teal) · secondary `#0A5A6A` · accent `#FF7A45` (coral) · success `#129B6C` · error `#E5484D` · warning `#E8A13C` · textPrimary `#1B1D22` · textSecondary `#6B7280` · textTertiary `#A6ACB8`. Dark variants configured in `Core/Theme/AppTheme.swift`. Import `GambitCoreKit` for `AppColors`, `AppFonts` (largeTitle/title/title2/title3/headline/body/bodyMedium/subheadline/footnote/caption/caption2 + timerLarge/timerMedium monospaced), `AppSpacing` (xs4 sm8 md16 lg24 xl32 xxl48 + screenPadding20 cardPadding16 cornerRadius14 cornerRadiusLarge20), `HapticManager`, `.pressAnimation()`, `.shimmer()`, `SkeletonView`.

## Models (Data/Models/)
```swift
struct Trip: Identifiable, Codable, Hashable {
  let id: UUID; var name: String; var emoji: String; var startDate: Date; var endDate: Date
  var homeCurrency: String        // ISO 4217
  var budgetTotal: Double?        // nil = no budget, dashboard shows totals only
  var totalDays: Int; var isActive: Bool; var isUpcoming: Bool; var isPast: Bool
}
struct Expense: Identifiable, Codable, Hashable {
  enum PaymentMethod: String, Codable, CaseIterable { case cash, card }
  let id: UUID; var tripId: UUID
  var amount: Double; var currency: String           // paid amount + currency
  var amountHome: Double                              // converted to trip.homeCurrency
  var rateUsed: Double                                // units of currency per 1 home unit (locked)
  var rateDate: Date
  var category: ExpenseCategory; var note: String; var date: Date; var paymentMethod: PaymentMethod
}
enum ExpenseCategory: String, Codable, CaseIterable, Identifiable
  // food transport lodging activities shopping fees health other
  // .symbol (SFSymbol) · .title (localized) · .color (chart Color)
enum CurrencyCatalog {
  struct Entry { let code: String; let flag: String; var localizedName: String }
  static let all: [Entry]                      // 40 travel currencies, picker order
  static func entry(for code: String) -> Entry?
  static var deviceDefault: String
  static func format(_ value: Double, code: String, compact: Bool = false) -> String
}
```

## Services (Data/Services/, all singletons)
```swift
@MainActor final class TripStore: ObservableObject {   // SOURCE OF TRUTH — injected via .environmentObject from MainTabView
  static let shared: TripStore
  @Published private(set) var trips: [Trip]; @Published private(set) var expenses: [Expense]
  func add(_ trip: Trip); func update(_ trip: Trip); func deleteTrip(_ id: UUID)
  func add(_ expense: Expense); func update(_ expense: Expense); func deleteExpense(_ id: UUID)
  func expenses(for tripId: UUID) -> [Expense]         // sorted date desc
  var currentTrip: Trip?                               // pinned > date-active > most recent
}
enum BudgetEngine {                                     // pure math, home currency
  struct Summary { let spentTotal, spentToday: Double; let remaining, safeToSpendToday: Double?; let daysLeft: Int? }
  static func summary(trip: Trip, expenses: [Expense], today: Date = Date()) -> Summary
  static func byCategory(trip: Trip, expenses: [Expense]) -> [(category: ExpenseCategory, total: Double)]
  static func dailyTotals(trip: Trip, expenses: [Expense]) -> [(day: Date, total: Double)]
}
final class CurrencyService {                           // open.er-api.com, cached 12h, offline-first
  static let shared: CurrencyService
  func rate(base: String, currency: String) -> Double?  // units of currency per 1 base
  @discardableResult func refreshIfNeeded(base: String) async -> RateTable?   // call on screen appear
  func convertToHome(amount: Double, currency: String, base: String) -> (amountHome: Double, rate: Double, rateDate: Date)?
  func cachedTable(base: String) -> RateTable?          // .fetchedAt for "rate of <date>" label
}
enum ExportService { static func csvFileURL(trip: Trip, expenses: [Expense]) -> URL? }  // ShareLink
```
`UserDefaults` keys via `StorageKeys`: `pinnedTripId` (String uuid), `lastUsedCurrency` (String). Constants via `AppConstants`.

## Navigation map
TabView (MainTabView, done): **Trips** / **Stats** / **Settings**, tint AppColors.primary.
- Trips tab: `NavigationStack`. `TripsHomeView` → push `TripDetailView` (`.navigationDestination(for: Trip.self)`); modals: `NewTripSheet` (create+edit trip), `AddExpenseSheet` (create+edit expense). Rule: create/edit = modal `.sheet`, details = push.
- Stats tab: `NavigationStack` with `.navigationTitle`, NO pushes (picker de trip inline).
- Settings tab: done, don't touch.
Background pattern: `ZStack { AppColors.background.ignoresSafeArea(); ScrollView {...} }`. Nav bar appearance already configured globally.

## Localization
Keys `feature.element.qualifier` (e.g. `trip.detail.remaining`). Code: `String(localized: "key")`; interpolation via `%@`/`%lld` xcstrings entries. DO NOT edit xcstrings — return a JSON block `{ "key": {"en": "...", "pt-BR": "...", "es-ES": "..."} }` with ALL your keys in your final report. Currency values ALWAYS via `CurrencyCatalog.format`.

## UI states & haptics
Every list screen: loading (shimmer/skeleton), empty (icon + title + CTA), content. `HapticManager` on save/delete/success. Touch targets ≥44pt. Rows tappable full-width (`.contentShape(Rectangle())`).
