import 'package:flutter/material.dart';
import 'package:services/services.dart';

class TitleMenu extends StatelessWidget {
  final String title;
  final Size size;
  final Function() onClose;

  const TitleMenu(
      {super.key,
      required this.title,
      required this.onClose,
      required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: size,
      child: Row(
        children: [
          IconButton(
              onPressed: onClose,
              icon: Icon(
                Icons.arrow_back,
                size: Theme.of(context).textTheme.displayMedium!.fontSize,
              )),
          Expanded(
            child: Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyles.pageTitle(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
