import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../services/clipboard/clipboard.dart';
import '../../../custom_widgets/menu3.dart';

class EnterNewWords extends StatelessWidget {
  final Future<bool> Function(List<String>) onMultiWords;

  final TextEditingController controller;
  final FocusNode focusNode;

  const EnterNewWords({
    super.key,
    required this.controller,
    required this.onMultiWords,
    required this.focusNode,
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
              null,
              null,
              TextButton(
                  onPressed: () async {
                    final text = await ClipboardManager.paste();
                    final words = text
                        .replaceAll(RegExp(r"[^a-zA-Z\s\r\n\,]"), "")
                        .split(RegExp(r"[\s\r\n]"));
                    await onMultiWords(words);
                  },
                  child: const Text(
                    "Paste",
                    textAlign: TextAlign.end,
                  )),
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
