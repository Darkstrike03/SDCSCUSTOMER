import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_layout.dart';
import '../../../data/mock_data.dart';
import '../../../models/booking.dart';
import '../../../models/quote.dart';
import '../../../models/service_tier.dart';
import '../../../models/worker.dart';
import '../widgets/booking_status_stepper.dart';

class BookingTrackingScreen extends StatefulWidget {
  final String bookingId;

  const BookingTrackingScreen({super.key, required this.bookingId});

  @override
  State<BookingTrackingScreen> createState() => _BookingTrackingScreenState();
}

class _BookingTrackingScreenState extends State<BookingTrackingScreen> {
  bool _sessionActive = false;
  bool _showEndCode = false;
  String? _quoteDecision; // accepted | rejected

  @override
  Widget build(BuildContext context) {
    final booking = MockData.bookings.firstWhere((b) => b.id == widget.bookingId);
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
            if (booking.tier == ServiceTier.contract)
              _negotiationCard(context, booking),
            const SizedBox(height: 28),
            _sessionCodeSection(context, booking),
            const SizedBox(height: 28),
            _paymentCta(context, booking),
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
                      if (booking.tier == ServiceTier.contract) ...[
                        const SizedBox(height: 24),
                        _negotiationCard(context, booking),
                      ],
                      const SizedBox(height: 24),
                      _sessionCodeSection(context, booking),
                      const SizedBox(height: 24),
                      _paymentCta(context, booking),
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

  Widget _sessionCodeSection(BuildContext context, Booking booking) {
    if (booking.status == BookingStatus.completed) {
      return _neutralCard(
        context,
        icon: Icons.task_alt,
        title: 'Work session completed',
        subtitle: 'Final payment and receipt will be issued by the cooperative.',
      );
    }
    if (_showEndCode) {
      return _neutralCard(
        context,
        icon: Icons.check_circle,
        title: 'End code shared',
        subtitle: 'The worker has scanned the end code to close the session.',
      );
    }
    if (_sessionActive) {
      return _neutralCard(
        context,
        icon: Icons.qr_code_2,
        title: 'Session in progress',
        subtitle: 'Show the end code when the worker finishes the job.',
        action: FilledButton.icon(
          onPressed: () {
            setState(() => _showEndCode = true);
            _showQrCodeSheet(context, title: 'End work session', endCode: true);
          },
          style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
          icon: const Icon(Icons.qr_code, size: 18),
          label: const Text('Show end code'),
        ),
      );
    }
    return _neutralCard(
      context,
      icon: Icons.qr_code_2,
      title: 'Ready to start work session',
      subtitle:
          'When the worker arrives and starts on their device, show this code so they can begin the session.',
      action: FilledButton.icon(
        onPressed: () {
          setState(() => _sessionActive = true);
          _showQrCodeSheet(context, title: 'Start work session', endCode: false);
        },
        style: FilledButton.styleFrom(backgroundColor: AppColors.primary),
        icon: const Icon(Icons.qr_code, size: 18),
        label: const Text('Show start code'),
      ),
    );
  }

  Widget _paymentCta(BuildContext context, Booking booking) {
    final ready =
        _quoteDecision == 'accepted' || (_sessionActive && _showEndCode);
    if (!ready) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryDark, AppColors.primary],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Job complete — ready for payment',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppColors.textOnPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Confirm the final amount and pay securely via UPI.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textOnPrimary.withValues(alpha: 0.9),
            ),
          ),
          const SizedBox(height: 14),
          FilledButton.icon(
            onPressed: () => context.push('/bookings/${booking.id}/pay'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            icon: const Icon(Icons.payment),
            label: const Text(
              'Proceed to Payment',
              style: TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _neutralCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? action,
  }) {
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
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 26),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (action != null) ...[
            const SizedBox(height: 16),
            action,
          ],
        ],
      ),
    );
  }

  void _showQrCodeSheet(BuildContext context, {required String title, required bool endCode}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: _QrCodeSheet(title: title, endCode: endCode),
      ),
    );
  }

  Widget _negotiationCard(BuildContext context, Booking booking) {
    final quote = MockData.quotes.firstWhere(
      (q) => q.bookingId == booking.id,
      orElse: () => MockData.quotes.isNotEmpty
          ? MockData.quotes.first
          : Quote(
              status: 'pending',
              bookingId: booking.id,
              proposedAmount: 4500,
              proposedTimeline: '3 days (2 visits)',
              proposedAt: DateTime.now(),
            ),
    );

    final decided = _quoteDecision != null;

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
          Row(
            children: [
              const Icon(Icons.request_quote_outlined, color: AppColors.primary, size: 26),
              const SizedBox(width: 12),
              Text(
                'Price Proposal',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (quote.consultancyFee != null || quote.distanceFee != null) ...[
            _quoteLine(context, 'Consultancy / visit fee', quote.consultancyFee),
            _quoteLine(context, 'Distance fee', quote.distanceFee),
            const Divider(height: 20, color: AppColors.divider),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Proposed amount',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              Text(
                '₹${quote.proposedAmount.round()}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Timeline: ${quote.proposedTimeline}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 16),
          if (decided)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: _quoteDecision == 'accepted'
                    ? AppColors.success.withValues(alpha: 0.12)
                    : AppColors.error.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  _quoteDecision == 'accepted'
                      ? 'Proposal approved — amount confirmed'
                      : 'Proposal rejected — awaiting revised quote',
                  style: TextStyle(
                    color: _quoteDecision == 'accepted'
                        ? AppColors.success
                        : AppColors.error,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => setState(() => _quoteDecision = 'rejected'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.error,
                      side: const BorderSide(color: AppColors.error),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Reject', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () => setState(() => _quoteDecision = 'accepted'),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text('Accept', style: TextStyle(fontWeight: FontWeight.w700)),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _quoteLine(BuildContext context, String label, double? value) {
    if (value == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            '₹${value.round()}',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
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

/// Bottom sheet shown on the customer's device displaying the QR + OTP the
/// worker scans/enters to start (or end) a work session (§6).
class _QrCodeSheet extends StatelessWidget {
  final String title;
  final bool endCode;

  const _QrCodeSheet({required this.title, required this.endCode});

  @override
  Widget build(BuildContext context) {
    final otp = endCode ? '9-4-7-2-6-1' : '4-8-3-2-9-1';
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.divider,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Show this code to the worker so they can ${endCode ? 'close' : 'start'} the work session.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 20),
          _FakeQr(),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              otp,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w800,
                letterSpacing: 4,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'OTP · session ${endCode ? 'end' : 'start'} code',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Stylized non-scanning QR placeholder (real QR needs an encoder package).
class _FakeQr extends StatelessWidget {
  const _FakeQr();

  @override
  Widget build(BuildContext context) {
    final size = 180.0;
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider, width: 1),
        boxShadow: const [
          BoxShadow(color: AppColors.glassShadow, blurRadius: 16, offset: Offset(0, 4)),
        ],
      ),
      child: CustomPaint(
        painter: _QrPainter(
          dark: AppColors.textPrimary,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _QrPainter extends CustomPainter {
  final Color dark;
  const _QrPainter({required this.dark});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = dark;
    const cols = 25;
    final cell = size.width / cols;

    int seed(int i, int j) => (i * 31 + j * 17) % 19;
    for (var i = 0; i < cols; i++) {
      for (var j = 0; j < cols; j++) {
        final inFinder = _inFinder(i, j);
        final inTiming = _inTiming(i, j);
        if (inFinder || inTiming || (!_nearFinder(i, j) && seed(i, j) < 5)) {
          canvas.drawRect(
            Rect.fromLTWH(i * cell, j * cell, cell, cell),
            paint,
          );
        }
      }
    }
  }

  static const _cols = 25;

  bool _inFinder(int i, int j) {
    bool inside(int a, int b) => a < 7 && b < 7;
    return inside(i, j) ||
        inside(i, _cols - 1 - j) ||
        inside(_cols - 1 - i, j);
  }

  bool _nearFinder(int i, int j) {
    bool near(int a, int b) => a < 9 && b < 9;
    return near(i, j) ||
        near(i, _cols - 1 - j) ||
        near(_cols - 1 - i, j);
  }

  bool _inTiming(int i, int j) {
    final mid = _cols ~/ 2;
    return (i == mid && j > 7 && j < _cols - 8 && (j % 2 == 0)) ||
        (j == mid && i > 7 && i < _cols - 8 && (i % 2 == 0));
  }

  @override
  bool shouldRepaint(covariant _QrPainter oldDelegate) => oldDelegate.dark != dark;
}
