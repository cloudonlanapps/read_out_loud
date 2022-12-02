// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LessonListView extends ConsumerWidget {
  const LessonListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container();
  }
}


/*

int currentIndex = 5;
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Widget> lessons = [];
  final Tween<Offset> _offset =
      Tween(begin: const Offset(1, 0), end: const Offset(0, 0));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _addTrips();
    });
  }

  void _addTrips() async {
    // get data from db
    List<String> trips = [
      "1 Short 'a' words",
      "2 Short 'e' words",
      "3 Short 'i' words",
      "4 Short 'i' naughty words",
      "5 Short 'a' words",
      "6 Short 'e' words",
      "7 Short 'i' words",
      "8 Short 'i' naughty words",
      "9 Short 'a' words",
      "10 Short 'e' words",
      "11 Short 'i' words",
      "12 Short 'i' naughty words",
      "13 Short 'a' words",
      "14 Short 'e' words",
      "15 Short 'i' words",
      "16 Short 'i' naughty words",
    ];

    for (var trip in trips.sublist(currentIndex, currentIndex + 5)) {
      await Future.delayed(const Duration(milliseconds: 200), () {
        lessons.add(_buildTile(trip));
        _listKey.currentState!.insertItem(lessons.length - 1);
      });
    }
  }

  Widget _buildTile(String lesson) {
    return ListTile(
      onTap: () {},
      contentPadding: const EdgeInsets.all(25),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(lesson, style: const TextStyle()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    lessons.add(Row(
      children: const [],
    ));

    return Column(
      children: [
        const Text("Play a lesson"),
        Expanded(
          child: AnimatedList(
              key: _listKey,
              initialItemCount: lessons.length,
              itemBuilder: (context, index, animation) {
                return SlideTransition(
                  position: animation.drive(_offset),
                  child: lessons[index],
                );
              }),
        ),
        TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.more),
            label: const Text("More"))
      ],
    );
  }
*/