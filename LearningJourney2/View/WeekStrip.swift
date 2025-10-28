import SwiftUI

struct WeekStrip: View {
    @Binding var selectedDate: Date
    var calendar: Calendar = .current
    var tint: Color = .orange
    var statusForDate: (Date) -> DayStatus?
    var onSelectDate: (Date) -> Void

    @State private var showMonthYearPicker = false

    // start of the shown ISO week
    private var weekStart: Date {
        calendar.date(
            from: calendar.dateComponents(
                [.yearForWeekOfYear, .weekOfYear],
                from: selectedDate
            )
        )!
    }

    private var days: [Date] {
        (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: weekStart) }
    }

    private func colors(for day: Date) -> (bg: Color, text: Color) {
        if let status = statusForDate(day) {
            switch status {
            case .learned:
                return (Color("brandBrown"), .orange)
            case .freezed:
                return (Color("blueSS"), Color("brandBlue"))
            }
        } else {
            if calendar.isDateInToday(day) {
                return (tint, .white)
            } else {
                return (Color.white.opacity(0.08), .white.opacity(0.9))
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {

            // header row: Month Year + nav
            HStack(spacing: 8) {
                Text(selectedDate.formatted(.dateTime.month(.wide).year()))
                    .font(.headline)
                    .foregroundColor(.white.opacity(0.95))

                Button {
                    showMonthYearPicker = true
                } label: {
                    Image(systemName: "chevron.right")
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(tint)
                        .accessibilityLabel("Choose Month and Year")
                }

                Spacer()

                Button { moveWeek(-1) } label: {
                    Image(systemName: "chevron.left").foregroundColor(tint)
                }
                Button { moveWeek(+1) } label: {
                    Image(systemName: "chevron.right").foregroundColor(tint)
                }
            }

            // days row
            HStack(spacing: 10) {
                ForEach(days, id: \.self) { day in
                    let c = colors(for: day)
                    VStack(spacing: 6) {
                        Text(day.formatted(.dateTime.weekday(.abbreviated)).uppercased())
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.55))
                        Text(day, format: .dateTime.day())
                            .font(.system(size: 23, weight: .bold))
                            .frame(width: 44, height: 44)
                            .background(Circle().fill(c.bg))
                            .foregroundColor(c.text)
                            .onTapGesture {
                                selectedDate = day
                                onSelectDate(day)
                            }
                    }
                }
            }
        }
        .padding(14)
        .sheet(isPresented: $showMonthYearPicker) {
            MonthYearPickerSheet(
                initial: selectedDate,
                onCancel: { showMonthYearPicker = false },
                onDone: { year, month in
                    if let new = calendar.date(from: DateComponents(year: year, month: month, day: 1)) {
                        let currentDay = calendar.component(.day, from: selectedDate)
                        if let target = calendar.date(bySetting: .day, value: currentDay, of: new),
                           calendar.isDate(target, equalTo: new, toGranularity: .month) {
                            selectedDate = target
                            onSelectDate(target)
                        } else {
                            selectedDate = new
                            onSelectDate(new)
                        }
                    }
                    showMonthYearPicker = false
                }
            )
        }
    }

    private func moveWeek(_ delta: Int) {
        if let newDate = calendar.date(byAdding: .day, value: 7 * delta, to: selectedDate) {
            selectedDate = newDate
            onSelectDate(newDate)
        }
    }
}
//
//  WeekStrip.swift
//  LearningJourney2
//
//  Created by Amnah Albrahim on 05/05/1447 AH.
//

