import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/app_dialog_wrapper.dart';
import '../../../service_categories/domain/providers/service_category_provider.dart';
import '../../data/models/service_model.dart';
import '../../domain/providers/service_provider.dart';

/// Dialog for adding, editing, or viewing a [ServiceModel].
///
/// Fields:
/// Category*, Service Name*, Service Name (Arb), Base Rate*,
/// Short Description, Short Description AR, Duration*, Display Order,
/// Commission Type (radio), Commission Value, Allow at Cust Loc (checkbox).
class AddEditServiceDialog extends StatefulWidget {
  const AddEditServiceDialog({
    super.key,
    required this.service,
    required this.provider,
    required this.categoryProvider,
    this.readOnly = false,
  });

  final ServiceModel? service;
  final ServiceProvider provider;
  final ServiceCategoryProvider categoryProvider;
  final bool readOnly;

  @override
  State<AddEditServiceDialog> createState() => _AddEditServiceDialogState();
}

class _AddEditServiceDialogState extends State<AddEditServiceDialog> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _nameArbCtrl = TextEditingController();
  final _rateCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _descArbCtrl = TextEditingController();
  final _durationCtrl = TextEditingController();
  final _orderCtrl = TextEditingController();
  final _commissionValueCtrl = TextEditingController();
  final _branchCtrl = TextEditingController();

  String? _selectedCategoryId;
  CommissionType _commissionType = CommissionType.percentage;
  bool _allowAtCustomerLocation = false;
  bool _isSubmitting = false;

  bool get _isAdding => widget.service == null;

  @override
  void initState() {
    super.initState();
    final svc = widget.service;
    if (svc != null) {
      _nameCtrl.text = svc.serviceName;
      _nameArbCtrl.text = svc.serviceNameArb;
      _rateCtrl.text = svc.baseRate.toString();
      _descCtrl.text = svc.shortDescription;
      _descArbCtrl.text = svc.shortDescriptionArb;
      _durationCtrl.text = svc.duration.toString();
      _orderCtrl.text = svc.displayOrder.toString();
      _commissionValueCtrl.text = svc.commissionValue.toString();
      _selectedCategoryId = svc.categoryId;
      _commissionType = svc.commissionType;
      _allowAtCustomerLocation = svc.allowAtCustomerLocation;
      _branchCtrl.text = svc.branch;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _nameArbCtrl.dispose();
    _rateCtrl.dispose();
    _descCtrl.dispose();
    _descArbCtrl.dispose();
    _durationCtrl.dispose();
    _orderCtrl.dispose();
    _commissionValueCtrl.dispose();
    _branchCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    final model = ServiceModel(
      id: widget.service?.id ?? '',
      categoryId: _selectedCategoryId!,
      serviceName: _nameCtrl.text.trim(),
      serviceNameArb: _nameArbCtrl.text.trim(),
      baseRate: double.parse(_rateCtrl.text.trim()),
      shortDescription: _descCtrl.text.trim(),
      shortDescriptionArb: _descArbCtrl.text.trim(),
      duration: int.parse(_durationCtrl.text.trim()),
      displayOrder: int.tryParse(_orderCtrl.text.trim()) ?? 0,
      commissionType: _commissionType,
      commissionValue:
          double.tryParse(_commissionValueCtrl.text.trim()) ?? 0.0,
      allowAtCustomerLocation: _allowAtCustomerLocation,
      branch: _branchCtrl.text.trim(),
    );

    final success = _isAdding
        ? await widget.provider.addService(model)
        : await widget.provider.updateService(model);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isAdding
                ? 'Service added successfully.'
                : 'Service updated successfully.',
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
        ? 'View Service'
        : (_isAdding ? 'Add Service' : 'Edit Service');

    final categories = widget.categoryProvider.categories;

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
            // ── Category Dropdown ─────────────────────────────────────────
            DropdownButtonFormField<String>(
              key: ValueKey(_selectedCategoryId),
              initialValue: _selectedCategoryId,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Category *'),
              items: categories
                  .map(
                    (cat) => DropdownMenuItem<String>(
                      value: cat.id,
                      child: Text(cat.categoryName),
                    ),
                  )
                  .toList(),
              onChanged: widget.readOnly
                  ? null
                  : (val) => setState(() => _selectedCategoryId = val),
              validator: (_) => _selectedCategoryId == null
                  ? 'Category is required.'
                  : null,
            ),
            const SizedBox(height: AppSpacing.md),

            // ── Service Name ──────────────────────────────────────────────
            TextFormField(
              controller: _nameCtrl,
              readOnly: widget.readOnly,
              decoration:
                  const InputDecoration(labelText: 'Service Name *'),
              validator: (v) => v == null || v.trim().isEmpty
                  ? 'Service Name is required.'
                  : null,
            ),
            const SizedBox(height: AppSpacing.md),

            // ── Service Name (Arb) ────────────────────────────────────────
            TextFormField(
              controller: _nameArbCtrl,
              readOnly: widget.readOnly,
              textDirection: TextDirection.rtl,
              decoration:
                  const InputDecoration(labelText: 'Service Name (Arb)'),
            ),
            const SizedBox(height: AppSpacing.md),

            // ── Base Rate ─────────────────────────────────────────────────
            TextFormField(
              controller: _rateCtrl,
              readOnly: widget.readOnly,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d+\.?\d{0,2}'),
                ),
              ],
              decoration: const InputDecoration(
                labelText: 'Base Rate *',
                prefixText: 'SAR ',
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) {
                  return 'Base Rate is required.';
                }
                if (double.tryParse(v.trim()) == null) {
                  return 'Enter a valid number.';
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),

            // ── Short Description ─────────────────────────────────────────
            TextFormField(
              controller: _descCtrl,
              readOnly: widget.readOnly,
              maxLines: 2,
              decoration:
                  const InputDecoration(labelText: 'Short Description'),
            ),
            const SizedBox(height: AppSpacing.md),

            // ── Short Description AR ──────────────────────────────────────
            TextFormField(
              controller: _descArbCtrl,
              readOnly: widget.readOnly,
              maxLines: 2,
              textDirection: TextDirection.rtl,
              decoration: const InputDecoration(
                labelText: 'Short Description AR (Arb)',
              ),
            ),
            const SizedBox(height: AppSpacing.md),

            // ── Duration + Display Order (side-by-side) ───────────────────
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _durationCtrl,
                    readOnly: widget.readOnly,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Duration (min) *',
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Duration is required.';
                      }
                      if (int.tryParse(v.trim()) == null) {
                        return 'Enter whole minutes.';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: TextFormField(
                    controller: _orderCtrl,
                    readOnly: widget.readOnly,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Display Order',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),

            // ── Commission Type (Radio) ────────────────────────────────────
            _CommissionTypeSelector(
              value: _commissionType,
              readOnly: widget.readOnly,
              onChanged: (val) => setState(() => _commissionType = val),
            ),
            const SizedBox(height: AppSpacing.sm),

            // ── Commission Value ──────────────────────────────────────────
            TextFormField(
              controller: _commissionValueCtrl,
              readOnly: widget.readOnly,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d+\.?\d{0,2}'),
                ),
              ],
              decoration: InputDecoration(
                labelText: 'Commission Value',
                suffixText: _commissionType == CommissionType.percentage
                    ? '%'
                    : 'SAR',
              ),
            ),
            const SizedBox(height: AppSpacing.sm),

            // ── Allow at Customer Location (Checkbox) ─────────────────────
            CheckboxListTile(
              value: _allowAtCustomerLocation,
              onChanged: widget.readOnly
                  ? null
                  : (val) => setState(
                      () => _allowAtCustomerLocation = val ?? false),
              title: const Text(
                'Allow Service At Customer Location',
                style: TextStyle(fontSize: 13),
              ),
              activeColor: AppColors.primary,
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              dense: true,
            ),
            const SizedBox(height: AppSpacing.md),

            // ── Branch ────────────────────────────────────────────────────
            TextFormField(
              controller: _branchCtrl,
              readOnly: widget.readOnly,
              decoration: const InputDecoration(
                labelText: 'Branch',
                hintText: 'e.g. Main Branch',
                prefixIcon: Icon(Icons.store_outlined, size: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Commission Type Selector ──────────────────────────────────────────────────

class _CommissionTypeSelector extends StatelessWidget {
  const _CommissionTypeSelector({
    required this.value,
    required this.readOnly,
    required this.onChanged,
  });

  final CommissionType value;
  final bool readOnly;
  final ValueChanged<CommissionType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Commission Type',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        RadioGroup<CommissionType>(
          groupValue: value,
          onChanged: readOnly
              ? (_) {}
              : (val) => onChanged(val as CommissionType),
          child: Row(
            children: CommissionType.values.map((type) {
              return Expanded(
                child: RadioListTile<CommissionType>(
                  value: type,
                  title: Text(
                    type.label,
                    style: const TextStyle(fontSize: 13),
                  ),
                  activeColor: AppColors.primary,
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
