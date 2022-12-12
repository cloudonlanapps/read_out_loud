import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

import 'enter_new_words.dart';
import 'show_existing_words.dart';

class ChapterUpdate extends ConsumerStatefulWidget {
  final Repository repository;

  final int index;
  final bool readOnly;
  const ChapterUpdate(
      {super.key,
      required this.repository,
      required this.index,
      required this.readOnly});

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
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  child: Column(
                    children: [
                      if (addingNewWords)
                        Expanded(
                            child: EnterNewWords(
                          focusNode: wordsfocusNode,
                          controller: wordsController,
                          onMultiWords: onMultiWords,
                        ))
                      else
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: ShowExistingWords(
                            readonly: widget.readOnly,
                            repository: widget.repository,
                            index: widget.index,
                          ),
                        ),
                      if (addingNewWords) ...[
                        Row(
                          children: [
                            Expanded(
                                child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                  onPressed: () {
                                    setState(() {
                                      addingNewWords = !addingNewWords;
                                    });
                                  },
                                  child: const Text("Cancel")),
                            )),
                            Expanded(
                              child: Center(
                                child: TextButton(
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        await ref
                                            .read(wordsProvider(widget
                                                    .repository
                                                    .chapters[widget.index]
                                                    .filename)
                                                .notifier)
                                            .addMoreWords(wordsController.text
                                                .split("\n")
                                                .where((e) => e.isNotEmpty)
                                                .toList());
                                      }
                                    },
                                    child: const Text("Add Words")),
                              ),
                            ),
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: (isKeyboardVisible)
                                    ? Align(
                                        alignment: Alignment.centerRight,
                                        child: IconButton(
                                            onPressed: () =>
                                                FocusScope.of(context)
                                                    .unfocus(),
                                            icon: const Icon(
                                                Icons.keyboard_hide)),
                                      )
                                    : Container(),
                              ),
                            )
                          ],
                        )
                      ] else ...[
                        const Spacer(),
                        Row(
                          children: [
                            Expanded(
                                child: Align(
                              alignment: Alignment.center,
                              child: TextButton(
                                  onPressed: () {},
                                  child: const Text("Clear all words")),
                            )),
                            Expanded(
                              child: Center(
                                child: TextButton(
                                    onPressed: () {
                                      setState(() {
                                        addingNewWords = !addingNewWords;
                                      });
                                    },
                                    child: const Text("Add more words")),
                              ),
                            ),
                          ],
                        )
                      ]
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

  Future<bool> onMultiWords(List<String> words) async {
    var currText = wordsController.text;
    if (currText.isNotEmpty && currText[currText.length - 1] != "\n") {
      currText = "$currText\n";
    }
    currText = "$currText${words.join("\n")}\n";
    setState(() {
      wordsController.text = currText;
      wordsController.selection = TextSelection.fromPosition(
          TextPosition(offset: wordsController.text.length));
    });
    if (wordsfocusNode.canRequestFocus) {
      wordsfocusNode.requestFocus();
    }
    return true;
  }
}
