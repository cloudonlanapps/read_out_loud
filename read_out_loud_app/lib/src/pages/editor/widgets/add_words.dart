import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:services/services.dart';

import '../../../custom_widgets/menu3.dart';

class AddWords extends StatelessWidget {
  final Future<bool> Function(List<String>) onMultiWords;
  final Function() onClearController;
  final Function() onTextChanged;

  final TextEditingController controller;
  final FocusNode focusNode;

  const AddWords({
    super.key,
    required this.controller,
    required this.onMultiWords,
    required this.onClearController,
    required this.focusNode,
    required this.onTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: Menu3(
            height: 50,
            children: [
              if (controller.text.isEmpty)
                null
              else
                TextButton(
                    onPressed: onClearController,
                    child: const Text("Clear", textAlign: TextAlign.start)),
              null,
              TextButton(
                  onPressed: () async {
                    final text = await ClipboardManager.paste();
                    final words = text
                        .replaceAll(RegExp(r"[^a-zA-Z\s\r\n\,]"), "")
                        .split(RegExp(r"[\s\r\n]"));
                    await onMultiWords(words);
                  },
                  child: const Text("Paste", textAlign: TextAlign.end)),
            ],
          ),
        ),
        Expanded(
          child: TextFormField(
            focusNode: focusNode,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z\r\n]")),
            ],
            expands: true,
            decoration: InputDecoration(
              label: const Text("Enter Words, one word per line"),
              alignLabelWithHint: true,
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    width: 2, color: Colors.blueGrey), //<-- SEE HERE
                borderRadius: BorderRadius.circular(5.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    width: 2, color: Colors.blueGrey), //<-- SEE HERE
                borderRadius: BorderRadius.circular(5.0),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    width: 2, color: Colors.red), //<-- SEE HERE
                borderRadius: BorderRadius.circular(5.0),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    width: 2, color: Colors.red), //<-- SEE HERE
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            controller: controller,
            minLines: null,
            maxLines: null,
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.top,
            textInputAction: TextInputAction.newline,
            onChanged: (_) => onTextChanged(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
        ),
      ],
    );
  }
}
