import 'package:flutter/material.dart';

class SizeGetter extends StatefulWidget {
  final Widget Function(BuildContext context, Size size) builder;
  const SizeGetter({super.key, required this.builder});

  @override
  State<StatefulWidget> createState() => SizeGetterState();
}

class SizeGetterState extends State<SizeGetter> {
  Size? size;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    WidgetsBinding.instance.addPostFrameCallback(getSize);
    super.didChangeDependencies();
  }

  void getSize(_) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;

    try {
      setState(() {
        size = renderBox.size;
      });
      print(renderBox.size);
    } catch (e) {
      //print('catch: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (size == null) {
      return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              Divider(
                height: 16,
              ),
              Text("Checking your Device Dimension, "
                  "If everything goes well, you don't see  or "
                  "see this page for a very brief moment."),
            ],
          ),
        ),
      );
    } else {
      return widget.builder(context, size!);
    }
  }
}
