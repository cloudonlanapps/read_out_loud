import 'package:flutter/material.dart';

class IntroWidget extends StatelessWidget {
  const IntroWidget({
    Key? key,
    required this.introText,
  }) : super(key: key);

  final String introText;

  @override
  Widget build(BuildContext context) {
    return Text(
      introText,
      textAlign: TextAlign.center,
      style: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.bold, fontSize: 40),
    );
  }
}
