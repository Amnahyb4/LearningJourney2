import Foundation
import Combine

@MainActor
final class ContentViewModel: ObservableObject {
    // Inputs bound from the View
    @Published var topic: String = ""
    @Published var selectedDuration: Duration = .week

    // Output for navigation
    @Published private(set) var currentGoal: LearningGoal?

    private let startDateKey = "goalStartDate"
    private let calendar: Calendar

    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    func startLearning() {
        let now = Date()
        UserDefaults.standard.set(now.timeIntervalSince1970, forKey: startDateKey)

        currentGoal = LearningGoal(
            topic: topic.trimmingCharacters(in: .whitespacesAndNewlines),
            duration: selectedDuration,
            startDate: now,
            targetDays: computeTargetDays(for: selectedDuration, startDate: now),
            allowedFreezes: selectedDuration.freezes
        )
    }

    private func computeTargetDays(for duration: Duration, startDate: Date) -> Int {
        switch duration {
        case .week:  return 7
        case .month: return calendar.range(of: .day, in: .month, for: startDate)?.count ?? 30
        case .year:  return 365
        }
    }
}
//
//  ContentViewModel.swift
//  LearningJourney2
//
//  Created by Amnah Albrahim on 05/05/1447 AH.
//
