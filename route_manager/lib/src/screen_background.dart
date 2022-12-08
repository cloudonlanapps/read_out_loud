// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'background.dart';
import 'size.dart';
import 'view_config.dart';

class ScreenBackground extends StatelessWidget {
  final ViewConfig viewConfig;
  final Widget Function(BuildContext context, Size size) builder;
  const ScreenBackground(
      {super.key, required this.builder, required this.viewConfig});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final padding = MediaQuery.of(context).size.shortestSide * 0.01;
    final double borderRadius = viewConfig.borderRadius ?? 15;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Background(
            size: size,
            borderRadius: borderRadius,
          ),
          SafeArea(
            minimum: EdgeInsets.all(padding),
            child: Container(
                decoration: BoxDecoration(
                  //color: Colors.white,
                  borderRadius: BorderRadius.circular(borderRadius),
                  border: viewConfig.showContentBorder ? Border.all() : null,
                ),
                child: viewConfig.hideContent
                    ? null
                    : SizeGetter(builder: builder)),
          ),
        ],
      ),
    );
  }
}
