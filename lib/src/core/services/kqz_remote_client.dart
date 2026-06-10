import 'package:http/http.dart' as http;

import '../models/election_source.dart';
import '../models/kqz_remote_status.dart';
import 'kqz_remote_config.dart';

class KqzRemoteClient {
  final http.Client _client;

  const KqzRemoteClient({
    required http.Client client,
  }) : _client = client;

  factory KqzRemoteClient.create() {
    return KqzRemoteClient(client: http.Client());
  }

  Future<KqzRemoteStatus> checkSource(ElectionSource source) async {
    final uri = KqzRemoteConfig.platformUriFor(source);
    final sourceName = KqzRemoteConfig.sourceNameFor(source);

    try {
      final response = await _client.get(uri).timeout(
        const Duration(seconds: 12),
      );

      final isReachable = response.statusCode >= 200 && response.statusCode < 400;

      return KqzRemoteStatus(
        isReachable: isReachable,
        statusCode: response.statusCode,
        sourceName: sourceName,
        url: uri.toString(),
        checkedAt: DateTime.now(),
      );
    } catch (error) {
      return KqzRemoteStatus(
        isReachable: false,
        statusCode: null,
        sourceName: sourceName,
        url: uri.toString(),
        checkedAt: DateTime.now(),
        errorMessage: error.toString(),
      );
    }
  }
}