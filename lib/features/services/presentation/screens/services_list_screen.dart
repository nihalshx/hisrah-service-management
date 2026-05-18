import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/action_icon_button.dart';
import '../../../../core/widgets/confirm_delete_dialog.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../../service_categories/data/models/service_category_model.dart';
import '../../../service_categories/domain/providers/service_category_provider.dart';
import '../../data/models/service_model.dart';
import '../../domain/providers/service_provider.dart';
import '../dialogs/add_edit_service_dialog.dart';

/// Screen displaying the Services list with a collapsible filter bar
/// and full CRUD support.
class ServicesListScreen extends StatelessWidget {
  const ServicesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Service Management')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Collapsible filter bar
            const _FilterBar(),
            const SizedBox(height: AppSpacing.md),
            // Main data card
            Expanded(
              child: Card(
                child: Column(
                  children: [
                    SectionHeader(
                      title: 'Services',
                      actions: [
                        HeaderIconButton(
                          icon: Icons.filter_alt_outlined,
                          tooltip: 'Toggle Filter',
                          onTap: () =>
                              context.read<ServiceProvider>().toggleFilterBar(),
                        ),
                        const SizedBox(width: 6),
                        HeaderIconButton(
                          icon: Icons.add,
                          tooltip: 'Add Service',
                          onTap: () => _openAddDialog(context),
                        ),
                      ],
                    ),
                    Expanded(child: _ServicesBody()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openAddDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => AddEditServiceDialog(
        service: null,
        provider: context.read<ServiceProvider>(),
        categoryProvider: context.read<ServiceCategoryProvider>(),
      ),
    );
  }
}

// ── Filter Bar ────────────────────────────────────────────────────────────────

class _FilterBar extends StatefulWidget {
  const _FilterBar();

  @override
  State<_FilterBar> createState() => _FilterBarState();
}

class _FilterBarState extends State<_FilterBar>
    with SingleTickerProviderStateMixin {
  String? _selectedCategoryId;
  final _nameCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final show = context.watch<ServiceProvider>().showFilterBar;
    final categories = context.watch<ServiceCategoryProvider>().categories;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 200),
      transitionBuilder: (child, animation) => SizeTransition(
        sizeFactor: animation,
        child: child,
      ),
      child: show
          ? Card(
              key: const ValueKey('filter-bar'),
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppSpacing.cardRadius),
                side: const BorderSide(color: AppColors.tableBorder),
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.sm,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    SizedBox(
                      width: 220,
                      child: DropdownButtonFormField<String>(
                        key: ValueKey(_selectedCategoryId),
                        initialValue: _selectedCategoryId,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Service Category',
                          isDense: true,
                          prefixIcon:
                              Icon(Icons.category_outlined, size: 18),
                        ),
                        hint: const Text('All Categories'),
                        items: [
                          const DropdownMenuItem<String>(
                            value: null,
                            child: Text('All Categories'),
                          ),
                          ...categories.map(
                            (cat) => DropdownMenuItem<String>(
                              value: cat.id,
                              child: Text(cat.categoryName),
                            ),
                          ),
                        ],
                        onChanged: (val) =>
                            setState(() => _selectedCategoryId = val),
                      ),
                    ),
                    SizedBox(
                      width: 220,
                      child: TextFormField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Service Name',
                          isDense: true,
                          prefixIcon: Icon(
                            Icons.miscellaneous_services_outlined,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _applyFilter(context, categories),
                      icon: const Icon(Icons.search, size: 16),
                      label: const Text('Search'),
                    ),
                    OutlinedButton.icon(
                      onPressed: () => _clearFilter(context),
                      icon: const Icon(Icons.clear, size: 16),
                      label: const Text('Clear'),
                    ),
                  ],
                ),
              ),
            )
          : const SizedBox.shrink(key: ValueKey('filter-hidden')),
    );
  }

  void _applyFilter(
    BuildContext context,
    List<ServiceCategoryModel> categories,
  ) {
    // Build a lookup map so the provider can match by name
    final catMap = {for (final c in categories) c.id: c.categoryName};

    final selectedCatName = _selectedCategoryId != null
        ? (catMap[_selectedCategoryId] ?? '')
        : '';

    context.read<ServiceProvider>().applyFilter(
          categoryName: selectedCatName,
          serviceName: _nameCtrl.text.trim(),
          categoryNames: catMap,
        );
  }

  void _clearFilter(BuildContext context) {
    setState(() => _selectedCategoryId = null);
    _nameCtrl.clear();
    context.read<ServiceProvider>().clearFilter();
  }
}

// ── Body ──────────────────────────────────────────────────────────────────────

class _ServicesBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ServiceProvider>();

    if (provider.isLoading) return const ShimmerTable();

    if (provider.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline,
                  color: AppColors.error, size: 44),
              const SizedBox(height: 10),
              Text(
                provider.error!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.error),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () =>
                    context.read<ServiceProvider>().loadServices(),
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (provider.services.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.miscellaneous_services_outlined,
        message: provider.hasActiveFilter
            ? 'No services match your filter.\nTry adjusting your search.'
            : 'No services found.\nTap + to add one.',
      );
    }

    return _ServicesDataTable(services: provider.services);
  }
}

// ── Data Table ────────────────────────────────────────────────────────────────

class _ServicesDataTable extends StatelessWidget {
  const _ServicesDataTable({required this.services});

  final List<ServiceModel> services;

  @override
  Widget build(BuildContext context) {
    final categories = context.watch<ServiceCategoryProvider>().categories;

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
              label: Text('Service Name',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
            ),
            DataColumn(
              label: Text('Category',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
            ),
            DataColumn(
              label: Text('Rate (SAR)',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
              numeric: true,
            ),
            DataColumn(
              label: Text('Duration',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
            ),
            DataColumn(
              label: Text('Branch',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
            ),
            DataColumn(
              label: Text('Action',
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w600)),
            ),
          ],
          rows: services.asMap().entries.map((entry) {
            final isEven = entry.key.isEven;
            final svc = entry.value;
            final catMatches =
                categories.where((c) => c.id == svc.categoryId);
            final categoryName = catMatches.isNotEmpty
                ? catMatches.first.categoryName
                : svc.categoryId;

            return DataRow(
              color: WidgetStatePropertyAll(
                isEven ? AppColors.tableRowEven : AppColors.tableRowOdd,
              ),
              cells: [
                DataCell(Text(svc.serviceName)),
                DataCell(Text(categoryName)),
                DataCell(
                  Text(svc.baseRate.toStringAsFixed(2)),
                ),
                DataCell(Text('${svc.duration} min')),
                DataCell(
                  Text(svc.branch.isEmpty ? '—' : svc.branch),
                ),
                DataCell(_ServiceActionRow(service: svc)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ── Action Row ────────────────────────────────────────────────────────────────

class _ServiceActionRow extends StatelessWidget {
  const _ServiceActionRow({required this.service});

  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ViewActionButton(onTap: () => _openDialog(context, readOnly: true)),
        const SizedBox(width: 4),
        EditActionButton(onTap: () => _openDialog(context)),
        const SizedBox(width: 4),
        DeleteActionButton(onTap: () => _confirmDelete(context)),
      ],
    );
  }

  void _openDialog(BuildContext context, {bool readOnly = false}) {
    showDialog<void>(
      context: context,
      barrierDismissible: readOnly,
      builder: (_) => AddEditServiceDialog(
        service: service,
        provider: context.read<ServiceProvider>(),
        categoryProvider: context.read<ServiceCategoryProvider>(),
        readOnly: readOnly,
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showConfirmDeleteDialog(
      context,
      itemName: service.serviceName,
    );
    if (!confirmed || !context.mounted) return;

    final provider = context.read<ServiceProvider>();
    final success = await provider.deleteService(service.id);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? '"${service.serviceName}" has been deleted.'
              : (provider.error ?? 'Delete failed.'),
        ),
        backgroundColor: success ? AppColors.success : AppColors.error,
      ),
    );
  }
}
