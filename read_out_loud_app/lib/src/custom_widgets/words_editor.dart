import 'package:flutter/material.dart';

class WordsEditor extends StatefulWidget {
  final String title;
  final List<String> existingWords;
  final Function()? onSave;
  const WordsEditor({
    super.key,
    required this.title,
    required this.existingWords,
    this.onSave,
  });

  @override
  State<StatefulWidget> createState() => _WordsEditorState();
}

class _WordsEditorState extends State<WordsEditor> {
  late final TextEditingController titleController;
  late final TextEditingController newWordsController;
  @override
  void initState() {
    titleController = TextEditingController(text: widget.title);
    newWordsController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tittle",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      width: 2, color: Colors.blueGrey), //<-- SEE HERE
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              controller: titleController,
              minLines: 1,
              maxLines: 1,
            ),
          ),
          Text(
            "Words",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                expands: true,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                        width: 2, color: Colors.blueGrey), //<-- SEE HERE
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                controller: newWordsController,
                minLines: null,
                maxLines: null,
              ),
            ),
          )
        ],
      ),
    );
  }
}
