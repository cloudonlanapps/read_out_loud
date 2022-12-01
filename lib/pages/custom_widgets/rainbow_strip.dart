import 'package:flutter/material.dart';

class Rainbow extends StatelessWidget {
  const Rainbow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Color.fromARGB(0xFF, 0xEE, 0x82, 0xEE), // Violet
        const Color.fromARGB(0xFF, 0x4b, 0x00, 0x82), // Indigo
        // const Color.fromARGB(0xFF, 0x00, 0x00, 0xFF), // Blue
        //  const Color.fromARGB(0xFF, 0x00, 0x80, 0x00), // Green
        const Color.fromARGB(0xFF, 0xFf, 0xFF, 0x00), // Yellow
        const Color.fromARGB(0xFF, 0xFF, 0xA5, 0x00), // Orange
        const Color.fromARGB(0xFF, 0xFF, 0x00, 0x00), //Red
      ]
          .map(
            (e) => Expanded(
              child: Container(
                color: e,
              ),
            ),
          )
          .toList(),
    );
  }
}

class RainbowVertical extends StatelessWidget {
  const RainbowVertical({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Color.fromARGB(0x7F, 0xEE, 0x82, 0xEE), // Violet
        const Color.fromARGB(0x7F, 0x4b, 0x00, 0x82), // Indigo
        // const Color.fromARGB(0x7F, 0x00, 0x00, 0xFF), // Blue
        //const Color.fromARGB(0x7F, 0x00, 0x80, 0x00), // Green
        const Color.fromARGB(0x7F, 0xFf, 0xFF, 0x00), // Yellow
        const Color.fromARGB(0x7F, 0xFF, 0xA5, 0x00), // Orange
        const Color.fromARGB(0x7F, 0xFF, 0x00, 0x00), //Red
      ]
          .map(
            (e) => Expanded(
              child: Container(
                color: e,
              ),
            ),
          )
          .toList(),
    );
  }
}
