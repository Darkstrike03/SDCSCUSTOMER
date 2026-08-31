import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/verified_badge.dart';
import '../../../core/widgets/rating_display.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../data/mock_data.dart';

class EmergencyMatchScreen extends StatelessWidget {
  const EmergencyMatchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final worker = MockData.workers.first;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Matched Worker'),
        foregroundColor: Colors.white,
        backgroundColor: AppColors.error,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.success),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Worker found! ${worker.name} is nearby and available.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider, width: 0.5),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: AppColors.primarySurface,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, size: 40, color: AppColors.primary),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        worker.name,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const VerifiedBadge(size: 18),
                    ],
                  ),
                  const SizedBox(height: 8),
                  RatingDisplay(rating: worker.rating, reviewCount: worker.reviewCount),
                  const SizedBox(height: 8),
                  Text(
                    '${worker.distanceKm} km away  •  ${worker.yearsActive} yrs experience',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: worker.skills.map((s) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(s, style: const TextStyle(fontSize: 12, color: AppColors.primary)),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const Spacer(),
            PrimaryButton(
              label: 'Confirm Booking',
              onPressed: () {
                context.go('/');
              },
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => context.pop(),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
