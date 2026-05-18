# HISRAH Service Management

Flutter Developer Assessment — Service Management Module

---

## Deliverables

| # | Item | Link |
|---|---|---|
| Source Code | GitHub Repository | https://github.com/nihalshx/hisrah-service-management |
| APK | Android Build | https://drive.google.com/file/d/1STOs8SZSUpzlCAOU38MA4q8-I32zO75A/view?usp=sharing |
| Screen Recording | Loom | https://www.loom.com/share/4d6b882fe7e14c6681d1715c9cb5de5a |

---

## Flutter Version

- Flutter SDK: 3.11.5 (stable)
- Dart SDK: >=3.0.0 <4.0.0

---

## Setup Steps

```bash
git clone https://github.com/nihalshx/hisrah-service-management.git
cd hisrah-service-management
flutter pub get
flutter run
```

To build a release APK:

```bash
flutter build apk --release
```

To run lint checks:

```bash
flutter analyze
```

To run tests:

```bash
flutter test
```

---

## Packages and Justification

| Package | Version | Justification |
|---|---|---|
| provider | ^6.1.2 | Selected as required by the assessment. Officially recommended by the Flutter team, minimal boilerplate, and straightforward integration with ChangeNotifier for CRUD and loading/error state. |
| go_router | ^13.2.0 | Selected as required by the assessment. Declarative routing with a single configuration file, supports deep linking and scales well as screens are added. |
| logger | ^2.3.0 | Replaces print() with structured, levelled logging (debug, info, warning, error). Ensures no raw print statements are present in the submission. |
| shimmer | ^3.0.0 | Provides skeleton loading animation for data tables while data is being fetched, improving perceived performance. |

---

## Folder Structure

```
lib/
├── core/
│   ├── theme/
│   │   ├── app_colors.dart          Central colour palette — brand and action colours
│   │   ├── app_spacing.dart         Spacing, padding, and border radius constants
│   │   └── app_theme.dart           Material 3 ThemeData configuration
│   ├── utils/
│   │   └── app_logger.dart          Application-wide logger wrapper
│   └── widgets/
│       ├── action_icon_button.dart  View, Edit, Delete icon button components
│       ├── app_dialog_wrapper.dart  Shared dialog shell with title bar and footer
│       ├── confirm_delete_dialog.dart  Reusable delete confirmation dialog
│       └── shared_widgets.dart      EmptyStateWidget, SectionHeader, ShimmerTable
│
├── features/
│   ├── service_categories/
│   │   ├── data/
│   │   │   ├── models/              ServiceCategoryModel
│   │   │   └── repositories/        ServiceCategoryRepository
│   │   ├── domain/
│   │   │   └── providers/           ServiceCategoryProvider
│   │   └── presentation/
│   │       ├── screens/             ServiceCategoriesScreen
│   │       └── dialogs/             AddEditCategoryDialog
│   │
│   └── services/
│       ├── data/
│       │   ├── models/              ServiceModel, CommissionType
│       │   └── repositories/        ServiceRepository
│       ├── domain/
│       │   └── providers/           ServiceProvider
│       └── presentation/
│           ├── screens/             ServicesListScreen
│           └── dialogs/             AddEditServiceDialog
│
├── app_router.dart                  GoRouter configuration
├── home_screen.dart                 Root screen with bottom NavigationBar
└── main.dart                        Entry point, MultiProvider setup
```

---

## Architecture Decisions

The project follows a feature-first folder structure aligned with Clean Architecture principles. Each feature (service_categories, services) owns its data, domain, and presentation layers independently. This keeps each feature self-contained and makes the codebase easier to navigate, extend, and maintain.

All colours, spacing values, and theme configurations are defined in the core/theme layer and referenced by widgets. No hardcoded values appear in widget code.

Dialogs are built from a shared AppDialogWrapper shell so that the title bar, close button, footer buttons, and loading state are consistent across all Add, Edit, and View flows.

---

## State Management Justification

Provider was selected as specified in the assessment requirements.

Each feature has a dedicated ChangeNotifier provider (ServiceCategoryProvider, ServiceProvider) that holds the list state, loading flag, and error message. All data-mutating methods (add, update, delete) perform the async repository call, update the in-memory list, and return a boolean success flag. Screens use context.watch to rebuild on state changes and context.read to call methods without rebuilding.

The ServiceProvider additionally manages filter state and exposes applyFilter and clearFilter methods, keeping all filter logic out of the presentation layer.

Both providers are registered at the root in main.dart using MultiProvider and load their initial data immediately on creation.

---

## Assumptions Made

- All data repositories are in-memory mocks with simulated async delays of 400 to 600 milliseconds. No real backend or API is integrated.
- Branch is implemented as a plain text input field. The assessment specification did not define a Branch entity or a predefined list of branches.
- The assessment did not require authentication, so no login screen is included.
- Data is not persisted between app sessions. Restarting the app resets all records to the initial mock seed data.
- iOS was not built or tested. The code is cross-platform but the submitted build targets Android only.
- Pagination is not implemented. All records are rendered in the table. For production use with large datasets, server-side pagination would be required.


