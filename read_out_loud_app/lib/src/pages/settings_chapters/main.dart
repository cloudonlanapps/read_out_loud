import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

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
          return ListView(
              padding: const EdgeInsets.only(left: 8, right: 8, top: 16),
              children: [
                ...repository.chapters
                    .map(
                      ((Chapter chapter) => Padding(
                            padding: const EdgeInsets.only(bottom: 16.0),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(8),
                              shape: RoundedRectangleBorder(
                                //<-- SEE HERE
                                side: const BorderSide(width: 2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              title: TitleText(chapter.title),
                              subtitle: const Padding(
                                padding: EdgeInsets.only(left: 8.0),
                              ),
                              tileColor: Colors.white,
                            ),
                          )),
                    )
                    .toList()
              ]);
        },
        error: (error, stackTrace) => Container(),
        loading: () => const CircularProgressIndicator());
  }
}

class TitleText extends StatelessWidget {
  final String text;
  const TitleText(
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold, fontSize: 40),
      textAlign: TextAlign.start,
    );
  }
}

class SubtitleText extends StatelessWidget {
  final String text;
  const SubtitleText(
    this.text, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(color: Colors.blueGrey, fontSize: 20),
      textAlign: TextAlign.start,
    );
  }
}
