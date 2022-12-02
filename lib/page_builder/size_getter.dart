import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/providers/size_provider.dart';

class SizeGetter extends ConsumerStatefulWidget {
  final Widget Function(BuildContext context, BoxConstraints constraints,
      WidgetRef ref, Size size) builder;
  const SizeGetter({super.key, required this.builder});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => SizeGetterState();
}

class SizeGetterState extends ConsumerState<SizeGetter> {
  Size? size;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback(getSize);
    super.initState();
  }

  void getSize(_) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;

    try {
      setState(() {
        size = renderBox.size;
        ref.read(sizeProvider.notifier).size = size;
      });
      //print(size);
    } catch (e) {
      //print('catch: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (size == null) {
      return const Center(
          child: Text(
              "Checking Mobile Dimension, If everything goes well, you don't see this."));
    } else {
      return LayoutBuilder(
          builder: (context, constraints) =>
              widget.builder(context, constraints, ref, size!));
    }
  }
}
