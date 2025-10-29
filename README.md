Learning Journey App
---------------------------------------------------------------------------------------------------------- 

<p align="left">
  <img src="https://raw.githubusercontent.com/Amnahyb4/LearningJourney2/main/Learning%20Icon.svg" width="200">
</p>

Learning Journey is a SwiftUI-based (iOS 16+) interactive and personalized learning companion designed to help users cultivate consistent daily learning habits, monitor their progress, and stay motivated through engaging streaks, customizable topics, and insightful visual progress tracking.

### 🖼️ Preview

<p align="center">
  <img src="https://raw.githubusercontent.com/Amnahyb4/LearningJourney2/main/IMG_0010.PNG" width="250" style="margin-right:10px;"/>
  <img src="https://raw.githubusercontent.com/Amnahyb4/LearningJourney2/main/IMG_0011.PNG" width="250" style="margin-right:10px;"/>
  <img src="https://raw.githubusercontent.com/Amnahyb4/LearningJourney2/main/IMG_0013.PNG" width="250"/>
</p>

---

## App Architecture (MVVM)

---

- **Model –** `ActivityModels.swift`, `Duration.swift`, `LearningGoal.swift`, `NewLearningModels.swift`  
  Business logic & data types: log/freeze days, streak rules, goal/topic & duration, snapshot shapes.

- **ViewModel / Presenter –** `ContentViewModel.swift`, `ActivityPresenter.swift`, `NewLearningPresenter.swift`  
  Exposes read-only state to Views; handles actions (`logToday()`, `freezeToday()`, `select(date:)`); manages navigation flags and autosave to `UserDefaults` (no separate persistence file).

- **Views**
  - `ActivityView.swift` – Home: toolbar, progress card, primary actions  
  - `NewLearningView.swift` – Topic & duration setup  
  - `CalendarSheet.swift`, `MonthYearPickerSheet.swift` – Calendar/month picker sheets  
  - Components: `WeekStrip`, `ToolbarView`, `CalendarProgressView`, `LogActionButton`, `FreezeButton`, `NewGoalButton`, `GoalCompletedView`

- **Persistence –** `Persistence`  
  Encodes a lightweight `LearningProgressSnapshot` to `UserDefaults` (ISO-8601 dates).  
  **Guard:** App only boots to Activity if a valid topic + duration were saved.


## Getting Started

1- Clone the repository: [https://github.com/Amnahyb4/LearningJourney2.git](https://github.com/Amnahyb4/LearningJourney2.git)

2- Open in Xcode: Select **Clone from Remote Repository**.

3- Build & run on an iPhone simulator or device that supports **iOS 16.0+**.

---

## 🧾 Requirements

- **iOS 16+**  
- **Xcode 16+**

---

## 👩🏻‍💻 Author

**Amnah Y. Albrahim**  
🎓 *Artificial Intelligence Graduate – Imam Abdulrahman Bin Faisal University*  
💡 *Passionate about building intelligent, user-centered educational experiences.*
