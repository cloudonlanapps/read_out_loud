import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ChapterTitle extends StatelessWidget {
  final TextEditingController? controller;
  final String title;
  final FocusNode? focusNode;
  final Function()? onChange;

  final Function(String fname)? onValidateFileName;
  final bool readonly;

  const ChapterTitle(
      {super.key,
      required this.title,
      this.controller,
      this.onChange,
      this.focusNode,
      this.onValidateFileName,
      this.readonly = false});

  @override
  Widget build(BuildContext context) {
    assert(readonly ||
        (focusNode != null && onChange != null && controller != null));

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
            child: Text(
          title.isNotEmpty ? title : "Untitled",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge,
        )),
        if (!readonly)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: TextFormField(
              focusNode: focusNode,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r"[0-9a-zA-Z\ ]")),
              ],
              decoration: InputDecoration(
                label: const Text("Edit name of the Chapter"),
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
              minLines: 1,
              maxLines: 1,
              onChanged: (_) {
                onChange?.call();
              },
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (readonly) return null;
                if (value == null || value.isEmpty) {
                  return 'Enter a title';
                }

                return onValidateFileName?.call("$value.json");
              },
            ),
          ),
      ],
    );
  }
}
