import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

import '../../../custom_widgets/menu3.dart';
import 'add_words.dart';
import 'title_editor.dart';
import 'show_words.dart';

class ChapterUpdate extends ConsumerStatefulWidget {
  final Function() onClose;
  final String wordsFilename;

  final bool readOnly;
  const ChapterUpdate({
    super.key,
    required this.wordsFilename,
    required this.readOnly,
    required this.onClose,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => ChapterUpdateState();
}

class ChapterUpdateState extends ConsumerState<ChapterUpdate>
    with WidgetsBindingObserver {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController wordsController;
  late final FocusNode wordsfocusNode;
  var isKeyboardVisible = false;
  late bool addingNewWords;
  List<Word> deletedWords = [];
  List<String> addedWords = [];

  @override
  void initState() {
    wordsController = TextEditingController();
    wordsfocusNode = FocusNode();
    WidgetsBinding.instance.addObserver(this);

    addingNewWords = false;
    super.initState();
  }

  @override
  void dispose() {
    wordsController.dispose();
    wordsfocusNode.dispose();

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
                child: Column(
                  children: [
                    TitleEditor(
                      readonly: true,
                      title: ref.watch(wordsProvider(widget.wordsFilename)
                          .select((value) => value?.title ?? "")),
                    ),
                    if (!addingNewWords)
                      Menu3(
                        height: 50,
                        children: [
                          null,
                          null,
                          if (widget.readOnly)
                            null
                          else
                            TextButton(
                                onPressed: () {
                                  setState(() {
                                    addingNewWords = !addingNewWords;
                                  });
                                },
                                child: const Text("Add more words")),
                        ],
                      ),
                    if (addingNewWords || isKeyboardVisible)
                      Expanded(
                          child: AddWords(
                              focusNode: wordsfocusNode,
                              controller: wordsController,
                              onMultiWords: onMultiWords,
                              onTextChanged: () {
                                setState(() {});
                              },
                              onClearController: () {
                                setState(() {
                                  wordsController.clear();
                                });
                              }))
                    else
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.all(16.0),
                            child: ShowWords(
                                readonly: widget.readOnly,
                                wordsFilename: widget.wordsFilename,
                                addedWords: addedWords,
                                deletedWords: deletedWords,
                                onDeleteString: onDeleteString,
                                onRestoreDeletedWord: onRestoreDeletedWord,
                                onDeleteWord: onDeleteWord),
                          ),
                        ),
                      ),
                    if (addingNewWords)
                      Menu3(
                        height: 50,
                        children: [
                          TextButton(
                              onPressed: () async {
                                if (wordsController.text.isEmpty) {
                                  closeEditor();
                                } else {
                                  confirmBeforeCall(context,
                                      message:
                                          "This will discard all the words you have enterred. Do you want to preceed?",
                                      action: closeEditor);
                                }
                              },
                              child: Text(wordsController.text.isEmpty
                                  ? "Cancel"
                                  : "Discard")),
                          TextButton(
                              onPressed: wordsController.text.isEmpty
                                  ? null
                                  : addToList,
                              child: const Text("Add to List")),
                          if (isKeyboardVisible)
                            IconButton(
                                onPressed: () => closeKeyboard,
                                icon: const Icon(Icons.keyboard_hide))
                          else
                            null
                        ],
                      ),
                    if (!addingNewWords) ...[
                      Menu3(
                        height: 50,
                        children: [
                          TextButton(
                              onPressed: () async {
                                if (!needSave) {
                                  widget.onClose();
                                } else {
                                  confirmBeforeCall(context,
                                      message:
                                          "This will discard all the changed you have done in this chapter. Do you want to preceed?",
                                      action: widget.onClose);
                                }
                              },
                              child: Text(widget.readOnly || !needSave
                                  ? "Done"
                                  : "Cancel, Don't Save")),
                          null,
                          if (widget.readOnly)
                            null
                          else
                            TextButton(
                                onPressed: needSave ? onSave : null,
                                child: const Text("Save")),
                        ],
                      )
                    ]
                  ],
                ),
              ),
            ),
        error: (error, stackTrace) => Container(),
        loading: () => const Center(
              child: CircularProgressIndicator(),
            ));
  }

  Future<bool> onMultiWords(List<String> words) async {
    wordsController.text = wordsController.text.appendList(words);
    wordsController.selection = TextSelection.fromPosition(
        TextPosition(offset: wordsController.text.length));
    if (wordsfocusNode.canRequestFocus) {
      wordsfocusNode.requestFocus();
    }
    setState(() {});

    return true;
  }

  addToList() async {
    final validate = _formKey.currentState!.validate();
    if (validate) {
      addedWords = [
        ...{
          ...addedWords,
          ...wordsController.text
              .split("\n")
              .where((e) => e.isNotEmpty)
              .toList()
        }
      ];
      setState(() {});

      await closeEditor();
    }
  }

  closeEditor() async {
    wordsController.clear();
    closeKeyboard();
    setState(() {
      addingNewWords = !addingNewWords;
    });
  }

  closeKeyboard() {
    if (isKeyboardVisible) {
      FocusScope.of(context).unfocus();
    }
  }

  onRestoreDeletedWord(Word word) {
    setState(() {
      deletedWords = deletedWords.where((element) => element != word).toList();
    });
  }

  onDeleteString(string) {
    setState(() {
      addedWords = addedWords.where((element) => element != string).toList();
    });
  }

  onDeleteWord(Word word) {
    setState(() {
      deletedWords = [
        ...{...deletedWords, word}
      ];
    });
  }

  bool get needSave => !(deletedWords.isEmpty && addedWords.isEmpty);
  onSave() async {
    await ref.read(wordsProvider(widget.wordsFilename).notifier).updateWords(
        wordListToRemove: deletedWords, newWordStrings: addedWords);

    widget.onClose();
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

extension ConcatenateList on String {
  appendList(List<String> list) {
    final newLine = isNotEmpty && (this[length - 1] != "\n") ? '\n' : '';
    return "${this}$newLine${list.join("\n")}\n";
  }
}
