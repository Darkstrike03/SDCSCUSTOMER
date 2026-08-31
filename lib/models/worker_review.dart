class WorkerReview {
  final String workerId;
  final String name;
  final String initials;
  final int rating;
  final String timeAgo;
  final String comment;

  const WorkerReview({
    required this.workerId,
    required this.name,
    required this.initials,
    required this.rating,
    required this.timeAgo,
    required this.comment,
  });
}
