import SwiftUI

// MARK: - Mock Data
//
// One coherent trip across ALL 5 prints: Lisbon 🇵🇹, home currency USD,
// budget $1,800, day 4 of 10, spent $560, remaining $1,240, safe to spend
// today $128. Money strings are pre-formatted per locale exactly the way
// `CurrencyCatalog.format` (NumberFormatter .currency) renders them.

// MARK: - Category

enum MockCategory: String, CaseIterable, Identifiable {
    case food, transport, lodging, activities, shopping, fees, health, other

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .food: return "fork.knife"
        case .transport: return "bus.fill"
        case .lodging: return "bed.double.fill"
        case .activities: return "ticket.fill"
        case .shopping: return "bag.fill"
        case .fees: return "creditcard.fill"
        case .health: return "cross.case.fill"
        case .other: return "ellipsis.circle.fill"
        }
    }

    var color: Color {
        switch self {
        case .food: return MockTheme.categoryFood
        case .transport: return MockTheme.categoryTransport
        case .lodging: return MockTheme.categoryLodging
        case .activities: return MockTheme.categoryActivities
        case .shopping: return MockTheme.categoryShopping
        case .fees: return MockTheme.categoryFees
        case .health: return MockTheme.categoryHealth
        case .other: return MockTheme.categoryOther
        }
    }

    func title(_ locale: String) -> String {
        let table: [String: [String: String]] = [
            "food":       ["en-US": "Food",       "pt-BR": "Comida",      "es-ES": "Comida"],
            "transport":  ["en-US": "Transport",  "pt-BR": "Transporte",  "es-ES": "Transporte"],
            "lodging":    ["en-US": "Lodging",    "pt-BR": "Hospedagem",  "es-ES": "Alojamiento"],
            "activities": ["en-US": "Activities", "pt-BR": "Passeios",    "es-ES": "Actividades"],
            "shopping":   ["en-US": "Shopping",   "pt-BR": "Compras",     "es-ES": "Compras"],
            "fees":       ["en-US": "Fees",       "pt-BR": "Taxas",       "es-ES": "Tasas"],
            "health":     ["en-US": "Health",     "pt-BR": "Saúde",       "es-ES": "Salud"],
            "other":      ["en-US": "Other",      "pt-BR": "Outros",      "es-ES": "Otros"]
        ]
        return table[rawValue]?[locale] ?? table[rawValue]?["en-US"] ?? rawValue
    }
}

// MARK: - Trip Mock

struct MockTripData {
    /// The Lisbon trip — same values everywhere.
    static let emoji = "🇵🇹"
    static let romeEmoji = "🇮🇹"
    static let parisEmoji = "🇫🇷"

    static func name(_ locale: String) -> String {
        ["en-US": "Lisbon", "pt-BR": "Lisboa", "es-ES": "Lisboa"][locale] ?? "Lisbon"
    }

    static func romeName(_ locale: String) -> String {
        ["en-US": "Rome", "pt-BR": "Roma", "es-ES": "Roma"][locale] ?? "Rome"
    }

    static func parisName(_ locale: String) -> String {
        ["en-US": "Paris", "pt-BR": "Paris", "es-ES": "París"][locale] ?? "Paris"
    }

    static func dateRange(_ locale: String) -> String {
        ["en-US": "Aug 16 – 25, 2026",
         "pt-BR": "16 – 25 de ago. de 2026",
         "es-ES": "16 – 25 ago 2026"][locale] ?? "Aug 16 – 25, 2026"
    }

    static func romeDateRange(_ locale: String) -> String {
        ["en-US": "Sep 12 – 19, 2026",
         "pt-BR": "12 – 19 de set. de 2026",
         "es-ES": "12 – 19 sept 2026"][locale] ?? "Sep 12 – 19, 2026"
    }

    static func parisDateRange(_ locale: String) -> String {
        ["en-US": "May 3 – 10, 2026",
         "pt-BR": "3 – 10 de mai. de 2026",
         "es-ES": "3 – 10 may 2026"][locale] ?? "May 3 – 10, 2026"
    }

    /// Budget progress: 560 / 1800.
    static let budgetProgress: Double = 560.0 / 1800.0
}

// MARK: - Money (pre-formatted per locale, USD home currency)

enum MockMoney {
    private static let table: [String: [String: String]] = [
        "safeToday":      ["en-US": "$128.00",   "pt-BR": "US$ 128,00",   "es-ES": "128,00 US$"],
        "remaining":      ["en-US": "$1,240.00", "pt-BR": "US$ 1.240,00", "es-ES": "1.240,00 US$"],
        "spent":          ["en-US": "$560.00",   "pt-BR": "US$ 560,00",   "es-ES": "560,00 US$"],
        "budgetFull":     ["en-US": "$1,800.00", "pt-BR": "US$ 1.800,00", "es-ES": "1.800,00 US$"],
        "budgetCompact":  ["en-US": "$1,800",    "pt-BR": "US$ 1.800",    "es-ES": "1.800 US$"],
        "spentToday":     ["en-US": "$64.00",    "pt-BR": "US$ 64,00",    "es-ES": "64,00 US$"],
        "avgPerDay":      ["en-US": "$140.00",   "pt-BR": "US$ 140,00",   "es-ES": "140,00 US$"],
        "dailyTarget":    ["en-US": "$180.00",   "pt-BR": "US$ 180,00",   "es-ES": "180,00 US$"],
        "romeSpent":      ["en-US": "$0.00",     "pt-BR": "US$ 0,00",     "es-ES": "0,00 US$"],
        "romeBudget":     ["en-US": "$1,500",    "pt-BR": "US$ 1.500",    "es-ES": "1.500 US$"],
        "parisSpent":     ["en-US": "$1,320",    "pt-BR": "US$ 1.320",    "es-ES": "1.320 US$"],
        "parisBudget":    ["en-US": "$1,400",    "pt-BR": "US$ 1.400",    "es-ES": "1.400 US$"],
        "dayTotal":       ["en-US": "$91.78",    "pt-BR": "US$ 91,78",    "es-ES": "91,78 US$"],
        "catLodging":     ["en-US": "$230.00",   "pt-BR": "US$ 230,00",   "es-ES": "230,00 US$"],
        "catFood":        ["en-US": "$179.00",   "pt-BR": "US$ 179,00",   "es-ES": "179,00 US$"],
        "catTransport":   ["en-US": "$84.00",    "pt-BR": "US$ 84,00",    "es-ES": "84,00 US$"],
        "catActivities":  ["en-US": "$67.00",    "pt-BR": "US$ 67,00",    "es-ES": "67,00 US$"],
        "tramPaid":       ["en-US": "€24.00",    "pt-BR": "€ 24,00",      "es-ES": "24,00 €"],
        "tramHome":       ["en-US": "$27.78",    "pt-BR": "US$ 27,78",    "es-ES": "27,78 US$"],
        "dinnerPaid":     ["en-US": "€55.30",    "pt-BR": "€ 55,30",      "es-ES": "55,30 €"],
        "dinnerHome":     ["en-US": "$64.00",    "pt-BR": "US$ 64,00",    "es-ES": "64,00 US$"],
        "pasteisPaid":    ["en-US": "€12.40",    "pt-BR": "€ 12,40",      "es-ES": "12,40 €"],
        "pasteisHome":    ["en-US": "$14.35",    "pt-BR": "US$ 14,35",    "es-ES": "14,35 US$"],
        "conversion":     ["en-US": "≈ $115.76 · 1 USD = 0.8639 EUR (Aug 19)",
                           "pt-BR": "≈ US$ 115,76 · 1 USD = 0,8639 EUR (19/08)",
                           "es-ES": "≈ 115,76 US$ · 1 USD = 0,8639 EUR (19 ago)"]
    ]

    static func s(_ key: String, _ locale: String) -> String {
        table[key]?[locale] ?? table[key]?["en-US"] ?? key
    }
}

// MARK: - Localized UI Labels (mirror of Localizable.xcstrings values)

enum L {
    private static let table: [String: [String: String]] = [
        // Trips home
        "trips.title":          ["en-US": "Trips",               "pt-BR": "Viagens",              "es-ES": "Viajes"],
        "trips.hero.safeToday": ["en-US": "Safe to spend today", "pt-BR": "Pode gastar hoje",     "es-ES": "Puedes gastar hoy"],
        "trips.hero.spent":     ["en-US": "Total spent",         "pt-BR": "Total gasto",          "es-ES": "Total gastado"],
        "trips.hero.budget":    ["en-US": "Budget",              "pt-BR": "Orçamento",            "es-ES": "Presupuesto"],
        "trips.status.active":  ["en-US": "Active",              "pt-BR": "Em andamento",         "es-ES": "En curso"],
        "trips.section.active":   ["en-US": "Active",            "pt-BR": "Em andamento",         "es-ES": "En curso"],
        "trips.section.upcoming": ["en-US": "Upcoming",          "pt-BR": "Próximas",             "es-ES": "Próximos"],
        "trips.section.past":     ["en-US": "Past",              "pt-BR": "Anteriores",           "es-ES": "Anteriores"],
        // Add expense
        "expense.form.title.add":      ["en-US": "Add Expense", "pt-BR": "Nova despesa", "es-ES": "Nuevo gasto"],
        "expense.form.cancel":         ["en-US": "Cancel",      "pt-BR": "Cancelar",     "es-ES": "Cancelar"],
        "expense.form.save":           ["en-US": "Save",        "pt-BR": "Salvar",       "es-ES": "Guardar"],
        "expense.form.category.title": ["en-US": "Category",    "pt-BR": "Categoria",    "es-ES": "Categoría"],
        "expense.form.note.placeholder": ["en-US": "Note",      "pt-BR": "Observação",   "es-ES": "Nota"],
        "expense.form.date":           ["en-US": "Date",        "pt-BR": "Data",         "es-ES": "Fecha"],
        "expense.form.method.cash":    ["en-US": "Cash",        "pt-BR": "Dinheiro",     "es-ES": "Efectivo"],
        "expense.form.method.card":    ["en-US": "Card",        "pt-BR": "Cartão",       "es-ES": "Tarjeta"],
        // Trip detail
        "trip.detail.remaining": ["en-US": "Remaining", "pt-BR": "Restante", "es-ES": "Restante"],
        "trip.detail.spent":     ["en-US": "Spent",     "pt-BR": "Gasto",    "es-ES": "Gastado"],
        "trip.detail.byCategory": ["en-US": "By category", "pt-BR": "Por categoria", "es-ES": "Por categoría"],
        // Stats
        "stats.title":               ["en-US": "Stats",           "pt-BR": "Resumo",          "es-ES": "Resumen"],
        "stats.summary.spent":       ["en-US": "Total spent",     "pt-BR": "Total gasto",     "es-ES": "Total gastado"],
        "stats.summary.avgPerDay":   ["en-US": "Avg / day",       "pt-BR": "Média / dia",     "es-ES": "Media / día"],
        "stats.summary.dailyTarget": ["en-US": "Daily target",    "pt-BR": "Meta diária",     "es-ES": "Meta diaria"],
        "stats.section.daily":       ["en-US": "Spending by day", "pt-BR": "Gastos por dia",  "es-ES": "Gastos por día"],
        "stats.section.categories":  ["en-US": "Categories",      "pt-BR": "Categorias",      "es-ES": "Categorías"],
        // Widget
        "widget.today":      ["en-US": "Today you can spend", "pt-BR": "Hoje você pode gastar", "es-ES": "Hoy puedes gastar"],
        "widget.spentToday": ["en-US": "Spent today",         "pt-BR": "Gasto hoje",            "es-ES": "Gastado hoy"]
    ]

    static func t(_ key: String, _ locale: String) -> String {
        table[key]?[locale] ?? table[key]?["en-US"] ?? key
    }
}

// MARK: - Composite Localized Strings

enum MockComposite {
    /// TripDashboardCard chip — "trip.detail.safeToday %@".
    static func safeTodayChip(_ locale: String) -> String {
        let amount = MockMoney.s("safeToday", locale)
        switch locale {
        case "pt-BR": return "\(amount) livres para gastar hoje"
        case "es-ES": return "\(amount) disponibles para gastar hoy"
        default:      return "\(amount) safe to spend today"
        }
    }

    /// TripDashboardCard days line — "Day 4 of 10 · 6 days left".
    static func daysInfo(_ locale: String) -> String {
        switch locale {
        case "pt-BR": return "Dia 4 de 10 · 6 dias restantes"
        case "es-ES": return "Día 4 de 10 · 6 días restantes"
        default:      return "Day 4 of 10 · 6 days left"
        }
    }

    /// TripDetail day-section header date (Aug 19).
    static func dayHeader(_ locale: String) -> String {
        switch locale {
        case "pt-BR": return "qua., 19 de ago."
        case "es-ES": return "mié., 19 ago"
        default:      return "Wed, Aug 19"
        }
    }

    /// Expense date row value in the add-expense form.
    static func expenseDate(_ locale: String) -> String {
        switch locale {
        case "pt-BR": return "19 de ago. de 2026"
        case "es-ES": return "19 ago 2026"
        default:      return "Aug 19, 2026"
        }
    }

    /// Expense note titles.
    static func tramNote(_ locale: String) -> String {
        switch locale {
        case "pt-BR": return "Elétrico 28"
        case "es-ES": return "Tranvía 28"
        default:      return "Tram 28"
        }
    }

    static func dinnerNote(_ locale: String) -> String {
        switch locale {
        case "pt-BR": return "Jantar no Bairro Alto"
        case "es-ES": return "Cena en Bairro Alto"
        default:      return "Dinner Bairro Alto"
        }
    }
}

// MARK: - Stats Chart Points (Aug 16–19, total $560, target $180)

struct MockChartPoint: Identifiable {
    let id: Int
    let dayLabel: String
    let value: Double
    var isOverTarget: Bool { value > 180 }
}

enum MockChartData {
    static let points: [MockChartPoint] = [
        MockChartPoint(id: 16, dayLabel: "16", value: 210),
        MockChartPoint(id: 17, dayLabel: "17", value: 96),
        MockChartPoint(id: 18, dayLabel: "18", value: 190),
        MockChartPoint(id: 19, dayLabel: "19", value: 64)
    ]
    static let dailyTarget: Double = 180
    static let maxY: Double = 240

    /// Category breakdown — lodging 41 %, food 32 %, transport 15 %, activities 12 %.
    static let categories: [(category: MockCategory, moneyKey: String, share: Double)] = [
        (.lodging,    "catLodging",    0.41),
        (.food,       "catFood",       0.32),
        (.transport,  "catTransport",  0.15),
        (.activities, "catActivities", 0.12)
    ]
}

// MARK: - Home-Screen Icon Labels (widget print)

enum MockHomeIcons {
    static func labels(_ locale: String) -> [String] {
        switch locale {
        case "pt-BR": return ["Fotos", "Câmera", "Mapas", "Música", "Mail", "Tempo", "Relógio", "Notas",
                              "Calendário", "Carteira", "Vídeos", "Saúde"]
        case "es-ES": return ["Fotos", "Cámara", "Mapas", "Música", "Mail", "Tiempo", "Reloj", "Notas",
                              "Calendario", "Cartera", "Vídeos", "Salud"]
        default:      return ["Photos", "Camera", "Maps", "Music", "Mail", "Weather", "Clock", "Notes",
                              "Calendar", "Wallet", "Videos", "Health"]
        }
    }
}
