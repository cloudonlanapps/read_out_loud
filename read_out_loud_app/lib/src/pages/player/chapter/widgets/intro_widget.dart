import 'package:flutter/material.dart';
import 'package:services/services.dart';

class IntroWidget extends StatelessWidget {
  const IntroWidget({
    required this.introText,
    Key? key,
  }) : super(key: key);

  final String introText;

  @override
  Widget build(BuildContext context) {
    return Text(
      introText,
      textAlign: TextAlign.center,
      style: TextStyles.fullPageText(context),
    );
  }
}
