import 'dart:io';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manage_content/manage_content.dart';
import 'package:read_out_loud_app/src/custom_widgets/menu3.dart';

import 'title_editor.dart';
import 'add_words.dart';

class ChapterCreate extends ConsumerStatefulWidget {
  final Function() onClose;
  final Repository repository;
  const ChapterCreate({
    super.key,
    required this.repository,
    required this.onClose,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ChapterCreateState();
}

class ChapterCreateState extends ConsumerState<ChapterCreate>
    with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController titleController;
  late final TextEditingController wordsController;
  late final FocusNode titlefocusNode;
  late final FocusNode wordsfocusNode;
  var isKeyboardVisible = false;

  @override
  void initState() {
    titleController = TextEditingController();
    wordsController = TextEditingController();
    titlefocusNode = FocusNode();
    wordsfocusNode = FocusNode();
    WidgetsBinding.instance.addObserver(this);

    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    wordsController.dispose();
    wordsfocusNode.dispose();
    titlefocusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    final newValue = bottomInset > 0.0;
    if (newValue != isKeyboardVisible) {
      setState(() {
        isKeyboardVisible = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final repositoryPath = ref.watch(repositoryPathProvider);

    return repositoryPath.when(
        data: (String path) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      TitleEditor(
                        readonly: false,
                        title: titleController.text,
                        controller: titleController,
                        focusNode: titlefocusNode,
                        onValidateFileName: ((fname) {
                          if (File("$path/$fname").existsSync()) {
                            return "Chapter with the same name exists already";
                          }
                          return null;
                        }),
                        onChange: () {
                          setState(() {});
                        },
                      ),
                      Expanded(
                          child: AddWords(
                              focusNode: wordsfocusNode,
                              controller: wordsController,
                              onMultiWords: ((List<String> words) async {
                                var currText = wordsController.text;
                                if (currText.isNotEmpty &&
                                    currText[currText.length - 1] != "\n") {
                                  currText = "$currText\n";
                                }
                                currText = "$currText${words.join("\n")}\n";
                                setState(() {
                                  wordsController.text = currText;
                                  wordsController.selection =
                                      TextSelection.fromPosition(TextPosition(
                                          offset: wordsController.text.length));
                                });
                                if (wordsfocusNode.canRequestFocus) {
                                  wordsfocusNode.requestFocus();
                                }
                                return true;
                              }),
                              onTextChanged: () {
                                setState(() {});
                              },
                              onClearController: () {
                                setState(() {
                                  wordsController.clear();
                                });
                              })),
                      Menu3(
                        height: 50,
                        children: [
                          TextButton(
                              onPressed: () async {
                                if (wordsController.text.isEmpty) {
                                  widget.onClose();
                                } else {
                                  confirmBeforeCall(context,
                                      message:
                                          "This will discard all the words you have enterred. Do you want to preceed?",
                                      action: widget.onClose);
                                }
                              },
                              child: Text(wordsController.text.isEmpty
                                  ? "Cancel"
                                  : "Discard")),
                          TextButton(
                              onPressed:
                                  wordsController.text.isEmpty ? null : onSave,
                              child: const Text("Save")),
                          if (isKeyboardVisible)
                            IconButton(
                                onPressed: closeKeyboard,
                                icon: const Icon(Icons.keyboard_hide))
                          else
                            null
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
        error: (error, stackTrace) => Container(),
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ));
  }

  onSave() async {
    if (_formKey.currentState!.validate()) {
      context.pop();
      String title = titleController.text;
      List<String> newWords = [
        ...{
          ...wordsController.text
              .split("\n")
              .where((e) => e.isNotEmpty)
              .toList()
        }
      ];
      Words words = Words(
          title: title,
          words: newWords.map((e) => Word.fromString(e)).toList());

      final fname = "$title.json";
      await words.save(fname);
      Chapter chapter = Chapter(filename: fname, title: title);
      await ref
          .read(repositoryProvider("index.json").notifier)
          .addChapter(widget.repository, chapter);
    }
  }

  closeKeyboard() {
    if (isKeyboardVisible) {
      FocusScope.of(context).unfocus();
    }
  }

  confirmBeforeCall(BuildContext context,
      {required String message, required Function() action}) {
    showOkCancelAlertDialog(
      context: context,
      message: message,
      okLabel: "Yes",
      cancelLabel: "No",
    ).then((result) {
      if (result == OkCancelResult.ok) {
        action();
      }
    });
  }
}
