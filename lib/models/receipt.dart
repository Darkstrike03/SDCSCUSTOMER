/// Final invoice/receipt for a completed and paid booking (§7, §9 `materials`).
class Receipt {
  final String id;
  final String bookingId;
  final String serviceName;
  final String workerName;
  final String paymentMethod;
  final double baseAmount;
  final double? distanceFee;
  final double? consultancyFee;
  final double? materialAmount;
  final double tax;
  final double tip;
  final double total;
  final DateTime paidAt;

  const Receipt({
    required this.id,
    required this.bookingId,
    required this.serviceName,
    required this.workerName,
    required this.paymentMethod,
    required this.baseAmount,
    this.distanceFee,
    this.consultancyFee,
    this.materialAmount,
    this.tax = 0,
    this.tip = 0,
    required this.total,
    required this.paidAt,
  });
}
