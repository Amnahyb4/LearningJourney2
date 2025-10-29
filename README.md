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

## 🧠 App Architecture (MVVM)

---

### 🧩 Model  
**Files:** `ActivityModels.swift`, `Duration.swift`, `LearningGoal.swift`, `NewLearningModels.swift`  
Handles the **core business logic and data types** — including logging and freezing days, streak rules, goal/topic & duration tracking, and snapshot data structures.

---

### ⚙️ ViewModel / Presenter  
**Files:** `ContentViewModel.swift`, `ActivityPresenter.swift`, `NewLearningPresenter.swift`  
Manages the **application state** and connects logic to views.  
- Exposes read-only state to `Views`  
- Handles actions: `logToday()`, `freezeToday()`, `select(date:)`  
- Manages navigation flags and automatically saves progress to `UserDefaults` (no external persistence layer)

---

### 🪄 Views  
- `ActivityView.swift` — Home screen with toolbar, progress card, and primary actions  
- `NewLearningView.swift` — Setup screen for topic & duration  
- `CalendarSheet.swift`, `MonthYearPickerSheet.swift` — Calendar and month picker sheets  
- `WeekStrip.swift` — Displays ISO week + day pills; maps `DayStatus` → color states  
- `ContentView.swift`, `SimpleTextField.swift` — App shell & reusable input components  

---

### 🚀 App Entry  
**File:** `LearningJourney2App.swift`  
- Launches directly to `ActivityView` if a valid topic and duration exist  
- Otherwise, presents `NewLearningView` for onboarding setup  

---

## 🧾 Requirements

- **iOS 16+**  
- **Xcode 16+**

---

## 👩🏻‍💻 Author

**Amnah Y. Albrahim**  
🎓 *Artificial Intelligence Graduate – Imam Abdulrahman Bin Faisal University*  
💡 *Passionate about building intelligent, user-centered educational experiences.*
