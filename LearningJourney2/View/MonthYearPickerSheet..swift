import SwiftUI

struct MonthYearPickerSheet: View {
    let initial: Date
    var onCancel: () -> Void
    var onDone: (_ year: Int, _ month: Int) -> Void

    private let months = DateFormatter().monthSymbols ?? [
        "January","February","March","April","May","June",
        "July","August","September","October","November","December"
    ]
    private let years: [Int] = {
        let current = Calendar.current.component(.year, from: Date())
        return Array((current - 10)...(current + 10))
    }()

    @State private var selMonth: Int
    @State private var selYear: Int

    init(initial: Date, onCancel: @escaping () -> Void, onDone: @escaping (Int, Int) -> Void) {
        self.initial = initial
        self.onCancel = onCancel
        self.onDone = onDone

        let comps = Calendar.current.dateComponents([.year, .month], from: initial)
        _selYear  = State(initialValue: comps.year ?? Calendar.current.component(.year, from: Date()))
        _selMonth = State(initialValue: comps.month ?? Calendar.current.component(.month, from: Date()))
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                HStack(spacing: 0) {
                    Picker("Month", selection: $selMonth) {
                        ForEach(1...12, id: \.self) { i in
                            Text(months[i - 1]).tag(i)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxWidth: .infinity)

                    Picker("Year", selection: $selYear) {
                        ForEach(years, id: \.self) { y in
                            Text(String(y)).tag(y)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel", action: onCancel)
                        .foregroundColor(.orange)
                }
                ToolbarItem(placement: .principal) {
                    Text("\(months[selMonth-1]) \(String(selYear))")
                        .font(.headline)
                        .foregroundColor(.white)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") { onDone(selYear, selMonth) }
                        .foregroundColor(.orange)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
//
//  MonthYearPickerSheet..swift
//  LearningJourney2
//
//  Created by Amnah Albrahim on 05/05/1447 AH.
//

