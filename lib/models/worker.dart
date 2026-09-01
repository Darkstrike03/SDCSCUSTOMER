class Worker {
  final String id;
  final String name;
  final String photoUrl;
  final double rating;
  final int reviewCount;
  final double distanceKm;
  final bool isVerified;
  final String verificationNote;
  final int yearsActive;
  final int completedJobs;
  final List<String> skills;
  final String categoryId;

  /// Fixed-tier list price (₹), free-distance radius excluded beyond 3 km.
  final double priceEstimate;

  /// Hourly-tier rate (₹/hr). Distance fee is already included.
  final double? hourlyRate;

  /// Contract tier: base consultancy/visit fee (₹) before distance fee.
  final double? contractVisitFee;

  final bool availableToday;
  final String about;

  const Worker({
    required this.id,
    required this.name,
    required this.photoUrl,
    required this.rating,
    required this.reviewCount,
    required this.distanceKm,
    required this.isVerified,
    this.verificationNote = 'Verified cooperative worker',
    required this.yearsActive,
    required this.completedJobs,
    required this.skills,
    required this.categoryId,
    required this.priceEstimate,
    this.hourlyRate,
    this.contractVisitFee,
    this.availableToday = true,
    this.about = '',
  });

  bool get offersHourly => hourlyRate != null;
  bool get offersContract => contractVisitFee != null;

  /// Fixed-tier total including distance charge beyond the free radius.
  double fixedTotal(double distanceKm, {double freeRadius = 3.0, double perKm = 20.0}) {
    final beyond = (distanceKm - freeRadius).clamp(0.0, double.infinity);
    return priceEstimate + beyond * perKm;
  }
}
