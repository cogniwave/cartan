import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter/material.dart';

class SearchResults {

  static Widget buildNoResultsFound({
    required String message,
    required ThemeData theme,
    IconData icon = AntIcons.warningOutlined,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 64,
              color: theme.colorScheme.primary.withValues(alpha: 0.5),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: theme.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}