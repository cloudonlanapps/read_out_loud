import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manage_content/manage_content.dart';

import 'enter_new_words.dart';

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
                      if (addingNewWords) ...[
                        Expanded(
                            child: EnterNewWords(
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
                        )),
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
                                        context.pop();

                                        await ref
                                            .read(
                                                repositoryProvider("index.json")
                                                    .notifier)
                                            .addMoreWords(
                                                widget.repository,
                                                widget.index,
                                                wordsController.text
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
                                            onPressed: () {
                                              FocusScope.of(context).unfocus();
                                            },
                                            icon: const Icon(
                                                Icons.keyboard_hide)),
                                      )
                                    : Container(),
                              ),
                            )
                          ],
                        )
                      ] else ...[
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          child: WordsAsChip(
                            readonly: widget.readOnly,
                            repository: widget.repository,
                            index: widget.index,
                          ),
                        ),
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
}

class WordsAsChip extends ConsumerStatefulWidget {
  final Repository repository;
  final int index;
  final bool readonly;
  const WordsAsChip({
    super.key,
    required this.repository,
    required this.index,
    required this.readonly,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _WordsAsChipState();
}

class _WordsAsChipState extends ConsumerState<WordsAsChip> {
  @override
  Widget build(BuildContext context) {
    final words = ref.watch(
        wordsProvider(widget.repository.chapters[widget.index].filename));
    if (words == null || words.words.isEmpty) {
      return const Center(
        child: Text(
          "This is an empty list, add more words ",
          style: TextStyle(
            fontSize: 40.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'Horizon',
          ),
        ),
      );
    }
    return Wrap(
      spacing: 6.0,
      runSpacing: 6.0,
      children: <Widget>[
        for (Word word in words.wordsIncludeReported)
          _buildChip(word, widget.readonly),
      ],
    );
  }

  Widget _buildChip(Word word, bool readOnly) {
    return Chip(
        backgroundColor: word.succeeded ? Colors.lightGreen : null,
        labelPadding: const EdgeInsets.all(2.0),
        label: Text(word.original,
            style: (word.report)
                ? Theme.of(context).textTheme.labelLarge!.copyWith(
                      decoration: TextDecoration.lineThrough,
                      decorationThickness: 3,
                      decorationColor: Colors.redAccent,
                    )
                : Theme.of(context).textTheme.labelLarge),
        elevation: 6.0,
        shadowColor: Colors.grey[60],
        padding: const EdgeInsets.all(8.0),
        onDeleted: readOnly || word.report
            ? null
            : () async {
                await ref
                    .read(repositoryProvider("index.json").notifier)
                    .removeWords(widget.repository, widget.index, [word]);
              });
  }
}
