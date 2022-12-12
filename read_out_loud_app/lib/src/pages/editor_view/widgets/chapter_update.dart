import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manage_content/manage_content.dart';

import '../../../custom_widgets/menu3.dart';
import 'enter_new_words.dart';
import 'show_existing_words.dart';

class ChapterUpdate extends ConsumerStatefulWidget {
  final String wordsFilename;

  final bool readOnly;
  const ChapterUpdate(
      {super.key, required this.wordsFilename, required this.readOnly});

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
                          wordsFilename: widget.wordsFilename,
                        ),
                      ),
                    if (addingNewWords)
                      Menu3(
                        children: [
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  addingNewWords = !addingNewWords;
                                });
                              },
                              child: const Text("Cancel")),
                          TextButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  await ref
                                      .read(wordsProvider(widget.wordsFilename)
                                          .notifier)
                                      .addMoreWords(wordsController.text
                                          .split("\n")
                                          .where((e) => e.isNotEmpty)
                                          .toList());
                                }
                              },
                              child: const Text("Add Words")),
                          (!isKeyboardVisible)
                              ? null
                              : IconButton(
                                  onPressed: () =>
                                      FocusScope.of(context).unfocus(),
                                  icon: const Icon(Icons.keyboard_hide))
                        ],
                      )
                    else ...[
                      const Spacer(),
                      Menu3(
                        children: [
                          TextButton(
                              onPressed: () {},
                              child: const Text("Clear all words")),
                          TextButton(
                              onPressed: () {
                                setState(() {
                                  addingNewWords = !addingNewWords;
                                });
                              },
                              child: const Text("Add more words")),
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
}

extension ConcatenateList on String {
  appendList(List<String> list) {
    final newLine = isNotEmpty && (this[length - 1] != "\n") ? '\n' : '';
    return "${this}$newLine${list.join("\n")}\n";
  }
}
