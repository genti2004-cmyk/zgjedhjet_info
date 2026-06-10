import 'package:flutter/material.dart';

import '../models/election_source.dart';
import '../services/selected_election_controller.dart';
import '../theme/app_theme.dart';

class ElectionPickerCard extends StatelessWidget {
  final VoidCallback? onChanged;

  const ElectionPickerCard({
    super.key,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ElectionSource>(
      valueListenable: SelectedElectionController.selectedElection,
      builder: (context, selected, _) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Zgjedhja aktive',
                  style: TextStyle(
                    color: AppTheme.textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<ElectionSourceType>(
                  value: selected.type,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppTheme.softBlue,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppTheme.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppTheme.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(
                        color: AppTheme.primaryBlue,
                        width: 1.4,
                      ),
                    ),
                  ),
                  items: ElectionSource.all.map((source) {
                    return DropdownMenuItem<ElectionSourceType>(
                      value: source.type,
                      child: Text(
                        source.shortTitle,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value == null) return;

                    final source = ElectionSource.all.firstWhere(
                          (item) => item.type == value,
                    );

                    SelectedElectionController.select(source);
                    onChanged?.call();
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  selected.description,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}