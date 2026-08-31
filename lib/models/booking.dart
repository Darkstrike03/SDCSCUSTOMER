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
  final BookingStatus status;
  final DateTime createdAt;
  final DateTime? scheduledDateTime;
  final double priceEstimate;

  const Booking({
    required this.id,
    required this.serviceName,
    required this.workerId,
    required this.workerName,
    required this.workerPhotoUrl,
    required this.addressLabel,
    required this.addressDetail,
    required this.type,
    required this.status,
    required this.createdAt,
    this.scheduledDateTime,
    required this.priceEstimate,
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
