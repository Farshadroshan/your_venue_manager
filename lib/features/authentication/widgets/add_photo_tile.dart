import 'package:flutter/material.dart';
import 'package:your_venue_manager/core/colors/app_colors.dart';
import 'package:your_venue_manager/features/authentication/widgets/dotted_border_box.dart';

class AddPhotoTile extends StatelessWidget {
  final VoidCallback onTap;

  const AddPhotoTile({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: DottedBorderBox(
        child: const Center(
          child: Icon(Icons.add, color: AppColors.textSecondary),
        ),
      ),
    );
  }
}