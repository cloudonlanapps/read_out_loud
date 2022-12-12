import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:manage_content/manage_content.dart';

import 'enter_title.dart';
import 'enter_new_words.dart';

class ChapterCreate extends ConsumerStatefulWidget {
  final Repository repository;
  const ChapterCreate({
    super.key,
    required this.repository,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewWordsState();
}

class _NewWordsState extends ConsumerState<ChapterCreate>
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
                      EnterTitle(
                          path: path,
                          controller: titleController,
                          focusNode: titlefocusNode,
                          onChange: () {
                            setState(() {});
                          }),
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
                      Stack(
                        children: [
                          Center(
                            child: TextButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    context.pop();
                                    String title = titleController.text;
                                    Words words = Words(
                                        title: title,
                                        words: wordsController.text
                                            .split("\n")
                                            .where((e) => e.isNotEmpty)
                                            .map((e) => Word.fromString(e))
                                            .toList());

                                    final fname = "$title.json";
                                    await words.save(fname);
                                    Chapter chapter =
                                        Chapter(filename: fname, title: title);
                                    await ref
                                        .read(repositoryProvider("index.json")
                                            .notifier)
                                        .addChapter(widget.repository, chapter);
                                  }
                                },
                                child: const Text("Save")),
                          ),
                          if (isKeyboardVisible)
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                  },
                                  icon: const Icon(Icons.keyboard_hide)),
                            )
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
}
