part of '../page.dart';

class ListItems extends ConsumerStatefulWidget {
  final List<String> items;
  final Size size;
  const ListItems({super.key, required this.items, required this.size});

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
    ref.read(isAnimatingProvider.notifier).isAnimating = true;
    for (var item in widget.items) {
      await Future.delayed(const Duration(milliseconds: 100), () {
        items.add(_buildTile(item));
        _listKey.currentState!.insertItem(items.length - 1);
      });
    }
    ref.read(isAnimatingProvider.notifier).isAnimating = false;
  }

  Widget _buildTile(String lesson) {
    var rng = Random();
    double percentageCompleted = rng.nextDouble();
    //percentageCompleted = .03;
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ClipRect(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.red,
              border: Border.all(color: Colors.amberAccent),
              borderRadius: BorderRadius.circular(50)),
          alignment: Alignment.center,
          // padding: const EdgeInsets.symmetric(horizontal: 8),
          width: widget.size.width - 8,
          height: widget.size.height - 8,

          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        /* borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(50.0),
                            bottomLeft: Radius.circular(50.0)), */
                        color: Colors.green.shade300,
                      ),
                      child: SizedBox(
                        width:
                            (widget.size.width - 8 - 2) * percentageCompleted,
                        height: widget.size.height - 8 - 2,
                      ),
                    ),
                    Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(50.0),
                            bottomRight: Radius.circular(50.0)),
                        color: Colors.white,
                      ),
                      child: SizedBox(
                        width: (widget.size.width - 8 - 2) *
                            (1 - percentageCompleted),
                        height: widget.size.height - 8 - 2,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(50.0),
                          bottomLeft: Radius.circular(50.0)),
                      // color: Colors.blue.shade100,
                    ),
                    width: 50,
                    height: widget.size.height - 8 - 2,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Transform.rotate(
                              angle: -pi / 6.0,
                              child: FittedBox(
                                  fit: BoxFit.fitWidth,
                                  child: Text(
                                    (percentageCompleted < 0.05)
                                        ? "new"
                                        : "${(percentageCompleted * 100).toInt()}%",
                                    style:
                                        TextStyle(color: Colors.blue.shade800),
                                  ))),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    //  color: Colors.blue.shade100,
                    width: (widget.size.width - 8) - 100 - 2,
                    height: widget.size.height - 8 - 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 2.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 60,
                            child: FittedBox(
                              fit: BoxFit.fitWidth,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(lesson,
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(fontSize: 30)),
                              ),
                            ),
                          ),
                          // const Expanded(flex: 40, child: Text("Not attempted yet"))
                        ],
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(50.0),
                          bottomRight: Radius.circular(50.0)),
                      //  color: Colors.blue.shade100,
                    ),
                    width: 50,
                    height: widget.size.height - 8 - 2,
                    child: Icon(Icons.settings_backup_restore_outlined),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
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
/*

const Icon(
              Icons.arrow_forward_ios,
              color: Colors.amberAccent,
            )

const CircleAvatar(
                radius: 18,
                child: Padding(
                  padding: EdgeInsets.all(3.0),
                  child: FittedBox(fit: BoxFit.fitWidth, child: Text("NEW")),
                )),
                 */