import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_dialog_wrapper.dart';
import '../../data/models/service_category_model.dart';
import '../../domain/providers/service_category_provider.dart';

/// Dialog for adding, editing, or viewing a [ServiceCategoryModel].
///
/// - Pass [category] as `null` for the Add flow.
/// - Pass an existing model for Edit; all fields are pre-populated.
/// - Set [readOnly] to `true` for a non-editable View dialog.
class AddEditCategoryDialog extends StatefulWidget {
  const AddEditCategoryDialog({
    super.key,
    required this.category,
    required this.provider,
    this.readOnly = false,
  });

  final ServiceCategoryModel? category;
  final ServiceCategoryProvider provider;
  final bool readOnly;

  @override
  State<AddEditCategoryDialog> createState() => _AddEditCategoryDialogState();
}

class _AddEditCategoryDialogState extends State<AddEditCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _nameArbCtrl = TextEditingController();
  final _displayNameCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  String _categoryFor = 'All';
  bool _isSubmitting = false;

  bool get _isAdding => widget.category == null;

  @override
  void initState() {
    super.initState();
    final cat = widget.category;
    if (cat != null) {
      _nameCtrl.text = cat.categoryName;
      _nameArbCtrl.text = cat.categoryNameArb;
      _displayNameCtrl.text = cat.displayName;
      _descCtrl.text = cat.shortDescription;
      _categoryFor = cat.categoryFor;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameArbCtrl.dispose();
    _displayNameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final model = ServiceCategoryModel(
      id: widget.category?.id ?? '',
      categoryName: _nameCtrl.text.trim(),
      categoryNameArb: _nameArbCtrl.text.trim(),
      displayName: _displayNameCtrl.text.trim(),
      shortDescription: _descCtrl.text.trim(),
      categoryFor: _categoryFor,
    );

    final success = _isAdding
        ? await widget.provider.addCategory(model)
        : await widget.provider.updateCategory(model);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isAdding
                ? 'Category added successfully.'
                : 'Category updated successfully.',
          ),
          backgroundColor: AppColors.success,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.provider.error ?? 'Operation failed. Please try again.',
          ),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.readOnly
        ? 'View Service Category'
        : (_isAdding ? 'Add Service Category' : 'Edit Service Category');

    return AppDialogWrapper(
      title: title,
      onClose: () => Navigator.of(context).pop(),
      onSubmit:
          widget.readOnly ? () => Navigator.of(context).pop() : _submit,
      isSubmitting: _isSubmitting,
      showSubmit: !widget.readOnly,
      submitLabel: widget.readOnly ? 'Close' : 'Submit',
      closeLabel: 'Close',
      content: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildRequiredField(
              controller: _nameCtrl,
              label: 'Category Name',
            ),
            const SizedBox(height: AppSpacing.md),
            _buildRequiredField(
              controller: _nameArbCtrl,
              label: 'Category Name (Arb)',
              textDirection: TextDirection.rtl,
              hint: 'اكتب هنا...',
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _displayNameCtrl,
              readOnly: widget.readOnly,
              decoration: const InputDecoration(labelText: 'Display Name'),
            ),
            const SizedBox(height: AppSpacing.md),
            TextFormField(
              controller: _descCtrl,
              readOnly: widget.readOnly,
              maxLines: 3,
              decoration:
                  const InputDecoration(labelText: 'Short Description'),
            ),
            const SizedBox(height: AppSpacing.md),
            _CategoryForField(
              value: _categoryFor,
              readOnly: widget.readOnly,
              onChanged: (val) => setState(() => _categoryFor = val),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a text field with required validation.
  Widget _buildRequiredField({
    required TextEditingController controller,
    required String label,
    TextDirection textDirection = TextDirection.ltr,
    String? hint,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: widget.readOnly,
      textDirection: textDirection,
      decoration: InputDecoration(
        labelText: '$label *',
        hintText: hint,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return '$label is required.';
        }
        return null;
      },
    );
  }
}

/// Segmented "Category For" selector (All / Male / Female).
class _CategoryForField extends StatelessWidget {
  const _CategoryForField({
    required this.value,
    required this.readOnly,
    required this.onChanged,
  });

  final String value;
  final bool readOnly;
  final ValueChanged<String> onChanged;

  static const _options = ['All', 'Male', 'Female'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category For',
          style: TextStyle(
            fontSize: 13,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SegmentedButton<String>(
          segments: _options
              .map((o) => ButtonSegment<String>(value: o, label: Text(o)))
              .toList(),
          selected: {value},
          onSelectionChanged:
              readOnly ? null : (val) => onChanged(val.first),
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.primary;
              }
              return null;
            }),
            foregroundColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.white;
              }
              return AppColors.textPrimary;
            }),
          ),
        ),
      ],
    );
  }
}
