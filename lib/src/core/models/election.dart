class Election {
  final String id;
  final String title;
  final String type;
  final String status;
  final DateTime date;
  final DateTime lastUpdated;

  const Election({
    required this.id,
    required this.title,
    required this.type,
    required this.status,
    required this.date,
    required this.lastUpdated,
  });
}