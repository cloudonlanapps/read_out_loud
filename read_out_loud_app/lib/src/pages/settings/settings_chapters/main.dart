import 'package:flutter/material.dart';
import 'package:manage_content/manage_content.dart';

import 'widgets/list_chapters.dart';

class MainContent extends StatelessWidget {
  final Repository repository;

  const MainContent({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    if (repository.isEmpty) {
      return const Center(
        child: Text(
          "Nothing to show here",
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Horizon',
          ),
        ),
      );
    }
    return ListChapters(repository: repository);
  }
}
