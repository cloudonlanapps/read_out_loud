part of '../page.dart';

class BottomMenu extends ConsumerWidget {
  const BottomMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LessonsList? lessonsList = ref.watch(lessonsListProvider);
    final bool isAnimating = ref.watch(isAnimatingProvider);
    if ((lessonsList?.numPages ?? 0) == 0) return Container();
    return CustomMenu(menuItems: [
      ((lessonsList?.isFirst ?? true) || isAnimating)
          ? null
          : CustomMenuItem(
              alignment: Alignment.bottomCenter,
              icon: Icons.arrow_circle_left,
              onTap: () async {
                await ref.read(lessonsListProvider.notifier).prev();
              },
              title: 'Prev'),
      CustomMenuItem(
          alignment: Alignment.bottomCenter,
          icon: Icons.density_medium,
          onTap: () {},
          title:
              "${(lessonsList?.currentPage ?? 0) + 1}/${lessonsList?.numPages}"),
      ((lessonsList?.isLast ?? true) || isAnimating)
          ? null
          : CustomMenuItem(
              alignment: Alignment.bottomCenter,
              icon: Icons.arrow_circle_right,
              onTap: () async {
                await ref.read(lessonsListProvider.notifier).next();
              },
              title: 'Next')
    ]);
  }
}
