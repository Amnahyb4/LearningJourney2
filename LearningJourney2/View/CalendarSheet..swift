import SwiftUI

struct CalendarSheet: View {
    let initialMonth: Date
    let yearsAround: Int
    private let calendar: Calendar

    @Environment(\.dismiss) private var dismiss

    init(initialMonth: Date = Date(),
         yearsAround: Int = 2,
         calendar: Calendar = .current) {

        self.initialMonth = CalendarSheet.startOfMonthNoon(for: initialMonth, calendar: calendar)
        self.yearsAround = yearsAround
        self.calendar = calendar
    }

    var body: some View {
        NavigationStack {
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 24) {
                        ForEach(monthsInRange, id: \.self) { monthStart in
                            CalendarMonthSection(
                                calendar: calendar,
                                monthStart: monthStart
                            )
                            .id(monthID(monthStart))
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                }
                .background(Color.black.ignoresSafeArea())
                .navigationTitle("All activities")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 36, height: 36)
                                .background(Color.white.opacity(0.12))
                                .clipShape(Circle())
                        }
                        .glassEffect()
                        .accessibilityLabel("Back")
                    }
                }
                .onAppear {
                    DispatchQueue.main.async {
                        proxy.scrollTo(monthID(initialMonth), anchor: .top)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .preferredColorScheme(.dark)
    }
}

struct CalendarMonthSection: View {
    let calendar: Calendar
    let monthStart: Date

    private var monthTitle: String {
        monthStart.formatted(.dateTime.month(.wide).year())
    }

    private var daysInMonth: Int {
        calendar.range(of: .day, in: .month, for: monthStart)!.count
    }

    private var weekdayHeaders: [String] {
        let syms = calendar.shortStandaloneWeekdaySymbols
        let start = calendar.firstWeekday - 1
        return Array(syms[start...] + syms[..<start])
    }

    private var leadingBlankCount: Int {
        let weekday = calendar.component(.weekday, from: monthStart)
        return (weekday - calendar.firstWeekday + 7) % 7
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(monthTitle)
                .font(.title3.bold())
                .foregroundStyle(.primary)

            HStack {
                ForEach(weekdayHeaders, id: \.self) { s in
                    Text(s.uppercased())
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity)
                }
            }

            let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(0..<leadingBlankCount, id: \.self) { _ in
                    Color.clear
                        .frame(height: 40)
                }

                ForEach(1...daysInMonth, id: \.self) { day in
                    Text("\(day)")
                        .font(.callout.weight(.semibold))
                        .frame(height: 40)
                        .frame(maxWidth: .infinity)
                        .accessibilityLabel("\(monthTitle) \(day)")
                }
            }

            Divider().foregroundStyle(.quaternary)
        }
    }
}

private extension CalendarSheet {
    var monthsInRange: [Date] {
        let baseYear  = calendar.component(.year, from: initialMonth)
        let startYear = baseYear - yearsAround
        let endYear   = baseYear + yearsAround

        var months: [Date] = []
        months.reserveCapacity((endYear - startYear + 1) * 12)

        for year in startYear...endYear {
            for month in 1...12 {
                if let first = calendar.date(from: DateComponents(year: year, month: month, day: 1)) {
                    months.append(CalendarSheet.startOfMonthNoon(for: first, calendar: calendar))
                }
            }
        }
        return months.sorted()
    }

    func monthID(_ date: Date) -> String {
        let comps = calendar.dateComponents([.year, .month], from: date)
        return String(format: "%04d-%02d", comps.year ?? 0, comps.month ?? 0)
    }

    static func startOfMonthNoon(for date: Date, calendar: Calendar) -> Date {
        let comps = calendar.dateComponents([.year, .month], from: date)
        let firstDay = calendar.date(from: DateComponents(year: comps.year, month: comps.month, day: 1))!
        return calendar.date(bySettingHour: 12, minute: 0, second: 0, of: firstDay)!
    }
}
//
//  CalendarSheet..swift
//  LearningJourney2
//
//  Created by Amnah Albrahim on 05/05/1447 AH.
//

