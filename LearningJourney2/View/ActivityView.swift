import SwiftUI

struct ActivityView: View {
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var presenter: ActivityPresenter

    init(allowedFreezes: Int, topic: String, startDate: Date, targetDays: Int) {
        _presenter = StateObject(
            wrappedValue: ActivityPresenter(
                input: ActivityInputModel(
                    allowedFreezes: allowedFreezes,
                    topic: topic,
                    startDate: startDate,
                    targetDays: targetDays
                )
            )
        )
    }

    var body: some View {
        NavigationStack {
            ZStack(alignment: .top) {
                // Use system background to respect system light/dark mode
                Color(.systemBackground).ignoresSafeArea()

                VStack(alignment: .leading, spacing: 18) {

                    headerBar

                    calendarTopicStreaks

                    centerActionArea

                    Spacer().frame(height: 56)
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 20)
            }
            .overlay(bottomOverlay, alignment: .bottom)
            .onAppear {
                presenter.onAppear()
            }
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active {
                    presenter.onBecomeActive()
                }
            }
            .sheet(isPresented: $presenter.viewState.showCalendarSheet) {
                CalendarSheet(
                    initialMonth: presenter.viewState.selectedDate,
                    yearsAround: 2
                )
            }
            .navigationDestination(isPresented: $presenter.viewState.navigateToNewLearning) {
                NewLearningView()
                    .onAppear {
                        // optional: once we navigated we can clear the flag
                        presenter.didFinishNavigation()
                    }
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    // MARK: - Subviews

    private var headerBar: some View {
        HStack {
            Text("Activity")
                .font(.system(size: 34, weight: .bold))
                .foregroundColor(.primary) // adapt to system
            Spacer()
            HStack(spacing: 12) {
                Button {
                    presenter.didTapCalendar()
                } label: {
                    Image(systemName: "calendar")
                        .font(.system(size: 27, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(width: 50, height: 50)
                        .background(Color.primary.opacity(0.12))
                        .clipShape(Circle())
                }
                .glassEffect()

                Button {
                    presenter.didTapNewLearning()
                } label: {
                    Image(systemName: "pencil.and.outline")
                        .font(.system(size: 26, weight: .medium))
                        .foregroundColor(.primary)
                        .frame(width: 50, height: 50)
                        .background(Color.primary.opacity(0.12))
                        .clipShape(Circle())
                }
                .glassEffect()
            }
        }
        .padding(.top, 3)
    }

    private var calendarTopicStreaks: some View {
        VStack(alignment: .leading, spacing: 4) {
            WeekStrip(
                selectedDate: $presenter.viewState.selectedDate,
                tint: .orange,
                statusForDate: { date in
                    presenter.status(for: date)
                },
                onSelectDate: { date in
                    presenter.select(date: date)
                }
            )
            .padding(.top, 4)

            Rectangle()
                .fill(Color.primary.opacity(0.10))
                .frame(height: 1)
                .padding(.horizontal, 12)

            Text("Learning \(presenter.viewState.topicDisplay)")
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(.primary.opacity(0.9))
                .padding(.horizontal, 14)
                .padding(.bottom, 12)

            HStack(spacing: 10) {
                learnedCapsule
                Spacer(minLength: 0)
                freezedCapsule
            }
            .padding(.horizontal, 14)
            .padding(.bottom, 18)

        }
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.primary.opacity(0.04))
                
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(Color.primary.opacity(0.10), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.20), radius: 14, y: 8)
//        .glassEffect(.clear.tint(Color.black.opacity(0.4)))

    }

    private var learnedCapsule: some View {
        HStack(spacing: 8) {
            Image(systemName: "flame.fill")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(Color("brandOrange"))
            VStack(alignment: .leading, spacing: 2) {
                Text("\(presenter.viewState.currentStreak)")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                Text("\(presenter.viewState.currentStreak == 1 ? "Day" : "Days") learned")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.primary.opacity(0.95))
            }
        }
        .frame(width: 120, height: 75)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
        .background(Capsule().fill(Color("brandBrown")))
        .overlay(
            Capsule().stroke(Color.primary.opacity(0.12), lineWidth: 1)
        )
    }

    private var freezedCapsule: some View {
        HStack(spacing: 8) {
            Text("🧊")
                .font(.system(size: 20))
            VStack(alignment: .leading, spacing: 2) {
                Text("\(presenter.viewState.usedFreezes)")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                Text("\(presenter.viewState.usedFreezes == 1 ? "Day" : "Days") freezed")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.primary.opacity(0.95))
            }
        }
        .frame(width: 120, height: 75)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 10)
        .background(Capsule().fill(Color("blueSS")))
        .overlay(
            Capsule().stroke(Color.primary.opacity(0.12), lineWidth: 1)
        )
    }

    private var centerActionArea: some View {
        HStack {
            Spacer()
            if presenter.viewState.hasCompletedGoal {
                celebrationView
            } else {
                logButton
            }
            Spacer()
        }
        // Increase bottom padding to push it up a bit more away from the bottom overlay.
        .padding(.top, 3)
        .padding(.bottom, 20)
    }

    private var celebrationView: some View {
        VStack(spacing: 16) {
            Image(systemName: "hands.and.sparkles.fill")
                .font(.system(size: 40, weight: .bold))
                .foregroundColor(.orange)
            Text("Well Done!")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.primary)
            Text("Goal completed! start learning again or set new learning goal")
                .font(.system(size: 18, weight: .regular))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 300)
        }
        .padding()
        .shadow(color: .black.opacity(0.2), radius: 14, y: 8)
    }

    private var logButton: some View {
        Button {
            presenter.markLearned()
        } label: {
            ZStack {
                if presenter.viewState.isSelectedDayFreezed {
                    Circle()
                        .fill(Color(.systemBackground))
                        .glassEffect(.clear)
                        .overlay(
                            Circle().stroke(
                                LinearGradient(
                                    colors: [
                                        Color("brandBlue").opacity(0.8),
                                        Color("brandBlue").opacity(0.8),
                                        Color("brandBlue").opacity(0.8),
                                        Color.primary.opacity(0.2),
                                        Color.black.opacity(0.2),
                                        Color.black.opacity(0.2),
                                        Color.primary.opacity(0.2),
                                        Color("brandBlue").opacity(0.7)
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottom
                                )
                            )
                        )
                    Text("Day is freezed")
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(Color("brandBlue"))
                        .frame(width: 240, height: 90)
                } else if presenter.viewState.isSelectedDayLearned {
                    Circle()
                        .fill(Color("darkOrange"))
                    Circle()
                        .strokeBorder(Color.orange.opacity(0.7), lineWidth: 1)

                    Text("Learned \nToday")
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineSpacing(-4)
                        .kerning(-0.5)
                        .fixedSize()
                    
                } else {
                    Circle()
                        .fill(Color("brandOrange"))
                        .glassEffect(.clear.tint(.black.opacity(0.6)))
                        .overlay(
                            Circle().stroke(
                                LinearGradient(
                                    colors: [
                                        Color.orange.opacity(0.45),
                                        Color.orange.opacity(0.45),
                                        Color.orange.opacity(0.45),
                                        Color.primary.opacity(0.2),
                                        Color.black.opacity(0.2),
                                        Color.black.opacity(0.2),
                                        Color.primary.opacity(0.2),
                                        Color.orange.opacity(0.2),
                                    ],
                                    startPoint: .topLeading,
                                    endPoint: .bottom
                                )
                            )
                        )

                    Text("Log as\nLearned")
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .lineSpacing(-4)
                        .kerning(-0.5)
                        .fixedSize()
                 }
            }
            .frame(width: 274, height: 274)
            .shadow(
                color: Color.orange.opacity(presenter.viewState.isSelectedDayFreezed ? 0.0 : 0.35),
                radius: 18,
                x: 0,
                y: 10
            )
        }
        .buttonStyle(.plain)
        .disabled(presenter.viewState.isSelectedDayFreezed || presenter.viewState.isSelectedDayLearned)
    }

    private var bottomOverlay: some View {
        Group {
            if presenter.viewState.hasCompletedGoal {
                VStack(spacing: 12) {
                    Button {
                        presenter.didTapNewLearning()
                    } label: {
                        Text("Set new learning goal")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                Capsule().fill(Color("brandOrange"))
                            )
                            .overlay(
                                Capsule().stroke(
                                    LinearGradient(
                                        colors: [
                                            Color.orange.opacity(0.45),
                                            Color.orange.opacity(0.45),
                                            Color.orange.opacity(0.45),
                                            Color.primary.opacity(0.2),
                                            Color.black.opacity(0.2),
                                            Color.black.opacity(0.2),
                                            Color.primary.opacity(0.2),
                                            Color.orange.opacity(0.2)
                                        ],
                                        startPoint: .topLeading,
                                        endPoint: .bottom
                                    ),
                                    lineWidth: 1
                                )
                            )
                    }
                    .buttonStyle(.plain)
                    .glassEffect(.clear)

                    Button {
                        presenter.resetSameGoal()
                    } label: {
                        Text("Set same learning goal and duration")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundColor(.orange)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                    }
                    .buttonStyle(.plain)
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.bottom, 36)

            } else {
                VStack(spacing: 18) {
                    HStack {
                        Button {
                            presenter.markFreezed()
                        } label: {
                            Text("Log as freezed")
                                .font(.system(size: 20, weight: .bold))
                                .padding(.horizontal, 44)
                                .padding(.vertical, 18)
                                .frame(minWidth: 240)
                                .background(
                                    Capsule().fill(
                                        presenter.viewState.remainingFreezes > 0
                                        ? Color("brandBlue")
                                        : Color("darkBlue")
                                    )
                                )
                                .foregroundColor(.white)
                                .overlay(
                                    Group {
                                        if presenter.viewState.remainingFreezes == 0 {
                                            Capsule().stroke(
                                                LinearGradient(
                                                    colors: [
                                                        Color.primary.opacity(0.7),
                                                        Color.black.opacity(0.6),
                                                        Color.primary.opacity(0.7),
                                                        Color.black.opacity(0.6)
                                                    ],
                                                    startPoint: .topLeading,
                                                    endPoint: .bottom
                                                ),
                                                lineWidth: 1
                                            )
                                        }
                                    }
                                )
                        }
                        .disabled(
                            presenter.viewState.remainingFreezes == 0 ||
                            presenter.viewState.isSelectedDayLearned ||
                            presenter.viewState.isSelectedDayFreezed
                        )
                    }
                    .padding(.top, 16)

                    Text("\(presenter.viewState.usedFreezes) out of \(presenter.allowedFreezes) freezes used")
                        .font(.system(size: 15, weight: .regular))
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 1)
            }
        }
    }
}
