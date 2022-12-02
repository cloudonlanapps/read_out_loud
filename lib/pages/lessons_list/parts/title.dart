part of '../page.dart';

class _LessonsListTitle extends StatelessWidget {
  const _LessonsListTitle({
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
