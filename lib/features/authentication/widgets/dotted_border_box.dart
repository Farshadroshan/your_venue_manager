import 'package:flutter/material.dart';
import 'package:your_venue_manager/core/colors/app_colors.dart';
import 'package:your_venue_manager/features/authentication/widgets/dashed_border_painter.dart';

class DottedBorderBox extends StatelessWidget {
  final Widget child;

  const DottedBorderBox({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DashedBorderPainter(),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.inputFill,
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      ),
    );
  }
}