import 'package:flutter/material.dart';
import 'package:manage_content/manage_content.dart';

class WordsEditor extends StatefulWidget {
  final Words words;
  final Function(Words words)? onSave;
  const WordsEditor({
    super.key,
    required this.words,
    this.onSave,
  });

  @override
  State<StatefulWidget> createState() => _WordsEditorState();
}

class _WordsEditorState extends State<WordsEditor> {
  late final TextEditingController titleController;
  late final FocusNode titleFocusNode;

  @override
  void initState() {
    titleController = TextEditingController(text: widget.words.title);
    titleFocusNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    titleController.dispose();
    titleFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool readOnly = widget.onSave == null;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SingleChildScrollView(
        child: Scrollbar(
          thickness: 4,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (readOnly)
                  Center(
                    child: Text(
                      titleController.text,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  )
                else
                  Column(
                    mainAxisSize: MainAxisSize.min,
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
                                  width: 2,
                                  color: Colors.blueGrey), //<-- SEE HERE
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          controller: titleController,
                          minLines: 1,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                if (widget.words.words.isEmpty)
                  const Text("This chapter is empty")
                else
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!readOnly)
                        Text(
                          "Words",
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        child: Wrap(
                          spacing: 6.0,
                          runSpacing: 6.0,
                          children: <Widget>[
                            for (Word word in widget.words.words)
                              _buildChip(word, readOnly),
                          ],
                        ),
                      )
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChip(Word word, bool readOnly) {
    return Chip(
        labelPadding: const EdgeInsets.all(2.0),
        label: Text(word.original,
            style: (word.report)
                ? Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .copyWith(decoration: TextDecoration.lineThrough)
                : Theme.of(context).textTheme.labelLarge),
        elevation: 6.0,
        shadowColor: word.succeeded ? Colors.lightGreen : Colors.grey[60],
        padding: const EdgeInsets.all(8.0),
        onDeleted: readOnly ? null : () {});
  }
}
