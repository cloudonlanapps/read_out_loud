import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:services/services.dart';

class MainContent extends ConsumerWidget {
  final Size size;
  final String? filename;
  const MainContent({super.key, required this.filename, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Text(
        "This is a template",
        textAlign: TextAlign.center,
        style: TextStyles.fullPageText(context),
      ),
    );
  }
}
