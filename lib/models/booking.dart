import 'service_tier.dart';

enum BookingType { immediate, scheduled, emergency }

enum BookingStatus { confirmed, workerEnRoute, inProgress, completed, cancelled }

class Booking {
  final String id;
  final String serviceName;
  final String workerId;
  final String workerName;
  final String workerPhotoUrl;
  final String addressLabel;
  final String addressDetail;
  final BookingType type;
  final ServiceTier tier;
  final BookingStatus status;

  /// True once the final payment has been made and job fully completed.
  final bool isPaid;
  final DateTime createdAt;
  final DateTime? scheduledDateTime;
  final double priceEstimate;

  /// For hourly tier: the agreed hourly rate at booking time.
  final double? hourlyRate;

  /// For contract tier: base consultancy/visit fee at booking time.
  final double? contractVisitFee;

  const Booking({
    required this.id,
    required this.serviceName,
    required this.workerId,
    required this.workerName,
    required this.workerPhotoUrl,
    required this.addressLabel,
    required this.addressDetail,
    required this.type,
    this.tier = ServiceTier.fixed,
    required this.status,
    this.isPaid = false,
    required this.createdAt,
    this.scheduledDateTime,
    required this.priceEstimate,
    this.hourlyRate,
    this.contractVisitFee,
  });

  String get statusLabel {
    switch (status) {
      case BookingStatus.confirmed:
        return 'Confirmed';
      case BookingStatus.workerEnRoute:
        return 'Worker en route';
      case BookingStatus.inProgress:
        return 'In progress';
      case BookingStatus.completed:
        return 'Completed';
      case BookingStatus.cancelled:
        return 'Cancelled';
    }
  }
}

/// One work session within a booking. Multiple sessions accumulate for
/// multi-visit contracts (§6.3). Mirrors the `work_sessions` DB table.
class WorkSession {
  final String id;
  final String bookingId;

  /// work = active, pause = break/away.
  final bool isPause;
  final DateTime startTime;
  final DateTime? endTime;

  const WorkSession({
    required this.id,
    required this.bookingId,
    required this.isPause,
    required this.startTime,
    this.endTime,
  });
}
