import SwiftUI

struct ContentView: View {
    @StateObject private var vm = ContentViewModel()
    @State private var navigate = false

    // cached payload for navigationDestination
    @State private var destAllowedFreezes: Int = 0
    @State private var destTopic: String = ""
    @State private var destStartDate: Date = Date()
    @State private var destTargetDays: Int = 0

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {

                // Logo centered horizontally
                HStack {
                    Spacer()
                    Button(action: {}) {
                        Image(systemName: "flame.fill")
                            .font(.largeTitle)
                            .foregroundColor(.orange)
                            .frame(width: 109, height: 109)
                            .background(Color("brown2"))
                            .clipShape(Circle())
                            .overlay(
                                Circle().strokeBorder(Color.brown.opacity(0.45), lineWidth: 1)
                            )
                    }
                    .clipShape(Capsule())
                    .overlay(
                        Capsule().stroke(
                            LinearGradient(
                                colors: [
                                    Color.orange.opacity(0.45), Color.orange.opacity(0.45), Color.orange.opacity(0.45),
                                    Color.white.opacity(0.2),
                                    Color.black.opacity(0.2), Color.black.opacity(0.2),
                                    Color.white.opacity(0.2),
                                    Color.orange.opacity(0.2),
                                ],
                                startPoint: .topLeading, endPoint: .bottom
                            )
                        )
                    )
                    Spacer()
                }
                .padding(.top, 16)

                Spacer().frame(height: 76)

                // Title + subtitle
                VStack(alignment: .leading, spacing: 4) {
                    Text("Hello Learner")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundColor(.primary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)

                    Text("This app will help you learn everyday!")
                        .font(.system(size: 17, weight: .regular))
                        .foregroundColor(.secondary)
                }

                Spacer().frame(height: 31)

                // Input field
                VStack(alignment: .leading, spacing: 2) {
                    Text("I want to learn")
                        .foregroundColor(.primary)
                        .font(.system(size: 22, weight: .regular))

                    SimpleTextField(text: $vm.topic, placeholder: "Swift")
                }

                Divider().background(Color.secondary.opacity(0.3))

                Spacer().frame(height: 31)

                // Duration selector (selectable chips)
                VStack(alignment: .leading, spacing: 15) {
                    Text("I want to learn it in a")
                        .foregroundColor(.primary)
                        .font(.system(size: 22, weight: .regular))

                    HStack(spacing: 12) {
                        ForEach(Duration.allCases) { d in
                            Button {
                                vm.selectedDuration = d
                            } label: {
                                Text(d.rawValue)
                                    .fontWeight(.medium)
                                    .frame(width: 97, height: 48)
                                    .background(
                                        Capsule()
                                            .fill(vm.selectedDuration == d ? Color("brandOrange") : Color.gray.opacity(0.3))
                                    )
                                    .foregroundColor(.white)
                            }
                            .buttonStyle(.plain)
                            .glassEffect(.clear)
                            .accessibilityAddTraits(vm.selectedDuration == d ? .isSelected : [])
                        }
                    }
                }

                Spacer() // push content up
            }
            .padding(.horizontal, 17)
            // Bottom-centered overlay button
            .overlay(
                HStack {
                    Button(action: {
                        vm.startLearning()
                        if let goal = vm.currentGoal {
                            destAllowedFreezes = goal.allowedFreezes
                            destTopic = goal.topic
                            destStartDate = goal.startDate
                            destTargetDays = goal.targetDays
                            navigate = true
                        }
                    }) {
                        Text("Start learning")
                            .fontWeight(.medium)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 12)
                            .background(Capsule().fill(Color("brandOrange")))
                            .foregroundColor(.white)
                    }
                    .glassEffect(.clear)
                    .disabled(vm.topic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .opacity(vm.topic.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? 0.6 : 1)
                }
                .frame(maxWidth: .infinity)
                .padding(.bottom, 24),
                alignment: .bottom
            )
            // Navigate with precomputed params
            .navigationDestination(isPresented: $navigate) {
                ActivityView(
                    allowedFreezes: destAllowedFreezes,
                    topic: destTopic,
                    startDate: destStartDate,
                    targetDays: destTargetDays
                )
            }
        }
    }
}

#Preview { ContentView() }
//
//  ContentView.swift
//  LearningJourney2
//
//  Created by Amnah Albrahim on 05/05/1447 AH.
//

