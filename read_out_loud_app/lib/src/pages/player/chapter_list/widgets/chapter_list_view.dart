import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manage_content/manage_content.dart';
import 'package:services/services.dart';

import '../../../../custom_widgets/chapter_view.dart';
import '../../chapter/page.dart';

import '../providers/state_provider.dart';

class ChapterListView extends ConsumerStatefulWidget {
  final List<Chapter> chapters;
  const ChapterListView({super.key, required this.chapters});
  @override
  ConsumerState<ChapterListView> createState() => ListItemsState();
}

class ListItemsState extends ConsumerState<ChapterListView> {
  late ListPaginate<Chapter> pageHandler;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Widget> items = [];
  final Tween<Offset> _offset =
      Tween(begin: const Offset(-1, 0), end: const Offset(0, 0));
  bool itemSelected = false;

  @override
  void initState() {
    Size tileSize = Size(ref.read(contentPageProvider).tileWidth,
        ref.read(contentPageProvider).tileHeight);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      addItems(tileSize);
    });
    super.initState();
  }

  @override
  void dispose() {
    items.clear();
    super.dispose();
  }

  void addItems(Size tileSize) async {
    items.clear();
    ref.read(isAnimatingProvider.notifier).isAnimating = true;

    for (var item in widget.chapters) {
      if (_listKey.currentState == null) {
        return;
      } else {
        await Future.delayed(const Duration(milliseconds: 100), () {
          items.add(_buildTile(item, tileSize));
          if (_listKey.currentState == null) {
            return;
          } else {
            _listKey.currentState!.insertItem(items.length - 1);
          }
        });
      }
    }
    ref.read(isAnimatingProvider.notifier).isAnimating = false;
  }

  Widget _buildTile(Chapter chapter, Size tileSize) {
    return ChapterView(
      chapter: chapter,
      onTap: () => onSelectItem(chapter),
    );
  }

  onSelectItem(Chapter chapter) {
    setState(() {
      itemSelected = true;
    });
    context.goNamed(ChapterPage().name,
        queryParams: {"filename": chapter.filename});
  }

  @override
  Widget build(BuildContext context) {
    if (itemSelected) {
      return const CircularProgressIndicator();
    }
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
