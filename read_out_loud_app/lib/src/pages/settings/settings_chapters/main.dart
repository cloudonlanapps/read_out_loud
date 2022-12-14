import 'package:flutter/material.dart';
import 'package:manage_content/manage_content.dart';
import 'package:services/services.dart';

import 'widgets/list_chapters.dart';

class MainContent extends StatelessWidget {
  final Repository repository;

  const MainContent({super.key, required this.repository});

  @override
  Widget build(BuildContext context) {
    if (repository.isEmpty) {
      return Center(
        child: Text(
          "Nothing to show here",
          style: TextStyles.fullPageText(context),
        ),
      );
    }
    return ListChapters(repository: repository);
  }
}
