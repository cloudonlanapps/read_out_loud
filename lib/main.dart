import 'package:flutter/material.dart';
import 'package:read_out_loud/pages/samples/hello_world.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Read Out Loud',
      home: HelloWorld(),
    );
  }
}
