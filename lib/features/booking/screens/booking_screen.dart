import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../data/mock_data.dart';
import '../../../models/service_tier.dart';
import '../../../models/worker.dart';

class BookingScreen extends StatefulWidget {
  final String workerId;

  const BookingScreen({super.key, required this.workerId});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _selectedAddress = 'Home';
  bool _isScheduled = false;
  ServiceTier _tier = ServiceTier.fixed;
  double _hours = 1;

  Worker get _worker =>
      MockData.workers.firstWhere((w) => w.id == widget.workerId);

  List<ServiceTier> get _availableTiers {
    final tiers = <ServiceTier>[ServiceTier.fixed];
    if (_worker.offersHourly) tiers.add(ServiceTier.hourly);
    if (_worker.offersContract) tiers.add(ServiceTier.contract);
    return tiers;
  }

  double get _tierTotal {
    switch (_tier) {
      case ServiceTier.fixed:
        return _worker.fixedTotal(_worker.distanceKm);
      case ServiceTier.hourly:
        return (_worker.hourlyRate ?? _worker.priceEstimate) * _hours;
      case ServiceTier.contract:
        return _worker.contractVisitFee ?? _worker.priceEstimate;
    }
  }

  String get _tierNote {
    switch (_tier) {
      case ServiceTier.fixed:
        final beyond = (_worker.distanceKm - 3).clamp(0.0, double.infinity);
        if (beyond > 0) {
          return 'Includes ₹${(beyond * 20).round()} distance charge for ${_worker.distanceKm} km';
        }
        return 'Price locked upfront. Distance within free radius included.';
      case ServiceTier.hourly:
        return 'Billed by time, paid by the session. Distance fee included.';
      case ServiceTier.contract:
        return 'Visit fee shown. Final amount confirmed by worker after assessment.';
    }
  }

  @override
  Widget build(BuildContext context) {
    final worker = _worker;

    return Scaffold(
      appBar: AppBar(title: const Text('Confirm Booking')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primarySurface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.person, color: AppColors.primary),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          worker.name,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '₹${_tierTotal.round()} estimated',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Choose a plan',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ..._availableTiers.map((tier) => _tierCard(context, tier)),
            if (_tier == ServiceTier.hourly) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estimated Duration',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Slider(
                            value: _hours,
                            min: 1,
                            max: 8,
                            divisions: 7,
                            label: '${_hours.round()} hr',
                            activeColor: AppColors.primary,
                            onChanged: (v) => setState(() => _hours = v),
                          ),
                        ),
                        Text(
                          '${_hours.round()} hr',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 24),
            Text(
              'Service Address',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            ...MockData.addresses.map((addr) {
              final isSelected = addr.label == _selectedAddress;
              return GestureDetector(
                onTap: () => setState(() {}),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primarySurface : AppColors.surface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.divider,
                      width: isSelected ? 1.5 : 0.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        addr.label == 'Home'
                            ? Icons.home_outlined
                            : addr.label == 'Work'
                                ? Icons.work_outline
                                : Icons.location_on_outlined,
                        color: isSelected ? AppColors.primary : AppColors.textSecondary,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              addr.label,
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              addr.detail,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle, color: AppColors.primary),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),
            Text(
              'Booking Time',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _timeChip(context, 'Now', !_isScheduled, () => setState(() => _isScheduled = false)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _timeChip(context, 'Schedule', _isScheduled, () => setState(() => _isScheduled = true)),
                ),
              ],
            ),
            if (_isScheduled) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Select date & time (coming soon)',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
            const SizedBox(height: 16),
            Text(
              _tierNote,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Estimated Total',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    '₹${_tierTotal.round()}',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              label: 'Confirm Booking',
              onPressed: () {
                context.push('/bookings/b1/track');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _timeChip(BuildContext context, String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppColors.primary : AppColors.divider),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: selected ? AppColors.textOnPrimary : AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _tierCard(BuildContext context, ServiceTier tier) {
    final selected = tier == _tier;
    return GestureDetector(
      onTap: () => setState(() => _tier = tier),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primarySurface : AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.divider,
            width: selected ? 1.5 : 0.5,
          ),
        ),
        child: Row(
          children: [
            Icon(
              switch (tier) {
                ServiceTier.fixed => Icons.price_check,
                ServiceTier.hourly => Icons.schedule,
                ServiceTier.contract => Icons.description_outlined,
              },
              color: selected ? AppColors.primary : AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        tier.label,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _tierPriceLabel(tier),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    tier.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }

  String _tierPriceLabel(ServiceTier tier) {
    switch (tier) {
      case ServiceTier.fixed:
        return '₹${_worker.priceEstimate.round()}';
      case ServiceTier.hourly:
        return '₹${(_worker.hourlyRate ?? _worker.priceEstimate).round()}/hr';
      case ServiceTier.contract:
        return '₹${(_worker.contractVisitFee ?? 0).round()} visit';
    }
  }
}
