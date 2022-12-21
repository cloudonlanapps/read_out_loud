import 'package:flutter/material.dart';
import 'package:services/services.dart';

class TitleMenu extends StatelessWidget {
  const TitleMenu({
    required this.title,
    required this.action,
    required this.size,
    this.rightWidget,
    super.key,
  });
  final String title;
  final Size size;
  final Widget? rightWidget;
  final Function() action;

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size,
      child: Row(
        children: [
          IconButton(
            onPressed: action,
            icon: Icon(
              Icons.arrow_back,
              size: Theme.of(context).textTheme.displayMedium!.fontSize,
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyles.pageTitle(context),
              ),
            ),
          ),
          if (rightWidget != null) rightWidget!
        ],
      ),
    );
  }
}
