import 'package:go_router/go_router.dart';

import 'home_screen.dart';

/// Application router configuration using GoRouter.
///
/// A single root route `/` renders [HomeScreen], which owns the
/// bottom NavigationBar and switches between the two module screens
/// via an [IndexedStack] — avoiding full rebuilds on tab changes.
abstract final class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
}
