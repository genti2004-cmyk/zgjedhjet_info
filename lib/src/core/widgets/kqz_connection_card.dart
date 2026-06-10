import 'package:flutter/material.dart';

import '../../features/results/data/election_repository.dart';
import '../models/kqz_remote_status.dart';
import '../theme/app_theme.dart';
import '../utils/app_formatters.dart';

class KqzConnectionCard extends StatefulWidget {
  const KqzConnectionCard({super.key});

  @override
  State<KqzConnectionCard> createState() => _KqzConnectionCardState();
}

class _KqzConnectionCardState extends State<KqzConnectionCard> {
  final ElectionRepository _repository = ElectionRepository.withRemote();

  late Future<KqzRemoteStatus> _statusFuture;

  @override
  void initState() {
    super.initState();
    _statusFuture = _repository.checkSelectedSource();
  }

  void _refresh() {
    setState(() {
      _statusFuture = _repository.checkSelectedSource();
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<KqzRemoteStatus>(
      future: _statusFuture,
      builder: (context, snapshot) {
        final status = snapshot.data;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _ConnectionShell(
            icon: Icons.sync_rounded,
            iconColor: AppTheme.primaryBlue,
            title: 'Duke kontrolluar lidhjen me KQZ...',
            description: 'Ju lutem prisni derisa burimi zyrtar të kontrollohet.',
            trailing: SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(strokeWidth: 2.4),
            ),
          );
        }

        if (status == null) {
          return _ConnectionShell(
            icon: Icons.error_outline_rounded,
            iconColor: AppTheme.redAccent,
            title: 'Statusi nuk u lexua',
            description: 'Nuk u arrit të kontrollohet burimi zyrtar.',
            trailing: IconButton(
              onPressed: _refresh,
              icon: const Icon(Icons.refresh_rounded),
            ),
          );
        }

        final checkedAt = AppFormatters.dateTime(status.checkedAt);

        if (status.isReachable) {
          return _ConnectionShell(
            icon: Icons.verified_rounded,
            iconColor: const Color(0xFF079455),
            title: 'Burimi zyrtar është i arritshëm',
            description:
            '${status.sourceName}\nHTTP ${status.statusCode} • Kontrolluar: $checkedAt',
            trailing: IconButton(
              onPressed: _refresh,
              icon: const Icon(Icons.refresh_rounded),
            ),
          );
        }

        return _ConnectionShell(
          icon: Icons.warning_amber_rounded,
          iconColor: const Color(0xFFB54708),
          title: 'Burimi zyrtar nuk u arrit',
          description:
          '${status.sourceName}\nAplikacioni vazhdon me të dhëna lokale/testuese.\nKontrolluar: $checkedAt',
          trailing: IconButton(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh_rounded),
          ),
        );
      },
    );
  }
}

class _ConnectionShell extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String description;
  final Widget trailing;

  const _ConnectionShell({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.description,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 46,
              width: 46,
              decoration: BoxDecoration(
                color: AppTheme.softBlue,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                icon,
                color: iconColor,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}