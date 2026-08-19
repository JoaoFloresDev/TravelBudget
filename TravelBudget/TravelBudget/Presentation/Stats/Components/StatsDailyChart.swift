//
//  StatsDailyChart.swift
//  TravelBudget
//
//  Daily spending bar chart (Swift Charts) with dashed daily-target rule line.
//

import SwiftUI
import Charts
import GambitCoreKit

struct StatsDailyChart: View {

    // MARK: - Properties

    let points: [DailySpendPoint]
    let dailyTarget: Double?
    let currencyCode: String

    // MARK: - View Body

    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            chart
                .frame(height: 220)
            if let dailyTarget {
                targetLegend(dailyTarget)
            }
        }
        .padding(AppSpacing.cardPadding)
        .background(
            RoundedRectangle(cornerRadius: AppSpacing.cornerRadiusLarge)
                .fill(AppColors.surface)
        )
        .softShadow()
    }

    // MARK: - Subviews

    private var chart: some View {
        Chart {
            ForEach(points) { point in
                BarMark(
                    x: .value("Day", point.day, unit: .day),
                    y: .value("Spent", point.total)
                )
                .foregroundStyle(point.isOverTarget ? AppColors.accent : AppColors.primary)
                .cornerRadius(3)
            }
            if let dailyTarget {
                RuleMark(y: .value("Target", dailyTarget))
                    .foregroundStyle(AppColors.accent)
                    .lineStyle(StrokeStyle(lineWidth: 1.5, dash: [5, 4]))
            }
        }
        .chartXAxis {
            AxisMarks(values: .automatic(desiredCount: 6)) { value in
                AxisGridLine()
                    .foregroundStyle(AppColors.textTertiary.opacity(0.2))
                AxisValueLabel {
                    if let date = value.as(Date.self) {
                        Text(date, format: .dateTime.day())
                            .font(AppFonts.caption2)
                            .foregroundStyle(AppColors.textTertiary)
                    }
                }
            }
        }
        .chartYAxis {
            AxisMarks(position: .trailing, values: .automatic(desiredCount: 4)) { value in
                AxisGridLine()
                    .foregroundStyle(AppColors.textTertiary.opacity(0.2))
                AxisValueLabel {
                    if let amount = value.as(Double.self) {
                        Text(CurrencyCatalog.format(amount, code: currencyCode, compact: true))
                            .font(AppFonts.caption2)
                            .foregroundStyle(AppColors.textTertiary)
                    }
                }
            }
        }
    }

    private func targetLegend(_ target: Double) -> some View {
        HStack(spacing: AppSpacing.sm) {
            Rectangle()
                .fill(AppColors.accent)
                .frame(width: 18, height: 2)
                .mask(
                    HStack(spacing: 3) {
                        ForEach(0..<3, id: \.self) { _ in
                            Rectangle().frame(width: 5)
                        }
                    }
                )
            Text(String(localized: "stats.summary.dailyTarget"))
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.textSecondary)
            Spacer()
            Text(CurrencyCatalog.format(target, code: currencyCode))
                .font(AppFonts.caption)
                .foregroundStyle(AppColors.accent)
        }
    }
}
