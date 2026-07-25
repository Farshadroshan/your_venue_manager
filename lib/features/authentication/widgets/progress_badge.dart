import 'package:flutter/material.dart';
import 'package:your_venue_manager/core/colors/app_colors.dart';

class ProgressBadge extends StatelessWidget {
  final double progress;

  const ProgressBadge({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '${(progress * 100).toInt()}% Complete',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.green,
        ),
      ),
    );
  }
}