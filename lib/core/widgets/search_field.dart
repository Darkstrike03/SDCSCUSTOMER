import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SearchField extends StatelessWidget {
  final String hintText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final bool readOnly;

  const SearchField({
    super.key,
    this.hintText = 'Search a service or describe your problem',
    this.onTap,
    this.onChanged,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AbsorbPointer(
        absorbing: readOnly || onTap != null,
        child: TextField(
          onChanged: onChanged,
          readOnly: readOnly || onTap != null,
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: const Icon(Icons.search, color: AppColors.textHint),
            suffixIcon: readOnly ? null : const Icon(Icons.mic, color: AppColors.textHint),
          ),
        ),
      ),
    );
  }
}
