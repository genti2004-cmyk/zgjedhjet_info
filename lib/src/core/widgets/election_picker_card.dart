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
      builder: (context, selectedElection, _) {
        return Card(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
            child: Row(
              children: [
                Container(
                  height: 42,
                  width: 42,
                  decoration: BoxDecoration(
                    color: AppTheme.softGreen,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.how_to_vote_rounded,
                    color: AppTheme.primaryGreen,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<ElectionSource>(
                    initialValue: selectedElection,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Zgjedhja',
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppTheme.primaryGreen,
                    ),
                    items: ElectionSource.all.map((source) {
                      return DropdownMenuItem<ElectionSource>(
                        value: source,
                        child: Text(
                          source.shortTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value == null) return;

                      SelectedElectionController.selectedElection.value = value;
                      onChanged?.call();
                    },
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
