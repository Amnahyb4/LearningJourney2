import Foundation
import SwiftUI
import Combine

@MainActor
final class ActivityPresenter: ObservableObject {

    // MARK: - Inputs
    private let input: ActivityInputModel
    private let calendar: Calendar = .current

    // MARK: - Persisted storage (backed by UserDefaults)
    @AppStorage(ActivityStorageKeys.currentStreak)
    private var persistedStreak: Int = 0

    @AppStorage(ActivityStorageKeys.lastActionTimestamp)
    private var lastActionTimestamp: Double = 0

    @AppStorage(ActivityStorageKeys.dayStatusesJSON)
    private var dayStatusesJSON: String = "{}"

    // MARK: - In-memory model
    // startOfDay -> DayStatus
    private var dayStatuses: [Date: DayStatus] = [:]

    // MARK: - Published state for View
    @Published var viewState: ActivityViewState

    // MARK: - Init
    init(input: ActivityInputModel) {
        self.input = input

        // Initialize viewState first so self is fully initialized before method calls.
        let selected = Date()
        self.viewState = ActivityViewState(
            selectedDate: selected,
            remainingFreezes: 0,         // temp; will recompute
            usedFreezes: 0,
            currentStreak: 0,
            hasCompletedGoal: false,
            isSelectedDayLearned: false,
            isSelectedDayFreezed: false,
            topicDisplay: ""
        )

        // Now it's safe to use self
        loadStatuses()
        recomputeDerivedState()
    }

    // MARK: - Public interface for the View

    func onAppear() {
        checkResetIfNeeded()
        recomputeDerivedState()
    }

    func onBecomeActive() {
        checkResetIfNeeded()
        recomputeDerivedState()
    }

    func didTapCalendar() {
        viewState.showCalendarSheet = true
    }

    func didDismissCalendar() {
        viewState.showCalendarSheet = false
    }

    func didTapNewLearning() {
        viewState.navigateToNewLearning = true
    }

    func didFinishNavigation() {
        // caller can set this back to false after pushing
        viewState.navigateToNewLearning = false
    }

    func select(date: Date) {
        viewState.selectedDate = date
        recomputeDerivedState()
    }

    func markLearned() {
        // can't mark if already learned or freezed
        guard status(for: viewState.selectedDate) == nil else { return }

        let day = startOfDay(viewState.selectedDate)
        dayStatuses[day] = .learned
        lastActionTimestamp = Date().timeIntervalSince1970

        saveStatuses()
        recomputeDerivedState()
    }

    func markFreezed() {
        guard viewState.remainingFreezes > 0 else { return }
        guard status(for: viewState.selectedDate) == nil else { return }

        let day = startOfDay(viewState.selectedDate)
        dayStatuses[day] = .freezed
        lastActionTimestamp = Date().timeIntervalSince1970

        saveStatuses()
        recomputeDerivedState()
    }

    func resetSameGoal() {
        // same goal, same duration — wipe streak + history
        persistedStreak = 0
        lastActionTimestamp = 0
        dayStatuses.removeAll()
        saveStatuses()
        recomputeDerivedState()
    }

    // MARK: - Getters for rendering subviews

    func status(for date: Date) -> DayStatus? {
        dayStatuses[startOfDay(date)]
    }

    var allowedFreezes: Int { input.allowedFreezes }
    var targetDays: Int { input.targetDays }
    var topic: String { input.topic }

    // MARK: - Internal helpers

    private func startOfDay(_ d: Date) -> Date {
        calendar.startOfDay(for: d)
    }

    /// Recompute streak, remaining freezes, booleans, etc. Pushes result into `viewState`
    private func recomputeDerivedState() {
        // 1. streak: consecutive learned days ending today
        let (streak, _) = computeStreak()
        persistedStreak = streak

        // 2. freezes
        let totalFreezed = dayStatuses.values.filter { $0 == .freezed }.count
        let remaining = max(0, input.allowedFreezes - totalFreezed)

        // 3. state for selected date
        let selStatus = status(for: viewState.selectedDate)
        let isLearned = selStatus == .learned
        let isFreezed = selStatus == .freezed

        viewState.currentStreak = streak
        viewState.usedFreezes = (input.allowedFreezes - remaining)
        viewState.remainingFreezes = remaining
        viewState.isSelectedDayLearned = isLearned
        viewState.isSelectedDayFreezed = isFreezed
        viewState.hasCompletedGoal = streak >= input.targetDays

        if input.topic.isEmpty {
            viewState.topicDisplay = "something"
        } else {
            viewState.topicDisplay = input.topic.lowercased()
        }
    }

    /// Return (streak, coveredDates)
    /// streak: how many consecutive .learned days ending on today
    private func computeStreak() -> (Int, [Date]) {
        let today = startOfDay(Date())
        var count = 0
        var cursor = today
        while let s = dayStatuses[cursor], s == .learned {
            count += 1
            guard let prev = calendar.date(byAdding: .day, value: -1, to: cursor) else { break }
            cursor = startOfDay(prev)
        }
        return (count, [])
    }

    /// If >32h since last action, streak resets to 0
    private func checkResetIfNeeded() {
        guard lastActionTimestamp > 0 else { return }
        let now = Date().timeIntervalSince1970
        let elapsed = now - lastActionTimestamp
        let threshold: TimeInterval = 32 * 3600

        if elapsed > threshold {
            persistedStreak = 0
        }
    }

    // MARK: - Persistence for dayStatuses

    private func loadStatuses() {
        guard let data = dayStatusesJSON.data(using: .utf8) else {
            dayStatuses = [:]
            return
        }
        do {
            let decoded = try JSONDecoder().decode([String: DayStatus].self, from: data)
            var map: [Date: DayStatus] = [:]
            for (k, v) in decoded {
                if let ts = TimeInterval(k) {
                    map[Date(timeIntervalSince1970: ts)] = v
                }
            }
            dayStatuses = map
        } catch {
            dayStatuses = [:]
        }
    }

    private func saveStatuses() {
        var enc: [String: DayStatus] = [:]
        for (date, status) in dayStatuses {
            let key = String(startOfDay(date).timeIntervalSince1970)
            enc[key] = status
        }
        if let data = try? JSONEncoder().encode(enc),
           let json = String(data: data, encoding: .utf8) {
            dayStatusesJSON = json
        }
    }
}
//
//  ActivityPresenter.swift
//  LearningJourney2
//
//  Created by Amnah Albrahim on 05/05/1447 AH.
//
