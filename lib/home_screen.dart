import 'package:flutter/material.dart';

import 'core/theme/app_colors.dart';
import 'features/service_categories/presentation/screens/service_categories_screen.dart';
import 'features/services/presentation/screens/services_list_screen.dart';

/// Root screen. Owns the bottom [NavigationBar] and switches between
/// [ServiceCategoriesScreen] and [ServicesListScreen] via an [IndexedStack].
///
/// [IndexedStack] keeps both screens alive so scroll positions and loaded
/// data are preserved when the user switches tabs.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    ServiceCategoriesScreen(),
    ServicesListScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: Colors.white,
        indicatorColor: AppColors.primary.withValues(alpha: 0.15),
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) =>
            setState(() => _selectedIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.category_outlined),
            selectedIcon: Icon(Icons.category, color: AppColors.primary),
            label: 'Service Categories',
          ),
          NavigationDestination(
            icon: Icon(Icons.miscellaneous_services_outlined),
            selectedIcon: Icon(
              Icons.miscellaneous_services,
              color: AppColors.primary,
            ),
            label: 'Services',
          ),
        ],
      ),
    );
  }
}
