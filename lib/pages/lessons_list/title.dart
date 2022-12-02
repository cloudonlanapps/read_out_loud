import 'package:flutter/material.dart';

class LessonsListTitle extends StatelessWidget {
  const LessonsListTitle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        "Select one to play",
        style: TextStyle(
          fontSize: 30.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Horizon',
        ),
      ),
    );
  }
}
