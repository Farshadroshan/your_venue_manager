import 'package:flutter/material.dart';
import 'package:your_venue_manager/core/colors/app_colors.dart';

class LabeledDropdown extends StatelessWidget {
  final String label;
  final IconData icon;
  final ValueNotifier<String?> notifier;
  final String hintText;
  final List<String> items;
 
  const LabeledDropdown({
    required this.label,
    required this.icon,
    required this.notifier,
    required this.hintText,
    required this.items,
  });
 
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: AppColors.gold),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ValueListenableBuilder<String?>(
            valueListenable: notifier,
            builder: (context, value, _) {
              return DropdownButtonFormField<String>(
                initialValue: value,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppColors.textSecondary),
                style: const TextStyle(fontSize: 14, color: AppColors.textPrimary),
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(10),
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                  ),
                  filled: true,
                  fillColor: AppColors.inputFill,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.cardBorder),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.cardBorder),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(color: AppColors.gold, width: 1.4),
                  ),
                ),
                items: items
                    .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        ))
                    .toList(),
                // No setState here — just push the new value into the
                // notifier. The ValueListenableBuilder above handles
                // rebuilding itself.
                onChanged: (value) => notifier.value = value,
              );
            },
          ),
        ],
      ),
    );
  }
}