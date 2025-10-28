import Foundation

enum Duration: String, CaseIterable, Identifiable {
    case week = "Week", month = "Month", year = "Year"
    var id: String { rawValue }

    var freezes: Int {
        switch self {
        case .week:  return 2
        case .month: return 8
        case .year:  return 96
        }
    }
}
//
//  Duration.swift
//  LearningJourney2
//
//  Created by Amnah Albrahim on 05/05/1447 AH.
//

