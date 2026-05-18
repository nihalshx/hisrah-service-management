import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/action_icon_button.dart';
import '../../../../core/widgets/confirm_delete_dialog.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../data/models/service_category_model.dart';
import '../../domain/providers/service_category_provider.dart';
import '../dialogs/add_edit_category_dialog.dart';

/// Screen displaying the Service Categories list with full CRUD support.
class ServiceCategoriesScreen extends StatelessWidget {
  const ServiceCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Service Management')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Column(
            children: [
              SectionHeader(
                title: 'Service Categories',
                actions: [
                  HeaderIconButton(
                    icon: Icons.add,
                    tooltip: 'Add Category',
                    onTap: () => _openDialog(context, category: null),
                  ),
                ],
              ),
              Expanded(child: _CategoriesBody()),
            ],
          ),
        ),
      ),
    );
  }

  void _openDialog(
    BuildContext context, {
    required ServiceCategoryModel? category,
    bool readOnly = false,
  }) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AddEditCategoryDialog(
        category: category,
        provider: context.read<ServiceCategoryProvider>(),
        readOnly: readOnly,
      ),
    );
  }
}

// ── Body ──────────────────────────────────────────────────────────────────────

class _CategoriesBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ServiceCategoryProvider>();

    if (provider.isLoading) return const ShimmerTable();

    if (provider.error != null) return _ErrorView(message: provider.error!);

    if (provider.categories.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.category_outlined,
        message: 'No categories found.\nTap + to add one.',
      );
    }

    return _CategoriesTable(categories: provider.categories);
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline,
                color: AppColors.error, size: 44),
            const SizedBox(height: 10),
            Text(message,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.error)),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () =>
                  context.read<ServiceCategoryProvider>().loadCategories(),
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Data Table ────────────────────────────────────────────────────────────────

class _CategoriesTable extends StatelessWidget {
  const _CategoriesTable({required this.categories});

  final List<ServiceCategoryModel> categories;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          headingRowColor:
              const WidgetStatePropertyAll(AppColors.tableHeaderBg),
          columnSpacing: 24,
          horizontalMargin: 16,
          columns: const [
            DataColumn(
              label: Text('Category Name',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
            ),
            DataColumn(
              label: Text('Display Name',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
            ),
            DataColumn(
              label: Text('Category For',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
            ),
            DataColumn(
              label: Text('Action',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ],
          rows: categories.asMap().entries.map((entry) {
            final isEven = entry.key.isEven;
            final cat = entry.value;
            return DataRow(
              color: WidgetStatePropertyAll(
                isEven ? AppColors.tableRowEven : AppColors.tableRowOdd,
              ),
              cells: [
                DataCell(Text(cat.categoryName)),
                DataCell(
                  Text(cat.displayName.isEmpty ? '—' : cat.displayName),
                ),
                DataCell(_CategoryForBadge(label: cat.categoryFor)),
                DataCell(_ActionRow(category: cat)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ── Category For Badge ────────────────────────────────────────────────────────

class _CategoryForBadge extends StatelessWidget {
  const _CategoryForBadge({required this.label});

  final String label;

  Color get _color {
    switch (label) {
      case 'Male':
        return const Color(0xFF1565C0);
      case 'Female':
        return const Color(0xFFC62828);
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: _color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}

// ── Action Row ────────────────────────────────────────────────────────────────

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.category});

  final ServiceCategoryModel category;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ViewActionButton(
          onTap: () => _openDialog(context, readOnly: true),
        ),
        const SizedBox(width: 4),
        EditActionButton(
          onTap: () => _openDialog(context),
        ),
        const SizedBox(width: 4),
        DeleteActionButton(
          onTap: () => _confirmDelete(context),
        ),
      ],
    );
  }

  void _openDialog(BuildContext context, {bool readOnly = false}) {
    showDialog<void>(
      context: context,
      barrierDismissible: readOnly,
      builder: (_) => AddEditCategoryDialog(
        category: category,
        provider: context.read<ServiceCategoryProvider>(),
        readOnly: readOnly,
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showConfirmDeleteDialog(
      context,
      itemName: category.categoryName,
    );
    if (!confirmed || !context.mounted) return;

    final provider = context.read<ServiceCategoryProvider>();
    final success = await provider.deleteCategory(category.id);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? '"${category.categoryName}" has been deleted.'
              : (provider.error ?? 'Delete failed.'),
        ),
        backgroundColor:
            success ? AppColors.success : AppColors.error,
      ),
    );
  }
}
