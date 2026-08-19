import SwiftUI
import AppKit
import GambitScreenshotKit

// MARK: - Render Pipeline — TravelBudget
//
// House LOOK on all 5 prints: solid deep-teal brand background (#0A5D6E,
// no blobs/rays/gradients), white SF Pro Black verb-split headline, the
// real app inside the kit's DeviceFrame, and a whole-section breakout with
// coral border + glow overflowing both device edges. Slot 3 (widget print)
// has NO breakout — the widgets are the focus.
//
//   • initial → 1 set per locale at iPhone 6.9" (1320×2868)
//   • abtest  → reserved (treatments B/C are not written yet)

enum RenderMode { case abtest, initial }

struct PipelineError: Error, CustomStringConvertible {
    let description: String
}

// MARK: - Brand Marketing Theme (solid background, black-weight headline)

let brandTheme = MarketingTheme(
    baseColor: MockTheme.marketingBackground,
    blobBright: MockTheme.marketingBackground,
    blobMid: MockTheme.marketingBackground,
    blobDeep: MockTheme.marketingBackground,
    rayLeft: .clear,
    rayRight: .clear,
    highlightGlow: .clear,
    headlineTop: .white,
    headlineBottom: .white,
    headlineDepthShadow: Color.black.opacity(0.30),
    vignetteColor: MockTheme.marketingBackground,
    deviceContactShadow: Color.black.opacity(0.55),
    headlineWeight: .black
)

// MARK: - Headline Validation

@MainActor
func validateNoTODOs(in treatments: [TreatmentCopy], locales: [String]) throws {
    var problems: [String] = []
    for t in treatments {
        let slots: [(String, LocalizedHeadlines)] = [
            ("home",       t.home),
            ("feature1",   t.feature1),
            ("feature2",   t.feature2),
            ("settings",   t.settings),
            ("onboarding", t.onboarding)
        ]
        for (slotName, slot) in slots {
            for locale in locales {
                let headline = slot[locale]?.text ?? ""
                if headline.isEmpty || headline.uppercased().contains("TODO") {
                    problems.append("  treatment \(t.id) / \(slotName) / \(locale): \(headline.isEmpty ? "<empty>" : headline)")
                }
            }
        }
    }
    if !problems.isEmpty {
        throw PipelineError(description:
            "Headlines.swift still has \(problems.count) TODO/empty headline(s) for the active mode:\n" +
            problems.joined(separator: "\n") +
            "\nFill them in (with user-approved copy) before rendering."
        )
    }
}

// MARK: - Pipeline

@MainActor
func runFullRenderPipeline(mode: RenderMode) throws {
    let outputBase = URL(fileURLWithPath: NSString(string: "../fastlane/screenshots").expandingTildeInPath)
    try FileManager.default.createDirectory(at: outputBase, withIntermediateDirectories: true)

    let device: DeviceKind = .iPhone6_9
    let canvas = device.canvasSize

    // Pass 1: en-US only (review pass). Pass 2 adds pt-BR, es-ES, es-MX.
    let locales = ["en-US", "pt-BR", "es-ES"]

    let contentLocaleMap: [String: String] = [
        "es-MX": "es-ES"  // re-use es-ES content for es-MX
    ]

    let treatments: [TreatmentCopy] = (mode == .initial) ? [Headlines.treatmentA] : Headlines.all

    try validateNoTODOs(in: treatments, locales: locales.map { contentLocaleMap[$0] ?? $0 })

    var totalRendered = 0

    for treatment in treatments {
        let baseDir: URL = (mode == .initial)
            ? outputBase.appendingPathComponent("initial")
            : outputBase.appendingPathComponent("treatment_\(treatment.id)")

        for locale in locales {
            let uploadDir = baseDir.appendingPathComponent(locale)
            try FileManager.default.createDirectory(at: uploadDir, withIntermediateDirectories: true)

            let contentLocale = contentLocaleMap[locale] ?? locale

            try renderLocaleSet(treatment: treatment, locale: contentLocale,
                                device: device, canvas: canvas, outputDir: uploadDir)
            totalRendered += 5
            print("✅ \(mode == .initial ? "initial" : "treatment_\(treatment.id)") / \(locale) — 5 PNGs done")
        }
    }

    print("\n\(totalRendered) PNGs rendered at: \(outputBase.path)")
}

// MARK: - Per-Locale Rendering (5 slots, house LOOK)

@MainActor
func renderLocaleSet(
    treatment: TreatmentCopy,
    locale: String,
    device: DeviceKind,
    canvas: CGSize,
    outputDir: URL
) throws {
    let totalSlots = 5

    // Slot 1 — Trips home, breakout = TripHeroCard
    try render(
        view: marketing(device: device, slot: 0, totalSlots: totalSlots,
                        headline: treatment.home[locale],
                        breakout: Breakouts.home(locale)) { TripsHomeScreen(locale: locale) },
        canvas: canvas, scale: 1.0,
        to: outputDir.appendingPathComponent("01_home_iphone.png")
    )

    // Slot 2 — Add expense, breakout = amount + conversion
    try render(
        view: marketing(device: device, slot: 1, totalSlots: totalSlots,
                        headline: treatment.feature1[locale],
                        breakout: Breakouts.addExpense(locale)) { AddExpenseScreen(locale: locale) },
        canvas: canvas, scale: 1.0,
        to: outputDir.appendingPathComponent("02_currency_iphone.png")
    )

    // Slot 3 — Widget print, NO breakout (widgets are the focus)
    try render(
        view: marketing(device: device, slot: 2, totalSlots: totalSlots,
                        headline: treatment.feature2[locale],
                        breakout: nil) { WidgetHomeScreen(locale: locale) },
        canvas: canvas, scale: 1.0,
        to: outputDir.appendingPathComponent("03_widget_iphone.png")
    )

    // Slot 4 — Trip detail, breakout = CategoryDonutCard
    try render(
        view: marketing(device: device, slot: 3, totalSlots: totalSlots,
                        headline: treatment.settings[locale],
                        breakout: Breakouts.tripDetail(locale)) { TripDetailScreen(locale: locale) },
        canvas: canvas, scale: 1.0,
        to: outputDir.appendingPathComponent("04_tripdetail_iphone.png")
    )

    // Slot 5 — Stats, breakout = daily bar chart card
    try render(
        view: marketing(device: device, slot: 4, totalSlots: totalSlots,
                        headline: treatment.onboarding[locale],
                        breakout: Breakouts.stats(locale)) { StatsScreen(locale: locale) },
        canvas: canvas, scale: 1.0,
        to: outputDir.appendingPathComponent("05_stats_iphone.png")
    )
}

// MARK: - Marketing Wrapper Helper

@MainActor
@ViewBuilder
func marketing<Content: View>(
    device: DeviceKind,
    slot: Int,
    totalSlots: Int,
    headline: Headline?,
    breakout: AnyView?,
    @ViewBuilder content: () -> Content
) -> some View {
    let h = headline ?? Headline(text: "", highlight: nil)
    MarketingScreen(
        device: device,
        headline: h.text,
        highlightWord: h.highlight,
        slotIndex: slot,
        totalSlots: totalSlots,
        theme: brandTheme,
        backgroundOverride: AnyView(MockTheme.marketingBackground),
        foreground: breakout,
        splitFirstWord: true,
        content: content
    )
}

// MARK: - Render Helper

@MainActor
func render<V: View>(view: V, canvas: CGSize, scale: CGFloat, to url: URL) throws {
    let sized = view.frame(width: canvas.width, height: canvas.height)
    let renderer = ImageRenderer(content: sized)
    renderer.scale = scale
    renderer.proposedSize = ProposedViewSize(width: canvas.width, height: canvas.height)

    guard let cg = renderer.cgImage else {
        throw NSError(domain: "Screenshots", code: 1,
                      userInfo: [NSLocalizedDescriptionKey: "ImageRenderer returned nil for \(url.lastPathComponent)"])
    }
    let bitmap = NSBitmapImageRep(cgImage: cg)
    bitmap.size = NSSize(width: cg.width, height: cg.height)
    guard let data = bitmap.representation(using: .png, properties: [:]) else {
        throw NSError(domain: "Screenshots", code: 2,
                      userInfo: [NSLocalizedDescriptionKey: "PNG encoding failed for \(url.lastPathComponent)"])
    }
    try data.write(to: url)
}

// MARK: - Entry

MainActor.assumeIsolated {
    let mode: RenderMode = CommandLine.arguments.contains("initial") ? .initial : .abtest
    print(mode == .initial
          ? "🎬 Mode: INITIAL — single set per locale at 6.9\" (default product page)"
          : "🧪 Mode: A/B TEST — treatments × locales (PPO experiment)")
    do {
        try runFullRenderPipeline(mode: mode)
    } catch {
        print("❌ Pipeline failed: \(error)")
        exit(1)
    }
}
