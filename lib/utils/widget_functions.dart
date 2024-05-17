import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

showSingleTextInputDialog({
  required BuildContext context,
  required String title,
  String posBtnTxt = 'OK',
  String negBtnTxt = 'CLOSE',
  required Function(String) onSubmit,
}) {
  final controller = TextEditingController();
  showDialog(context: context, builder: (context) => AlertDialog(
    title: Text(title),
    content: Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(
          labelText: title,
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(negBtnTxt),
      ),
      TextButton(
        onPressed: () {
          if(controller.text.isEmpty) return;
          onSubmit(controller.text);
          Navigator.pop(context);
        },
        child: Text(posBtnTxt),
      ),
    ],
  ));
}

showMsg(BuildContext context, String msg) =>
    ScaffoldMessenger
    .of(context)
    .showSnackBar(SnackBar(content: Text(msg)));