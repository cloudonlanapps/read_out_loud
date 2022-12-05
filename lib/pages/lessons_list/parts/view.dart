part of '../page.dart';

class LessonListView extends ConsumerWidget {
  final Size size;
  const LessonListView({super.key, required this.size});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<Chapter>? lessons = ref
        .watch(lessonsListProvider.select((value) => value?.getcurrentPage()));
    final sizeProperties = ref.watch(sizeProvider);

    if (lessons != null && lessons.isEmpty) {
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
    return Column(
      children: [
        SizedBox(
            height: sizeProperties.titleHeight,
            child: const _LessonsListTitle()),
        Expanded(
          child: ListItems(
            key: ValueKey(lessons.toString()),
            items: lessons!,
            size: Size(sizeProperties.size!.width, sizeProperties.tileHeight),
          ),
        )
      ],
    );
  }
}
