import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

import '../../custom_widgets/progress_bar.dart';
import 'animate_state.dart';
import 'item_tile.dart';

class ListItems extends ConsumerStatefulWidget {
  final List<Chapter> items;
  final Size size;
  const ListItems({super.key, required this.items, required this.size});
  static double get tileHeight => 75;
  @override
  ConsumerState<ListItems> createState() => ListItemsState();
}

class ListItemsState extends ConsumerState<ListItems> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Widget> items = [];
  final Tween<Offset> _offset =
      Tween(begin: const Offset(-1, 0), end: const Offset(0, 0));

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
    items.clear();
    ref.read(isAnimatingProvider.notifier).isAnimating = true;
    for (var item in widget.items) {
      if (_listKey.currentState == null) {
        return;
      } else {
        await Future.delayed(const Duration(milliseconds: 100), () {
          items.add(_buildTile(item));
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

  double get pad => 4.0;
  double get widthMinusPad => widget.size.width - (2 * pad);
  double get heightMinusPad => widget.size.height - (2 * pad);
  Size get size => Size(widthMinusPad, heightMinusPad);
  Widget _buildTile(Chapter chapter) {
    var rng = Random();
    double percentageCompleted = rng.nextDouble();
    //percentageCompleted = .03;
    return Padding(
      padding: EdgeInsets.all(pad),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Stack(
          children: [
            ProgressBar(size: size, progress: percentageCompleted),
            ItemTile(
                text: chapter.title, size: size, progress: percentageCompleted),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final titleHeight = size.height - (items.length * ListItems.tileHeight);
    return Column(
      children: [
        SizedBox(
          height: titleHeight,
          width: size.width,
          child: const Center(
            child: Text(
              "Select one",
              style: TextStyle(
                fontSize: 40.0,
                fontWeight: FontWeight.bold,
                fontFamily: 'Horizon',
              ),
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
