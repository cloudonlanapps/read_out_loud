import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:services/services.dart';

class TitleEditor extends StatelessWidget {
  final TextEditingController? controller;
  final String title;
  final FocusNode? focusNode;
  final Function()? onChange;

  final Function(String fname)? onValidateFileName;
  final bool readonly;

  const TitleEditor(
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
          style: TextStyles.chapterTitle(context),
        )),
        if (!readonly)
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: TextFormField(
              focusNode: focusNode,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r"[0-9a-zA-Z\ ]")),
              ],
              decoration: AppTextFieldTheme.inputDecoration(
                  label: "Edit name of the Chapter"),
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
