// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:read_out_loud/pages/lessons_list/provider.dart';
import 'package:read_out_loud/shared/providers/size_provider.dart';

import '../../shared/providers/animating.dart';
import 'title.dart';

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
            child: const LessonsListTitle()),
        if (lessons != null)
          Expanded(
            child: _ListItems(
              key: ValueKey(lessons.toString()),
              items: lessons,
              tileHeight: sizeProperties.tileHeight,
            ),
          ),
      ],
    );
  }
}

class _ListItems extends ConsumerStatefulWidget {
  final List<String> items;
  final double tileHeight;
  const _ListItems({super.key, required this.items, required this.tileHeight});

  @override
  ConsumerState<_ListItems> createState() => _ListItemsState();
}

class _ListItemsState extends ConsumerState<_ListItems> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Widget> items = [];
  final Tween<Offset> _offset =
      Tween(begin: const Offset(1, 0), end: const Offset(0, 0));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addItems();
    });
  }

  @override
  void dispose() {
    items.clear();
    super.dispose();
  }

  void addItems() async {
    ref.read(isAnimatingProvider.notifier).isAnimating = true;
    for (var item in widget.items) {
      await Future.delayed(const Duration(milliseconds: 200), () {
        items.add(_buildTile(item));
        _listKey.currentState!.insertItem(items.length - 1);
      });
    }
    ref.read(isAnimatingProvider.notifier).isAnimating = false;
  }

  Widget _buildTile(String lesson) {
    return Container(
      //decoration: BoxDecoration(border: Border.all()),
      height: widget.tileHeight,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.all(8.0),
      child: Text(lesson, style: const TextStyle()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AnimatedList(
              key: _listKey,
              initialItemCount: items.length,
              itemBuilder: (context, index, animation) {
                return SlideTransition(
                  position: animation.drive(_offset),
                  child: items[index],
                );
              }),
        ),
      ],
    );
  }
}
