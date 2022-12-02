part of '../page.dart';

class LessonListView extends ConsumerWidget {
  final Size size;
  const LessonListView({super.key, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<String>? lessons = ref
        .watch(lessonsListProvider.select((value) => value?.getcurrentPage()));
    final sizeProperties = ref.watch(sizeProvider);

    return Column(
      children: [
        SizedBox(
            height: sizeProperties.titleHeight,
            child: const _LessonsListTitle()),
        if (lessons != null)
          Expanded(
            child: ListItems(
              key: ValueKey(lessons.toString()),
              items: lessons,
              tileHeight: sizeProperties.tileHeight,
            ),
          ),
      ],
    );
  }
}
