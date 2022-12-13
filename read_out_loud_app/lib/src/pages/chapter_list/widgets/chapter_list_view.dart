import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manage_content/manage_content.dart';
import 'package:read_out_loud_app/services/paginate.dart';

import '../../chapter/page.dart';

import '../providers/state_provider.dart';
import 'chapter_view.dart';

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
      size: tileSize,
      onSelectItem: () => onSelectItem(chapter),
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
        SizedBoxDecorated(
          //debug: true,
          width: ref.read(contentPageProvider).titleWidth,
          height: ref.read(contentPageProvider).titleHeight,
          child: Align(
            alignment: Alignment.topCenter,
            child: Text(
              "Select one",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        ),
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

const bool debug = true;

class SizedBoxDecorated extends StatelessWidget {
  final double width;
  final double height;
  final Widget? child;
  final bool debug;
  const SizedBoxDecorated(
      {super.key,
      required this.width,
      required this.height,
      this.child,
      this.debug = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: debug
          ? DecoratedBox(
              decoration: BoxDecoration(border: Border.all()),
              child: Stack(
                children: [
                  if (child != null) child!,
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Text("${width}x$height"),
                  ),
                ],
              ),
            )
          : child,
    );
  }
}
