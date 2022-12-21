// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'background.dart';
import 'view_config.dart';

class ScreenBackground extends StatelessWidget {
  final ViewConfig viewConfig;
  final Widget Function(BuildContext context) builder;
  const ScreenBackground({
    required this.builder,
    required this.viewConfig,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final borderRadius = viewConfig.borderRadius ?? 15;

    /// Flutter starts quicker in release mode and the native platform
    /// reports the actual resolution with a delay. So the very first frame
    /// is build with Size(0.0, 0.0). After sometime, the app will be
    /// rebuilt again with the proper value. Print MediaQuery.context.size
    /// in the build() to observe this. (you need to use the regular print()
    /// in your app to debug. Make the code to be resilient against
    /// Size(0.0, 0.0) and make sure that you call findRenderBox only after
    /// the resolution is received from the platform will make sure that you
    /// get correct size.
    /// Refer this https://github.com/flutter/flutter/issues/25827
    ///
    /// Alternate way using RenderProxyBox can also be explored.
    /// https://stackoverflow.com/questions/49307677/how-to-get-height-of-a-widget

    if (MediaQuery.of(context).size.width < 10 ||
        MediaQuery.of(context).size.height < 10) {
      return const Scaffold(
        body: Center(
          child: Text('Insufficent screen space'),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Background(
            size: size,
            borderRadius: borderRadius,
          ),
          SafeArea(
            child: DecoratedBox(
              decoration: BoxDecoration(
                //color: Colors.white,
                borderRadius: BorderRadius.circular(borderRadius),
                border: viewConfig.showContentBorder ? Border.all() : null,
              ),
              child: builder(context),
            ),
          ),
        ],
      ),
    );
  }
}
