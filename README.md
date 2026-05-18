# HISRAH Service Management — Flutter Developer Assessment

A Flutter application implementing the **Service Management** module.  
Two fully functional screens: **Service Categories** and **Services List**, with complete CRUD, form validation, filtering, and Provider-based state management.

---

## Environment

| Item | Version |
|---|---|
| Flutter SDK | ≥ 3.16.0 (tested on 3.22.x stable) |
| Dart SDK | ≥ 3.0.0 |
| Target platforms | Android (primary), iOS |

---

## Quick Start

```bash
# Install dependencies
flutter pub get

# Run on a connected device / emulator
flutter run

# Lint check
flutter analyze

# Run tests
flutter test
```

---

## Architecture

**Feature-first Clean Architecture:**

```
lib/
├── core/
│   ├── theme/            AppColors · AppTheme · AppSpacing
│   ├── utils/            AppLogger (wraps logger package)
│   └── widgets/          ActionIconButton · AppDialogWrapper
│                         ConfirmDeleteDialog · SharedWidgets
├── features/
│   ├── service_categories/
│   │   ├── data/         ServiceCategoryModel · ServiceCategoryRepository
│   │   ├── domain/       ServiceCategoryProvider (ChangeNotifier)
│   │   └── presentation/ ServiceCategoriesScreen · AddEditCategoryDialog
│   └── services/
│       ├── data/         ServiceModel · ServiceRepository
│       ├── domain/       ServiceProvider (ChangeNotifier)
│       └── presentation/ ServicesListScreen · AddEditServiceDialog
├── app_router.dart       GoRouter (single "/" route → HomeScreen)
├── home_screen.dart      IndexedStack + NavigationBar
└── main.dart             MultiProvider + MaterialApp.router
```

---

## State Management — Provider

**Why Provider?**

| Concern | Approach |
|---|---|
| Separation of concerns | Repository handles data; Provider handles state |
| Loading / error / data states | `isLoading`, `error`, `items` fields in each Provider |
| CRUD feedback | All mutating methods return `bool` success |
| Filter state | `ServiceProvider` owns filter fields and applies them |
| Navigation preservation | `IndexedStack` keeps both screens alive |

---

## Dependencies

| Package | Version | Justification |
|---|---|---|
| `provider` | ^6.1.2 | Lightweight, officially recommended by Flutter team; minimal boilerplate for CRUD + loading/error state; easy to test |
| `go_router` | ^13.2.0 | Declarative navigation as required by assessment; future-proof for deep linking |
| `logger` | ^2.3.0 | Replaces `print()` with structured, levelled logging — zero print statements in submission |
| `shimmer` | ^3.0.0 | Shimmer skeleton loading state for data tables — better UX than a blank screen |

---

## Screens

### 1 — Service Categories
- **Data table:** Category Name · Display Name · Category For · Action
- **Action icons:** 🟢 View · 🟠 Edit · 🔴 Delete
- **Add/Edit/View dialog:** Category Name\*, Category Name (Arb, RTL)\*, Display Name, Short Description, Category For (segmented selector)
- **Inline validation:** all required fields validated before submit

### 2 — Services List
- **Collapsible filter bar** (toggle via 🔽 icon): Category dropdown + Service Name text + Search / Clear
- **Data table:** Service Name · Category · Rate (SAR) · Duration · Branch · Action
- **Add/Edit/View dialog:** Category\*, Service Name\*, Service Name (Arb, RTL), Base Rate\*, Short Description, Short Description AR, Duration\*, Display Order, Commission Type (radio: Percentage / Amount), Commission Value, Allow at Customer Location (checkbox)

---

## Design Tokens

| Token | Value |
|---|---|
| Brand primary | `#0F5C68` |
| View action | `#1E8449` (green) |
| Edit action | `#E07B39` (orange) |
| Delete action | `#C0392B` (red) |

---

## Notes & Assumptions

- Repositories are **in-memory mocks** with simulated 400–600 ms delays. Swap out for Dio/Retrofit in production.
- Arabic fields use `textDirection: TextDirection.rtl` for correct RTL rendering.
- `IndexedStack` preserves scroll position and loaded data when switching tabs.
- Branch is treated as a plain string; no separate Branch entity was required by the assessment spec.
