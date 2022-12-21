import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:services/services.dart';

class TitledWrap extends StatelessWidget {
  const TitledWrap({
    required this.children,
    this.title,
    super.key,
  });
  final String? title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (title != null)
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                title!,
                style: TextStyles.chapterTitle(context),
              ),
            ),
          SizedBox(
            width: double.infinity,
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: children,
            ),
          ),
        ],
      ),
    );
  }
}
