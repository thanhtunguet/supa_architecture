import 'package:flutter/material.dart';

class EmptyComponent extends StatelessWidget {
  static String _emptyStateImage =
      'packages/supa_architecture/assets/images/empty_state.png';

  static void setDefaultImage(String defaultImage) {
    _emptyStateImage = defaultImage;
  }

  final String title;

  final String? subtitle;

  final String? imageUrl;

  const EmptyComponent({
    super.key,
    this.title = 'Chưa có dữ liệu',
    this.subtitle = 'Keep up the good work!',
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image(
            image: AssetImage(
              imageUrl ?? _emptyStateImage,
            ),
          ),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
          const SizedBox(height: 8),
          if (subtitle != null)
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.secondary,
              ),
            ),
        ],
      ),
    );
  }
}
