Learning Journey App
----------------------------------------------------------------------------------------------------------


An interactive and personalized learning companion that helps users build daily learning habits, track progress, and stay motivated through streaks, topics, and visual insights.

Features:
-----------------------------------------------------------------------------------------------------------
✍️ Onboarding – Type your learning topic and pick a duration.
🔥 Streaks – Log “Learned Today”; auto-count your current streak.
🧊 Freeze days – Limited “skip” days per goal (2/week, 8/month, 96/year).
📆 Calendar – Month list + weekly view; coloured dots for learned/frozen days.
✅ Goal updates – Change your goal mid-cycle (option to reset counters).
💾 Local persistence – Progress saved to disk; app opens to Activity only after onboarding.

App Architecture (MVVM)
--------------------------------------------------------------------------------------------------------------
Model— ActivityModels.swift, Duration.swift, LearningGoal.swift, NewLearningModels.swift
Business logic & data types: log/freeze days, streak rules, goal/topic & duration, snapshot shapes.

ViewModel / Presenter — ContentViewModel.swift, ActivityPresenter.swift, NewLearningPresenter.swift
Exposes read-only state to Views; handles actions (logToday(), freezeToday(), select(date:)), navigation flags, and autosave to UserDefaults (no separate persistence file).

Views
ActivityView.swift — Home: toolbar, progress card, primary actions
NewLearningView.swift — Topic & duration setup
CalendarSheet.swift, MonthYearPickerSheet.swift — Calendar/month picker sheets
WeekStrip.swift — ISO week + day pills; maps DayStatus → colors
ContentView.swift, SimpleTextField.swift — App shell & reusable input
App Entry — LearningJourney2App.swift
Boots to ActivityView when a valid topic + duration exist; otherwise shows NewLearningView.

Requirements:
--------------------------------------------------------------------------------------------------------------
iOS 26+
Xcode 26+

Author:
----------------

Amnah Y. Albrahim

🎓 Artificial Intelligence Graduate – Imam Abdulrahman Bin Faisal University

💡 Passionate about building intelligent, user-centered educational experiences.
