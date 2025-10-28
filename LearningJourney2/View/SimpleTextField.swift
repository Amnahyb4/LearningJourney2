import SwiftUI

struct SimpleTextField: View {
    @Binding var text: String
    var placeholder: String = "Swift"

    @FocusState private var focused: Bool
    private let placeholderColor = Color.secondary.opacity(0.4)

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty {
                Text(placeholder).foregroundColor(placeholderColor)
            }
            TextField("", text: $text)
                .focused($focused)
                .foregroundColor(.primary)
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled(true)
                .accessibilityLabel("Learning topic")
        }
        .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
        .overlay(
            Rectangle()
                .frame(height: 1)
                .foregroundColor(focused ? Color("brandOrange") : Color.secondary.opacity(0.3)),
            alignment: .bottom
        )
    }
}
//
//  SimpleTextField.swift
//  LearningJourney2
//
//  Created by Amnah Albrahim on 05/05/1447 AH.
//

