import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:services/services.dart';

class MainContent extends ConsumerWidget {
  const MainContent({
    required this.filename,
    required this.size,
    super.key,
  });
  final Size size;
  final String? filename;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Text(
        'This is a template',
        textAlign: TextAlign.center,
        style: TextStyles.fullPageText(context),
      ),
    );
  }
}
