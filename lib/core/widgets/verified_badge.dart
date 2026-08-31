import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class VerifiedBadge extends StatelessWidget {
  final bool showLabel;
  final double size;

  const VerifiedBadge({super.key, this.showLabel = false, this.size = 18});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.verified, color: AppColors.verifiedGreen, size: size),
        if (showLabel) ...[
          const SizedBox(width: 4),
          Text(
            'Verified',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.verifiedGreen,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}
