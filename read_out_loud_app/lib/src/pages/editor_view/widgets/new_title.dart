import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewTitle extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function() onChange;

  final Function(String fname) onValidateFileName;

  const NewTitle({
    super.key,
    required this.controller,
    required this.onChange,
    required this.focusNode,
    required this.onValidateFileName,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(),
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
              onChange();
            },
            textInputAction: TextInputAction.next,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter a title';
              }

              return onValidateFileName("$value.json");
            },
          ),
        ),
      ],
    );
  }
}