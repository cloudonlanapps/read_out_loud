part of '../page.dart';

class ListItems extends ConsumerStatefulWidget {
  final List<String> items;
  final double tileHeight;
  const ListItems({super.key, required this.items, required this.tileHeight});

  @override
  ConsumerState<ListItems> createState() => ListItemsState();
}

class ListItemsState extends ConsumerState<ListItems> {
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
