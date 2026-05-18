import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_router.dart';
import 'core/theme/app_theme.dart';
import 'features/service_categories/data/repositories/service_category_repository.dart';
import 'features/service_categories/domain/providers/service_category_provider.dart';
import 'features/services/data/repositories/service_repository.dart';
import 'features/services/domain/providers/service_provider.dart';

void main() {
  runApp(const HisrahApp());
}

/// Root application widget.
///
/// Sets up [MultiProvider] with all feature providers, applies the
/// branded [AppTheme], and configures GoRouter via [AppRouter.router].
class HisrahApp extends StatelessWidget {
  const HisrahApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) =>
              ServiceCategoryProvider(ServiceCategoryRepository())
                ..loadCategories(),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              ServiceProvider(ServiceRepository())..loadServices(),
        ),
      ],
      child: MaterialApp.router(
        title: 'HISRAH Service Management',
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
