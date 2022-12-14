import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:services/services.dart';

class TitledWrap extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const TitledWrap({super.key, required this.children, this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  title!,
                  style: TextStyles.chapterTitle(context),
                )),
          SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: 6.0,
                runSpacing: 6.0,
                children: children,
              )),
        ],
      ),
    );
  }
}
