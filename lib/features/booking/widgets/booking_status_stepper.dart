import 'package:flutter/material.dart';
import '../../../models/booking.dart';
import '../../../core/theme/app_colors.dart';

class BookingStatusStepper extends StatelessWidget {
  final BookingStatus currentStatus;

  const BookingStatusStepper({super.key, required this.currentStatus});

  @override
  Widget build(BuildContext context) {
    final steps = _stepsFor(context, currentStatus);

    return Column(
      children: List.generate(steps.length * 2 - 1, (index) {
        if (index.isOdd) {
          return Container(
            margin: const EdgeInsets.only(left: 11),
            width: 2,
            height: 24,
            color: index ~/ 2 < steps.length - 1 ? AppColors.primary : AppColors.divider,
          );
        }
        return steps[index ~/ 2];
      }),
    );
  }

  List<Widget> _stepsFor(BuildContext context, BookingStatus status) {
    const steps = [
      (BookingStatus.confirmed, 'Booking Confirmed', 'Today, 09:45 AM', Icons.check),
      (BookingStatus.workerEnRoute, 'Worker En Route', 'Marcus is on the way to your location.', Icons.directions_car),
      (BookingStatus.inProgress, 'Service In Progress', 'Pending', Icons.build),
      (BookingStatus.completed, 'Completed', 'Pending', Icons.task_alt),
    ];

    final isCancelled = status == BookingStatus.cancelled;
    final currentIndex = isCancelled
        ? -1
        : steps.indexWhere((s) => s.$1 == status);

    return List.generate(steps.length, (i) {
      final step = steps[i];
      final state = isCancelled
          ? _StepState.completed
          : i == currentIndex
              ? _StepState.active
              : i < currentIndex
                  ? _StepState.completed
                  : _StepState.pending;
      return _buildStepRow(
        context,
        icon: step.$4,
        title: step.$2,
        subtitle: step.$3,
        state: state,
        isCancelled: isCancelled,
      );
    });
  }

  Widget _buildStepRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required _StepState state,
    required bool isCancelled,
  }) {
    final isCompleted = state == _StepState.completed && !isCancelled;
    final isActive = state == _StepState.active;
    final isPending = state == _StepState.pending || (isCompleted && isCancelled);

    final Color nodeColor;
    final Color nodeForeground;
    if (isCompleted) {
      nodeColor = AppColors.primary;
      nodeForeground = AppColors.textOnPrimary;
    } else if (isActive) {
      nodeColor = AppColors.primary;
      nodeForeground = AppColors.textOnPrimary;
    } else {
      nodeColor = AppColors.surfaceVariant;
      nodeForeground = AppColors.textHint;
    }

    final labelColor = isActive
        ? AppColors.primary
        : isCompleted
            ? AppColors.textPrimary
            : AppColors.textSecondary;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: nodeColor,
            border: isActive
                ? Border.all(color: AppColors.primary, width: 2)
                : null,
            boxShadow: isActive || isCompleted
                ? const [
                    BoxShadow(
                      color: AppColors.glassShadow,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Icon(icon, size: 14, color: nodeForeground),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Opacity(
            opacity: isPending ? 0.5 : 1.0,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: labelColor,
                    ),
                  ),
                  if (subtitle.isNotEmpty)
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

enum _StepState { completed, active, pending }
