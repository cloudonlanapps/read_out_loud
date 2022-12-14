import 'dart:ui';

import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Size size;
  final double borderRadius;
  const Background({
    super.key,
    required this.size,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.width,
      height: size.height,
      child: Stack(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              clipBehavior: Clip.antiAlias,
              child: Container(
                width: size.width,
                height: size.height,
                //margin: marigin ?? EdgeInsets.all(padding),
                //padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                    //color: Colors.white,
                    borderRadius: BorderRadius.circular(borderRadius),
                    // border: Border.all(),
                    gradient: const LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.blueGrey,
                          Colors.white,
                          Color.fromARGB(0xFF, 0xF0, 0xF0, 0xF0),
                          Colors.yellow,
                          Colors.red,
                          Colors.red,
                          Colors.yellow,
                          Color.fromARGB(0xFF, 0xF0, 0xF0, 0xF0),
                          Colors.white,
                          Colors.blueGrey,
                          /* 
                          Color.fromARGB(0xFF, 0x00, 0x8F, 0x8F),
                          Color.fromARGB(0xFF, 0x8F, 0x8F, 0x00), */
                        ])),
              )),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(borderRadius),
                color: Colors.grey.shade200.withOpacity(0.2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
