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
  final double priceEstimate;
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
    this.availableToday = true,
    this.about = '',
  });
}
