import Foundation
import SwiftUI

/// What happened on a given day
enum DayStatus: String, Codable, Equatable {
    case learned
    case freezed
}

/// Immutable info passed from the previous screen into Activity
struct ActivityInputModel {
    let allowedFreezes: Int
    let topic: String
    let startDate: Date
    let targetDays: Int
}

/// UI-facing state for the view
struct ActivityViewState {
    var selectedDate: Date
    var showCalendarSheet: Bool = false
    var navigateToNewLearning: Bool = false

    // presentation
    var remainingFreezes: Int
    var usedFreezes: Int
    var currentStreak: Int
    var hasCompletedGoal: Bool

    // for today/selected day buttons
    var isSelectedDayLearned: Bool
    var isSelectedDayFreezed: Bool

    var topicDisplay: String
}

/// Persistence keys for AppStorage/UserDefaults
enum ActivityStorageKeys {
    static let currentStreak = "currentStreak"
    static let lastActionTimestamp = "lastActionTimestamp"
    static let dayStatusesJSON = "dayStatusesJSON"
}
//
//  ActivityModels.swift
//  LearningJourney2
//
//  Created by Amnah Albrahim on 05/05/1447 AH.
//

