import 'package:flutter/material.dart';
import 'package:your_venue_manager/core/colors/app_colors.dart';

class DocumentUploadRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? badgeText;
  final Color? badgeColor;
  final double? progress;
  final Widget trailing;

  const DocumentUploadRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.badgeText,
    this.badgeColor,
    this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AppColors.inputFill,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.cardBorder),
          ),
          child: Icon(icon, size: 18, color: AppColors.navy),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  if (badgeText != null) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: (badgeColor ?? AppColors.gold).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        badgeText!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: badgeColor ?? AppColors.gold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              if (progress != null) ...[
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: AppColors.cardBorder,
                    valueColor: const AlwaysStoppedAnimation(AppColors.green),
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 8),
        trailing,
      ],
    );
  }
}