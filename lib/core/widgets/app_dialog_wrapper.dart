import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Reusable dialog shell with:
/// - Branded teal title bar with white text and ✕ close button.
/// - Scrollable content area.
/// - Footer: Close (outlined) + optional Submit (filled).
/// - [isSubmitting] replaces the submit label with a [CircularProgressIndicator].
/// - Set [showSubmit] to `false` for view-only dialogs (only Close is shown).
class AppDialogWrapper extends StatelessWidget {
  const AppDialogWrapper({
    super.key,
    required this.title,
    required this.content,
    required this.onClose,
    required this.onSubmit,
    this.isSubmitting = false,
    this.submitLabel = 'Submit',
    this.closeLabel = 'Close',
    this.showSubmit = true,
  });

  final String title;
  final Widget content;
  final VoidCallback onClose;
  final VoidCallback onSubmit;
  final bool isSubmitting;
  final String submitLabel;
  final String closeLabel;
  final bool showSubmit;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogWidth = screenWidth > AppSpacing.dialogMaxWidth + 48
        ? AppSpacing.dialogMaxWidth
        : screenWidth * 0.92;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.dialogRadius),
      ),
      clipBehavior: Clip.hardEdge,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: SizedBox(
        width: dialogWidth,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 620),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _TitleBar(title: title, onClose: onClose),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: content,
                ),
              ),
              _Footer(
                onClose: onClose,
                onSubmit: onSubmit,
                isSubmitting: isSubmitting,
                submitLabel: submitLabel,
                closeLabel: closeLabel,
                showSubmit: showSubmit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Teal title bar with close icon.
class _TitleBar extends StatelessWidget {
  const _TitleBar({required this.title, required this.onClose});

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primary,
      padding: const EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.sm,
        top: 10,
        bottom: 10,
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 20),
            onPressed: onClose,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
          ),
        ],
      ),
    );
  }
}

/// Footer with Close and optional Submit buttons.
class _Footer extends StatelessWidget {
  const _Footer({
    required this.onClose,
    required this.onSubmit,
    required this.isSubmitting,
    required this.submitLabel,
    required this.closeLabel,
    required this.showSubmit,
  });

  final VoidCallback onClose;
  final VoidCallback onSubmit;
  final bool isSubmitting;
  final String submitLabel;
  final String closeLabel;
  final bool showSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: isSubmitting ? null : onClose,
            child: Text(closeLabel),
          ),
          if (showSubmit) ...[
            const SizedBox(width: AppSpacing.sm),
            ElevatedButton(
              onPressed: isSubmitting ? null : onSubmit,
              child: isSubmitting
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(submitLabel),
            ),
          ],
        ],
      ),
    );
  }
}
