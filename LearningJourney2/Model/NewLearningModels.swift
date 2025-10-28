import Foundation

/// Input state needed to start or update a learning plan
struct NewLearningInputModel {
    var topic: String
    var selectedDuration: Duration
}

/// Output state the View renders
struct NewLearningViewState {
    // form fields
    var topic: String
    var selectedDuration: Duration

    // navigation
    var navigateToActivity: Bool

    // popup visibility
    var showUpdatePopup: Bool

    // derived preview data
    var persistedStartDate: Date        // the "start" date we're going to use
    var targetDays: Int                 // how many days in that duration
    var allowedFreezes: Int             // based on duration.freezes
}

/// storage keys for this flow
enum NewLearningStorageKeys {
    static let goalStartDate = "goalStartDate" // TimeInterval since 1970
}
//
//  NewLearningModels.swift
//  LearningJourney2
//
//  Created by Amnah Albrahim on 05/05/1447 AH.
//

