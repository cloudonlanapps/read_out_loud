import 'package:flutter/material.dart';
import 'package:services/services.dart';

class CustomMenuItem {
  String? title;
  IconData? icon;
  final AlignmentGeometry alignment;
  void Function()? onTap;
  void Function()? onLongPress;
  double? scale;
  Color? color;
  CustomMenuItem(
      {this.title,
      this.icon,
      this.color,
      this.onTap,
      this.alignment = Alignment.center,
      this.onLongPress,
      this.scale});
}

class CustomMenuButton extends StatelessWidget {
  final CustomMenuItem menuItem;

  const CustomMenuButton({super.key, required this.menuItem});

  @override
  Widget build(BuildContext context) {
    final color =
        (menuItem.onTap == null ? Colors.grey : menuItem.color ?? Colors.black);
    return Transform.scale(
      scale: menuItem.scale ?? 1.0,
      child: InkWell(
        //splashColor: const Color.fromARGB(128, 255, 0, 0),
        onTap: menuItem.onTap,
        onLongPress: menuItem.onLongPress,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            if (menuItem.icon != null)
              Flexible(
                  child: FittedBox(
                      child: Icon(menuItem.icon!, size: 40, color: color))),
            if (menuItem.title != null)
              Flexible(
                child: FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      menuItem.title!,
                      style: TextStyles.menuIcon(context),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class CustomMenu extends StatelessWidget {
  final List<CustomMenuItem?> menuItems;

  const CustomMenu({super.key, required this.menuItems});

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: menuItems
            .map((e) => Expanded(
                  child: Align(
                    alignment: (e == null) ? Alignment.center : e.alignment,
                    child: (e == null)
                        ? Container()
                        : CustomMenuButton(menuItem: e),
                  ),
                ))
            .toList());
  }
}

class CardMenu extends StatelessWidget {
  final List<CustomMenuItem?> menuItems;
  const CardMenu({
    Key? key,
    required this.menuItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 4.0,
        mainAxisSpacing: 4.0,
        children: List.generate(menuItems.length, (index) {
          return Center(
            child: CardMenuButton(choice: menuItems[index]),
          );
        }));
  }
}

class CardMenuButton extends StatelessWidget {
  const CardMenuButton({Key? key, required this.choice}) : super(key: key);
  final CustomMenuItem? choice;

  @override
  Widget build(BuildContext context) {
    if (choice == null) return Container();
    return SizedBox(
      width: 80,
      height: 80,
      child: InkWell(
        enableFeedback: true,
        onTap: choice!.onTap,
        onLongPress: choice!.onLongPress,
        child: Card(
            child: Center(
          child: Padding(
            padding: const EdgeInsets.all(4),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  if (choice!.icon != null)
                    Expanded(
                      child: Icon(
                        choice!.icon,
                        color: choice!.color,
                        size: TextStyles.menuIcon(context).fontSize! * 2,
                      ),
                    ),
                  if (choice!.title != null)
                    Text(choice!.title!,
                        style: TextStyles.menuIcon(context)
                            .copyWith(color: choice!.color)),
                ]),
          ),
        )),
      ),
    );
  }
}
