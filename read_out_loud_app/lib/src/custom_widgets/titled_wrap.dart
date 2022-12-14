import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:services/services.dart';

class TitledWrap extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const TitledWrap({super.key, required this.children, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title!,
                  style: TextStyles.chapterTitle(context),
                )),
          ),
        Card(
            margin: const EdgeInsets.all(4.0),
            elevation: 4,
            child: SizedBox(
                width: double.infinity,
                child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Wrap(
                      spacing: 6.0,
                      runSpacing: 6.0,
                      children: children,
                    )))),
      ],
    );
  }
}
