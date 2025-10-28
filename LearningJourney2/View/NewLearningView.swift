import SwiftUI

struct NewLearningView: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject private var presenter = NewLearningPresenter()

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {

                Spacer().frame(height: 56)

                // Topic input
                VStack(alignment: .leading, spacing: 8) {
                    Text("I want to learn")
                        .foregroundColor(.primary)
                        .font(.system(size: 22, weight: .regular))

                    ZStack(alignment: .leading) {
                        if presenter.viewState.topic.isEmpty {
                            Text("Swift")
                                .foregroundColor(Color.secondary.opacity(0.6))
                        }

                        TextField(
                            "",
                            text: Binding(
                                get: { presenter.viewState.topic },
                                set: { presenter.didChangeTopic($0) }
                            )
                        )
                        .foregroundColor(.primary)
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled(true)
                    }
                    .frame(maxWidth: .infinity, minHeight: 48, alignment: .leading)
                    .overlay(
                        Rectangle()
                            .frame(height: 1)
                            .foregroundColor(Color.secondary.opacity(0.3)),
                        alignment: .bottom
                    )
                }

                Spacer().frame(height: 28)

                // Duration selector chips
                durationSelector

                Spacer()
            }
            .padding(.horizontal, 17)
            // Popup overlay
            .overlay {
                if presenter.viewState.showUpdatePopup {
                    PopupOverlayView(
                        onBackgroundTap: { presenter.popupBackgroundTap() },
                        onDismissTap: { presenter.popupDismiss() },
                        onUpdateTap: { presenter.popupConfirmUpdate() }
                    )
                    .transition(.opacity.combined(with: .scale))
                }
            }
            // Toolbar
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Learning Goal")
                        .font(.system(size: 23, weight: .bold))
                        .foregroundColor(.primary)
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        presenter.didTapCheckmark()
                    } label: {
                        ZStack {
                            Circle()
                                .fill(Color("brandOrange"))
                                .frame(width: 35, height: 35)
                            Image(systemName: "checkmark")
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(.white)
                        }
                    }
                    .accessibilityLabel("Confirm and start")
                }
            }
            .navigationBarTitleDisplayMode(.inline)

            // Navigation to ActivityView: controlled by presenter.viewState.navigateToActivity
            .navigationDestination(isPresented: Binding(
                get: { presenter.viewState.navigateToActivity },
                set: { newValue in
                    // when NavigationStack finishes pushing, SwiftUI might set this back.
                    // We route that back so presenter can clear it.
                    if presenter.viewState.navigateToActivity != newValue {
                        presenter.navigationHandled()
                    }
                }
            )) {
                ActivityView(
                    allowedFreezes: presenter.viewState.allowedFreezes,
                    topic: presenter.viewState.topic,
                    startDate: presenter.viewState.persistedStartDate,
                    targetDays: presenter.viewState.targetDays
                )
            }
        }
    }

    // MARK: - subviews

    private var durationSelector: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("I want to learn it in a")
                .foregroundColor(.primary)
                .font(.system(size: 21, weight: .regular))

            HStack(spacing: 12) {
                ForEach(Duration.allCases) { d in
                    let isSelected = (presenter.viewState.selectedDuration == d)

                    Button {
                        presenter.didSelectDuration(d)
                    } label: {
                        Text(d.rawValue)
                            .fontWeight(.medium)
                            .frame(width: 97, height: 48)
                            .background(
                                Capsule()
                                    .fill(isSelected ? Color("brandOrange") : Color.gray.opacity(0.3))
                            )
                            .foregroundColor(.white)
                    }
                    .buttonStyle(.plain)
                    .glassEffect(.clear)
                }
            }
        }
    }
}

// MARK: - Popup

private struct PopupOverlayView: View {
    var onBackgroundTap: () -> Void
    var onDismissTap: () -> Void
    var onUpdateTap: () -> Void

    var body: some View {
        ZStack {
            Color.black.opacity(0.45)
                .ignoresSafeArea()
                .onTapGesture(perform: onBackgroundTap)

            PopupCardView(
                onDismissTap: onDismissTap,
                onUpdateTap: onUpdateTap
            )
            .padding(.horizontal, 28)
        }
    }
}

private struct PopupCardView: View {
    var onDismissTap: () -> Void
    var onUpdateTap: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Text("Update learning goal")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.primary)
                .padding(.top, 6)

            Text("If you update now, your streak will start over.")
                .font(.system(size: 16, weight: .regular))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 6)

            HStack(spacing: 12) {
                Button(action: onDismissTap) {
                    Text("Dismiss")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(Color.secondary.opacity(0.2))
                        )
                }
                .buttonStyle(.plain)

                Button(action: onUpdateTap) {
                    Text("Update")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            Capsule()
                                .fill(Color.orange)
                        )
                }
                .buttonStyle(.plain)
                .glassEffect()
            }
            .padding(.bottom, 6)
        }
        .padding(18)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(.systemBackground))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
        )
        .transition(.scale.combined(with: .opacity))
    }
}

#Preview {
    NewLearningView()
}
//
//  NewLearningView.swift
//  LearningJourney2
//
//  Created by Amnah Albrahim on 05/05/1447 AH.
//

