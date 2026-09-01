import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/mock_data.dart';
import '../../../models/receipt.dart';

class ReceiptScreen extends StatelessWidget {
  final String bookingId;

  const ReceiptScreen({super.key, required this.bookingId});

  @override
  Widget build(BuildContext context) {
    final receipt = _receiptFor(context, bookingId);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Receipt'),
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.check_circle, color: AppColors.success, size: 64),
                const SizedBox(height: 12),
                Text(
                  'Payment Successful',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Your service has been completed and paid.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 28),
                _receiptCard(context, receipt),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textOnPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text(
                    'Back to Bookings',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Receipt _receiptFor(BuildContext context, String bookingId) {
    for (final r in MockData.receipts) {
      if (r.bookingId == bookingId) return r;
    }
    return MockData.receipts.isNotEmpty
        ? MockData.receipts.first
        : Receipt(
            id: 'r-fallback', bookingId: bookingId, serviceName: 'Service',
            workerName: 'Worker', paymentMethod: 'UPI', baseAmount: 0,
            tax: 0, total: 0, paidAt: DateTime.now(),
          );
  }

  Widget _receiptCard(BuildContext context, Receipt receipt) {
    final rows = <(String, String)>[
      ('Service', receipt.serviceName),
      ('Worker', receipt.workerName),
      ('Base amount', '₹${receipt.baseAmount.round()}'),
      if (receipt.distanceFee != null) ('Distance fee', '₹${receipt.distanceFee!.round()}'),
      if (receipt.consultancyFee != null) ('Consultancy', '₹${receipt.consultancyFee!.round()}'),
      if (receipt.materialAmount != null) ('Materials', '₹${receipt.materialAmount!.round()}'),
      if (receipt.tax > 0) ('Tax', '₹${receipt.tax.round()}'),
      if (receipt.tip > 0) ('Tip', '₹${receipt.tip.round()}'),
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.divider.withValues(alpha: 0.8), width: 1),
        boxShadow: const [
          BoxShadow(color: AppColors.glassShadow, blurRadius: 24, offset: Offset(0, 8)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Receipt · ${receipt.id.toUpperCase()}',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              Icon(Icons.receipt_long, color: AppColors.primary),
            ],
          ),
          const Divider(height: 28, color: AppColors.divider),
          ...rows.map(
            (r) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    r.$1,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    r.$2,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 28, color: AppColors.divider),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Paid',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              Text(
                '₹${receipt.total.round()}',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'Paid via ${receipt.paymentMethod} · ${_date(receipt.paidAt)}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  String _date(DateTime d) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }
}
