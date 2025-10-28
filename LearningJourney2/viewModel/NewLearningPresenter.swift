import Foundation
import SwiftUI
import Combine

@MainActor
final class NewLearningPresenter: ObservableObject {

    // MARK: - Stored refs
    private let calendar: Calendar = .current

    // Persisted "start" timestamp shared with Activity
    @AppStorage(NewLearningStorageKeys.goalStartDate)
    private var storedGoalStartDate: Double = 0 // TimeInterval since 1970

    // MARK: - Published view state (the View binds to this)
    @Published var viewState: NewLearningViewState

    // MARK: - Init
    init(initialTopic: String = "",
         initialDuration: Duration = .week) {

        // 1) Initialize viewState with a temporary placeholder so `self` is fully initialized.
        let now = Date()
        self.viewState = NewLearningViewState(
            topic: initialTopic,
            selectedDuration: initialDuration,
            navigateToActivity: false,
            showUpdatePopup: false,
            persistedStartDate: now,
            targetDays: Self.computeTargetDays(for: initialDuration, startDate: now, calendar: calendar),
            allowedFreezes: initialDuration.freezes
        )

        // 2) Now it's safe to read @AppStorage and compute the real initial state.
        let persistedStartDate: Date = storedGoalStartDate > 0
        ? Date(timeIntervalSince1970: storedGoalStartDate)
        : now

        let targetDays = Self.computeTargetDays(
            for: initialDuration,
            startDate: persistedStartDate,
            calendar: calendar
        )

        // 3) Update viewState with the correct derived values.
        viewState.persistedStartDate = persistedStartDate
        viewState.targetDays = targetDays
        viewState.allowedFreezes = initialDuration.freezes
    }

    // MARK: - Intents from the View

    func didChangeTopic(_ newValue: String) {
        viewState.topic = newValue
        // nothing else to recompute
    }

    func didSelectDuration(_ duration: Duration) {
        viewState.selectedDuration = duration

        // recompute derived fields
        let newTarget = Self.computeTargetDays(
            for: duration,
            startDate: viewState.persistedStartDate,
            calendar: calendar
        )

        viewState.targetDays = newTarget
        viewState.allowedFreezes = duration.freezes
    }

    func didTapCheckmark() {
        // show the confirmation popup
        withAnimation(.easeInOut) {
            viewState.showUpdatePopup = true
        }
    }

    func popupDismiss() {
        withAnimation(.easeInOut) {
            viewState.showUpdatePopup = false
        }
    }

    func popupBackgroundTap() {
        // same as dismiss
        popupDismiss()
    }

    func popupConfirmUpdate() {
        // user confirmed "Update"

        // 1. reset startDate to NOW for the new goal
        let now = Date()
        storedGoalStartDate = now.timeIntervalSince1970

        // 2. recompute preview with that new start
        let newTarget = Self.computeTargetDays(
            for: viewState.selectedDuration,
            startDate: now,
            calendar: calendar
        )

        viewState.persistedStartDate = now
        viewState.targetDays = newTarget

        // 3. close popup, then flip navigation flag
        withAnimation(.easeInOut) {
            viewState.showUpdatePopup = false
        }

        // Navigation flag that ActivityView will read using .navigationDestination
        // SwiftUI will observe this @Published change.
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            self.viewState.navigateToActivity = true
        }
    }

    func navigationHandled() {
        // after NavigationStack actually pushed ActivityView,
        // we can clear the flag to avoid double-push on re-render
        viewState.navigateToActivity = false
    }

    // MARK: - Helpers

    static func computeTargetDays(for duration: Duration,
                                  startDate: Date,
                                  calendar: Calendar) -> Int {
        switch duration {
        case .week:
            return 7
        case .month:
            return calendar.range(of: .day, in: .month, for: startDate)?.count ?? 30
        case .year:
            return 365
        }
    }
}
//
//  NewLearningPresenter.swift
//  LearningJourney2
//
//  Created by Amnah Albrahim on 05/05/1447 AH.
//
