import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Generic circular icon button used for table row actions.
class ActionIconButton extends StatelessWidget {
  const ActionIconButton({
    super.key,
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
            border: Border.all(color: color.withValues(alpha: 0.35)),
          ),
          child: Icon(icon, color: color, size: 16),
        ),
      ),
    );
  }
}

/// Pre-configured green View action button.
class ViewActionButton extends StatelessWidget {
  const ViewActionButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ActionIconButton(
        icon: Icons.visibility_outlined,
        color: AppColors.viewAction,
        tooltip: 'View',
        onTap: onTap,
      );
}

/// Pre-configured orange Edit action button.
class EditActionButton extends StatelessWidget {
  const EditActionButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ActionIconButton(
        icon: Icons.edit_outlined,
        color: AppColors.editAction,
        tooltip: 'Edit',
        onTap: onTap,
      );
}

/// Pre-configured red Delete action button.
class DeleteActionButton extends StatelessWidget {
  const DeleteActionButton({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ActionIconButton(
        icon: Icons.delete_outline,
        color: AppColors.deleteAction,
        tooltip: 'Delete',
        onTap: onTap,
      );
}
