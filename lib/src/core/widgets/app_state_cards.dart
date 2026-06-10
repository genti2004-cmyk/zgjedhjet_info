import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class AppLoadingCard extends StatelessWidget {
  final String message;

  const AppLoadingCard({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            const SizedBox(
              height: 22,
              width: 22,
              child: CircularProgressIndicator(strokeWidth: 2.4),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                message,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppEmptyCard extends StatelessWidget {
  final String message;

  const AppEmptyCard({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}

class AppErrorCard extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const AppErrorCard({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppTheme.redAccent,
              size: 25,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Të dhënat nuk u ngarkuan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.textDark,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Provo përsëri'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}