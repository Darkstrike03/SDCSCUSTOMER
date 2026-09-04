import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/floating_bottom_nav.dart';
import '../../../core/widgets/rating_display.dart';
import '../../../core/widgets/app_layout.dart';
import '../../../core/widgets/shell_scaffold.dart';
import '../../../data/mock_data.dart';
import '../../../models/booking.dart';
import '../../../models/worker.dart';

class BookingsScreen extends StatelessWidget {
  const BookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookings = MockData.bookings;

    return ShellScaffold(
      appBar: LandscapeShellScope.of(context) ? null : AppBar(title: const Text('My Bookings')),
      body: bookings.isEmpty
          ? const Center(
              child: Text('No bookings yet.'),
            )
          : ListView.separated(
              padding: EdgeInsets.fromLTRB(
                16,
                16,
                16,
                16 + kFloatingNavHeight + kFloatingNavGap,
              ),
              itemCount: bookings.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final booking = bookings[index];
                final worker = _workerFor(booking);
                return _BookingCard(
                  key: ValueKey('booking-${booking.id}'),
                  booking: booking,
                  worker: worker,
                );
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

class _BookingCard extends StatelessWidget {
  final Booking booking;
  final Worker? worker;

  const _BookingCard({super.key, required this.booking, required this.worker});

  @override
  Widget build(BuildContext context) {
    final paid = booking.status == BookingStatus.completed && booking.isPaid;
    return GestureDetector(
      onTap: () => context.push(
        paid
            ? '/bookings/${booking.id}/receipt'
            : '/bookings/${booking.id}/track',
      ),
      child: Container(
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 12),
            _buildDetails(context),
            const SizedBox(height: 10),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final worker = this.worker;
    return Row(
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
              if (worker != null) ...[
                const SizedBox(height: 3),
                RatingDisplay(
                  rating: worker.rating,
                  reviewCount: worker.reviewCount,
                  iconSize: 14,
                ),
              ],
            ],
          ),
        ),
        const SizedBox(width: 8),
        _statusPill(context),
      ],
    );
  }

  Widget _avatar(BuildContext context) {
    final worker = this.worker;
    final hasPhoto = worker != null && worker.photoUrl.isNotEmpty;
    return Container(
      width: 52,
      height: 52,
      decoration: const BoxDecoration(
        color: AppColors.primarySurface,
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      child: hasPhoto
          ? Image.network(worker.photoUrl, fit: BoxFit.cover)
          : const Icon(Icons.person, color: AppColors.primary, size: 28),
    );
  }

  Widget _statusPill(BuildContext context) {
    final status = _friendlyStatus(booking.status);
    final color = _statusColor(booking.status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: color,
          fontWeight: FontWeight.w700,
          fontSize: 11,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    final worker = this.worker;
    final skill = worker != null && worker.skills.isNotEmpty
        ? worker.skills.first
        : booking.serviceName;

    return Row(
      children: [
        Icon(Icons.build_outlined, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            skill,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      children: [
        Text(
          '₹${booking.priceEstimate.toInt()}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          width: 1,
          height: 14,
          color: AppColors.divider,
        ),
        const SizedBox(width: 8),
        Icon(Icons.location_on_outlined, size: 14, color: AppColors.textHint),
        const SizedBox(width: 3),
        Expanded(
          child: Text(
            booking.addressLabel,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          _formatDate(booking.createdAt),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textHint,
          ),
        ),
      ],
    );
  }

  String _friendlyStatus(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return 'Scheduled';
      case BookingStatus.workerEnRoute:
        return 'En Route';
      case BookingStatus.inProgress:
        return 'Working';
      case BookingStatus.completed:
        return 'Done';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }

  Color _statusColor(BookingStatus status) {
    switch (status) {
      case BookingStatus.completed:
        return AppColors.success;
      case BookingStatus.cancelled:
        return AppColors.error;
      case BookingStatus.confirmed:
        return AppColors.info;
      case BookingStatus.workerEnRoute:
        return AppColors.warning;
      case BookingStatus.inProgress:
        return AppColors.primary;
    }
  }

  String _formatDate(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${months[d.month - 1]} ${d.day}';
  }
}
