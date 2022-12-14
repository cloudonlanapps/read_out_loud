import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

import 'widgets/list_chapters.dart';

class MainContent extends ConsumerWidget {
  final Size size;
  final String filename;
  const MainContent({super.key, required this.filename, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    AsyncValue<Repository> asyncValue = ref.watch(repositoryProvider(filename));
    return asyncValue.when(
        data: (Repository repository) {
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
        },
        error: (error, stackTrace) => Container(),
        loading: () => const CircularProgressIndicator());
  }
}
