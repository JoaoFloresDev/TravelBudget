import Foundation

// MARK: - Headline Copy
//
// Treatment A only (initial mode). Verb-split house style: first word BIG
// alone on line 1, rest on line 2 (`splitFirstWord: true` in main.swift).
// All 30 lines measured with AppKit (SF Pro Black, L1 161.28pt / L2 74.88pt,
// tracking -0.5, available 1160pt) — every line fits without shrinking.
// Slot 3's line 1 is the noun WIDGET on purpose (indexed caption).

struct Headline {
    let text: String
    let highlight: String?
}

typealias LocalizedHeadlines = [String: Headline]

struct TreatmentCopy {
    let id: String
    let label: String
    let home: LocalizedHeadlines
    let feature1: LocalizedHeadlines
    let feature2: LocalizedHeadlines
    let settings: LocalizedHeadlines
    let onboarding: LocalizedHeadlines
}

enum Headlines {

    // MARK: - Treatment A — Direct / Action (verb-split, ASO keyword-rich)

    static let treatmentA = TreatmentCopy(
        id: "A",
        label: "Direct / Action",
        // Slot 1 — Trips home (safe to spend today)
        home: [
            "en-US": Headline(text: "KNOW what you can spend today", highlight: nil),
            "pt-BR": Headline(text: "SAIBA quanto pode gastar hoje", highlight: nil),
            "es-ES": Headline(text: "SABE cuánto puedes gastar hoy", highlight: nil)
        ],
        // Slot 2 — Add expense in any currency
        feature1: [
            "en-US": Headline(text: "SPEND in any currency", highlight: nil),
            "pt-BR": Headline(text: "GASTE em qualquer moeda", highlight: nil),
            "es-ES": Headline(text: "GASTA en cualquier moneda", highlight: nil)
        ],
        // Slot 3 — Widget on the iOS home screen
        feature2: [
            "en-US": Headline(text: "WIDGET your budget, one glance", highlight: nil),
            "pt-BR": Headline(text: "WIDGET na sua tela de início", highlight: nil),
            "es-ES": Headline(text: "WIDGET en tu pantalla de inicio", highlight: nil)
        ],
        // Slot 4 — Trip detail (track every expense)
        settings: [
            "en-US": Headline(text: "TRACK every travel expense", highlight: nil),
            "pt-BR": Headline(text: "CONTROLE cada gasto da viagem", highlight: nil),
            "es-ES": Headline(text: "CONTROLA cada gasto del viaje", highlight: nil)
        ],
        // Slot 5 — Stats (see where the money goes)
        onboarding: [
            "en-US": Headline(text: "SEE where your money goes", highlight: nil),
            "pt-BR": Headline(text: "VEJA pra onde foi o dinheiro", highlight: nil),
            "es-ES": Headline(text: "MIRA a dónde se va el dinero", highlight: nil)
        ]
    )

    // MARK: - Treatments B/C — not used by initial mode (A/B test only)

    static let treatmentB = TreatmentCopy(
        id: "B",
        label: "Emotional / Aspirational",
        home: [:], feature1: [:], feature2: [:], settings: [:], onboarding: [:]
    )

    static let treatmentC = TreatmentCopy(
        id: "C",
        label: "Feature / Technical",
        home: [:], feature1: [:], feature2: [:], settings: [:], onboarding: [:]
    )

    static let all: [TreatmentCopy] = [treatmentA, treatmentB, treatmentC]
}

// MARK: - Localized App Listing Strings (used by App Store mockup, abtest only)

enum LocalizedListing {
    static let appName: [String: String] = [
        "en-US": "Travel Budget",
        "pt-BR": "Gastos de Viagem",
        "es-ES": "Gastos de Viaje"
    ]
    static let subtitle: [String: String] = [
        "en-US": "Trip expense tracker",
        "pt-BR": "Controle de gastos de viagem",
        "es-ES": "Control de gastos de viaje"
    ]
}
