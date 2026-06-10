class PartyResult {
  final String id;
  final String name;
  final String shortName;
  final int votes;
  final double percentage;
  final int seats;

  const PartyResult({
    required this.id,
    required this.name,
    required this.shortName,
    required this.votes,
    required this.percentage,
    required this.seats,
  });
}