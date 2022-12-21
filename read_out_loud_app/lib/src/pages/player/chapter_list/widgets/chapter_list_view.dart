import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manage_content/manage_content.dart';
import 'package:services/services.dart';

import '../../../../custom_widgets/chapter_view.dart';
import '../../chapter/page.dart';

import '../providers/state_provider.dart';

class ChapterListView extends ConsumerStatefulWidget {
  const ChapterListView({
    required this.chapters,
    super.key,
  });
  final List<Chapter> chapters;
  @override
  ConsumerState<ChapterListView> createState() => ListItemsState();
}

class ListItemsState extends ConsumerState<ChapterListView> {
  late ListPaginate<Chapter> pageHandler;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Widget> items = [];
  final Tween<Offset> _offset =
      Tween(begin: const Offset(-1, 0), end: Offset.zero);
  bool itemSelected = false;

  @override
  void initState() {
    final tileSize = Size(
      ref.read(contentPageProvider).tileWidth,
      ref.read(contentPageProvider).tileHeight,
    );
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

  Future<void> addItems(Size tileSize) async {
    items.clear();
    ref.read(isAnimatingProvider.notifier).isAnimating = true;

    for (final item in widget.chapters) {
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
      size: tileSize,
      onTap: () => onSelectItem(chapter),
    );
  }

  void onSelectItem(Chapter chapter) {
    setState(() {
      itemSelected = true;
    });
    context.goNamed(
      ChapterPage().name,
      queryParams: {'filename': chapter.filename},
    );
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
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            key: _listKey,
            initialItemCount: items.length,
            itemBuilder: (context, index, animation) {
              return SlideTransition(
                position: animation.drive(_offset),
                child: items[index],
              );
            },
          ),
        ),
      ],
    );
  }
}
