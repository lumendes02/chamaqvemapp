// import 'package:flutter/material.dart';
// import 'package:masked_text/masked_text.dart';

// class MaskedTextFieldtxt extends StatelessWidget {
//   final TextEditingController controller;
//   final String text;
//   final String mask;
//   final int limit;
//   final TextInputType? keyboard;

//   const MaskedTextFieldtxt(
//       {required this.controller,
//       required this.text,
//       required this.mask,
//       required this.limit,
//       this.keyboard,
//       Key? key})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//         padding: const EdgeInsets.all(16),
//         child: MaskedTextField(
//           mask: mask,
//           controller: controller,
//           maxLength: limit == 0 ? 100 : limit,
//           keyboardType: keyboard ?? TextInputType.text,
//           decoration: InputDecoration(
//               labelText: text, border: const OutlineInputBorder()),
//         ));
//   }
// }
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:flutter/material.dart';

class ExampleMask {
  final TextEditingController textController = TextEditingController();
  final MaskTextInputFormatter formatter;
  final FormFieldValidator<String>? validator;
  final String hint;
  final TextInputType textInputType;

  ExampleMask(
      {required this.formatter,
      this.validator,
      required this.hint,
      required this.textInputType});
}
