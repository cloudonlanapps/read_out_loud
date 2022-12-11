import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

import '../../custom_widgets/custom_menu.dart';

class TopMenu extends ConsumerWidget {
  final Size size;
  final String filename;
  final Function() onClose;
  const TopMenu(
      {super.key,
      required this.onClose,
      required this.size,
      required this.filename});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    AsyncValue<Repository> asyncValue = ref.watch(repositoryProvider(filename));
    return Row(
      children: [
        CustomMenuButton(
          menuItem: CustomMenuItem(
            alignment: Alignment.centerRight,
            icon: Icons.arrow_back,
            onTap: onClose,
          ),
        ),
        const Expanded(
          child: Center(
            child: Text(
              "Chapters",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: asyncValue.maybeWhen(
              data: (Repository repository) {
                return CustomMenuButton(
                  menuItem: CustomMenuItem(
                      alignment: Alignment.centerRight,
                      icon: Icons.add,
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Stack(
                                  clipBehavior: Clip.none,
                                  children: <Widget>[
                                    Positioned(
                                      right: -40.0,
                                      top: -40.0,
                                      child: InkResponse(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const CircleAvatar(
                                          backgroundColor: Colors.red,
                                          child: Icon(Icons.close),
                                        ),
                                      ),
                                    ),
                                    Form(
                                      key: formKey,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                              child: const Text("Submitß"),
                                              onPressed: () {
                                                if (formKey.currentState!
                                                    .validate()) {
                                                  formKey.currentState!.save();
                                                }
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });

                        /*  ref
                            .read(repositoryProvider(filename).notifier)
                            .addChapter(
                                repository,
                                Chapter(
                                    title: "new Chapter",
                                    filename: "new Chapter.json")); */
                      },
                      title: "Add New"),
                );
              },
              orElse: () => CustomMenuButton(
                menuItem: CustomMenuItem(
                  alignment: Alignment.centerRight,
                  icon: Icons.warning_amber,
                ),
              ),
            )),
      ],
    );
  }
}
