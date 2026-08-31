import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/rating_display.dart';
import '../../../data/mock_data.dart';
import '../../../models/booking.dart';
import '../../../models/worker.dart';

class BookAgainSection extends StatelessWidget {
  const BookAgainSection({super.key});

  @override
  Widget build(BuildContext context) {
    final recentBookings = MockData.bookings
        .where((b) => b.workerId.isNotEmpty)
        .take(3)
        .toList();

    return SizedBox(
      height: 236,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: recentBookings.length,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final booking = recentBookings[index];
          final worker = _workerFor(booking);
          return _BookAgainCard(booking: booking, worker: worker);
        },
      ),
    );
  }

  Worker? _workerFor(Booking booking) {
    for (final w in MockData.workers) {
      if (w.id == booking.workerId) return w;
    }
    return null;
  }
}

class _BookAgainCard extends StatelessWidget {
  final Booking booking;
  final Worker? worker;

  const _BookAgainCard({required this.booking, required this.worker});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.8), width: 1),
        boxShadow: const [
          BoxShadow(
            color: AppColors.glassShadow,
            blurRadius: 20,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _header(context),
          const Spacer(),
          _footer(context),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    final worker = this.worker;
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _avatar(context),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        worker?.name ?? booking.workerName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 3),
                      if (worker != null)
                        RatingDisplay(
                          rating: worker.rating,
                          reviewCount: worker.reviewCount,
                          iconSize: 14,
                        ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              worker != null && worker.skills.isNotEmpty
                  ? worker.skills.first
                  : booking.serviceName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Last booked: ${_formatDate(booking.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textHint,
              ),
            ),
          ],
        ),
        if ((worker?.isVerified ?? true) && (worker != null))
          Positioned(
            top: -2,
            right: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.verifiedGreen.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified, size: 12, color: AppColors.verifiedGreen),
                  SizedBox(width: 3),
                  Text(
                    'VERIFIED',
                    style: TextStyle(
                      color: AppColors.verifiedGreen,
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _avatar(BuildContext context) {
    final worker = this.worker;
    final hasPhoto = worker != null && worker.photoUrl.isNotEmpty;
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      child: hasPhoto
          ? Image.network(worker.photoUrl, fit: BoxFit.cover)
          : Icon(
              Icons.person,
              color: AppColors.primary,
              size: 28,
            ),
    );
  }

  Widget _footer(BuildContext context) {
    final worker = this.worker;
    return SizedBox(
      height: 42,
      child: FilledButton.icon(
        onPressed: () {
          if (worker != null) {
            context.push('/workers/${worker.id}/book');
          }
        },
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textOnPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        icon: const Icon(Icons.replay, size: 18),
        label: const Text(
          'Book Again',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}, ${d.year}';
  }
}
