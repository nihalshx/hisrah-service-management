import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Shows a confirmation dialog before a destructive delete action.
///
/// Returns `true` if the user confirmed, `false` if cancelled.
Future<bool> showConfirmDeleteDialog(
  BuildContext context, {
  required String itemName,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _ConfirmDeleteDialog(itemName: itemName),
  );
  return result ?? false;
}

class _ConfirmDeleteDialog extends StatelessWidget {
  const _ConfirmDeleteDialog({required this.itemName});

  final String itemName;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.dialogRadius),
      ),
      title: const Row(
        children: [
          Icon(Icons.warning_amber_rounded, color: AppColors.deleteAction),
          SizedBox(width: AppSpacing.sm),
          Text('Confirm Delete'),
        ],
      ),
      content: RichText(
        text: TextSpan(
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            height: 1.5,
          ),
          children: [
            const TextSpan(text: 'Are you sure you want to delete '),
            TextSpan(
              text: '"$itemName"',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const TextSpan(text: '? This action cannot be undone.'),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.deleteAction,
          ),
          child: const Text('Delete'),
        ),
      ],
    );
  }
}
