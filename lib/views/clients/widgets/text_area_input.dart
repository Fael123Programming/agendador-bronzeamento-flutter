import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TextAreaInputController extends GetxController {
  final FocusNode focusNode = FocusNode();
  Function()? onEditingComplete;
  final TextEditingController textArea = TextEditingController();
  String? hintText;
  IconData? icon;

  TextAreaInputController({this.hintText, this.icon});
}

class TextAreaInput extends StatelessWidget {
  const TextAreaInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextAreaInputController textAreaController = Get.find();
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.8,
      height: height * 0.2,
      padding: EdgeInsets.all(width * 0.03),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
        ),
      ),
      child: Row(
        children: <Widget>[
          Column(
            children: [
              Icon(
                textAreaController.icon,
                color: Colors.grey,
              ),
            ],
          ),
          SizedBox(
            width: width * 0.04,
          ),
          Expanded(
            child: TextFormField(
              maxLines: 5,
              maxLength: 130,
              onEditingComplete: textAreaController.onEditingComplete,
              focusNode: textAreaController.focusNode,
              controller: textAreaController.textArea,
              // autofocus: true,
              decoration: InputDecoration.collapsed(
                hintText: textAreaController.hintText,
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
