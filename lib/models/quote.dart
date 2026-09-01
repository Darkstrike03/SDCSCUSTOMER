/// Contract-tier negotiation record (§5.3, §9 `quotes`).
///
/// The worker proposes a price + timeline, the customer accepts or rejects.
/// A lightweight structured log even if the back-and-forth is informal chat.
class Quote {
  /// pending = awaiting customer decision; accepted / rejected = decided.
  final String status; // pending | accepted | rejected
  final String bookingId;
  final double proposedAmount;
  final String proposedTimeline;
  final double? consultancyFee;
  final double? distanceFee;
  final DateTime proposedAt;
  final DateTime? decidedAt;
  final String? customerNote;

  const Quote({
    required this.status,
    required this.bookingId,
    required this.proposedAmount,
    required this.proposedTimeline,
    this.consultancyFee,
    this.distanceFee,
    required this.proposedAt,
    this.decidedAt,
    this.customerNote,
  });

  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';
  bool get isRejected => status == 'rejected';
}
