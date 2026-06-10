class KqzRemoteStatus {
  final bool isReachable;
  final int? statusCode;
  final String sourceName;
  final String url;
  final DateTime checkedAt;
  final String? errorMessage;

  const KqzRemoteStatus({
    required this.isReachable,
    required this.statusCode,
    required this.sourceName,
    required this.url,
    required this.checkedAt,
    this.errorMessage,
  });
}