# HISRAH Service Management — Flutter Developer Assessment

> A Flutter application implementing the **Service Management** module with two fully functional screens: Service Categories and Services List.

---

## 📦 Deliverables

| # | Deliverable | Link |
|---|---|---|
| 1 | Source Code | [github.com/nihalshx/hisrah-service-management](https://github.com/nihalshx/hisrah-service-management) |
| 2 | APK Download | [Download APK (Google Drive)](https://drive.google.com/file/d/1STOs8SZSUpzlCAOU38MA4q8-I32zO75A/view?usp=sharing) |
| 3 | Screen Recording | [Watch on Loom](https://www.loom.com/share/4d6b882fe7e14c6681d1715c9cb5de5a) |
| 4 | README | This file |

---

## ⚙️ Environment

| Item | Version |
|---|---|
| Flutter SDK | 3.11.5 (stable) |
| Dart SDK | ≥ 3.0.0 < 4.0.0 |
| Target Platform | Android (primary) |
| IDE | Android Studio / VS Code |

---

## 🚀 How to Run

```bash
# 1. Clone the repository
git clone https://github.com/nihalshx/hisrah-service-management.git
cd hisrah-service-management

# 2. Install dependencies
flutter pub get

# 3. Run on a connected device or emulator
flutter run

# 4. Build a release APK
flutter build apk --release

# 5. Lint check (should return 0 issues)
flutter analyze

# 6. Run tests
flutter test
```

---

## 📦 Packages & Justification

| Package | Version | Justification |
|---|---|---|
| `provider` | ^6.1.2 | Lightweight, officially recommended by the Flutter team. Minimal boilerplate for CRUD + loading/error state. Easy to unit test with `ChangeNotifier`. |
| `go_router` | ^13.2.0 | Declarative, URL-based navigation as required by the assessment spec. Future-proof for deep linking and web support. |
| `logger` | ^2.3.0 | Replaces all `print()` calls with structured, levelled logging (debug / info / warning / error). Zero print statements in submission. |
| `shimmer` | ^3.0.0 | Skeleton loading shimmer animation for data tables. Provides a polished loading UX instead of a plain spinner or blank screen. |

---

## 🏗️ Architecture

**Feature-first Clean Architecture** — each feature owns its data, domain, and presentation layers independently.

```
lib/
├── core/                          # Shared across all features
│   ├── theme/
│   │   ├── app_colors.dart        # Central colour palette (brand + action colours)
│   │   ├── app_spacing.dart       # Spacing & radius constants
│   │   └── app_theme.dart         # Material 3 ThemeData
│   ├── utils/
│   │   └── app_logger.dart        # Structured logger (wraps logger package)
│   └── widgets/
│       ├── action_icon_button.dart     # View / Edit / Delete icon buttons
│       ├── app_dialog_wrapper.dart     # Branded dialog shell (title bar + footer)
│       ├── confirm_delete_dialog.dart  # Reusable delete confirmation
│       └── shared_widgets.dart         # EmptyState, SectionHeader, ShimmerTable
│
├── features/
│   ├── service_categories/        # Screen 1
│   │   ├── data/
│   │   │   ├── models/            # ServiceCategoryModel (immutable)
│   │   │   └── repositories/      # ServiceCategoryRepository (mock, async)
│   │   ├── domain/
│   │   │   └── providers/         # ServiceCategoryProvider (ChangeNotifier)
│   │   └── presentation/
│   │       ├── screens/           # ServiceCategoriesScreen
│   │       └── dialogs/           # AddEditCategoryDialog (Add / Edit / View)
│   │
│   └── services/                  # Screen 2
│       ├── data/
│       │   ├── models/            # ServiceModel + CommissionType enum
│       │   └── repositories/      # ServiceRepository (mock, async)
│       ├── domain/
│       │   └── providers/         # ServiceProvider (ChangeNotifier + filter logic)
│       └── presentation/
│           ├── screens/           # ServicesListScreen (filter bar + table)
│           └── dialogs/           # AddEditServiceDialog (Add / Edit / View)
│
├── app_router.dart                # GoRouter — single "/" route → HomeScreen
├── home_screen.dart               # IndexedStack + NavigationBar (2 tabs)
└── main.dart                      # MultiProvider + MaterialApp.router entry point
```

---

## 🧠 Architecture & State Management Decisions

### Why Provider?
- **Simple and official** — recommended by the Flutter team for projects of this scale.
- **ChangeNotifier** pattern keeps UI and business logic cleanly separated.
- All mutating methods (`add`, `update`, `delete`) return a `bool` success flag — screens react accordingly without coupling to provider internals.
- Loading, error, and data states are all exposed as simple getters — no stream subscriptions or complex reactivity needed.

### Why Feature-first folder structure?
- Each feature (`service_categories`, `services`) is self-contained — easy to locate, modify, or delete without touching other code.
- Scales naturally when new features are added.
- Aligns with the Clean Architecture layers (data → domain → presentation) within each feature.

### Why IndexedStack for navigation?
- Both screens stay alive when switching tabs — scroll positions, loaded data, and form state are preserved.
- Avoids unnecessary re-fetches from the mock repository on every tab switch.

---

## 🎨 Design Tokens

| Token | Hex | Usage |
|---|---|---|
| Brand Primary | `#0F5C68` | App bar, section headers, buttons, focus borders |
| View Action | `#1E8449` | Green eye icon |
| Edit Action | `#E07B39` | Orange pencil icon |
| Delete Action | `#C0392B` | Red trash icon |

---

## 📋 Features Implemented

### Screen 1 — Service Categories
- ✅ Data table: Category Name, Display Name, Category For, Action
- ✅ Add / Edit / View dialog with all fields
- ✅ Arabic (RTL) field support
- ✅ Category For — segmented selector (All / Male / Female)
- ✅ Inline form validation on required fields
- ✅ Delete with confirmation dialog
- ✅ Shimmer loading skeleton
- ✅ Empty state widget

### Screen 2 — Services List
- ✅ Filter bar (visible by default): Service Category dropdown + Service Name text + Search / Clear
- ✅ Data table: Service Name, Category, Rate, Duration, Branch, Action
- ✅ Add / Edit / View dialog with all 12 fields including Branch
- ✅ Commission Type — radio buttons (Percentage / Amount), mutually exclusive
- ✅ Allow at Customer Location — styled checkbox
- ✅ Arabic (RTL) field support
- ✅ Inline form validation on required fields
- ✅ Delete with confirmation dialog
- ✅ Filter applied on Submit; cleared on Clear
- ✅ Empty state for no results

---

## ⚠️ Known Limitations & Assumptions

| # | Item |
|---|---|
| 1 | **Mock data only** — all repositories use in-memory lists with simulated 400–600 ms async delays. There is no real backend or API integration. |
| 2 | **No authentication** — the module is standalone with no login screen. |
| 3 | **Branch is a free-text field** — the assessment did not specify a Branch entity/list, so branch is entered as plain text. |
| 4 | **No pagination** — the table renders all records. For large datasets, server-side pagination would be needed. |
| 5 | **Data is not persisted** — restarting the app resets all data to the mock seed values. |
| 6 | **iOS not tested** — the APK targets Android. The code is cross-platform but iOS build was not part of the submission. |
