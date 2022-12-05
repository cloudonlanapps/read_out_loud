import 'dart:ui';

import 'package:flutter/material.dart';

class ScreenBackground extends StatelessWidget {
  final double? borderRadius;
  final EdgeInsets? marigin;

  final Widget Function(BuildContext context, Size size) builder;
  const ScreenBackground(
      {super.key, required this.builder, this.borderRadius, this.marigin});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final padding = MediaQuery.of(context).size.shortestSide * 0.01;
    final double borderRadius =
        this.borderRadius ?? MediaQuery.of(context).size.shortestSide / 8;
    return SafeArea(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: width,
          height: height,
          margin: marigin ??
              EdgeInsets.only(
                top: padding,
                left: padding,
                right: padding,
                bottom: padding,
              ),
          //padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(),
              gradient: const LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Color.fromARGB(0xFF, 0x00, 0x8F, 0x8F),
                    Color.fromARGB(0xFF, 0x8F, 0x8F, 0x00),
                  ])),
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    color: Colors.grey.shade200.withOpacity(0.2),
                  ),
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(borderRadius),
                    border: Border.all(),
                  ),
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.shortestSide * 0.01,
                      left: MediaQuery.of(context).size.shortestSide * 0.01,
                      right: MediaQuery.of(context).size.shortestSide * 0.01,
                      bottom: MediaQuery.of(context).size.shortestSide * 0.01),
                  child: Container() // SizeGetter(builder: builder),
                  )
            ],
          ),
        ),
      ),
    );
  }
}
