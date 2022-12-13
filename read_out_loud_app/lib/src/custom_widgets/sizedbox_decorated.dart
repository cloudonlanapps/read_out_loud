import 'package:flutter/material.dart';

const bool _gDebug = false;

class SizedBoxDecorated extends StatelessWidget {
  final double? width;
  final double? height;
  final Widget? child;
  final bool debug;

  SizedBoxDecorated.fromSize(
      {super.key, required Size size, this.child, this.debug = false})
      : width = size.width,
        height = size.height;

  const SizedBoxDecorated(
      {super.key, this.width, this.height, this.child, this.debug = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: debug || _gDebug
          ? DecoratedBox(
              decoration: BoxDecoration(border: Border.all()),
              child: Stack(
                children: [
                  if (child != null) child!,
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: Text("${width}x$height"),
                  ),
                ],
              ),
            )
          : child,
    );
  }
}
