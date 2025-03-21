import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  final double? size;

  const LoadingIndicator({
    super.key,
    this.size = 32,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: const CircularProgressIndicator(),
      ),
    );
  }
}
