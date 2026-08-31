import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_layout.dart';
import '../../../data/mock_data.dart';
import '../../../models/booking.dart';
import '../../../models/worker.dart';
import '../widgets/booking_status_stepper.dart';

class BookingTrackingScreen extends StatelessWidget {
  final String bookingId;

  const BookingTrackingScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final booking = MockData.bookings.firstWhere((b) => b.id == bookingId);
    final worker = _workerFor(booking);

    if (isLandscape(context)) {
      return _buildDesktop(context, booking, worker);
    }
    return _buildMobile(context, booking, worker);
  }

  Worker? _workerFor(Booking booking) {
    for (final w in MockData.workers) {
      if (w.id == booking.workerId) return w;
    }
    return null;
  }

  // ----------------------------- Mobile -----------------------------

  Widget _buildMobile(BuildContext context, Booking booking, Worker? worker) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Booking Status')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _workerCard(context, booking, worker, actionsBelow: true),
            const SizedBox(height: 28),
            Text(
              'Service Status',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            BookingStatusStepper(currentStatus: booking.status),
            const SizedBox(height: 28),
            _jobDetails(context, booking),
            const SizedBox(height: 20),
            _mapPlaceholder(context, showEta: false),
          ],
        ),
      ),
    );
  }

  // ----------------------------- Desktop -----------------------------

  Widget _buildDesktop(BuildContext context, Booking booking, Worker? worker) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Track Service',
          style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _desktopMap(context, booking),
                      const SizedBox(height: 24),
                      _desktopJobDetails(context, booking),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                SizedBox(
                  width: 360,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _desktopWorkerCard(context, worker ?? _emptyWorker(booking)),
                      const SizedBox(height: 24),
                      _desktopStatusCard(context, booking),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Worker _emptyWorker(Booking booking) {
    return MockData.workers.isNotEmpty
        ? MockData.workers.first
        : Worker(
            id: booking.workerId,
            name: booking.workerName,
            photoUrl: '',
            rating: 0,
            reviewCount: 0,
            distanceKm: 0,
            isVerified: false,
            yearsActive: 0,
            completedJobs: 0,
            skills: [booking.serviceName],
            categoryId: '',
            priceEstimate: 0,
          );
  }

  Widget _desktopMap(BuildContext context, Booking booking) {
    return Container(
      height: 480,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.8), width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.map_outlined, size: 56, color: AppColors.textHint),
                SizedBox(height: 12),
                Text(
                  'Live map coming soon',
                  style: TextStyle(color: AppColors.textHint, fontSize: 16),
                ),
              ],
            ),
          ),
          Positioned(
            top: 20,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.divider.withValues(alpha: 0.8), width: 1),
                boxShadow: const [
                  BoxShadow(color: AppColors.glassShadow, blurRadius: 20, offset: Offset(0, 6)),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                      color: AppColors.primarySurface,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.schedule, size: 22, color: AppColors.primary),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Estimated Arrival',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                      ),
                      Text(
                        _etaFor(booking.status),
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _desktopJobDetails(BuildContext context, Booking booking) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.8), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Job Details',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _desktopDetail(context, 'Service', booking.serviceName),
              const SizedBox(width: 24),
              _desktopDetail(context, 'Location', booking.addressDetail),
              const SizedBox(width: 24),
              _desktopDetail(context, 'Total', '₹${booking.priceEstimate.toInt()}'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _desktopDetail(BuildContext context, String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label.toUpperCase(),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _desktopWorkerCard(BuildContext context, Worker worker) {
    final hasPhoto = worker.photoUrl.isNotEmpty;
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.8), width: 1),
        boxShadow: const [
          BoxShadow(color: AppColors.glassShadow, blurRadius: 20, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: AppColors.primarySurface,
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: hasPhoto
                        ? Image.network(worker.photoUrl, fit: BoxFit.cover)
                        : const Icon(Icons.person, color: AppColors.primary, size: 42),
                  ),
                  if (worker.isVerified)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 26,
                        height: 26,
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: AppColors.verifiedGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.verified, size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      worker.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, size: 18, color: AppColors.warning),
                        const SizedBox(width: 4),
                        Text(
                          worker.rating.toStringAsFixed(1),
                          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${worker.completedJobs} jobs)',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      worker.skills.isNotEmpty ? worker.skills.first : 'Worker',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _actionButtons(context),
        ],
      ),
    );
  }

  Widget _desktopStatusCard(BuildContext context, Booking booking) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.8), width: 1),
        boxShadow: const [
          BoxShadow(color: AppColors.glassShadow, blurRadius: 20, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Service Status',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          BookingStatusStepper(currentStatus: booking.status),
        ],
      ),
    );
  }

  // ----------------------------- Shared -----------------------------

  Widget _workerCard(
    BuildContext context,
    Booking booking,
    Worker? worker, {
    required bool actionsBelow,
  }) {
    final hasPhoto = worker != null && worker.photoUrl.isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
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
          Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: const BoxDecoration(
                      color: AppColors.primarySurface,
                      shape: BoxShape.circle,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: hasPhoto
                        ? Image.network(worker.photoUrl, fit: BoxFit.cover)
                        : const Icon(Icons.person, color: AppColors.primary, size: 34),
                  ),
                  if (worker?.isVerified ?? false)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: const BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified,
                          size: 18,
                          color: AppColors.verifiedGreen,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      worker?.name ?? booking.workerName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (worker != null) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 16, color: AppColors.warning),
                          const SizedBox(width: 4),
                          Text(
                            worker.rating.toStringAsFixed(1),
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '(${worker.completedJobs} jobs)',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                    const SizedBox(height: 2),
                    Text(
                      worker != null && worker.skills.isNotEmpty
                          ? worker.skills.first
                          : booking.serviceName,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (actionsBelow) ...[
            const SizedBox(height: 16),
            _actionButtons(context),
          ],
        ],
      ),
    );
  }

  Widget _actionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.info,
              side: const BorderSide(color: AppColors.info),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.chat_bubble_outline),
            label: const Text(
              'Chat',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: FilledButton.icon(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.textOnPrimary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.call),
            label: const Text(
              'Call',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ],
    );
  }

  Widget _jobDetails(BuildContext context, Booking booking) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.8), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Job Details',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          _detailRow(context, 'Service', booking.serviceName),
          _detailRow(context, 'Location', booking.addressDetail),
          _detailRow(context, 'Total', '₹${booking.priceEstimate.toInt()}'),
        ],
      ),
    );
  }

  Widget _detailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapPlaceholder(BuildContext context, {required bool showEta}) {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.map_outlined, size: 40, color: AppColors.textHint),
            SizedBox(height: 8),
            Text('Live map coming soon', style: TextStyle(color: AppColors.textHint)),
          ],
        ),
      ),
    );
  }

  String _etaFor(BookingStatus status) {
    switch (status) {
      case BookingStatus.confirmed:
        return 'Scheduled';
      case BookingStatus.workerEnRoute:
        return '12 mins';
      case BookingStatus.inProgress:
        return 'Working';
      case BookingStatus.completed:
        return 'Done';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }
}
