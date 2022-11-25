import 'package:flutter/material.dart';

import 'pages/samples/hello_world.dart';

class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Read Out Loud',
      home: HelloWorld(),
    );
  }
}
